import 'package:flutter/material.dart';
import 'package:mobile_netpool_station_player/core/theme/app_colors.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/bloc/booking_page_bloc.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/widget/helper_widget.dart';

class BillPreviewPage extends StatefulWidget {
  // --- UPDATED: Take real state ---
  final BookingPageState state;
  const BillPreviewPage({super.key, required this.state});

  @override
  State<BillPreviewPage> createState() => _BillPreviewPageState();
}

class _BillPreviewPageState extends State<BillPreviewPage> {
  String _paymentMethod = 'WALLET';
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    // --- UPDATED: Mapping Real Data ---
    final String stationName = state.selectedStation?.stationName ?? "";
    final String stationAddress = state.selectedStation?.address ?? "";
    final String stationImage = state.selectedStation?.avatar ?? "";

    // Get Date
    String dateStr = "--/--/----";
    if (state.schedules.isNotEmpty &&
        state.selectedDateIndex < state.schedules.length) {
      dateStr = state.schedules[state.selectedDateIndex].date ?? "";
    }

    // Get Resource Info
    String resourceName = "Chưa chọn";
    String resourceSpec = "";
    if (state.selectedResourceCodes.isNotEmpty) {
      final code = state.selectedResourceCodes.first;
      try {
        final res = state.resources.firstWhere((e) => e.resourceCode == code);
        resourceName = res.resourceName ?? code;
        // Simple spec summary for demo
        if (res.spec?.pc != null) {
          resourceSpec =
              "${res.spec!.pc!.pcCpu ?? ""} / ${res.spec!.pc!.pcGpu ?? ""}";
        }
      } catch (_) {
        resourceName = code;
      }
    } else if (state.bookingType == 'auto') {
      resourceName = "Tự động (Auto Pick)";
    }

    final double totalPrice = state.totalPrice;
    final int userBalance = state.userBalance ?? 0;
    final bool isWalletInsufficient =
        _paymentMethod == 'WALLET' && userBalance < totalPrice;

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kBgColor.withOpacity(0.8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Xác nhận thanh toán",
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.white.withOpacity(0.05), height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Station Info Card
            _buildStationCard(stationName, stationAddress, stationImage),
            const SizedBox(height: 24),

            // 2. Booking Details List
            _buildSectionTitle("Chi tiết đặt chỗ"),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: kCardColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildInfoRow(Icons.calendar_today, "Ngày chơi", dateStr),
                  _buildInfoRow(Icons.access_time, "Khung giờ",
                      "${state.selectedTime} - ${state.endTime} (${state.duration}h)",
                      isHighlight: true),
                  _buildInfoRow(
                      Icons.desktop_windows, "Thiết bị", resourceName),
                  if (resourceSpec.isNotEmpty)
                    _buildInfoRow(Icons.memory, "Cấu hình", resourceSpec,
                        isSubtext: true),
                  _buildInfoRow(Icons.grid_view, "Vị trí",
                      "${state.selectedSpace?.spaceCode} • ${state.selectedArea?.areaName}"),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 3. Payment Methods
            _buildSectionTitle("Phương thức thanh toán"),
            const SizedBox(height: 12),
            _buildPaymentCard(
              id: 'WALLET',
              title: "Ví NetPool",
              description: "Thanh toán nhanh, không phí",
              icon: Icons.account_balance_wallet,
              balance: userBalance,
            ),
            _buildPaymentCard(
              id: 'BANK_TRANSFER',
              title: "Chuyển khoản (QR)",
              description: "VietQR, MoMo, ZaloPay",
              icon: Icons.qr_code_2,
            ),
            _buildPaymentCard(
              id: 'DIRECT',
              title: "Tiền mặt",
              description: "Thanh toán tại quầy khi đến",
              icon: Icons.money,
            ),
            const SizedBox(height: 24),

            // 4. Summary Cost
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kCardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Column(
                children: [
                  _buildSummaryRow("Đơn giá",
                      "${formatCurrency(state.selectedArea?.price?.toDouble() ?? 0)} / giờ"),
                  const SizedBox(height: 8),
                  _buildSummaryRow("Thời lượng", "x ${state.duration} giờ"),
                  const SizedBox(height: 16),
                  Container(height: 1, color: Colors.white.withOpacity(0.2)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text("Tổng cộng",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      Text(formatCurrency(totalPrice),
                          style: const TextStyle(
                              color: kNeonCyan,
                              fontSize: 24,
                              fontWeight: FontWeight.w900)),
                    ],
                  )
                ],
              ),
            ),

