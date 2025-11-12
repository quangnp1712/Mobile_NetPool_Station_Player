// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:community_material_icon/community_material_icon.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:mobile_netpool_station_player/features/2_Home_Page/pages/home_page.dart';
import 'package:mobile_netpool_station_player/features/3_Station_Page/pages/station_page.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/pages/booking_page.dart';
import 'package:mobile_netpool_station_player/features/5_Matching_Page/pages/matching_page.dart';
import 'package:mobile_netpool_station_player/features/6_Menu_Page/pages/menu_page.dart';
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

  late final HomePage homePage;
  late final StationPage stationPage;
  late final BookingPage bookingPage;
  late final MatchingPage matchingPage;
  late final MenuPage menuPage;

  void setPage(index) {
    final CurvedNavigationBarState? navBarState =
        _bottomNavigationKey.currentState;
    navBarState?.setPage(index);
  }

  @override
  void initState() {
    // Lấy token từ arguments
    // LandingNavBottomWidgetBloc.add(LandingNavBottomWidgetInitial(bottomIndex: 0) as LandingNavBottomWidgetEvent);
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
          return SafeArea(
            child: PopScope(
              canPop: false,
              child: Scaffold(
                // key: _bottomNavigationKey,
                body: pages[state.bottomIndex],
                bottomNavigationBar: CurvedNavigationBar(
                  key: _bottomNavigationKey,
                  color: Colors.white,
                  backgroundColor: Color(0xFFF36439),
                  items: const [
                    CurvedNavigationBarItem(
                      child: Icon(Icons.home_outlined),
                      label: 'Trang chủ',
                    ),
                    CurvedNavigationBarItem(
                      child: Icon(Icons.list_alt),
                      label: 'Station',
                    ),
                    CurvedNavigationBarItem(
                      child: Icon(Icons.calendar_month),
                      label: 'Đặt lịch',
                    ),
                    CurvedNavigationBarItem(
                      // child: Icon(Icons.newspaper),
                      child:
                          Icon(CommunityMaterialIcons.ticket_percent_outline),
                      label: 'Ghép đội',
                    ),
                    CurvedNavigationBarItem(
                      child: Icon(Icons.perm_identity),
                      label: 'Tài khoản',
                    ),
                  ],
                  onTap: (index) {
                    landingBloc.add(LandingNavigationBottomTabChangeEvent(
                        bottomIndex: index));
                  },
                ),
              ),
            ),
          );
        });
  }
}
