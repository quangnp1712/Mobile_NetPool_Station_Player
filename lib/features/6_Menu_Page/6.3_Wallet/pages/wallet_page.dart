import 'package:flutter/material.dart';
import 'package:mobile_netpool_station_player/features/6_Menu_Page/6.3_Wallet/widgets/wallet_balance_card.dart';
import 'package:mobile_netpool_station_player/features/6_Menu_Page/6.3_Wallet/widgets/wallet_cofirm_button.dart';
import 'package:mobile_netpool_station_player/features/6_Menu_Page/6.3_Wallet/widgets/wallet_deposit_section.dart';
import 'package:mobile_netpool_station_player/features/6_Menu_Page/6.3_Wallet/widgets/wallet_history.dart';
import 'package:intl/intl.dart';


class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  double balance = 197756;
  final TextEditingController amountCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Ví của tôi', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
    TextButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const WalletHistoryPage(),
          ),
        );
      },
      icon: const Icon(
        Icons.history,
        color: Colors.deepPurple,
        size: 20,
      ),
      label: const Text(
        'Lịch sử',
        style: TextStyle(
          color: Colors.deepPurple,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  ],
      ),
      body: Column(
        children: [
          WalletBalanceCard(balance: balance),
          WalletDepositSection(amountCtrl: amountCtrl),
          const Spacer(),
          WalletConfirmButton(
            amountCtrl: amountCtrl,
            onConfirm: _onConfirm,
          ),
        ],
      ),
    );
  }

  void _onConfirm() {
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã tạo mã QR nạp tiền (PayOS demo)')),
    );
  }
}
