import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import để dùng FilteringTextInputFormatter
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_netpool_station_player/core/theme/app_colors.dart';
import 'package:mobile_netpool_station_player/features/8_Wallet_Payment/bloc/wallet_bloc.dart';
import 'package:mobile_netpool_station_player/features/8_Wallet_Payment/pages/payment_history.dart';
import 'package:mobile_netpool_station_player/features/Common/snackbar/snackbar.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher

// Giả định các màu sắc từ theme chung của App

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final TextEditingController _amountController = TextEditingController();
  WalletBloc bloc = WalletBloc();

  final List<int> quickAmounts = [
    50000,
    100000,
    200000,
    500000,
    1000000,
    2000000
  ];

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_formatInputMoney);
    bloc.add(WalletInitialEvent());
  }

  @override
  void dispose() {
    _amountController.removeListener(_formatInputMoney);
    _amountController.dispose();
    super.dispose();
  }

  void _formatInputMoney() {
    String text = _amountController.text;
    if (text.isEmpty) return;
    String cleanText = text.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanText.isEmpty) return;
    double value = double.tryParse(cleanText) ?? 0;
    final formatter = NumberFormat("#,###", "vi_VN");
    String newText = formatter.format(value);
    if (newText != text) {
      _amountController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    }
  }

  String formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(amount);
  }

  String formatQuickAmountToken(int amount) {
    if (amount >= 1000000) return "${amount ~/ 1000000} tr";
    if (amount >= 1000) return "${amount ~/ 1000} k";
    return amount.toString();
  }

  /// Hàm mở link thanh toán
  Future<void> _launchPaymentUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar("Lỗi", "Không thể mở liên kết thanh toán",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  /// Dialog thành công
  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          backgroundColor: kCardColor,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: kGreenColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle,
                      color: kGreenColor, size: 40),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Thanh toán thành công!",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: kTextGrey, fontSize: 14),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kGreenColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text("Đóng",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalletBloc, WalletState>(
      bloc: bloc,
      listener: (context, state) {
        // 1. Mở link thanh toán khi có URL và trạng thái waiting
        if (state.paymentStatus == PaymentActionStatus.waitingForPayment &&
            state.paymentUrl != null) {
          _launchPaymentUrl(state.paymentUrl!);
        }

        // 2. Xử lý kết quả thành công
        if (state.paymentStatus == PaymentActionStatus.success) {
          _showSuccessDialog(context, state.message);
          _amountController.clear();
        }

        // 3. Xử lý thất bại
        else if (state.paymentStatus == PaymentActionStatus.failure) {
          ShowSnackBar(context, state.message, false);
        }
      },
      builder: (context, state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: const Text("Ví của tôi",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white)),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  // Truyền Bloc hiện tại sang trang History để dùng chung State
                  Get.to(() => BlocProvider.value(
                        value: bloc,
                        child: PaymentHistoryPage(bloc: bloc),
                      ));
                },
                icon: const Icon(Icons.history, color: Colors.white),
                tooltip: "Lịch sử giao dịch",
              )
            ],
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2B0C4E), Color(0xFF5A1CCB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          body: Container(
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3B1F5A), kScaffoldBackground],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.5],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBalanceCard(state),
                    const SizedBox(height: 24),
                    _buildRechargeSection(context, state),
                    const SizedBox(height: 24),
                    _buildHistoryButton(context),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBalanceCard(WalletState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF7F00FF), kNeonPink],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: kNeonPink.withOpacity(0.4),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Số dư hiện tại",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 10),
          state.balanceStatus == WalletStatus.loading
              ? const SizedBox(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator(color: Colors.white))
              : Text(
                  formatCurrency(state.balance),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 2),
                          blurRadius: 4)
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildRechargeSection(BuildContext context, WalletState state) {
    // Kiểm tra xem có đang trong quá trình thanh toán (bao gồm chờ 30s) hay không
    final bool isWaiting =
        state.paymentStatus == PaymentActionStatus.waitingForPayment;
    final bool isProcessing =
        state.paymentStatus == PaymentActionStatus.processing;
    final bool isLoading = isWaiting || isProcessing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Nạp tiền vào ví",
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: kBoxBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: kPrimaryPurple.withOpacity(0.5)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2))
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  enabled: !isLoading, // Disable khi đang xử lý
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    hintText: "Nhập số tiền (tối thiểu 10k)",
                    hintStyle: TextStyle(color: kHintColor, fontSize: 14),
                    border: InputBorder.none,
                    suffixText: "vnđ",
                    suffixStyle: TextStyle(
                        color: kPrimaryPurple,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ),
              if (!isLoading)
                IconButton(
                  icon: const Icon(Icons.clear, color: kHintColor),
                  onPressed: () => _amountController.clear(),
                )
            ],
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: quickAmounts.map((amount) {
            return GestureDetector(
              onTap: isLoading
                  ? null
                  : () => _amountController.text = amount.toString(),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: kBoxBackground,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: kNeonPink.withOpacity(0.6)),
                ),
                child: Text(
                  formatQuickAmountToken(amount),
                  style: TextStyle(
                      color: isLoading ? kHintColor : kNeonPink,
                      fontWeight: FontWeight.bold),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: isLoading
                ? null
                : () {
                    bloc.add(WalletAddMoneyEvent(_amountController.text));
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryPurple,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 8,
              disabledBackgroundColor: kBoxBackground,
            ),
            child: isLoading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2)),
                      const SizedBox(width: 10),
                      Text(
                          isWaiting
                              ? "Đang chờ thanh toán..."
                              : "Đang xử lý...",
                          style: const TextStyle(fontSize: 14)),
                    ],
                  )
                : const Text("NẠP NGAY",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
        if (isWaiting)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: const Center(
              child: Text(
                "Vui lòng thanh toán trên trình duyệt web...",
                style: TextStyle(
                    color: kLinkActive,
                    fontSize: 12,
                    fontStyle: FontStyle.italic),
              ),
            ),
          )
      ],
    );
  }

  Widget _buildHistoryButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => PaymentHistoryPage(bloc: bloc));
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kBoxBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: kPrimaryPurple.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.history, color: Color(0xFFB041FF)),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Lịch sử giao dịch",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  SizedBox(height: 4),
                  Text("Xem lại các lần nạp tiền và thanh toán",
                      style: TextStyle(color: kHintColor, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: kHintColor, size: 16),
          ],
        ),
      ),
    );
  }
}
