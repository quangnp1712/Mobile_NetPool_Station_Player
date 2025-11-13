import 'package:flutter/material.dart';
import 'package:mobile_netpool_station_player/core/theme/app_colors.dart';

class WelcomeCard extends StatelessWidget {
  const WelcomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: kBoxBackground, // <-- Sử dụng hằng số
        borderRadius: BorderRadius.circular(12.0),

        // SỬA: Thêm viền tím phát sáng
        boxShadow: [
          BoxShadow(
            color: kGradientEnd, // Màu tím
            blurRadius: 2.0,
            spreadRadius: 2.0,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: kBoxBackground, // <-- Dùng màu nền xám
            child: const Icon(
              Icons.person,
              size: 40,
              color: kHintColor, // <-- Dùng màu hint
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Chào buổi sáng, Mike",
                style: TextStyle(color: kHintColor),
              ),
              const SizedBox(height: 4),
              Text(
                "Thứ 7, 18/10/2025",
                style: TextStyle(color: kHintColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
