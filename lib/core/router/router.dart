import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:mobile_netpool_station_player/core/router/routes.dart';
import 'package:mobile_netpool_station_player/features/0_Splash_Page/pages/splash_page.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.2_Login/pages/login_page.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.3_Register/pages/1.3.1_Register_1.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.3_Register/pages/1.3.2_Register_2.dart';
import 'package:mobile_netpool_station_player/features/2_Home_Page/pages/home_page.dart';
import 'package:mobile_netpool_station_player/features/Common/Landing/bloc/landing_navigation_bottom_bloc.dart';
import 'package:mobile_netpool_station_player/features/Common/Landing/pages/landing_navigation_bottom.dart';

class RouteGenerator {
  final LandingNavigationBottomBloc landingBloc = LandingNavigationBottomBloc();

  List<GetPage> routes() {
    return [
      // PAGE //
      GetPage(
        name: landingNavBottomWidgetRoute,
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
        page: () => const LoginPage(),
      ),
      GetPage(
        name: register1PageRoute,
        page: () => const RegisterPage1(),
      ),
      GetPage(
        name: register2PageRoute,
        page: () => const RegisterPage2(),
      ),

      // 2: Home Page //
      GetPage(
        name: homePageRoute,
        page: () {
          callback(int index) {}
          return HomePage(callback);
        },
      ),
    ];
  }
}
