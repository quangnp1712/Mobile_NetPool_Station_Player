import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:mobile_netpool_station_player/core/router/routes.dart';
import 'package:mobile_netpool_station_player/features/0_Splash_Page/pages/splash_page.dart';
import 'package:mobile_netpool_station_player/features/2_Home_Page/pages/home_page.dart';
import 'package:mobile_netpool_station_player/features/Common/Landing/bloc/landing_navigation_bottom_bloc.dart';
import 'package:mobile_netpool_station_player/features/Common/Landing/pages/landing_navigation_bottom.dart';

class RouteGenerator {
  final LandingNavigationBottomBloc landingBloc = LandingNavigationBottomBloc();

  List<GetPage> routes() {
    return [
      GetPage(
        name: splashPageRoute,
        page: () => const SplashPage(),
      ),
      GetPage(
        name: landingNavBottomWidgetRoute,
        page: () => BlocProvider<LandingNavigationBottomBloc>.value(
            value: landingBloc, child: const LandingNavBottomWidget()),
      ),
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
