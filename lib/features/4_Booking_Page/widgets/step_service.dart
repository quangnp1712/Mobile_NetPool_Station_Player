import 'package:flutter/material.dart';

class StepService extends StatelessWidget {
  final List<String> services;
  final List<String> selected;
  final Function(List<String>) onChanged;

  const StepService({
    super.key,
    required this.services,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 10,
        children: services.map((e) {
          final active = selected.contains(e);
          return FilterChip(
            selected: active,
            label: Text(e),
            onSelected: (v) {
              final list = [...selected];
              v ? list.add(e) : list.remove(e);
              onChanged(list);
            },
          );
        }).toList(),
      ),
    );
  }
}
