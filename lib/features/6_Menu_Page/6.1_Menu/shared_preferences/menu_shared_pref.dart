import 'package:mobile_netpool_station_player/core/utils/shared_preferences_helper.dart';

class MenuSharedPref {
  static Future<void> setIsMenuRoute(bool isMenuRoute) async {
    await SharedPreferencesHelper.preferences
        .setBool("isMenuRoute", isMenuRoute);
  }

  static bool getIsMenuRoute() {
    return SharedPreferencesHelper.preferences.getBool("isMenuRoute") ?? false;
  }

  static Future<void> clearIsMenuRoute() async {
    // Dùng remove() để xóa một key
    await SharedPreferencesHelper.preferences.remove("isMenuRoute");
  }
}
