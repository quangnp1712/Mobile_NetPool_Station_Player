import 'package:mobile_netpool_station_player/core/utils/shared_preferences_helper.dart';

class LoginPref {
  static Future<void> setPassword(String password) async {
    await SharedPreferencesHelper.preferences
        .setString("login_password", password);
  }

  static String getPassword() {
    return SharedPreferencesHelper.preferences.getString("login_password") ??
        "";
  }

  static Future<void> setEmail(String email) async {
    await SharedPreferencesHelper.preferences.setString("login_email", email);
  }

  static String getEmail() {
    return SharedPreferencesHelper.preferences.getString("login_email") ?? "";
  }
}
