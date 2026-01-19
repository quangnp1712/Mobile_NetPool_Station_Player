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
import 'package:mobile_netpool_station_player/features/1_Authentication/1.2_Login/bloc/login_page_bloc.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/shared_preferences/booking_shared_pref.dart';
import 'package:mobile_netpool_station_player/features/6_Menu_Page/6.1_Menu/shared_preferences/menu_shared_pref.dart';
import 'package:mobile_netpool_station_player/features/Common/Landing/pages/landing_navigation_bottom.dart';
import 'package:mobile_netpool_station_player/features/Common/snackbar/snackbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final LoginPageBloc loginPageBloc = LoginPageBloc();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    loginPageBloc.add(LoginInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF3B1F5A),
            kScaffoldBackground,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.5],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: const AuthenticationAppBar(title: 'ĐĂNG NHẬP'),
        body: SafeArea(
          child:

              //$ Bloc
              BlocConsumer<LoginPageBloc, LoginPageState>(
            bloc: loginPageBloc,
            listenWhen: (previous, current) => current is LoginActionState,
            buildWhen: (previous, current) => current is! LoginActionState,
            listener: (context, state) {
              switch (state.runtimeType) {
                case const (LoginSuccessState):
                  if (MenuSharedPref.getIsMenuRoute()) {
                    MenuSharedPref.clearIsMenuRoute();
                    Get.offAll(LandingNavBottomWidget(index: 4));
                  } else if (BookingSharedPref.getIsBookingRoute()) {
                    BookingSharedPref.clearIsBookingRoute();
                    Get.offAll(LandingNavBottomWidget(index: 2));
                  } else {
                    Get.offAllNamed(landingRoute);
                  }
                  break;

                case const (ShowSnackBarActionState):
                  final snackBarState = state as ShowSnackBarActionState;
                  ShowSnackBar(context,snackBarState.message, snackBarState.success);
                  break;
              }
            },
            builder: (context, state) {
              if (state is LoginPageInitial) {
                emailController.text = state.email ?? "";
              }
              if (state is Login_LoadingState) {
                isLoading = state.isLoading;
              }
              if (state is ShowSnackBarActionState) {
                isLoading = false;
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 30.0, vertical: 20.0),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FormContainer(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Center(
                              child: Image.asset(
                                'assets/images/logo_no_bg.png',
                                width: screenSize.width,
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
                            CustomTextField(
                              label: 'Email',
                              hint: 'Nhập Email',
                              icon: Icons.person_outline,
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              inputFormatters: [
                                FilteringTextInputFormatter.singleLineFormatter,
                                FilteringTextInputFormatter.deny(
                                    RegExp(r'[^a-zA-Z0-9@._-]')),
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email không được để trống';
                                }
                                if (!RegExp(
                                        r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value)) {
                                  return 'Email không hợp lệ';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 25),
                            CustomTextField(
                              label: 'Mật khẩu',
                              hint: 'Nhập Mật khẩu',
                              icon: Icons.lock_outline,
                              obscureText: true,
                              controller: passwordController,
                              inputFormatters: [
                                FilteringTextInputFormatter.singleLineFormatter,
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Vui lòng nhập mật khẩu ';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 30),
                            GradientButton(
                              text: 'Đăng nhập',
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  loginPageBloc.add(SubmitLoginEvent(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  ));
                                }
                              },
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                // TextButton(
                                //   onPressed: () {
                                //   },
                                //   style: TextButton.styleFrom(
                                //     padding: EdgeInsets.zero,
                                //     minimumSize: Size.zero,
                                //     tapTargetSize:
                                //         MaterialTapTargetSize.shrinkWrap,
                                //   ),
                                //   child: Text(
                                //     'Quên mật khẩu',
                                //     style: TextStyle(
                                //       color: kLinkForgot,
                                //       fontSize: 14,
                                //       fontWeight: FontWeight.w500,
                                //       decoration: TextDecoration.underline,
                                //       decorationColor: kLinkForgot,
                                //     ),
                                //   ),
                                // ),
                                TextButton(
                                  onPressed: () {
                                    Get.toNamed(sendValidCodePageRoute);
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    'Xác thực email',
                                    style: TextStyle(
                                      color: kLinkForgot,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.underline,
                                      decorationColor: kLinkForgot,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            AuthSwitchLink(
                              text: 'Bạn chưa có tài khoản? ',
                              linkText: 'Đăng ký',
                              onTap: () {
                                loginPageBloc.add(ShowRegisterEvent());
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
