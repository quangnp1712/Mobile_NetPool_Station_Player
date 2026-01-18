import 'package:flutter/material.dart';

class BookingInfoSection extends StatefulWidget {
  const BookingInfoSection({super.key});

  @override
  State<BookingInfoSection> createState() => _BookingInfoSectionState();
}

class _BookingInfoSectionState extends State<BookingInfoSection> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Booking Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _row('Booking Code', 'BK-20260108'),
            _row('Station Name', 'Net Pool Station A'),
            _row('Address', '123 Nguyen Van Linh, District 7'),
            _row('Table / Machine', 'PC-08'),
            _row('Type', 'PC Gaming'),
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
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
