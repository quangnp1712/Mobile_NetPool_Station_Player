import 'package:flutter/material.dart';

class StepZone extends StatelessWidget {
  final Map<String, int> zones;
  final String? selected;
  final Function(String) onSelected;

  const StepZone({
    super.key,
    required this.zones,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: zones.entries.map((e) {
          final active = selected == e.key;
          return GestureDetector(
            onTap: () => onSelected(e.key),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: active ? Colors.deepPurple : Colors.grey),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(e.key, style: const TextStyle(color: Colors.white)),
                  Text('${e.value}đ/giờ',
                      style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
