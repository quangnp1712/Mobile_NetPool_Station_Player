import 'package:flutter/material.dart';

class BookingTotalSection extends StatefulWidget {
  const BookingTotalSection({super.key});

  @override
  State<BookingTotalSection> createState() => _BookingTotalSectionState();
}

class _BookingTotalSectionState extends State<BookingTotalSection> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Total Amount',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '205,000 ₫',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
