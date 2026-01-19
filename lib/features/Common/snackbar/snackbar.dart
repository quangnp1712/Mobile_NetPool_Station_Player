// ignore_for_file: non_constant_identifier_names, use_super_parameters, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Vẫn cần Get để lấy context

void ShowSnackBar(BuildContext context, String message, bool success) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      // Margin cách đáy và 2 bên để tạo cảm giác "Floating" (nổi)
      margin: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
      padding: EdgeInsets.zero,
      duration: const Duration(seconds: 4),
      content: Container(
        decoration: BoxDecoration(
          // Nền màu tối (Charcoal) chuẩn Material Design hiện đại
          color: const Color(0xFF323232),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Dải màu chỉ báo trạng thái bên trái (Accent bar)
              Container(
                width: 6,
                decoration: BoxDecoration(
                  color: success
                      ? const Color(0xFF4CAF50)
                      : const Color(0xFFEF5350),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Icon trạng thái
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Icon(
                  success ? Icons.check_circle : Icons.info_outline,
                  // Icon mang màu sắc, nổi bật trên nền tối
                  color: success
                      ? const Color(0xFF4CAF50)
                      : const Color(0xFFEF5350),
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              // Nội dung Text
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 0),
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors
                          .white, // Chữ trắng trên nền tối luôn dễ đọc nhất
                      fontSize: 14,
                      fontWeight: FontWeight
                          .w400, // Font mảnh hơn cho cảm giác hiện đại
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Nút đóng nhỏ (tùy chọn, giúp người dùng chủ động tắt)
              IconButton(
                icon: const Icon(Icons.close, size: 20, color: Colors.grey),
                onPressed: () =>
                    ScaffoldMessenger.of(context).hideCurrentSnackBar(),
              ),
              const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    ),
  );
}
