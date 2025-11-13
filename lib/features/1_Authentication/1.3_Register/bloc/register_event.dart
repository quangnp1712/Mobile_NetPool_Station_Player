part of 'register_bloc.dart';

sealed class RegisterEvent {
  const RegisterEvent();
}

class RegisterInitialEvent extends RegisterEvent {}

class SubmitRegister1Event extends RegisterEvent {
  final String identification;
  final String phone;
  final String firstName;
  final String lastName;

  SubmitRegister1Event({
    required this.firstName,
    required this.lastName,
    required this.identification,
    required this.phone,
  });
}

class SubmitRegister2Event extends RegisterEvent {
  final String email;
  final String password;

  SubmitRegister2Event({
    required this.email,
    required this.password,
  });
}

class ShowLoginEvent extends RegisterEvent {}
