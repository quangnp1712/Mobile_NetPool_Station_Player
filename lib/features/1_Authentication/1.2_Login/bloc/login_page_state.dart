// ignore_for_file: camel_case_types

part of 'login_page_bloc.dart';

enum LoginStatus { initial, loading, success, failure, navigateRegister }

class LoginPageState extends Equatable {
  final LoginStatus status;
  final String email;
  final String message;
  final AuthenticationModel? authenticationModel;

  const LoginPageState({
    this.status = LoginStatus.initial,
    this.email = '',
    this.message = '',
    this.authenticationModel,
  });

  // Helper để tạo state mặc định
  factory LoginPageState.initial() {
    return const LoginPageState();
  }

  LoginPageState copyWith({
    LoginStatus? status,
    String? email,
    String? message,
    AuthenticationModel? authenticationModel,
  }) {
    return LoginPageState(
      status: status ?? LoginStatus.initial,
      email: email ?? this.email,
      message: message ?? '',
      authenticationModel: authenticationModel ?? this.authenticationModel,
    );
  }

  @override
  List<Object?> get props => [status, email, message, authenticationModel];
}
