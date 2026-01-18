import 'package:flutter/material.dart';

class BookingMenuSection extends StatefulWidget {
  const BookingMenuSection({super.key});

  @override
  State<BookingMenuSection> createState() => _BookingMenuSectionState();
}

class _BookingMenuSectionState extends State<BookingMenuSection> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Menu Selected',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _item('PC Gaming (7 hours)', 1, 140000),
            _item('Pepsi', 2, 20000),
            _item('Coca Cola', 1, 15000),
            _item('Bánh mì', 2, 30000),
          ],
        ),
      ),
    );
  }

  Widget _item(String name, int qty, int price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text('$name  x$qty')),
          Text(
            '${_money(price)} ₫',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  String _money(int v) {
    return v.toString().replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (m) => ',',
        );
  }
}
