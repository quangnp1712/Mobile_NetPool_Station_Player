import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_netpool_station_player/core/router/routes.dart';
import 'package:mobile_netpool_station_player/core/theme/app_colors.dart';
import 'package:mobile_netpool_station_player/core/theme/app_text_styles.dart';
import 'package:mobile_netpool_station_player/features/6_Menu_Page/6.1_Menu/shared_preferences/menu_shared_pref.dart';
import 'package:mobile_netpool_station_player/features/Common/Landing/pages/landing_navigation_bottom.dart';

class AuthenticationAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  final String title;
  const AuthenticationAppBar({super.key, required this.title});

  @override
  State<AuthenticationAppBar> createState() => _AuthenticationAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}

class _AuthenticationAppBarState extends State<AuthenticationAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,

      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          size: 20,
          color: kHintColor,
        ),
        onPressed: () {
          if (MenuSharedPref.getIsMenuRoute()) {
            MenuSharedPref.clearIsMenuRoute();
            Get.offAll(LandingNavBottomWidget(index: 0));
          } else if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            Get.offNamed(landingRoute);
          }
        },
      ),
      title: Text(widget.title,
          style: TextStyle(
              letterSpacing: 1.1,
              color: kHintColor,
              fontSize: 20,
              fontFamily: AppFonts.semibold)),

      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2B0C4E), Color(0xFF5A1CCB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
      ),
      //
    );
  }
}
