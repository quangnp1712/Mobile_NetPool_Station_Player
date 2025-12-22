import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart'
    as getXTransition;
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_netpool_station_player/core/router/router.dart';
import 'package:mobile_netpool_station_player/core/router/routes.dart';
import 'package:mobile_netpool_station_player/core/utils/debug_logger.dart';
import 'package:mobile_netpool_station_player/core/utils/shared_preferences_helper.dart';
import 'package:mobile_netpool_station_player/features/0_Splash_Page/service/splash_service.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.2_Login/bloc/login_page_bloc.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.3_Register/bloc/register_bloc.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.3_Register/shared_preferences/register_shared_pref.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.4_Valid_Email/bloc/valid_email_bloc.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.4_Valid_Email/shared_preferences/verify_email_shared_preferences.dart';
import 'package:mobile_netpool_station_player/features/3_Station_Page/bloc/station_page_bloc.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/bloc/booking_page_bloc.dart';
import 'package:mobile_netpool_station_player/features/Common/404/error.dart';
import 'package:mobile_netpool_station_player/features/Common/Landing/bloc/landing_navigation_bottom_bloc.dart';
import 'package:sizer/sizer.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await dotenv.load(fileName: ".env");
  await SharedPreferencesHelper.instance.init();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await FirebaseAppCheck.instance.activate(
  //   androidProvider: AndroidProvider.playIntegrity,
  // );
  _FBSignAnonymous();
  runApp(const MyApp());
}

Future<void> _FBSignAnonymous() async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInAnonymously();
    User? user = userCredential.user;
    print('Đăng nhập ẩn danh thành công: ${user!.uid}');
  } catch (e) {
    print('Lỗi không xác định: $e');
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ISplashService splashService = SplashService();

  @override
  void initState() {
    super.initState();
    splashService.initialization();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => LandingNavigationBottomBloc()),
            BlocProvider(create: (_) => LoginPageBloc()),
            BlocProvider(create: (_) => RegisterBloc()),
            BlocProvider(create: (_) => ValidEmailBloc()),
            BlocProvider(create: (_) => BookingPageBloc()),
            BlocProvider(create: (_) => StationPageBloc()),
          ],
          child: GetMaterialApp(
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('vi'),
            ],
            getPages: RouteGenerator().routes(),
            unknownRoute: GetPage(
              name: '/not-found',
              page: () => const PageNotFound(),
              transition: getXTransition.Transition.fadeIn,
            ),
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.purple,
              textTheme: GoogleFonts.robotoTextTheme(),
            ),
            initialRoute: splashPageRoute,
            // --- XỬ LÝ KHI RỜI TRANG ---
            routingCallback: (routing) {
              // Định nghĩa các route thuộc luồng Đăng ký / Quên mật khẩu
              // (Đây là các route mà bạn *cần* giữ lại email)
              const authFlowRoutes = [
                validEmailPageRoute,
              ];

              final previousRoute = routing?.previous; // Route vừa rời đi
              final currentRoute = routing?.current; // Route sắp vào

              // KIỂM TRA: Nếu ta vừa rời (previous) 1 trang trong luồng auth
              // VÀ ta sắp vào (current) 1 trang KHÔNG NẰM trong luồng auth
              // (ví dụ: đi từ /register -> /login hoặc /dashboard)
              if (authFlowRoutes.contains(previousRoute)) {
                RegisterSharedPref.clearEmail();
                VerifyEmailPref.clearEmail();
                DebugLogger.printLog("xoa Pref");
              }
            },
          ),
        );
      },
    );
  }
}
