part of 'menu_page_bloc.dart';

enum MenuStatus { initial, loading, success, failure, unauthenticated }

class MenuPageState extends Equatable {
  final MenuStatus status;
  final AccountInfoModel? accountInfo;
  final String walletBalance;
  final String? message;

  const MenuPageState({
    this.status = MenuStatus.initial,
    this.accountInfo,
    this.walletBalance = '0 đ',
    this.message,
  });

  MenuPageState copyWith({
    MenuStatus? status,
    AccountInfoModel? accountInfo,
    String? walletBalance,
    String? message,
  }) {
    return MenuPageState(
      status: status ?? MenuStatus.initial,
      accountInfo: accountInfo ?? this.accountInfo,
      walletBalance: walletBalance ?? this.walletBalance,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, accountInfo, walletBalance, message];
}
