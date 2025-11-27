import 'package:flutter/material.dart';

class BookingProgressBar extends StatelessWidget {
  final int currentStep;
final int totalStep;
  const BookingProgressBar({
    super.key,
    required this.currentStep,
    required this.totalStep, // ✅
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: List.generate(5, (i) {
          return Expanded(
            child: Container(
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: i <= currentStep
                    ? Colors.deepPurple
                    : Colors.grey.shade800,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        }),
      ),
    );
  }
}
