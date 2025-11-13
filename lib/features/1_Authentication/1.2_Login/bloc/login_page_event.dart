part of 'login_page_bloc.dart';

sealed class LoginPageEvent {
  const LoginPageEvent();
}

class LoginInitialEvent extends LoginPageEvent {}

class SubmitLoginEvent extends LoginPageEvent {
  final String email;
  final String password;
  SubmitLoginEvent({
    required this.email,
    required this.password,
  });
}

class ShowRegisterEvent extends LoginPageEvent {}
