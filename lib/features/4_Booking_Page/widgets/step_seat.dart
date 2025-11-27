import 'package:flutter/material.dart';

class StepSeat extends StatelessWidget {
  final List<String> seats;
  final String? selected;
  final Function(String) onSelected;

  const StepSeat({
    super.key,
    required this.seats,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: seats.map((e) {
          final active = selected == e;
          return GestureDetector(
            onTap: () => onSelected(e),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: active ? Colors.deepPurple : Colors.grey),
              ),
              child: Text(e,
                  style: const TextStyle(color: Colors.white, fontSize: 12)),
            ),
          );
        }).toList(),
      ),
    );
  }
}
