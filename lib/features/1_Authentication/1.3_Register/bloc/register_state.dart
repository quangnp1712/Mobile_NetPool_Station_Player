// ignore_for_file: camel_case_types

part of 'register_bloc.dart';

sealed class RegisterState {
  const RegisterState();
}

final class RegisterInitial extends RegisterState {}

abstract class RegisterActionState extends RegisterState {}

class ShowRegisterState extends RegisterActionState {}

class Register_ChangeState extends RegisterActionState {}

class Register_LoadingState extends RegisterActionState {
  final bool isLoading;

  Register_LoadingState({required this.isLoading});
}

class Register1SuccessState extends RegisterActionState {}

class Register2SuccessState extends RegisterActionState {}

class ShowSnackBarActionState extends RegisterActionState {
  final String message;
  final bool success;

  ShowSnackBarActionState({required this.success, required this.message});
}
