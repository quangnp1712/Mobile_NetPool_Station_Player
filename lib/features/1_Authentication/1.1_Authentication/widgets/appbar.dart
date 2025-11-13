import 'package:flutter/material.dart';
import 'package:mobile_netpool_station_player/core/theme/app_colors.dart';
import 'package:mobile_netpool_station_player/core/theme/app_text_styles.dart';

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
      // 1. Làm cho AppBar trong suốt để nền gradient được thấy
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,

      // 2. Giữ nguyên icon và title
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          size: 20,
          color: kHintColor,
        ),
        onPressed: () {
          // Chỉ pop nếu có thể quay lại, tránh lỗi ở màn hình Đăng nhập
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        },
      ),
      title: Text(widget.title,
          style: TextStyle(
              letterSpacing: 1.1,
              color: kHintColor,
              fontSize: 20,
              fontFamily: AppFonts.semibold)),

      // 3. Thay thế flexibleSpace bằng ảnh
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

  // 4. Set chiều cao tùy chỉnh là 60.0
}
