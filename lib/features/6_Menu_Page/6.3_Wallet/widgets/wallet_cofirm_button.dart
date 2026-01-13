import 'package:flutter/material.dart';


class WalletConfirmButton extends StatelessWidget {
  final TextEditingController amountCtrl;
  final VoidCallback onConfirm;

  const WalletConfirmButton({
    super.key,
    required this.amountCtrl,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final enable = amountCtrl.text.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: enable ? onConfirm : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          'Tạo mã QR nạp tiền',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
