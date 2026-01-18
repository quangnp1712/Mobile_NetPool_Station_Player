import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobile_netpool_station_player/core/router/routes.dart';
import 'package:mobile_netpool_station_player/core/theme/app_colors.dart';

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
      Get.offAllNamed(landingRoute);
    } else {
      Get.offAllNamed(landingRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildBackgroundGradient(),
          Positioned(
            top: screenSize.height * 0.25,
            left: 0,
            right: 0,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48.0),
                child: Image.asset(
                  'assets/images/logo_mobile.png',
                  width: screenSize.width * 0.7,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 64.0),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryGlow,
                ),
                strokeWidth: 3.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundGradient() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage('assets/images/bg_mobile.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
