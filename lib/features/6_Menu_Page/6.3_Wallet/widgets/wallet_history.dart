// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:mobile_netpool_station_player/features/Common/MoneyFormatter/money_formatter.dart';

class WalletHistoryPage extends StatefulWidget {
  const WalletHistoryPage({super.key});

  @override
  State<WalletHistoryPage> createState() => _WalletHistoryPageState();
}

class _WalletHistoryPageState extends State<WalletHistoryPage> {
  final List<Map<String, dynamic>> histories = [
    {
      'title': 'Nạp tiền vào ví',
      'amount': 40000,
      'isPlus': true,
      'status': 'Thành công',
      'time': '09:30 - 08/01/2026',
    },
    {
      'title': 'Thanh toán đặt máy',
      'amount': 40000,
      'isPlus': false,
      'status': 'Hoàn tất',
      'time': '12:15 - 07/01/2026',
    },
    {
      'title': 'Nạp tiền vào ví',
      'amount': 100000,
      'isPlus': true,
      'status': 'Thành công',
      'time': '18:45 - 05/01/2026',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text(
          'Lịch sử ví',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: histories.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = histories[index];
          return _historyItem(item);
        },
      ),
    );
  }

  Widget _historyItem(Map<String, dynamic> item) {
    final bool isPlus = item['isPlus'];
    final int amount = item['amount'];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isPlus
                  ? Colors.green.withOpacity(0.15)
                  : Colors.red.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isPlus ? Icons.add : Icons.remove,
              color: isPlus ? Colors.green : Colors.red,
            ),
          ),

          const SizedBox(width: 12),

          // Nội dung
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item['time'],
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item['status'],
                  style: TextStyle(
                    fontSize: 12,
                    color: isPlus ? Colors.green : Colors.blueGrey,
                  ),
                ),
              ],
            ),
          ),

          Text(
            MoneyFormatter.formatSigned(isPlus ? amount : -amount),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isPlus ? Colors.green : Colors.red,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
