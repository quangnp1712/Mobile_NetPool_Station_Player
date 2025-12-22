// --- Helpers UI ---
import 'package:flutter/material.dart';
import 'package:mobile_netpool_station_player/core/theme/app_colors.dart';

Color parseColor(String? hexString) {
  if (hexString == null || hexString.isEmpty) return kLinkActive;
  try {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  } catch (e) {
    return kLinkActive;
  }
}
