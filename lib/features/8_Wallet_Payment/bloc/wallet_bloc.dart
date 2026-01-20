import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:mobile_netpool_station_player/features/8_Wallet_Payment/models/1.wallet/wallet_model.dart';
import 'package:mobile_netpool_station_player/features/8_Wallet_Payment/models/1.wallet/wallet_response_model.dart';
import 'package:mobile_netpool_station_player/features/8_Wallet_Payment/models/2.wallet_ledger/wallet_ledger_model.dart';
import 'package:mobile_netpool_station_player/features/8_Wallet_Payment/models/2.wallet_ledger/wallet_ledger_response_model.dart';
import 'package:mobile_netpool_station_player/features/8_Wallet_Payment/repository/wallet_repository.dart';

part 'wallet_event.dart';
part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc() : super(WalletState.initial()) {
    on<WalletInitialEvent>(_onInitial);
    on<WalletRefreshBalanceEvent>(_onRefreshBalance);
    on<WalletAddMoneyEvent>(_onAddMoney);
    on<WalletChangeMonthEvent>(_onChangeMonth);
    on<WalletFetchHistoryEvent>(_onFetchHistory);
  }

  Future<void> _onInitial(
    WalletInitialEvent event,
    Emitter<WalletState> emit,
  ) async {
    add(WalletRefreshBalanceEvent());
    // Mặc định load lịch sử tháng hiện tại luôn nếu muốn cache trước
    // add(WalletFetchHistoryEvent());
  }

  /// Lấy số dư ví
  Future<void> _onRefreshBalance(
    WalletRefreshBalanceEvent event,
    Emitter<WalletState> emit,
  ) async {
    emit(state.copyWith(balanceStatus: WalletStatus.loading));
    try {
      final response = await WalletRepository().getWallet();
      var responseBody = WalletModelResponse.fromJson(response['body']);
      if (responseBody.success == true && responseBody.data != null) {
        final dynamic data = responseBody.data;
        double balance = 0;
        // Parsing an toàn
        if (data is Map) {
          if (data.containsKey('balance')) {
            balance = (data['balance'] ?? 0).toDouble();
          } else if (data.containsKey('amount')) {
            balance = (data['amount'] ?? 0).toDouble();
          }
        }

        emit(state.copyWith(
          balanceStatus: WalletStatus.success,
          balance: balance,
        ));
      } else {
        emit(state.copyWith(
          balanceStatus: WalletStatus.failure,
          message: response['message'] ?? "Không thể lấy thông tin ví",
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        balanceStatus: WalletStatus.failure,
        message: e.toString(),
      ));
    }
  }

  /// Xử lý nạp tiền (Bao gồm Validation)
  Future<void> _onAddMoney(
    WalletAddMoneyEvent event,
    Emitter<WalletState> emit,
  ) async {
    // 1. Validate Input
    if (event.amountString.isEmpty) {
      emit(state.copyWith(
          paymentStatus: PaymentActionStatus.failure,
          message: "Vui lòng nhập số tiền cần nạp"));
      return;
    }

    // Loại bỏ dấu chấm/phẩy phân cách để parse
    String cleanValue = event.amountString.replaceAll(RegExp(r'[^0-9]'), '');
    double amount = double.tryParse(cleanValue) ?? 0;

    if (amount < 10000) {
      emit(state.copyWith(
          paymentStatus: PaymentActionStatus.failure,
          message: "Số tiền nạp tối thiểu là 10.000đ"));
      return;
    }

    if (amount > 50000000) {
      emit(state.copyWith(
          paymentStatus: PaymentActionStatus.failure,
          message: "Số tiền nạp tối đa là 50.000.000đ/lần"));
      return;
    }

    // 2. Call API
    emit(state.copyWith(paymentStatus: PaymentActionStatus.processing));

    try {
      WalletModel walletModel = WalletModel(amount: amount, currency: "VND");
      final response = await WalletRepository().addMoneyToWallet(walletModel);
      var responseBody = WalletModelResponse.fromJson(response['body']);

      if (responseBody.success == true) {
        emit(state.copyWith(
          paymentStatus: PaymentActionStatus.success,
          message: "Nạp tiền thành công!",
        ));
        // Tự động refresh lại số dư sau khi nạp thành công
        add(WalletRefreshBalanceEvent());
        // Refresh lại lịch sử nếu đang ở tháng hiện tại
        if (state.selectedDate.month == DateTime.now().month &&
            state.selectedDate.year == DateTime.now().year) {
          add(WalletFetchHistoryEvent());
        }
      } else {
        emit(state.copyWith(
          paymentStatus: PaymentActionStatus.failure,
          message: response['message'] ?? "Nạp tiền thất bại",
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        paymentStatus: PaymentActionStatus.failure,
        message: "Lỗi kết nối: $e",
      ));
    } finally {
      // Reset status về idle để người dùng có thể nạp tiếp lần sau mà không bị kẹt status
      emit(state.copyWith(paymentStatus: PaymentActionStatus.idle));
    }
  }

  /// Thay đổi tháng xem lịch sử -> Trigger fetch lại data
  Future<void> _onChangeMonth(
    WalletChangeMonthEvent event,
    Emitter<WalletState> emit,
  ) async {
    // Chỉ fetch nếu tháng thay đổi
    if (event.selectedDate.month != state.selectedDate.month ||
        event.selectedDate.year != state.selectedDate.year) {
      emit(state.copyWith(selectedDate: event.selectedDate));
      add(WalletFetchHistoryEvent());
    }
  }

  /// Lấy danh sách lịch sử
  Future<void> _onFetchHistory(
    WalletFetchHistoryEvent event,
    Emitter<WalletState> emit,
  ) async {
    emit(state.copyWith(historyStatus: WalletStatus.loading));

    final DateTime date = state.selectedDate;
    final DateTime startOfMonth = DateTime(date.year, date.month, 1);
    final DateTime endOfMonth = DateTime(date.year, date.month + 1, 0);

    final String dateFrom = DateFormat('yyyy-MM-dd').format(startOfMonth);
    final String dateTo = DateFormat('yyyy-MM-dd').format(endOfMonth);

    try {
      final response =
          await WalletRepository().getPaymentHistory(dateFrom, dateTo);
      var responseBody = WalletLedgerModelResponse.fromJson(response['body']);

      if (responseBody.success == true && responseBody.data != null) {
        final parsedList = responseBody.data!;

        // Sort: Cũ nhất -> Mới nhất (hoặc Mới -> Cũ tùy nhu cầu)
        // Yêu cầu trước là "Sớm nhất" (Cũ nhất lên đầu)
        parsedList.sort((a, b) {
          final DateTime? dateA = a.transaction?.paymentCompleteAt;
          final DateTime? dateB = b.transaction?.paymentCompleteAt;
          if (dateA == null || dateB == null) return 0;
          return dateA.compareTo(dateB);
        });

        emit(state.copyWith(
          historyStatus: WalletStatus.success,
          transactions: parsedList,
        ));
      } else {
        emit(state.copyWith(
          historyStatus: WalletStatus.failure,
          transactions: [], // Clear data cũ
          message: response['message'] ?? "Lỗi tải lịch sử",
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        historyStatus: WalletStatus.failure,
        message: e.toString(),
      ));
    }
  }
}
