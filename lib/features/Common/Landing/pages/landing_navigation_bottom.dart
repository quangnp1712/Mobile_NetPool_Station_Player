// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:community_material_icon/community_material_icon.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:mobile_netpool_station_player/core/theme/app_colors.dart';
import 'package:mobile_netpool_station_player/features/2_Home_Page/pages/home_page.dart';
import 'package:mobile_netpool_station_player/features/3_Station_Page/3.1_Station_List/pages/station_page.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/pages/booking_page.dart';
import 'package:mobile_netpool_station_player/features/5_Matching_Page/5.1_Matching_List/pages/matching_page.dart';
import 'package:mobile_netpool_station_player/features/6_Menu_Page/6.1_Menu/pages/menu_page.dart';
import 'package:mobile_netpool_station_player/features/Common/Landing/bloc/landing_navigation_bottom_bloc.dart';

class LandingNavBottomWidget extends StatefulWidget {
  final int? index;
  const LandingNavBottomWidget({
    super.key,
    this.index,
  });

  @override
  State<LandingNavBottomWidget> createState() => _LandingNavBottomWidgetState();
}

class _LandingNavBottomWidgetState extends State<LandingNavBottomWidget> {
  final LandingNavigationBottomBloc landingBloc = LandingNavigationBottomBloc();

  int bottomIndex = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  void setPage(index) {
    final CurvedNavigationBarState? navBarState =
        _bottomNavigationKey.currentState;
    navBarState?.setPage(index);
  }

  @override
  void initState() {
    // landingBloc.add(LandingNavigationBottomInitialEvent());0
    // print('Current Route: ${Get.currentRoute}');
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.index != null) {
        bottomIndex = widget.index!;
        setPage(bottomIndex);
      }
    });
  }

  @override
  void dispose() {
    // landingBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      HomePage(setPage),
      StationPage(setPage),
      BookingPage(setPage),
      MatchingPage(setPage),
      MenuPage(setPage),
    ];
    return BlocConsumer<LandingNavigationBottomBloc,
        LandingNavigationBottomInitial>(
      bloc: landingBloc,
      listener: (context, state) {},
      builder: (context, state) {
        return Stack(
          fit: StackFit.expand,
          children: [
            Container(
              color: AppColors.bgDark,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 60.0,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF8A2387),
                      Colors.black,
                      Color(0xFF004D7A),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
            ),
            SafeArea(
              child: PopScope(
                canPop: false,
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: pages[state.bottomIndex],
                  bottomNavigationBar: CurvedNavigationBar(
                    key: _bottomNavigationKey,
                    color: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    buttonBackgroundColor: AppColors.menuActive,
                    height: 60.0,
                    items: const [
                      CurvedNavigationBarItem(
                        child: Icon(Icons.home_outlined, color: Colors.white),
                        label: 'Trang chủ',
                        labelStyle:
                            TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      CurvedNavigationBarItem(
                        child: Icon(Icons.list_alt, color: Colors.white),
                        label: 'Station',
                        labelStyle:
                            TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      CurvedNavigationBarItem(
                        child: Icon(Icons.calendar_month, color: Colors.white),
                        label: 'Đặt lịch',
                        labelStyle:
                            TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      CurvedNavigationBarItem(
                        child: Icon(
                            CommunityMaterialIcons.ticket_percent_outline,
                            color: Colors.white),
                        label: 'Ghép đội',
                        labelStyle:
                            TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      CurvedNavigationBarItem(
                        child: Icon(Icons.perm_identity, color: Colors.white),
                        label: 'Tài khoản',
                        labelStyle:
                            TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                    onTap: (index) {
                      landingBloc.add(LandingNavigationBottomTabChangeEvent(
                          bottomIndex: index));
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
