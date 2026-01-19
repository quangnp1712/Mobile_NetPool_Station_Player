import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:mobile_netpool_station_player/core/router/routes.dart';
import 'package:mobile_netpool_station_player/core/theme/app_colors.dart';
import 'package:mobile_netpool_station_player/core/utils/debug_logger.dart';
import 'package:mobile_netpool_station_player/features/8_Booking_History_Page/bloc/booking_history_bloc.dart';
import 'package:mobile_netpool_station_player/features/8_Booking_History_Page/model/1.booking/booking_model.dart';
import 'package:mobile_netpool_station_player/features/8_Booking_History_Page/services/helpers.dart';
import 'package:mobile_netpool_station_player/features/8_Booking_History_Page/widgets/widget_booking.dart';
import 'package:mobile_netpool_station_player/features/Common/snackbar/snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingDetailPage extends StatelessWidget {
  final BookingModel booking;
  final BookingHistoryBloc bloc;

  const BookingDetailPage(
      {super.key, required this.booking, required this.bloc});

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
                    fontWeight: FontWeight.bold,
                  ),
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
                    onPressed: () {
                      Navigator.of(context).pop(); // Close dialog
                    },
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
    final startAt = booking.startAt;
    final endAt = booking.endAt;
    final duration = getDuration(startAt, endAt);
    final spec = booking.stationResource?.spec;
    bool showCancel =
        booking.statusCode == 'NEW' || booking.statusCode == 'PENDING';
    bool showPay =
        (booking.statusCode == 'NEW' || booking.statusCode == 'PENDING') &&
            (booking.paymentMethodCode == 'BANK_TRANSFER' ||
                booking.paymentMethodCode == 'WALLET');

    return BlocConsumer<BookingHistoryBloc, BookingHistoryState>(
      bloc: bloc,
      listener: (context, state) async {
        if (state.actionStatus == BookingActionStatus.success) {
          // 1. Bank Transfer Link
          if (state.paymentUrl != null && state.paymentUrl!.isNotEmpty) {
            final Uri url = Uri.parse(state.paymentUrl!);
            try {
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);

                ShowSnackBar(context, "Đang mở trang thanh toán...", true);
              }
            } catch (e) {
              DebugLogger.printLog("Lỗi: ${e.toString()}");
            }
          }
          // 2. Wallet Payment Success (Show Popup)
          else if (state.actionMessage != null &&
              state.actionMessage!.contains("Thanh toán bằng ví thành công")) {
            _showSuccessDialog(context, state.actionMessage!);
          }
          // 3. Other Success (Cancel/Update) -> Show SnackBar
          else if (state.actionMessage != null &&
              state.actionMessage!.isNotEmpty) {
            ShowSnackBar(context, state.actionMessage ?? "", true);

            if (state.actionMessage == "Hủy đặt chỗ thành công") {
              Navigator.pop(context);
            }
          }
        } else if (state.actionStatus == BookingActionStatus.failure) {
          ShowSnackBar(
              context, state.actionMessage ?? "Đã có lỗi xảy ra", false);
        }
      },
      builder: (context, state) {
        bool isLoading = state.actionStatus == BookingActionStatus.loading;
        final currentBooking = state.selectedBooking ?? booking;

        return Scaffold(
          backgroundColor: kBgColor,
          body: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 300,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        kPrimaryPurple.withOpacity(0.2),
                        kBgColor,
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              icon: const Icon(Icons.arrow_back,
                                  color: Colors.white),
                              onPressed: () =>
                                  Get.toNamed(bookingHistoryPageRoute)),
                          const Text("Chi tiết đặt chỗ",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: const Icon(Icons.share, color: Colors.white),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Column(
                            children: [
                              StatusBadge(
                                  code: currentBooking.statusCode,
                                  name: currentBooking.statusName,
                                  isLarge: true),
                              const SizedBox(height: 16),
                              Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                      color: kCardLightColor,
                                      borderRadius: BorderRadius.circular(20),
                                      border:
                                          Border.all(color: Colors.white10)),
                                  child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(currentBooking.bookingCode ?? "",
                                            style: TextStyle(
                                                fontFamily: 'monospace',
                                                color: Colors.purple[200])),
                                        const SizedBox(width: 8),
                                        const Icon(Icons.copy,
                                            size: 14, color: kTextGrey)
                                      ])),
                              const SizedBox(height: 8),
                              Text(formatCurrency(currentBooking.totalPrice),
                                  style: const TextStyle(
                                      color: kAccentFuchsia,
                                      fontSize: 32,
                                      fontWeight: FontWeight.w900)),
                            ],
                          ),
                          const SizedBox(height: 24),
                          _buildSectionTitle("Địa điểm"),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: kCardColor,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: kBorderColor)),
                            child: Row(children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                      currentBooking.station?.avatar ?? "",
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                          width: 60,
                                          height: 60,
                                          color: Colors.grey))),
                              const SizedBox(width: 16),
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                    Text(
                                        currentBooking.station?.stationName ??
                                            "",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                    const SizedBox(height: 4),
                                    Row(children: [
                                      const Icon(Icons.location_on,
                                          size: 14, color: kPrimaryPurple),
                                      const SizedBox(width: 4),
                                      Expanded(
                                          child: Text(
                                              currentBooking.station?.address ??
                                                  "",
                                              style: const TextStyle(
                                                  color: kTextGrey,
                                                  fontSize: 12),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis))
                                    ])
                                  ])),
                            ]),
                          ),
                          const SizedBox(height: 20),
                          _buildSectionTitle("Thông tin buổi chơi"),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: kCardColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: kBorderColor),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildInfoBox(
                                        Icons.calendar_today,
                                        "Ngày",
                                        formatDate(startAt),
                                        kPrimaryPurple,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildInfoBox(
                                        Icons.access_time,
                                        "Thời lượng",
                                        "$duration giờ",
                                        kAccentFuchsia,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                const Divider(color: Colors.white10),
                                const SizedBox(height: 12),
                                _buildTimeRow("Bắt đầu", formatTime(startAt)),
                                const SizedBox(height: 8),
                                _buildTimeRow("Kết thúc", formatTime(endAt)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildSectionTitle("Thiết bị & Khu vực"),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: kCardColor,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: kBorderColor)),
                            child: Column(children: [
                              Row(children: [
                                Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: kPrimaryPurple.withOpacity(0.2),
                                        shape: BoxShape.circle),
                                    child: const Icon(Icons.computer,
                                        color: kPrimaryPurple)),
                                const SizedBox(width: 12),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          currentBooking.stationResource
                                                  ?.resourceName ??
                                              "",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16)),
                                      Text(
                                          "${currentBooking.stationResource?.rowName ?? ""} • ${currentBooking.area?.areaName}",
                                          style: const TextStyle(
                                              color: kTextGrey, fontSize: 12))
                                    ]),
                              ]),
                            ]),
                          ),
                          const SizedBox(height: 20),
                          _buildSectionTitle("Thanh toán"),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: kCardColor,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: kBorderColor)),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Phương thức",
                                        style: TextStyle(
                                            color: kTextGrey, fontSize: 13)),
                                    Row(
                                      children: [
                                        Text(
                                            currentBooking.paymentMethodName ??
                                                "",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13)),
                                        // -- update: Edit Payment Method Button
                                        if (currentBooking.statusCode ==
                                                'PENDING' ||
                                            currentBooking.statusCode == 'NEW')
                                          InkWell(
                                            onTap: () =>
                                                _showPaymentMethodSelector(
                                                    context,
                                                    currentBooking
                                                            .paymentMethodCode ??
                                                        'DIRECT'),
                                            child: const Padding(
                                              padding:
                                                  EdgeInsets.only(left: 8.0),
                                              child: Icon(Icons.edit,
                                                  size: 16, color: kNeonCyan),
                                            ),
                                          )
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                _buildPaymentRow("Giá phòng/máy",
                                    "${formatCurrency(currentBooking.area?.price)} / giờ"),
                                const SizedBox(height: 16),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Tổng cộng",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                          formatCurrency(
                                              currentBooking.totalPrice),
                                          style: const TextStyle(
                                              color: kAccentFuchsia,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold))
                                    ]),
                              ],
                            ),
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                      color: kBgColor,
                      border: Border(top: BorderSide(color: Colors.white10))),
                  child: SafeArea(
                    child: Row(
                      children: [
                        if (showCancel)
                          Expanded(
                            child: OutlinedButton(
                              onPressed: isLoading
                                  ? null
                                  : () => bloc.add(CancelBookingEvent(
                                      booking.bookingId ?? 0)),
                              style: OutlinedButton.styleFrom(
                                  side:
                                      const BorderSide(color: Colors.redAccent),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12))),
                              child: isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                          color: Colors.redAccent,
                                          strokeWidth: 2))
                                  : const Text("Hủy đặt chỗ",
                                      style: TextStyle(
                                          color: Colors.redAccent,
                                          fontWeight: FontWeight.bold)),
                            ),
                          ),
                        if (showPay) ...[
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () => bloc.add(PayBookingEvent(
                                      currentBooking.bookingId ?? 0,
                                      currentBooking.paymentMethodCode ?? "")),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: kGreenColor,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12))),
                              child: isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                          color: Colors.white, strokeWidth: 2))
                                  : const Text("Thanh toán",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPaymentMethodSelector(BuildContext context, String currentCode) {
    showModalBottomSheet(
      context: context,
      backgroundColor: kBgColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Đổi phương thức thanh toán",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              _buildMethodOption(ctx, "Ví NetPool", "WALLET", currentCode),
              _buildMethodOption(
                  ctx, "Chuyển khoản (QR)", "BANK_TRANSFER", currentCode),
              _buildMethodOption(
                  ctx, "Tiền mặt (Tại quầy)", "DIRECT", currentCode),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMethodOption(
      BuildContext ctx, String name, String code, String currentCode) {
    bool isSelected = code == currentCode;
    return ListTile(
      onTap: () {
        bloc.add(UpdateBookingPaymentMethodEvent(code, name));
        Navigator.pop(ctx);
      },
      leading: Icon(
        code == 'WALLET'
            ? Icons.account_balance_wallet
            : (code == 'BANK_TRANSFER' ? Icons.qr_code : Icons.money),
        color: isSelected ? kNeonCyan : kTextGrey,
      ),
      title: Text(name,
          style: TextStyle(color: isSelected ? kNeonCyan : Colors.white)),
      trailing: isSelected ? const Icon(Icons.check, color: kNeonCyan) : null,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(title.toUpperCase(),
          style: const TextStyle(
              color: kTextGrey, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildInfoBox(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kCardLightColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 6),
              Text(label,
                  style: const TextStyle(fontSize: 11, color: kTextGrey)),
            ],
          ),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildTimeRow(String label, String time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: kTextGrey, fontSize: 13)),
        Text(time,
            style: const TextStyle(
                color: Colors.white,
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSpecRow(String label, String? value) {
    if (value == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 60,
              child: Text("$label:",
                  style: const TextStyle(color: kTextGrey, fontSize: 12))),
          Expanded(
              child: Text(value,
                  style: TextStyle(color: Colors.purple[50], fontSize: 12))),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: kTextGrey, fontSize: 13)),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 13)),
      ],
    );
  }
}
