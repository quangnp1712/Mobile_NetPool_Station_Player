import 'package:flutter/material.dart';

class QuickActionBar extends StatefulWidget {
  const QuickActionBar({super.key});

  @override
  State<QuickActionBar> createState() => _QuickActionBarState();
}

class _QuickActionBarState extends State<QuickActionBar> {
  final List<Map<String, dynamic>> actions = [
    {'icon': Icons.calendar_today, 'label': 'Đặt lịch'},
    {'icon': Icons.history, 'label': 'Lịch sử đặt lịch'},
    {'icon': Icons.event_note, 'label': 'Lịch đặt của bạn'},
  ];

  void _onActionTap(String label) {
    debugPrint('👉 Bạn đã chọn: $label');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: actions.map((action) {
          return GestureDetector(
            onTap: () => _onActionTap(action['label'] as String),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔵 Icon có background tròn riêng
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xFF9C27B0), // 💜 tím riêng từng icon
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    action['icon'] as IconData,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  action['label'] as String,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10, // nhỏ gọn
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
