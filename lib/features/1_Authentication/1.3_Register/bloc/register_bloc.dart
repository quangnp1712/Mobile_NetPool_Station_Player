import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get/get.dart';
import 'package:mobile_netpool_station_player/core/router/routes.dart';
import 'package:mobile_netpool_station_player/core/utils/debug_logger.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.3_Register/model/register_model.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.3_Register/model/register_response_model.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.3_Register/repository/register_repository.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.3_Register/shared_preferences/register_shared_pref.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterModel _masterRegisterModel = RegisterModel();
  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterInitialEvent>(_registerInitialEvent);
    on<SubmitRegister1Event>(_submitRegister1Event);
    on<SubmitRegister2Event>(_submitRegister2Event);
    on<ShowLoginEvent>(_showLoginEvent);
  }

  FutureOr<void> _registerInitialEvent(
      RegisterInitialEvent event, Emitter<RegisterState> emit) {}

  FutureOr<void> _submitRegister1Event(
      SubmitRegister1Event event, Emitter<RegisterState> emit) {
    emit(Register_ChangeState());
    emit(Register_LoadingState(isLoading: true));
    try {
      String username = "${event.firstName} ${event.lastName}";
      RegisterSharedPref.setUserName(username);
      RegisterSharedPref.setPhone(event.phone);
      RegisterSharedPref.setIdentification(event.identification);

      emit(Register_LoadingState(isLoading: false));
      emit(Register1SuccessState());
    } catch (e) {
      emit(Register_LoadingState(isLoading: false));
      DebugLogger.printLog(e.toString());
      emit(ShowSnackBarActionState(
          message: "Lỗi! Vui lòng thử lại", success: false));
    }
  }

  FutureOr<void> _submitRegister2Event(
      SubmitRegister2Event event, Emitter<RegisterState> emit) async {
    emit(Register_ChangeState());

    emit(Register_LoadingState(isLoading: true));
    try {
      String username = RegisterSharedPref.getUserName();
      String phone = RegisterSharedPref.getPhone();
      String identification = RegisterSharedPref.getIdentification();
      _masterRegisterModel = RegisterModel(
          email: event.email,
          password: event.password,
          username: username,
          phone: phone,
          identification: identification);

      var results = await RegisterRepository().register(_masterRegisterModel);
      var responseMessage = results['message'];
      var responseStatus = results['status'];
      var responseSuccess = results['success'];
      var responseBody = results['body'];
      if (responseSuccess || responseStatus == 200) {
        RegisterModelResponse registerModelResponse =
            RegisterModelResponse.fromJson(responseBody);
        RegisterSharedPref.clearAll();
        RegisterSharedPref.setEmail(event.email);
        DebugLogger.printLog(
            "Register - email: ${RegisterSharedPref.getEmail().toString()}");

        emit(Register_LoadingState(isLoading: false));
        emit(Register2SuccessState());

        emit(ShowSnackBarActionState(
            message: "Đăng ký thành công", success: responseSuccess));
        return;
      } else if (responseStatus == 409) {
        emit(Register_LoadingState(isLoading: false));

        emit(ShowSnackBarActionState(
            message: "Thông tin đã tồn tại, vui lòng nhập thông tin khác",
            success: responseSuccess));
      } else if (responseStatus == 404) {
        emit(Register_LoadingState(isLoading: false));

        emit(ShowSnackBarActionState(
            message: responseMessage, success: responseSuccess));
      } else if (responseStatus == 401) {
        emit(Register_LoadingState(isLoading: false));

        emit(ShowSnackBarActionState(
            message: responseMessage, success: responseSuccess));
      } else {
        emit(Register_LoadingState(isLoading: false));
        DebugLogger.printLog("$responseStatus - $responseMessage");
        emit(ShowSnackBarActionState(
            message: "Lỗi! Vui lòng thử lại", success: false));
      }
    } catch (e) {
      emit(Register_LoadingState(isLoading: false));
      DebugLogger.printLog(e.toString());
      emit(ShowSnackBarActionState(
          message: "Lỗi! Vui lòng thử lại", success: false));
    }
  }

  FutureOr<void> _showLoginEvent(
      ShowLoginEvent event, Emitter<RegisterState> emit) {
    Get.toNamed(loginPageRoute);
  }
}
