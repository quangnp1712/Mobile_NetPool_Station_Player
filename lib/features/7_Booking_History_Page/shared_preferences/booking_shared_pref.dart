import 'package:mobile_netpool_station_player/core/utils/shared_preferences_helper.dart';

class BookingSharedPref {
  static Future<void> setIsBookingRoute(bool isBookingRoute) async {
    await SharedPreferencesHelper.preferences
        .setBool("isBookingRoute", isBookingRoute);
  }

  static bool getIsBookingRoute() {
    return SharedPreferencesHelper.preferences.getBool("isBookingRoute") ??
        false;
  }

  static Future<void> clearIsBookingRoute() async {
    // Dùng remove() để xóa một key
    await SharedPreferencesHelper.preferences.remove("isBookingRoute");
  }
}
