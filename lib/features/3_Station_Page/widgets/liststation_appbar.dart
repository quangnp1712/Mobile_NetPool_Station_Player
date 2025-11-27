// file: ListStation_Appbar.dart
import 'package:flutter/material.dart';

class ListStationAppbar extends StatelessWidget implements PreferredSizeWidget {
  const ListStationAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false, // bỏ nút back
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
        children: const [
          Icon(Icons.videogame_asset_rounded,
              color: Colors.purpleAccent, size: 28),
          SizedBox(width: 8),
          Text(
            'Danh Sách Station',
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
