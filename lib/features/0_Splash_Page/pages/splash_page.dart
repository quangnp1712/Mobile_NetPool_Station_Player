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
      // Sử dụng Stack để chồng các widget lên nhau
      body: Stack(
        fit: StackFit.expand, // Đảm bảo Stack lấp đầy toàn bộ màn hình
        children: [
          // Lớp 1: Background Gradient
          // Dựa trên ảnh, đây là gradient từ Tím/Magenta sang Xanh/Cyan đậm
          _buildBackgroundGradient(),

          // Lớp 2: Logo (Icon và Text)
          // Chúng ta đặt logo ở 1/3 trên của màn hình
          Positioned(
            top: screenSize.height * 0.25, // Căn logo ở 25% từ trên xuống
            left: 0,
            right: 0,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48.0),
                child:
                    // !!! QUAN TRỌNG:
                    // Bạn cần thay thế 'assets/images/netpool_logo_splash.png'
                    // bằng đường dẫn chính xác đến file ảnh logo của bạn.
                    // Đừng quên khai báo nó trong file `pubspec.yaml`!
                    Image.asset(
                  'assets/images/logo_mobile.png',
                  // Bạn có thể điều chỉnh chiều rộng nếu cần
                  width: screenSize.width * 0.7, // Rộng bằng 70% màn hình
                ),
              ),
            ),
          ),

          // Lớp 3: Loading Indicator ở dưới cùng
          // Sử dụng Align để đẩy widget xuống cuối màn hình
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              // Thêm padding để vòng xoay không bị dính sát cạnh dưới
              padding: const EdgeInsets.only(bottom: 64.0),
              child: CircularProgressIndicator(
                // Đặt màu tím cho vòng xoay như bạn yêu cầu
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryGlow, // Màu tím/magenta
                ),
                strokeWidth: 3.0, // Độ dày của vòng xoay
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Widget riêng để build nền gradient
  Widget _buildBackgroundGradient() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          // !!! QUAN TRỌNG:
          // Bạn cần thay thế 'assets/images/splash_background.png'
          // bằng đường dẫn chính xác đến file ảnh NỀN của bạn.
          image: const AssetImage('assets/images/bg_mobile.png'),

          // Đảm bảo ảnh nền lấp đầy toàn bộ màn hình
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
