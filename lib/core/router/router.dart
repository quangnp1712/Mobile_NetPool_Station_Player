import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:mobile_netpool_station_player/core/router/routes.dart';
import 'package:mobile_netpool_station_player/features/0_Splash_Page/pages/splash_page.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.2_Login/bloc/login_page_bloc.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.2_Login/pages/login_page.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.3_Register/bloc/register_bloc.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.3_Register/pages/1.3.1_register_1.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.3_Register/pages/1.3.2_Register_2.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.4_Valid_Email/bloc/valid_email_bloc.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.4_Valid_Email/pages/send_verify_page.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.4_Valid_Email/pages/verify_email_page.dart';
import 'package:mobile_netpool_station_player/features/2_Home_Page/pages/home_page.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/bloc/booking_page_bloc.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/pages/booking_page.dart';
import 'package:mobile_netpool_station_player/features/Common/Landing/bloc/landing_navigation_bottom_bloc.dart';
import 'package:mobile_netpool_station_player/features/Common/Landing/pages/landing_navigation_bottom.dart';

class RouteGenerator {
  final LandingNavigationBottomBloc landingBloc = LandingNavigationBottomBloc();
  final LoginPageBloc loginBloc = LoginPageBloc();
  final RegisterBloc registerBloc = RegisterBloc();
  final ValidEmailBloc validEmailBloc = ValidEmailBloc();
  final BookingPageBloc bookingPageBloc = BookingPageBloc();

  List<GetPage> routes() {
    return [
      // PAGE //
      GetPage(
        name: landingRoute,
        page: () => BlocProvider<LandingNavigationBottomBloc>.value(
            value: landingBloc, child: const LandingNavBottomWidget()),
      ),

      // 0: Splash Page //
      GetPage(
        name: splashPageRoute,
        page: () => const SplashPage(),
      ),

      // 1: Authentication Page //

      GetPage(
        name: loginPageRoute,
        page: () => BlocProvider<LoginPageBloc>.value(
            value: loginBloc, child: const LoginPage()),
      ),

      GetPage(
        name: register1PageRoute,
        page: () => BlocProvider<RegisterBloc>.value(
            value: registerBloc, child: const RegisterPage1()),
      ),
      GetPage(
        name: register2PageRoute,
        page: () => BlocProvider<RegisterBloc>.value(
            value: registerBloc, child: const RegisterPage2()),
      ),
      GetPage(
        name: validEmailPageRoute,
        page: () => BlocProvider<ValidEmailBloc>.value(
            value: validEmailBloc, child: const ValidEmailPage()),
      ),
      GetPage(
        name: sendValidCodePageRoute,
        page: () => BlocProvider<ValidEmailBloc>.value(
            value: validEmailBloc, child: const SendValidPage()),
      ),

      // 2: Home Page //
      GetPage(
        name: homePageRoute,
        page: () {
          callback(int index) {}
          return HomePage(callback);
        },
      ),

      GetPage(
        name: bookingPageRoute,
        page: () {
          callback(int index) {}
          return BlocProvider<BookingPageBloc>.value(
              value: bookingPageBloc, child: BookingPage(callback));
        },
      ),
    ];
  }
}
