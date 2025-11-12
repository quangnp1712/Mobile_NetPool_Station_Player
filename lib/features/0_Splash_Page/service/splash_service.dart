import 'package:flutter/foundation.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

abstract class ISplashService {
  void initialization();
}

class SplashService extends ISplashService {
  @override
  void initialization() async {
    if (kDebugMode) {
      print('loading...');
    }
    await Future.delayed(const Duration(seconds: 1));
    if (kDebugMode) {
      print('welcome!');
    }
    FlutterNativeSplash.remove();
  }
}
