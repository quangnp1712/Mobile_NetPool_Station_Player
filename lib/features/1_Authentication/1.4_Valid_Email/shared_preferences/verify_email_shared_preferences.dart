import 'package:mobile_netpool_station_player/core/utils/shared_preferences_helper.dart';

class VerifyEmailPref {
  static Future<void> setEmail(String email) async {
    await SharedPreferencesHelper.preferences.setString("valid_email", email);
  }

  static String getEmail() {
    return SharedPreferencesHelper.preferences.getString("valid_email") ?? "";
  }

  static Future<void> clearEmail() async {
    await SharedPreferencesHelper.preferences.remove("valid_email");
  }
}
