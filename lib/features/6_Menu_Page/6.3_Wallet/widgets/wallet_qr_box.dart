import 'package:flutter/material.dart';

class WalletQrBox extends StatelessWidget {
  const WalletQrBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.qr_code_2, size: 80),
          SizedBox(height: 8),
          Text('QR nạp tiền (PayOS)', style: TextStyle(color: Colors.black54)),
          SizedBox(height: 4),
          Text(
            'Quét mã để nạp tiền',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
