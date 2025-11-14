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
import 'package:mobile_netpool_station_player/features/1_Authentication/1.3_Register/pages/1.3.2_Register_2.dart';
import 'package:mobile_netpool_station_player/features/Common/snackbar/snackbar.dart';

//! Register 1 - Player thông tin cơ bản !//
class RegisterPage1 extends StatefulWidget {
  const RegisterPage1({super.key});

  @override
  State<RegisterPage1> createState() => _RegisterPage1State();
}

class _RegisterPage1State extends State<RegisterPage1> {
  final _formKey = GlobalKey<FormState>();

  final RegisterBloc registerPageBloc = RegisterBloc();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController identificationController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

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
          //$ ---- $//
          //$ Bloc
          child: BlocConsumer<RegisterBloc, RegisterState>(
            bloc: registerPageBloc,
            listenWhen: (previous, current) => current is RegisterActionState,
            buildWhen: (previous, current) => current is! RegisterActionState,
            listener: (context, state) {
              switch (state.runtimeType) {
                case Register1SuccessState:
                  Get.toNamed(register2PageRoute);
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
                              label: 'Họ',
                              hint: 'Nhập Họ của bạn',
                              icon: Icons.person_outline,
                              controller: firstNameController,
                              inputFormatters: [
                                FilteringTextInputFormatter
                                    .singleLineFormatter, // Đảm bảo chỉ nhập trên một dòng
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Vui lòng nhập Họ ';
                                }
                                return null; // Trả về null nếu không có lỗi
                              },
                            ),
                            const SizedBox(height: 25),
                            CustomTextField(
                              label: 'Tên',
                              hint: 'Nhập Tên của bạn',
                              icon: Icons.lock_outline,
                              controller: lastNameController,
                              inputFormatters: [
                                FilteringTextInputFormatter
                                    .singleLineFormatter, // Đảm bảo chỉ nhập trên một dòng
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Vui lòng nhập Tên ';
                                }
                                return null; // Trả về null nếu không có lỗi
                              },
                            ),
                            const SizedBox(height: 25),
                            CustomTextField(
                              label: 'Số định danh cá nhân (CMND/CCCD)',
                              hint: 'Nhập Số định danh cá nhân',
                              icon: Icons.lock_outline,
                              controller: identificationController,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.singleLineFormatter,
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(
                                    12), // Đảm bảo chỉ nhập trên một dòng
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Vui lòng nhập Sô định danh cá nhân ';
                                }
                                return null; // Trả về null nếu không có lỗi
                              },
                            ),
                            const SizedBox(height: 25),
                            CustomTextField(
                              label: 'Số điện thoại',
                              hint: 'Nhập Số điện thoại',
                              icon: Icons.lock_outline,
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.singleLineFormatter,
                                FilteringTextInputFormatter
                                    .digitsOnly, // Chỉ cho phép nhập số
                                LengthLimitingTextInputFormatter(10),
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Vui lòng nhập Số điện thoại';
                                }
                                return null; // Trả về null nếu không có lỗi
                              },
                            ),
                            const SizedBox(height: 30),
                            GradientButton(
                              text: 'Tiếp tục',
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  registerPageBloc.add(SubmitRegister1Event(
                                    identification:
                                        identificationController.text,
                                    phone: phoneController.text,
                                    firstName: firstNameController.text,
                                    lastName: lastNameController.text,
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
