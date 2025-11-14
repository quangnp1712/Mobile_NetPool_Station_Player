import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:mobile_netpool_station_player/core/router/routes.dart';
import 'package:mobile_netpool_station_player/core/theme/app_colors.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.1_Authentication/widgets/appbar.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.1_Authentication/widgets/custom_text_field.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.1_Authentication/widgets/form_container.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.1_Authentication/widgets/gradient_button.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.1_Authentication/widgets/switch_link.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.3_Register/bloc/register_bloc.dart';
import 'package:mobile_netpool_station_player/features/Common/snackbar/snackbar.dart';

class RegisterPage2 extends StatefulWidget {
  const RegisterPage2({super.key});

  @override
  State<RegisterPage2> createState() => _RegisterPage2State();
}

class _RegisterPage2State extends State<RegisterPage2> {
  final _formKey = GlobalKey<FormState>();

  final RegisterBloc registerPageBloc = RegisterBloc();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

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
        appBar: const AuthenticationAppBar(title: 'ĐĂNG NHẬP'),
        body: SafeArea(
          //$ ---- $//
          //$ Bloc

          child: BlocConsumer<RegisterBloc, RegisterState>(
            bloc: registerPageBloc,
            listenWhen: (previous, current) => current is RegisterActionState,
            buildWhen: (previous, current) => current is! RegisterActionState,
            listener: (context, state) {
              switch (state.runtimeType) {
                case Register2SuccessState:
                  Get.toNamed(validEmailPageRoute);
                  break;
                case ShowSnackBarActionState:
                  final snackBarState = state as ShowSnackBarActionState;
                  ShowSnackBar(snackBarState.message, snackBarState.success);
                  break;
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 30.0, vertical: 20.0),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                                width: screenSize.width *
                                    0.6, // Rộng bằng 70% màn hình
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
                            CustomTextField(
                              label: 'Email đăng nhập',
                              hint: 'Nhập Email của bạn',
                              icon: Icons.lock_outline,
                              controller: emailController,
                              keyboardType: TextInputType.text,
                              inputFormatters: [
                                FilteringTextInputFormatter
                                    .singleLineFormatter, // Đảm bảo chỉ nhập trên một dòng

                                FilteringTextInputFormatter.deny(
                                    RegExp(r'[^a-zA-Z0-9@._-]')),
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Vui lòng nhập email";
                                }
                                final emailRegex = RegExp(
                                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
                                if (!emailRegex.hasMatch(value)) {
                                  return "Email không hợp lệ";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 25),
                            CustomTextField(
                              label: 'Mật khẩu',
                              hint: 'Nhập mật khẩu của bạn',
                              icon: Icons.lock_outline,
                              obscureText: true,
                              controller: passwordController,
                              inputFormatters: [
                                FilteringTextInputFormatter
                                    .singleLineFormatter, // Đảm bảo chỉ nhập trên một dòng
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Vui lòng nhập mật khẩu ';
                                }

                                return null; // Trả về null nếu không có lỗi
                              },
                            ),
                            const SizedBox(height: 25),
                            CustomTextField(
                              label: 'Nhập lại mật khẩu',
                              hint: 'Nhập lại mật khẩu của bạn',
                              icon: Icons.lock_outline,
                              obscureText: true,
                              controller: confirmPasswordController,
                              inputFormatters: [
                                FilteringTextInputFormatter
                                    .singleLineFormatter, // Đảm bảo chỉ nhập trên một dòng
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Vui lòng nhập mật khẩu ';
                                }
                                if (value != passwordController.text) {
                                  return 'Mật khẩu không khớp';
                                }
                                return null; // Trả về null nếu không có lỗi
                              },
                            ),
                            const SizedBox(height: 30),
                            GradientButton(
                              text: 'Đăng ký',
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  registerPageBloc.add(SubmitRegister2Event(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  ));
                                }
                              },
                            ),
                            const SizedBox(height: 24),
                            AuthSwitchLink(
                              text: 'Bạn đã có tài khoản? ',
                              linkText: 'Đăng nhập',
                              onTap: () {
                                Get.toNamed(loginPageRoute);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
