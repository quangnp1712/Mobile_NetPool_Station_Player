import 'package:flutter/material.dart';

/// Lớp mô hình cho dữ liệu Station
class Station {
  final String id;
  final String name;
  final String imageUrl; // Sẽ là đường dẫn asset
  final List<String> tags;
  final String address; // <-- THÊM MỚI
  final String time; // <-- THÊM MỚI
  final String phone; // <-- THÊM MỚI

  Station({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.tags,
    required this.address,
    required this.time,
    required this.phone,
  });
}
