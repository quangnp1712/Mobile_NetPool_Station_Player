import 'package:flutter/material.dart';
import 'wallet_payment_method.dart';
import 'wallet_qr_box.dart';
import 'package:intl/intl.dart';

class WalletDepositSection extends StatelessWidget {
  final TextEditingController amountCtrl;

  const WalletDepositSection({super.key, required this.amountCtrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nạp tiền',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: amountCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Nhập số tiền cần nạp',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),

          const SizedBox(height: 16),
          const WalletPaymentMethod(),
          const SizedBox(height: 16),
          const WalletQrBox(),
        ],
      ),
    );
  }
}
