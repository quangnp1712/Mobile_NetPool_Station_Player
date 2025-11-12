import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:mobile_netpool_station_player/core/router/routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToHomePage();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  }

  bool _isDisposed = false;
  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  Future<void> _navigateToHomePage() async {
    // final authenticateService = AuthenticateService();
    if (!_isDisposed && mounted) {
      await Future.delayed(const Duration(milliseconds: 3000));
      Get.offAllNamed(landingNavBottomWidgetRoute);
    } else {
      Get.offAllNamed(landingNavBottomWidgetRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/bg.png',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset(
              "assets/images/logo_1.png",
              width: size.width * 0.6,
              fit: BoxFit.contain,
            ),
            SizedBox(
              height: size.height * 0.1,
            ),
            const SpinKitFadingCircle(
              color: Colors.white,
              size: 60.0,
            )
          ]),
        ],
      ),
    );
  }
}
