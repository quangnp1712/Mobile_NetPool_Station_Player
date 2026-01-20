import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:mobile_netpool_station_player/core/utils/debug_logger.dart';
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
      WalletRefreshBalanceEvent event, Emitter<WalletState> emit) async {
    emit(state.copyWith(balanceStatus: WalletStatus.loading));
    try {
      final response = await WalletRepository().getWallet();
      var responseBody = WalletModelResponse.fromJson(response['body']);
      if (response['success'] == true && responseBody.data != null) {
        WalletModel data = responseBody.data!;
        double balance = 0;
        // Parsing an toàn

        if (data.balance != null) {
          balance = (data.balance ?? 0).toDouble();
        } else if (data.amount != null) {
          balance = (data.amount ?? 0).toDouble();
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
        DebugLogger.printLog(
            response['message'] ?? "Không thể lấy thông tin ví");
      }
    } catch (e) {
      emit(state.copyWith(
        balanceStatus: WalletStatus.failure,
        message: e.toString(),
      ));
      DebugLogger.printLog(e.toString());
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
    // Lưu số dư cũ để so sánh
    final double oldBalance = state.balance;

    emit(state.copyWith(
        paymentStatus: PaymentActionStatus.processing,
        message: "Đang tạo giao dịch..."));

    try {
      final walletModel = WalletModel(amount: amount, currency: "VND");
      final response = await WalletRepository().addMoneyToWallet(walletModel);
      var responseBody = WalletModelResponse.fromJson(response['body']);

      if (response['success'] == true && responseBody.data != null) {
        final data = responseBody.data!;
        final String? checkoutUrl = data.checkoutUrl;

        if (checkoutUrl != null && checkoutUrl.isNotEmpty) {
          // 2. Có link thanh toán -> Emit URL để UI mở
          emit(state.copyWith(
            paymentStatus: PaymentActionStatus
                .waitingForPayment, // Trạng thái chờ thanh toán
            paymentUrl: checkoutUrl,
            message: "Đang mở cổng thanh toán...",
          ));

          // 3. Đợi 30 giây để người dùng thanh toán
          await Future.delayed(const Duration(seconds: 30));

          // 4. Kiểm tra lại số dư
          // Gọi trực tiếp repo để lấy dữ liệu mới nhất mà không cần qua event
          final checkResponse = await WalletRepository().getWallet();
          var checkResponseBody =
              WalletModelResponse.fromJson(checkResponse['body']);

          double newBalance = oldBalance;
          if (checkResponse['success'] == true &&
              checkResponseBody.data != null) {
            final WalletModel checkData = checkResponseBody.data!;

            if (checkData.balance != null) {
              newBalance = (checkData.balance ?? 0).toDouble();
            } else if (checkData.amount != null) {
              newBalance = (checkData.amount ?? 0).toDouble();
            }
          }

          // 5. So sánh
          if (newBalance > oldBalance) {
            emit(state.copyWith(
              paymentStatus: PaymentActionStatus.success,
              balance: newBalance, // Cập nhật luôn số dư hiển thị
              message:
                  "Nạp tiền thành công! +${NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(amount)}",
              paymentUrl: null, // Reset URL
            ));
            // Trigger refresh lịch sử nếu cần
            add(WalletFetchHistoryEvent());
          } else {
            emit(state.copyWith(
              paymentStatus: PaymentActionStatus.failure,
              message:
                  "Chưa nhận được tiền. Nếu bạn đã thanh toán, vui lòng đợi hệ thống cập nhật.",
              paymentUrl: null,
            ));
          }
        } else {
          emit(state.copyWith(
              paymentStatus: PaymentActionStatus.failure,
              message: "Không lấy được link thanh toán"));
        }
      } else {
        emit(state.copyWith(
            paymentStatus: PaymentActionStatus.failure,
            message: response['message'] ?? "Lỗi tạo giao dịch"));
      }
    } catch (e) {
      emit(state.copyWith(
          paymentStatus: PaymentActionStatus.failure, message: "Lỗi: $e"));
    } finally {
      // Reset về idle sau khi hoàn tất quy trình (thành công hoặc thất bại) để cho phép nạp tiếp
      if (state.paymentStatus == PaymentActionStatus.success ||
          state.paymentStatus == PaymentActionStatus.failure) {
        // Giữ trạng thái một chút để UI hiển thị dialog rồi mới reset nếu cần,
        // hoặc UI tự handle việc đóng dialog. Ở đây ta cứ để trạng thái đó.
        emit(state.copyWith(paymentStatus: PaymentActionStatus.idle));
      }
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

    // Ngày đầu tháng: YYYY-MM-01T00:00:00
    final DateTime startOfMonth = DateTime(date.year, date.month, 1, 0, 0, 0);

    // Ngày cuối tháng: YYYY-MM-LastDayT23:59:59
    final DateTime endOfMonth =
        DateTime(date.year, date.month + 1, 0, 23, 59, 59);

    // Format theo ISO 8601 như yêu cầu
    final String dateFrom =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(startOfMonth);
    final String dateTo =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(endOfMonth);

    try {
      final response =
          await WalletRepository().getPaymentHistory(dateFrom, dateTo);
      var responseBody = WalletLedgerModelResponse.fromJson(response['body']);

      if (response['success'] == true && responseBody.data != null) {
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
        message: "Lỗi xin vui lòng thử lại",
      ));
      DebugLogger.printLog(e.toString());
    }
  }
}
