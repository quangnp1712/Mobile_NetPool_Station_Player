// ignore_for_file: type_literal_in_constant_pattern

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_netpool_station_player/core/theme/app_colors.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.1_Authentication/widgets/appbar.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.1_Authentication/widgets/custom_text_field.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.1_Authentication/widgets/form_container.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.1_Authentication/widgets/gradient_button.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.4_Valid_Email/bloc/valid_email_bloc.dart';
import 'package:mobile_netpool_station_player/features/Common/snackbar/snackbar.dart';

//! Valid Email !//
class ValidEmailPage extends StatefulWidget {
  const ValidEmailPage({super.key});

  @override
  State<ValidEmailPage> createState() => _ValidEmailPageState();
}

class _ValidEmailPageState extends State<ValidEmailPage> {
  final _formKey = GlobalKey<FormState>();

  final ValidEmailBloc validEmailPageBloc = ValidEmailBloc();

  TextEditingController codeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  @override
  void initState() {
    validEmailPageBloc.add(ValidEmailInitialEvent());
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
        appBar: const AuthenticationAppBar(title: 'XÁC THỰC EMAIL'),
        body: SafeArea(
          //$
          //$ ---- $//
          //$ Bloc
          child: BlocConsumer<ValidEmailBloc, ValidEmailState>(
            bloc: validEmailPageBloc,
            listenWhen: (previous, current) => current is ValidEmailActionState,
            buildWhen: (previous, current) => current is! ValidEmailActionState,
            listener: (context, state) {
              switch (state.runtimeType) {
                case ShowSnackBarActionState:
                  final snackBarState = state as ShowSnackBarActionState;
                  ShowSnackBar(
                      context, snackBarState.message, snackBarState.success);
                  break;
              }
            },
            builder: (context, state) {
              if (state is ValidEmailInitial) {
                emailController.text = state.email ?? "";
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
                                width: screenSize.width * 0.6,
                              ),
                            ),
                            const SizedBox(height: 50),
                            const Text(
                              'Xác thực Email',
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
                              icon: Icons.email_outlined,
                              controller: emailController,
                              keyboardType: TextInputType.text,
                              inputFormatters: [
                                FilteringTextInputFormatter.singleLineFormatter,
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
                              label: 'Mã OTP',
                              hint: 'Nhập Mã OTP',
                              icon: Icons.lock_outline,
                              controller: codeController,
                              inputFormatters: [
                                FilteringTextInputFormatter.singleLineFormatter,
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(6),
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Vui lòng nhập Mã OTP ';
                                }

                                return null;
                              },
                            ),
                            const SizedBox(height: 30),
                            GradientButton(
                              text: 'Xác nhận',
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  validEmailPageBloc.add(SubmitValidEmailEvent(
                                    verificationCode: codeController.text,
                                  ));
                                }
                              },
                            ),
                            const SizedBox(height: 20),
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
