// ignore_for_file: depend_on_referenced_packages, no_leading_underscores_for_local_identifiers

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_netpool_station_player/core/router/routes.dart';
import 'package:mobile_netpool_station_player/core/services/authentication_service.dart';
import 'package:mobile_netpool_station_player/core/utils/debug_logger.dart';
import 'package:mobile_netpool_station_player/core/utils/shared_preferences_helper.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.1_Authentication/shared_preferences/auth_shared_preferences.dart';
import 'package:mobile_netpool_station_player/features/6_Menu_Page/6.1_Menu/repository/menu_repository.dart';
import 'package:mobile_netpool_station_player/features/6_Menu_Page/6.1_Menu/shared_preferences/menu_shared_pref.dart';
import 'package:mobile_netpool_station_player/features/6_Menu_Page/6.2_Profile/models/account_info_model.dart';
import 'package:mobile_netpool_station_player/features/6_Menu_Page/6.2_Profile/models/account_info_response_model.dart';
import 'package:mobile_netpool_station_player/features/8_Wallet_Payment/models/1.wallet/wallet_model.dart';
import 'package:mobile_netpool_station_player/features/8_Wallet_Payment/models/1.wallet/wallet_response_model.dart';
import 'package:mobile_netpool_station_player/features/8_Wallet_Payment/repository/wallet_repository.dart';

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
      // 1. Kiểm tra Token
      final checkJwtExpired = await AuthenticationService().checkJwtExpired();
      if (checkJwtExpired) {
        emit(state.copyWith(status: MenuStatus.unauthenticated));
        return;
      }

      String accountId = AuthenticationPref.getAcountId().toString();
      if (accountId == "" || accountId == "0") {
        emit(state.copyWith(
          status: MenuStatus.failure,
          message: "Lỗi: Không tìm thấy thông tin tài khoản",
        ));
        DebugLogger.printLog("Lỗi: không có accountID");
        return;
      }

      // 2. Gọi song song API Profile và Wallet
      final results = await Future.wait([
        MenuRepository().getProfile(accountId),
        WalletRepository().getWallet(),
      ]);

      final profileResult = results[0];
      final walletResult = results[1];

      AccountInfoModel? _player;
      double balance = 0;

      // 3. Xử lý kết quả Profile

      if (profileResult['success'] == true) {
        AccountInfoModelResponse profileBody =
            AccountInfoModelResponse.fromJson(profileResult['body']);
        _player = profileBody.data;
      }

      // 4. Xử lý kết quả Wallet
      if (walletResult['success'] == true) {
        // Kiểm tra xem body có tồn tại không trước khi parse
        var walletBody = WalletModelResponse.fromJson(walletResult['body']);
        if (walletBody.data != null) {
          try {
            WalletModel data = walletBody.data!;
            if (data.balance != null) {
              balance = (data.balance ?? 0).toDouble();
            } else if (data.amount != null) {
              balance = (data.amount ?? 0).toDouble();
            }
          } catch (e) {
            DebugLogger.printLog("Lỗi parse wallet: $e");
          }
        }
      } else {
        DebugLogger.printLog("Lỗi lấy ví: ${walletResult['message']}");
      }

      // 5. Cập nhật State
      if (_player != null) {
        emit(state.copyWith(
          status: MenuStatus.success,
          accountInfo: _player,
          walletBalance: _formatCurrency(balance),
        ));
      } else {
        emit(state.copyWith(
          status: MenuStatus.failure,
          message: "Không thể tải thông tin người dùng",
        ));
      }
    } catch (e) {
      emit(state.copyWith(
          status: MenuStatus.failure, message: "Lỗi hệ thống: $e"));
    }
  }

  Future<void> _onLogoutRequested(
      MenuLogoutRequested event, Emitter<MenuPageState> emit) async {
    emit(state.copyWith(status: MenuStatus.loading));
    try {
      var results = await MenuRepository().logout();

      SharedPreferencesHelper.clearAll();
      MenuSharedPref.setIsMenuRoute(true);
      Get.offAllNamed(loginPageRoute);
      emit(state.copyWith(
        status: MenuStatus.success,
        message: "Đăng xuất thành công",
      ));
    } catch (e) {
      SharedPreferencesHelper.clearAll();
      MenuSharedPref.setIsMenuRoute(true);
      Get.offAllNamed(loginPageRoute);
      DebugLogger.printLog("Lỗi! $e");
      emit(state.copyWith(
        status: MenuStatus.success,
        message: "Lỗi : $e",
      ));
    }
  }

  String _formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(amount);
  }
}
