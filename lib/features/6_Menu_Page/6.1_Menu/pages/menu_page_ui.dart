import 'package:flutter/material.dart';
import 'package:mobile_netpool_station_player/features/6_Menu_Page/6.1_Menu/widget/logout_button.dart';
import 'package:mobile_netpool_station_player/features/6_Menu_Page/6.2_Profile/pages/profile_page.dart';
import '../widget/appbar.dart';
import '../widget/section_avatar.dart';
import '../widget/option_card.dart';

class MenuPage extends StatefulWidget {
  final Function callback;

  const MenuPage(this.callback, {super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int _selectedIndex = 4; // tab Tài khoản đang chọn

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: const MenuAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const MenuAvatarSection(
              username: 'Anh Tuấn',
              avatarUrl: '', // URL avatar
            ),
            const SizedBox(height: 24),

            // 🟣 Các mục UI
            MenuOptionCard(
              icon: Icons.person_outline,
              title: 'Xem thông tin tài khoản',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(),
                  ),
                );
              },
            ),

            MenuOptionCard(
              icon: Icons.account_balance_wallet_outlined,
              title: 'Ví Tiền',
              onTap: () {
                // TODO: điều hướng UI
              },
            ),
            MenuOptionCard(
              icon: Icons.settings_outlined,
              title: 'Cài đặt',
              onTap: () {
                // TODO: điều hướng UI
              },
            ),
            MenuOptionCard(
              icon: Icons.help_outline,
              title: 'Hỗ trợ & FAQ',
              onTap: () {
                // TODO: điều hướng UI
              },
            ),
            MenuLogoutButton(
              onTap: () {
                // TODO: xử lý đăng xuất
              },
            ),
          ],
        ),
      ),
    );
  }
}
