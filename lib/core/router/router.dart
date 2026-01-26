import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:mobile_netpool_station_player/core/router/routes.dart';
import 'package:mobile_netpool_station_player/features/0_Splash_Page/pages/splash_page.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.2_Login/bloc/login_page_bloc.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.2_Login/pages/login_page.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.3_Register/bloc/register_bloc.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.3_Register/pages/register_1.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.3_Register/pages/register_2.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.4_Valid_Email/bloc/valid_email_bloc.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.4_Valid_Email/pages/1_send_verify_page.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.4_Valid_Email/pages/2_verify_email_page.dart';
import 'package:mobile_netpool_station_player/features/2_Home_Page/bloc/home_page_bloc.dart';
import 'package:mobile_netpool_station_player/features/2_Home_Page/pages/home_page.dart';
import 'package:mobile_netpool_station_player/features/3_Station_Page/3.1_Station_List/bloc/station_page_bloc.dart';
import 'package:mobile_netpool_station_player/features/3_Station_Page/3.1_Station_List/pages/station_page.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/bloc/booking_page_bloc.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/pages/booking_page.dart';
import 'package:mobile_netpool_station_player/features/5_Matching_Page/5.1_Matching/pages/5.1_Matching_List/matching_list_page.dart';
import 'package:mobile_netpool_station_player/features/5_Matching_Page/5.1_Matching/pages/5.2_Matching_Detail/matching_detail_page.dart';
import 'package:mobile_netpool_station_player/features/6_Menu_Page/6.1_Menu/bloc/menu_page_bloc.dart';
import 'package:mobile_netpool_station_player/features/6_Menu_Page/6.1_Menu/pages/menu_page.dart';
import 'package:mobile_netpool_station_player/features/6_Menu_Page/6.2_Profile/bloc/profile_page_bloc.dart';
import 'package:mobile_netpool_station_player/features/6_Menu_Page/6.2_Profile/pages/profile_page.dart';
import 'package:mobile_netpool_station_player/features/7_Booking_History_Page/bloc/booking_history_bloc.dart';
import 'package:mobile_netpool_station_player/features/7_Booking_History_Page/pages/booking_history_page.dart';
import 'package:mobile_netpool_station_player/features/8_Wallet_Payment/bloc/wallet_bloc.dart';
import 'package:mobile_netpool_station_player/features/8_Wallet_Payment/pages/wallet_me.dart';
import 'package:mobile_netpool_station_player/features/Common/Landing/bloc/landing_navigation_bottom_bloc.dart';
import 'package:mobile_netpool_station_player/features/Common/Landing/pages/landing_navigation_bottom.dart';

class RouteGenerator {
  final LandingNavigationBottomBloc landingBloc = LandingNavigationBottomBloc();
  final LoginPageBloc loginBloc = LoginPageBloc();
  final RegisterBloc registerBloc = RegisterBloc();
  final ValidEmailBloc validEmailBloc = ValidEmailBloc();
  final BookingPageBloc bookingPageBloc = BookingPageBloc();
  final BookingHistoryBloc bookingHistoryPageBloc = BookingHistoryBloc();
  final StationPageBloc stationPageBloc = StationPageBloc();
  final ProfilePageBloc profilePageBloc = ProfilePageBloc();
  final MenuPageBloc menuPageBloc = MenuPageBloc();
  final HomePageBloc homePageBloc = HomePageBloc();
  final WalletBloc walletBloc = WalletBloc();

  List<GetPage> routes() {
    return [
      //! PAGE //
      GetPage(
        name: landingRoute,
        page: () => BlocProvider<LandingNavigationBottomBloc>.value(
            value: landingBloc, child: const LandingNavBottomWidget()),
      ),

      //! 0: Splash Page //
      GetPage(
        name: splashPageRoute,
        page: () => const SplashPage(),
      ),

      //! 1: Authentication Page //

      GetPage(
        name: loginPageRoute,
        page: () => BlocProvider<LoginPageBloc>.value(
            value: loginBloc, child: const LoginPage()),
      ),

      GetPage(
        name: register1PageRoute,
        page: () => BlocProvider<RegisterBloc>.value(
            value: registerBloc, child: RegisterPage1()),
      ),
      GetPage(
        name: register2PageRoute,
        page: () => BlocProvider<RegisterBloc>.value(
            value: registerBloc, child: RegisterPage2()),
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

      //! 2: Home Page //
      GetPage(
        name: homePageRoute,
        page: () {
          callback(int index) {}
          return BlocProvider<HomePageBloc>.value(
              value: homePageBloc, child: HomePage(callback));
        },
      ),

      //! 3: Station Page //
      GetPage(
        name: stationPageRoute,
        page: () {
          callback(int index) {}
          return BlocProvider<StationPageBloc>.value(
              value: stationPageBloc, child: StationPage(callback));
        },
      ),

      //! 4: Booking Page //
      GetPage(
        name: bookingPageRoute,
        page: () {
          callback(int index) {}
          return BlocProvider<BookingPageBloc>.value(
              value: bookingPageBloc, child: BookingPage(callback));
        },
      ),

      GetPage(
        name: bookingHistoryPageRoute,
        page: () {
          return BlocProvider<BookingHistoryBloc>.value(
              value: bookingHistoryPageBloc, child: BookingHistoryPage());
        },
      ),

      //! 4: Matching Page //
      GetPage(
        name: matchingListPageRoute,
        page: () {
          callback(int index) {}
          return MatchingPage(callback);
        },
      ),
      GetPage(
        name: matchingDetailPageRoute,
        page: () => MatchingDetailPage(
          matchMakingId: Get.arguments as int,
        ),
      ),

      //! 5: Menu Page //
      GetPage(
        name: menuPageRoute,
        page: () {
          callback(int index) {}
          return BlocProvider<MenuPageBloc>.value(
              value: menuPageBloc, child: MenuPage(callback));
        },
      ),

      //$ 5.1: Profile Page //
      GetPage(
        name: profilePageRoute,
        page: () => BlocProvider<ProfilePageBloc>.value(
            value: profilePageBloc, child: const ProfilePage()),
      ),

      //! 7: Wallet Page //
      GetPage(
        name: walletPageRoute,
        page: () => BlocProvider<WalletBloc>.value(
            value: walletBloc, child: const WalletPage()),
      ),
    ];
  }
}
