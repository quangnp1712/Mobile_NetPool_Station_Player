import 'package:flutter/material.dart';

class StepCategory extends StatelessWidget {
  final List<String> categories;
  final String? selected;
  final Function(String) onSelected;

  const StepCategory({
    super.key,
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return _wrap(
      'Chọn thể loại chơi',
      Wrap(
        spacing: 12,
        children: categories.map((e) => _item(e)).toList(),
      ),
    );
  }

  Widget _item(String text) {
    final active = selected == text;

    return GestureDetector(
      onTap: () => onSelected(text),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: active ? Colors.deepPurple : Colors.grey),
        ),
        child: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _wrap(String title, Widget child) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
