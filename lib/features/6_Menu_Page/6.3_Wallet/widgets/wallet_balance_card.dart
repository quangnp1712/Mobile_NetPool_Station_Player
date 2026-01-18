import 'package:flutter/material.dart';
import 'package:mobile_netpool_station_player/features/Common/MoneyFormatter/money_formatter.dart';

class WalletBalanceCard extends StatelessWidget {
  final double balance;

  const WalletBalanceCard({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            'SỐ DƯ HIỆN TẠI',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            MoneyFormatter.formatVND(balance.toInt()),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
