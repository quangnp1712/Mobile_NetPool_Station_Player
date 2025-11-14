//! Register - station owner !//
import 'package:mobile_netpool_station_player/core/utils/shared_preferences_helper.dart';

class RegisterSharedPref {
  static Future<void> setUserName(String username) async {
    await SharedPreferencesHelper.preferences.setString("username", username);
  }

  static String getUserName() {
    return SharedPreferencesHelper.preferences.getString("username") ?? "";
  }

  static Future<void> setPhone(String phone) async {
    await SharedPreferencesHelper.preferences.setString("phone", phone);
  }

  static String getPhone() {
    return SharedPreferencesHelper.preferences.getString("phone") ?? "";
  }

  static Future<void> setIdentification(String identification) async {
    await SharedPreferencesHelper.preferences
        .setString("identification", identification);
  }

  static String getIdentification() {
    return SharedPreferencesHelper.preferences.getString("identification") ??
        "";
  }

  static Future<void> setEmail(String email) async {
    await SharedPreferencesHelper.preferences.setString("email", email);
  }

  static String getEmail() {
    return SharedPreferencesHelper.preferences.getString("email") ?? "";
  }

  static Future<void> clearEmail() async {
    // Dùng remove() để xóa một key
    await SharedPreferencesHelper.preferences.remove("email");
  }

  static Future<void> clearAll() async {
    // Dùng remove() để xóa một key
    await SharedPreferencesHelper.preferences.remove("username");
    await SharedPreferencesHelper.preferences.remove("phone");
    await SharedPreferencesHelper.preferences.remove("identification");
    await SharedPreferencesHelper.preferences.remove("email");
  }
}