            // 5. Warning
            if (isWalletInsufficient)
              Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: kRedColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: kRedColor.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: kRedColor, size: 18),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Số dư không đủ",
                              style: TextStyle(
                                  color: kRedColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold)),
                          Text(
                              "Vui lòng nạp thêm tiền hoặc chọn phương thức khác.",
                              style: TextStyle(
                                  color: kRedColor.withOpacity(0.8),
                                  fontSize: 11)),
                        ],
                      ),
                    )
                  ],
                ),
              )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kCardColor,
          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Tổng thanh toán",
                        style: TextStyle(color: kTextGrey, fontSize: 12)),
                    Text(formatCurrency(totalPrice),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: (_isProcessing || isWalletInsufficient)
                        ? null
                        : () {
                            setState(() => _isProcessing = true);
                            Future.delayed(const Duration(seconds: 2), () {
                              setState(() => _isProcessing = false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Đặt lịch thành công!")));
                            });
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      disabledBackgroundColor: kCardColorLight,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ).copyWith(
                      backgroundColor:
                          MaterialStateProperty.resolveWith((states) {
                        if (states.contains(MaterialState.disabled))
                          return kCardColorLight;
                        return null;
                      }),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                          gradient: (_isProcessing || isWalletInsufficient)
                              ? null
                              : const LinearGradient(
                                  colors: [kPrimaryPurple, Color(0xFF06B6D4)]),
                          borderRadius: BorderRadius.circular(12),
                          color: (_isProcessing || isWalletInsufficient)
                              ? kCardColorLight
                              : null),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          _isProcessing ? 'Đang xử lý...' : 'XÁC NHẬN',
                          style: TextStyle(
                            color: (_isProcessing || isWalletInsufficient)
                                ? kTextGrey
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET BUILDERS FOR BILL PREVIEW ---

  Widget _buildStationCard(String name, String address, String image) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(image,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: kCardColorLight)),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, kBgColor],
                stops: [0.3, 1.0],
              ),
            ),
          ),
          Positioned(
            bottom: 12,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: kNeonCyan, size: 14),
                    const SizedBox(width: 4),
                    Expanded(
                        child: Text(address,
                            style:
                                const TextStyle(color: kTextGrey, fontSize: 12),
                            overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value,
      {bool isHighlight = false, bool isSubtext = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: kPrimaryPurple.withOpacity(0.8)),
              const SizedBox(width: 12),
              Text(label,
                  style: const TextStyle(color: kTextGrey, fontSize: 13)),
            ],
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: isHighlight
                    ? kNeonCyan
                    : (isSubtext ? kTextGrey : Colors.white),
                fontSize: isSubtext ? 11 : 13,
                fontWeight: isHighlight ? FontWeight.bold : FontWeight.w500,
                fontStyle: isSubtext ? FontStyle.italic : FontStyle.normal,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(
      {required String id,
      required String title,
      required String description,
      required IconData icon,
      int? balance}) {
    final bool isSelected = _paymentMethod == id;
    return GestureDetector(
      onTap: () => setState(() => _paymentMethod = id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? kCardColorLight.withOpacity(0.9)
              : kCardColorLight.withOpacity(0.4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: isSelected ? kNeonCyan : Colors.white.withOpacity(0.05),
              width: isSelected ? 1.5 : 1),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                      color: kNeonCyan.withOpacity(0.15),
                      blurRadius: 10,
                      spreadRadius: 0)
                ]
              : [],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color:
                    isSelected ? kNeonCyan.withOpacity(0.2) : kCardColorLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon,
                  size: 18, color: isSelected ? kNeonCyan : kTextGrey),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          color: isSelected ? Colors.white : kTextGrey,
                          fontSize: 13,
                          fontWeight: FontWeight.bold)),
                  Text(description,
                      style: const TextStyle(color: kTextGrey, fontSize: 10)),
                  if (balance != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                          "Số dư: ${formatCurrency(balance.toDouble())}",
                          style: const TextStyle(
                              color: kGreenColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w500)),
                    )
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? kNeonCyan : kTextGrey,
              size: 18,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: kTextGrey, fontSize: 13)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 13)),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
          color: kTextGrey,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5),
    );
  }
}
