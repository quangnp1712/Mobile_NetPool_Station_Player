import 'package:flutter/material.dart';
import 'package:mobile_netpool_station_player/core/theme/app_colors.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.1_Authentication/widgets/appbar.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.1_Authentication/widgets/custom_text_field.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.1_Authentication/widgets/form_container.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.1_Authentication/widgets/gradient_button.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.1_Authentication/widgets/switch_link.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.3_Register/pages/1.3.2_Register_2.dart';

class RegisterPage1 extends StatefulWidget {
  const RegisterPage1({super.key});

  @override
  State<RegisterPage1> createState() => _RegisterPage1State();
}

class _RegisterPage1State extends State<RegisterPage1> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

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
      child: Scaffold(
        backgroundColor: Colors.transparent, // <-- QUAN TRỌNG
        extendBodyBehindAppBar: true,
        appBar: const AuthenticationAppBar(title: 'ĐĂNG KÝ'),
        body: SafeArea(
          child: SingleChildScrollView(
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
                      Center(
                        child: Image.asset(
                          'assets/images/logo_no_bg.png',
                          // Bạn có thể điều chỉnh chiều rộng nếu cần
                          width:
                              screenSize.width * 0.6, // Rộng bằng 70% màn hình
                        ),
                      ),
                      const SizedBox(height: 50),
                      const Text(
                        'Đăng ký',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const CustomTextField(
                        label: 'Họ',
                        hint: 'Nhập họ của bạn',
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(height: 25),
                      const CustomTextField(
                        label: 'Tên',
                        hint: 'Nhập tên của bạn',
                        icon: Icons.lock_outline,
                      ),
                      const SizedBox(height: 25),
                      const CustomTextField(
                        label: 'Căn cước công dân',
                        hint: 'Nhập tên của bạn',
                        icon: Icons.lock_outline,
                      ),
                      const SizedBox(height: 25),
                      const CustomTextField(
                        label: 'Số điện thoại',
                        hint: 'Nhập số điện thoại của bạn',
                        icon: Icons.lock_outline,
                      ),
                      const SizedBox(height: 30),
                      GradientButton(
                        text: 'Tiếp tục',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterPage2()),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      AuthSwitchLink(
                        text: 'Bạn đã có tài khoản? ',
                        linkText: 'Đăng nhập',
                        onTap: () {
                          Navigator.pop(context);
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
