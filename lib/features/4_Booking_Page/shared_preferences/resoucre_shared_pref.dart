import 'package:mobile_netpool_station_player/core/utils/shared_preferences_helper.dart';

class BookingSharedPref {
  static Future<void> setPassword(String password) async {
    await SharedPreferencesHelper.preferences
        .setString("booking_password", password);
  }

  static String getPassword() {
    return SharedPreferencesHelper.preferences.getString("booking_password") ??
        "";
  }
}
