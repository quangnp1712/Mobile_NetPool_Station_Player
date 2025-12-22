import 'package:mobile_netpool_station_player/core/utils/shared_preferences_helper.dart';

class AuthenticationPref {
  static Future<void> setAccountID(int accountId) async {
    await SharedPreferencesHelper.preferences
        .setInt("auth_accountId", accountId);
  }

  static int getAcountId() {
    return SharedPreferencesHelper.preferences.getInt("auth_accountId") ?? 0;
  }

  static Future<void> setAccessToken(String token) async {
    await SharedPreferencesHelper.preferences
        .setString("auth_accessToken", token);
  }

  static String getAccessToken() {
    return SharedPreferencesHelper.preferences.getString("auth_accessToken") ??
        "";
  }

  static Future<void> setRoleCode(String role) async {
    await SharedPreferencesHelper.preferences.setString("auth_role", role);
  }

  static String getRoleCode() {
    return SharedPreferencesHelper.preferences.getString("auth_role") ?? "";
  }

  static Future<void> setAccessExpiredAt(String accessExpiredAt) async {
    await SharedPreferencesHelper.preferences
        .setString("auth_accessExpiredAt", accessExpiredAt);
  }

  static String getAccessExpiredAt() {
    return SharedPreferencesHelper.preferences
            .getString("auth_accessExpiredAt") ??
        "";
  }

  static Future<void> setPassword(String password) async {
    await SharedPreferencesHelper.preferences
        .setString("auth_password", password);
  }

  static String getPassword() {
    return SharedPreferencesHelper.preferences.getString("auth_password") ?? "";
  }

  static Future<void> setEmail(String email) async {
    await SharedPreferencesHelper.preferences.setString("auth_email", email);
  }

  static String getEmail() {
    return SharedPreferencesHelper.preferences.getString("auth_email") ?? "";
  }

  static Future<void> setStationsJson(List<String> stations) async {
    await SharedPreferencesHelper.preferences
        .setStringList("auth_stations", stations);
  }

  static List<String> getStationsJson() {
    return SharedPreferencesHelper.preferences.getStringList("auth_stations") ??
        [];
  }
}
