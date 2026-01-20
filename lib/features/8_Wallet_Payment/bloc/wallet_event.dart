part of 'wallet_bloc.dart';

abstract class WalletEvent extends Equatable {
  const WalletEvent();
  @override
  List<Object?> get props => [];
}

/// Sự kiện khởi tạo ban đầu (Lấy số dư)
class WalletInitialEvent extends WalletEvent {}

/// Sự kiện làm mới số dư
class WalletRefreshBalanceEvent extends WalletEvent {}

/// Sự kiện nạp tiền
class WalletAddMoneyEvent extends WalletEvent {
  final String
      amountString; // Nhận String từ TextField để Bloc tự validate/parse

  const WalletAddMoneyEvent(this.amountString);

  @override
  List<Object?> get props => [amountString];
}

/// Sự kiện thay đổi tháng xem lịch sử (Chọn tháng)
class WalletChangeMonthEvent extends WalletEvent {
  final DateTime selectedDate;

  const WalletChangeMonthEvent(this.selectedDate);

  @override
  List<Object?> get props => [selectedDate];
}

/// Sự kiện tải lịch sử giao dịch (Dựa trên selectedDate trong State)
class WalletFetchHistoryEvent extends WalletEvent {}
