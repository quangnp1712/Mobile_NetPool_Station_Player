import 'package:flutter/material.dart';
import 'package:mobile_netpool_station_player/features/6_Menu_Page/6.2_Profile/widget/appbar.dart';
import 'package:mobile_netpool_station_player/features/6_Menu_Page/6.2_Profile/widget/body.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Nếu muốn AppBar tổng thể, dùng đây
      // appBar: AppBar(title: Text('Thông tin tài khoản')),
      appBar: ProfileAppbar(),
      body: const ProfileBody(),
    );
  }
}
