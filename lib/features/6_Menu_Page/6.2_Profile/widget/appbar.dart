import 'package:flutter/material.dart';
import 'package:mobile_netpool_station_player/features/6_Menu_Page/6.1_Menu/pages/menu_page_ui.dart';

class ProfileAppbar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
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
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 🔹 Logo (thay bằng Image.asset nếu có file logo riêng)
          const Icon(Icons.videogame_asset_rounded,
              color: Colors.purpleAccent, size: 28),
          const SizedBox(width: 8),
          const Text(
            'NETPOOL STATION BOOKING',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        onPressed: () {
          // 🔙 Quay lại HomePage
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => const MenuPage()),
          // );
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
