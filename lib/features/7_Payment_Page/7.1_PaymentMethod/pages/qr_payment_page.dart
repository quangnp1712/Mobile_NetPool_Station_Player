import 'package:flutter/material.dart';
import 'package:mobile_netpool_station_player/features/7_Payment_Page/7.1_PaymentMethod/pages/paymentsuccess_page.dart';


class QrPaymentPage extends StatelessWidget {
  const QrPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Payment')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Scan QR to Pay',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            Container(
              height: 220,
              width: 220,
              color: Colors.grey.shade300,
              child: const Center(child: Text('QR CODE')),
            ),

            const SizedBox(height: 16),
            const Text('Amount: 205,000 ₫'),

            const Spacer(),

            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PaymentSuccessPage(),
                  ),
                );
              },
              child: const Text('I Have Paid'),
            ),
          ],
        ),
      ),
    );
  }
}
