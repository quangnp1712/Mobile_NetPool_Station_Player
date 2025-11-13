import 'package:flutter/material.dart';
import 'package:mobile_netpool_station_player/core/theme/app_colors.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: kHintColor), // Kiểu chữ khi gõ
      decoration: InputDecoration(
        hintText: "Tìm kiếm tên tài khoản",
        hintStyle: const TextStyle(color: kHintColor), // Màu chữ gợi ý
        prefixIcon: const Icon(Icons.search, color: kHintColor), // Màu icon
        filled: true,
        fillColor: kBoxBackground, // <-- Nền thanh tìm kiếm
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide:
              const BorderSide(color: kUnderlineColor), // <-- Viền mặc định
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide:
              const BorderSide(color: kLinkActive), // <-- Viền khi focus
        ),
      ),
    );
  }
}
