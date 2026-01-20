part of 'wallet_bloc.dart';

enum WalletStatus { initial, loading, success, failure }

enum PaymentActionStatus { idle, processing, success, failure }

class WalletState extends Equatable {
  // Trạng thái chung
  final String message;

  // State cho phần Số Dư (Wallet Page)
  final WalletStatus balanceStatus;
  final double balance;

  // State cho phần Nạp Tiền (Action)
  final PaymentActionStatus paymentStatus;

  // State cho phần Lịch Sử (Payment History Page)
  final WalletStatus historyStatus;
  final List<WalletLedgerModel> transactions;
  final DateTime selectedDate; // Ngày đang chọn để lọc lịch sử

  const WalletState({
    this.message = '',
    this.balanceStatus = WalletStatus.initial,
    this.balance = 0.0,
    this.paymentStatus = PaymentActionStatus.idle,
    this.historyStatus = WalletStatus.initial,
    this.transactions = const [],
    required this.selectedDate, // Bắt buộc phải có ngày khởi tạo
  });

  // Helper để khởi tạo state mặc định
  factory WalletState.initial() {
    return WalletState(selectedDate: DateTime.now());
  }

  WalletState copyWith({
    String? message,
    WalletStatus? balanceStatus,
    double? balance,
    PaymentActionStatus? paymentStatus,
    WalletStatus? historyStatus,
    List<WalletLedgerModel>? transactions,
    DateTime? selectedDate,
  }) {
    return WalletState(
      message: message ?? '',
      balanceStatus: balanceStatus ?? WalletStatus.initial,
      balance: balance ?? this.balance,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      historyStatus: historyStatus ?? this.historyStatus,
      transactions: transactions ?? this.transactions,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }

  @override
  List<Object?> get props => [
        message,
        balanceStatus,
        balance,
        paymentStatus,
        historyStatus,
        transactions,
        selectedDate,
      ];
}
