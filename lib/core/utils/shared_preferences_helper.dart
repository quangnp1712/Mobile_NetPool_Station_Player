import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static SharedPreferences? _preferences;
  static SharedPreferencesHelper? _instance;

  SharedPreferencesHelper._();

  static SharedPreferencesHelper get instance {
    _instance ??= SharedPreferencesHelper._();
    return _instance!;
  }

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static SharedPreferences get preferences {
    return _preferences!;
  }

  static Future<void> clearAll() async {
    await preferences.clear();
  }
}
