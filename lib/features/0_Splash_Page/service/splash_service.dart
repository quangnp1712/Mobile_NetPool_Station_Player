import 'package:flutter/foundation.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:mobile_netpool_station_player/core/utils/debug_logger.dart';

abstract class ISplashService {
  void initialization();
}

class SplashService extends ISplashService {
  @override
  void initialization() async {
    if (kDebugMode) {
      DebugLogger.printLog('loading...');
    }
    await Future.delayed(const Duration(seconds: 1));
    if (kDebugMode) {
      DebugLogger.printLog('welcome!');
    }
    FlutterNativeSplash.remove();
  }
}
