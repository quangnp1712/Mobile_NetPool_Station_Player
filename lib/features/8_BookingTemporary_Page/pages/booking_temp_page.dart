import 'package:flutter/material.dart';

import 'package:mobile_netpool_station_player/features/7_Payment_Page/7.1_PaymentMethod/pages/paymentsuccess_page.dart';
import 'package:mobile_netpool_station_player/features/7_Payment_Page/7.1_PaymentMethod/pages/qr_payment_page.dart';
import 'package:mobile_netpool_station_player/features/7_Payment_Page/7.1_PaymentMethod/widgets/payment_method_section.dart';

import 'package:mobile_netpool_station_player/features/8_BookingTemporary_Page/widgets/booking_info_section.dart';
import 'package:mobile_netpool_station_player/features/8_BookingTemporary_Page/widgets/booking_menu_section.dart';
import 'package:mobile_netpool_station_player/features/8_BookingTemporary_Page/widgets/booking_schedule_section.dart';
import 'package:mobile_netpool_station_player/features/8_BookingTemporary_Page/widgets/booking_total_section.dart';

class BookingTempPage extends StatefulWidget {
  const BookingTempPage({super.key});

  @override
  State<BookingTempPage> createState() => _BookingTempPageState();
}

class _BookingTempPageState extends State<BookingTempPage> {
  PaymentMethod? _selectedPaymentMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đơn Thanh Toán'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            BookingInfoSection(),
            const SizedBox(height: 16),
            BookingScheduleSection(),
            const SizedBox(height: 16),
            BookingMenuSection(),
            const SizedBox(height: 24),
            BookingTotalSection(),
            const SizedBox(height: 16),
            PaymentMethodSection(
              onSelected: (method) {
                setState(() {
                  _selectedPaymentMethod = method;
                });
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _selectedPaymentMethod == null
                    ? null
                    : () => _handlePayment(context),
                child: const Text('Proceed to Payment'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handlePayment(BuildContext context) {
    switch (_selectedPaymentMethod) {
      case PaymentMethod.qr:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const QrPaymentPage(),
          ),
        );
        break;

      case PaymentMethod.wallet:
      case PaymentMethod.cash:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const PaymentSuccessPage(),
          ),
        );
        break;

      default:
        break;
    }
  }
}
