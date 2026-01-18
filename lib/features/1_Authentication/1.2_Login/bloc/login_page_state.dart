// ignore_for_file: camel_case_types

part of 'login_page_bloc.dart';

sealed class LoginPageState {
  const LoginPageState();
}

final class LoginPageInitial extends LoginPageState {
  String? email;
  LoginPageInitial({this.email});
}

abstract class LoginActionState extends LoginPageState {}

class ShowRegisterState extends LoginActionState {}

class Login_ChangeState extends LoginActionState {}

class Login_LoadingState extends LoginPageState {
  final bool isLoading;

  Login_LoadingState({required this.isLoading});
}

class LoginSuccessState extends LoginActionState {
  AuthenticationModel authenticationModel;
  LoginSuccessState({
    required this.authenticationModel,
  });
}

class ShowSnackBarActionState extends LoginActionState {
  final String message;
  final bool success;

  ShowSnackBarActionState({required this.success, required this.message});
}
