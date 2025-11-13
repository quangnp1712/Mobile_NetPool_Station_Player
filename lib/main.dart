import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_netpool_station_player/core/router/router.dart';
import 'package:mobile_netpool_station_player/core/router/routes.dart';
import 'package:mobile_netpool_station_player/core/utils/shared_preferences_helper.dart';
import 'package:mobile_netpool_station_player/features/0_Splash_Page/service/splash_service.dart';
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
            // BlocProvider(create: (_) => AuthenticationBloc()),
            // BlocProvider(create: (_) => HomePageBloc()),
            // BlocProvider(create: (_) => MenuPageBloc()),
            // BlocProvider(create: (_) => ProfilePageBloc()),
            // BlocProvider(create: (_) => ChangePassPageBloc()),
            // BlocProvider(create: (_) => ChangeEmailPageBloc()),
            // BlocProvider(create: (_) => ChangeEmailPageBloc()),
            // BlocProvider(create: (_) => ShelterPageBloc()),
          ],
          child: GetMaterialApp(
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
            ],
            supportedLocales: const [Locale('vi')],
            getPages: RouteGenerator().routes(),
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.purple,
              textTheme: GoogleFonts.quicksandTextTheme(
                Theme.of(context).textTheme,
              ),
            ),
            initialRoute: splashPageRoute,
          ),
        );
      },
    );
  }
}
