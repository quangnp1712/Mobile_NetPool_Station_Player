import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mobile_netpool_station_player/core/theme/app_colors.dart';

/// Link chuyển đổi Đăng nhập / Đăng ký
class AuthSwitchLink extends StatelessWidget {
  final String text;
  final String linkText;
  final VoidCallback onTap;

  const AuthSwitchLink({
    super.key,
    required this.text,
    required this.linkText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          // Cần set style ở đây để RichText có style mặc định
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: kHintColor,
                fontSize: 15,
              ),
          children: [
            TextSpan(text: text),
            TextSpan(
              text: linkText,
              style: const TextStyle(
                color: kLinkActive,
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()..onTap = onTap,
            ),
          ],
        ),
      ),
    );
  }
}
