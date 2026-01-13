import 'package:flutter/material.dart';
import 'package:mobile_netpool_station_player/features/7_Payment_Page/7.1_PaymentMethod/widgets/payment_method_items.dart';


enum PaymentMethod { qr, wallet, cash }

class PaymentMethodSection extends StatefulWidget {
  final Function(PaymentMethod) onSelected;

  const PaymentMethodSection({
    super.key,
    required this.onSelected,
  });

  @override
  State<PaymentMethodSection> createState() => _PaymentMethodSectionState();
}

class _PaymentMethodSectionState extends State<PaymentMethodSection> {
  PaymentMethod? selected;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            PaymentMethodItem(
              isSelected: selected == PaymentMethod.qr,
              icon: Icons.qr_code,
              title: 'Bank Transfer (QR)',
              onTap: () {
                setState(() => selected = PaymentMethod.qr);
                widget.onSelected(PaymentMethod.qr);
              },
            ),

            PaymentMethodItem(
              isSelected: selected == PaymentMethod.wallet,
              icon: Icons.account_balance_wallet_outlined,
              title: 'System Wallet',
              onTap: () {
                setState(() => selected = PaymentMethod.wallet);
                widget.onSelected(PaymentMethod.wallet);
              },
            ),

            PaymentMethodItem(
              isSelected: selected == PaymentMethod.cash,
              icon: Icons.payments_outlined,
              title: 'Cash Payment',
              onTap: () {
                setState(() => selected = PaymentMethod.cash);
                widget.onSelected(PaymentMethod.cash);
              },
            ),
          ],
        ),
      ),
    );
  }
}
