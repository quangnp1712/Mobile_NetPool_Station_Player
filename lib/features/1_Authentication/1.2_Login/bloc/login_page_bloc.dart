import 'dart:async';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile_netpool_station_player/core/utils/debug_logger.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.1_Authentication/model/authentication_model.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.1_Authentication/model/authentication_response_model.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.1_Authentication/shared_preferences/auth_shared_preferences.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.2_Login/model/login_model.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.2_Login/repository/login_repository.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.2_Login/shared_preferences/login_shared_preferences.dart';

part 'login_page_event.dart';
part 'login_page_state.dart';

class LoginPageBloc extends Bloc<LoginPageEvent, LoginPageState> {
  LoginPageBloc() : super(LoginPageState.initial()) {
    on<LoginInitialEvent>(_onLoginInitial);
    on<SubmitLoginEvent>(_onSubmitLogin);
    on<ShowRegisterEvent>(_onShowRegister);
  }

  Future<void> _onLoginInitial(
      LoginInitialEvent event, Emitter<LoginPageState> emit) async {
    String storedEmail = LoginPref.getEmail() ?? "";
    emit(state.copyWith(
      status: LoginStatus.initial,
      email: storedEmail,
    ));
  }

  Future<void> _onSubmitLogin(
      SubmitLoginEvent event, Emitter<LoginPageState> emit) async {
    // 1. Validate cơ bản (Optional)
    if (event.email.isEmpty || event.password.isEmpty) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        message: "Vui lòng nhập đầy đủ email và mật khẩu",
      ));
      return;
    }

    emit(state.copyWith(status: LoginStatus.loading));

    try {
      LoginModel loginModel =
          LoginModel(email: event.email, password: event.password);
      var results = await LoginRepository().login(loginModel);

      var responseMessage = results['message'];
      var responseStatus = results['status'];
      var responseSuccess = results['success'];
      var responseBody = results['body'];

      if (responseSuccess) {
        AuthenticationModelResponse authResponse =
            AuthenticationModelResponse.fromJson(responseBody);

        if (authResponse.data != null &&
            authResponse.data?.roleCode == "PLAYER") {
          // Lưu thông tin vào Prefs
          _saveToPrefs(authResponse.data!, event.password);

          emit(state.copyWith(
            status: LoginStatus.success,
            authenticationModel: authResponse.data,
            message: "Đăng nhập thành công",
          ));
          DebugLogger.printLog(
              "$responseStatus - $responseMessage - thành công");
        } else {
          emit(state.copyWith(
            status: LoginStatus.failure,
            message: "Tài khoản không có quyền truy cập",
          ));
        }
      } else {
        // Xử lý các mã lỗi cụ thể
        String errorMessage = "Lỗi! Vui lòng thử lại";
        if (responseStatus == 404 || responseStatus == 401) {
          errorMessage = "Email hoặc mật khẩu không đúng";
        } else if (responseStatus == 403) {
          errorMessage = "Chưa xác thực email";
        }

        DebugLogger.printLog("$responseStatus - $responseMessage");
        emit(state.copyWith(
          status: LoginStatus.failure,
          message: errorMessage,
        ));
      }
    } catch (e) {
      DebugLogger.printLog(e.toString());
      emit(state.copyWith(
        status: LoginStatus.failure,
        message: "Lỗi kết nối: ${e.toString()}",
      ));
    }
  }

  void _onShowRegister(ShowRegisterEvent event, Emitter<LoginPageState> emit) {
    // Có thể navigate trực tiếp hoặc emit state để UI navigate
    // Ở đây dùng state để đúng chuẩn Bloc
    emit(state.copyWith(status: LoginStatus.navigateRegister));
    // Reset lại status để tránh navigate nhiều lần nếu rebuild
    emit(state.copyWith(status: LoginStatus.initial));
  }

  void _saveToPrefs(AuthenticationModel data, String password) {
    AuthenticationPref.setRoleCode(data.roleCode ?? "");
    AuthenticationPref.setAccountID(data.accountId as int);
    AuthenticationPref.setAccessToken(data.accessToken ?? "");
    AuthenticationPref.setAccessExpiredAt(data.accessExpiredAt.toString());
    AuthenticationPref.setPassword(password);
    AuthenticationPref.setEmail(data.email ?? "");
    AuthenticationPref.setUserName(data.username ?? "");

    List<String>? stationJsonList =
        data.stations?.map((s) => s.toJson()).toList();
    AuthenticationPref.setStationsJson(stationJsonList ?? []);
  }
}
