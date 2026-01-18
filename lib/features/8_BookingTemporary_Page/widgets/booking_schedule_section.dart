import 'package:flutter/material.dart';

class BookingScheduleSection extends StatefulWidget {
  const BookingScheduleSection({super.key});

  @override
  State<BookingScheduleSection> createState() => _BookingScheduleSectionState();
}

class _BookingScheduleSectionState extends State<BookingScheduleSection> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Schedule',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _row('Booking Date', '08/01/2026'),
            _row('Check-in Time', '14:00'),
            _row('Total Play Time', '7 hours'),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
