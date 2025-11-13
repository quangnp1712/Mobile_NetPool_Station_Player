import 'package:flutter/material.dart';
import 'package:mobile_netpool_station_player/core/theme/app_colors.dart';

/// Một Container có nền xám đặc, bo góc và phát sáng nhẹ màu tím
class FormContainer extends StatelessWidget {
  final Widget child;

  const FormContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      decoration: BoxDecoration(
        color: kBoxBackground, // <-- Đã bỏ .withOpacity()
        borderRadius: BorderRadius.circular(25.0), // Bo tròn 25.0
        boxShadow: [
          // Hiệu ứng phát sáng nhẹ màu tím
          BoxShadow(
            color: kGradientEnd, // Màu tím #CB30E0 (không mờ)
            blurRadius: 2.0, // Không làm mờ
            spreadRadius: 2.0, // Độ dày của viền là 2.0
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: child,
    );
  }
}
