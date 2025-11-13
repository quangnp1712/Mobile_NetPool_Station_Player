import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_netpool_station_player/core/theme/app_colors.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.1_Authentication/widgets/appbar.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.1_Authentication/widgets/custom_text_field.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.1_Authentication/widgets/form_container.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.1_Authentication/widgets/gradient_button.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.1_Authentication/widgets/switch_link.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.3_Register/pages/1.3.1_Register_1.dart';
import 'package:mobile_netpool_station_player/features/2_Home_Page/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    // 1. Bọc MỌI THỨ trong Container chứa gradient
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF3B1F5A), // Màu tím
            kScaffoldBackground, // Màu đen
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.5], // Giữ nguyên stops của bạn
        ),
      ),
      // 2. Đặt Scaffold BÊN TRONG, và làm nó TRONG SUỐT
      child: Scaffold(
        backgroundColor: Colors.transparent, // <-- QUAN TRỌNG
        extendBodyBehindAppBar: true,
        appBar: const AuthenticationAppBar(title: 'ĐĂNG NHẬP'),
        // 3. Body bây giờ chỉ cần chứa SafeArea và SingleChildScrollView
        body: SafeArea(
          child: SingleChildScrollView(
            // Padding này là khoảng cách từ box đến viền màn hình
            padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Box phát sáng bọc toàn bộ nội dung
                FormContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // const LogoWidget(), // Logo nằm BÊN TRONG box
                      Center(
                        child: Image.asset(
                          'assets/images/logo_no_bg.png',
                          // Bạn có thể điều chỉnh chiều rộng nếu cần
                          width: screenSize.width, // Rộng bằng 70% màn hình
                        ),
                      ),
                      const SizedBox(height: 50),
                      const Text(
                        'Đăng nhập',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const CustomTextField(
                        label: 'Email',
                        hint: 'quangnp1712@gmail.com',
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(height: 25),
                      const CustomTextField(
                        label: 'Mật khẩu',
                        hint: '••••••••••',
                        icon: Icons.lock_outline,
                        obscureText: true,
                      ),
                      const SizedBox(height: 30),
                      GradientButton(
                        text: 'Đăng nhập',
                        onPressed: () {
                          // Get.back(); // Chú ý: Cần import Get nếu dùng
                          // Tạm thay bằng Navigator.pop
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () {/* TODO: Xử lý quên mật khẩu */},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Quên mật khẩu',
                            style: TextStyle(
                              color: kLinkForgot,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                              decorationColor: kLinkForgot,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      AuthSwitchLink(
                        text: 'Bạn chưa có tài khoản? ',
                        linkText: 'Đăng ký',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterPage1()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
