//! Register - station owner !//
import 'package:mobile_netpool_station_player/core/utils/shared_preferences_helper.dart';

class RegisterSharedPref {
  static Future<void> setUserName(String username) async {
    await SharedPreferencesHelper.preferences
        .setString("register_username", username);
  }

  static String getUserName() {
    return SharedPreferencesHelper.preferences.getString("register_username") ??
        "";
  }

  static Future<void> setPhone(String phone) async {
    await SharedPreferencesHelper.preferences
        .setString("register_phone", phone);
  }

  static String getPhone() {
    return SharedPreferencesHelper.preferences.getString("register_phone") ??
        "";
  }

  static Future<void> setIdentification(String identification) async {
    await SharedPreferencesHelper.preferences
        .setString("register_identification", identification);
  }

  static String getIdentification() {
    return SharedPreferencesHelper.preferences
            .getString("register_identification") ??
        "";
  }

  static Future<void> setEmail(String email) async {
    await SharedPreferencesHelper.preferences
        .setString("register_email", email);
  }

  static String getEmail() {
    return SharedPreferencesHelper.preferences.getString("register_email") ??
        "";
  }

  static Future<void> clearEmail() async {
    // Dùng remove() để xóa một key
    await SharedPreferencesHelper.preferences.remove("register_email");
  }

  static Future<void> clearAll() async {
    // Dùng remove() để xóa một key
    await SharedPreferencesHelper.preferences.remove("register_username");
    await SharedPreferencesHelper.preferences.remove("register_phone");
    await SharedPreferencesHelper.preferences.remove("register_identification");
    await SharedPreferencesHelper.preferences.remove("register_email");
  }
}
