import 'package:flutter/material.dart';

class BookingBillPreview extends StatefulWidget {
  final String category;
  final String zone;
  final int pricePerHour;
  final String seat;
  final String startTime;
  final String endTime;
  final List<String> services;

  const BookingBillPreview({
    super.key,
    required this.category,
    required this.zone,
    required this.pricePerHour,
    required this.seat,
    required this.startTime,
    required this.endTime,
    required this.services,
  });

  @override
  State<BookingBillPreview> createState() => _BookingBillPreviewState();
}

class _BookingBillPreviewState extends State<BookingBillPreview> {
  int _calcHours() {
    if (widget.startTime.isEmpty || widget.endTime.isEmpty) return 0;

    final start = int.parse(widget.startTime.split(':')[0]);
    final end = int.parse(widget.endTime.split(':')[0]);
    return end - start;
  }

  int _totalMoney() {
    return _calcHours() * widget.pricePerHour;
  }

  @override
  Widget build(BuildContext context) {
    final hours = _calcHours();
    final total = _totalMoney();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.deepPurple),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TỔNG KẾT TẠM TÍNH',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),

          _item('Thể loại', widget.category),
          _item('Khu vực', '${widget.zone} - ${widget.pricePerHour} đ/giờ'),
          _item('Chỗ ngồi', widget.seat),
          _item('Giờ chơi',
              '${widget.startTime} → ${widget.endTime} ($hours tiếng)'),

          const Divider(color: Colors.white24, height: 24),

          const Text(
            'Dịch vụ',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 6),

          widget.services.isEmpty
              ? const Text('Không chọn',
                  style: TextStyle(color: Colors.grey))
              : Wrap(
                  spacing: 6,
                  children: widget.services
                      .map(
                        (e) => Chip(
                          label: Text(e),
                          backgroundColor: Colors.deepPurple,
                          labelStyle:
                              const TextStyle(color: Colors.white),
                        ),
                      )
                      .toList(),
                ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tạm tính',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              Text(
                '$total đ',
                style: const TextStyle(
                  color: Colors.deepPurpleAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _item(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(value, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
