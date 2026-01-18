// ignore_for_file: depend_on_referenced_packages, no_leading_underscores_for_local_identifiers

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile_netpool_station_player/core/services/authentication_service.dart';
import 'package:mobile_netpool_station_player/core/utils/debug_logger.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.1_Authentication/shared_preferences/auth_shared_preferences.dart';
import 'package:mobile_netpool_station_player/features/6_Menu_Page/6.2_Profile/models/account_info_model.dart';
import 'package:mobile_netpool_station_player/features/6_Menu_Page/6.2_Profile/models/account_info_response_model.dart';
import 'package:mobile_netpool_station_player/features/6_Menu_Page/6.2_Profile/repository/profile_repository.dart';

part 'menu_page_event.dart';
part 'menu_page_state.dart';

class MenuPageBloc extends Bloc<MenuPageEvent, MenuPageState> {
  MenuPageBloc() : super(MenuPageState()) {
    on<MenuStarted>(_onStarted);
    on<MenuLogoutRequested>(_onLogoutRequested);
  }
  Future<void> _onStarted(
      MenuStarted event, Emitter<MenuPageState> emit) async {
    emit(state.copyWith(status: MenuStatus.loading));
    try {
      // 1. Kiểm tra Token hết hạn
      final checkJwtExpired = await AuthenticationService().checkJwtExpired();

      if (checkJwtExpired) {
        // Nếu token hết hạn, báo trạng thái unauthenticated để UI điều hướng
        emit(state.copyWith(status: MenuStatus.unauthenticated));
        return;
      }

      String accountId = AuthenticationPref.getAcountId().toString();

      if (accountId == "" || accountId == "0") {
        emit(state.copyWith(
          status: MenuStatus.failure,
          message: "Lỗi vui lòng thử lại",
        ));
        DebugLogger.printLog("Lỗi: không có accountID ");
        return;
      }

      //! A.  gọi API lấy chi tiết player
      AccountInfoModel _player;
      var results = await ProfileRepository().getProfile(accountId);
      var responseMessage = results['message'];
      var responseStatus = results['status'];
      var responseSuccess = results['success'];
      var responseBody = results['body'];
      if (responseSuccess || responseStatus == 200) {
        AccountInfoModelResponse resultsBody =
            AccountInfoModelResponse.fromJson(responseBody);
        if (resultsBody.data != null) {
          _player = resultsBody.data!;

          emit(state.copyWith(
            status: MenuStatus.success,
            accountInfo: _player,
            walletBalance: "150.000 đ",
          ));
        } else {
          DebugLogger.printLog("Lỗi: $responseMessage ");
          emit(state.copyWith(
            status: MenuStatus.failure,
            message: "Lỗi vui lòng thử lại",
          ));
        }
      } else {
        emit(state.copyWith(
          status: MenuStatus.failure,
          message: "Lỗi vui lòng thử lại",
        ));
      }
    } catch (e) {
      emit(state.copyWith(
          status: MenuStatus.failure, message: "Không thể tải dữ liệu: $e"));
    }
  }

  Future<void> _onLogoutRequested(
      MenuLogoutRequested event, Emitter<MenuPageState> emit) async {
    emit(state.copyWith(status: MenuStatus.loading));
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      // Logout thành công -> chuyển trạng thái về unauthenticated để out ra Login
      emit(state.copyWith(status: MenuStatus.unauthenticated));
    } catch (_) {
      emit(state.copyWith(
          status: MenuStatus.failure, message: "Đăng xuất thất bại"));
    }
  }
}
