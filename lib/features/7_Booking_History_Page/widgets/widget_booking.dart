// ignore_for_file: unused_local_variable, deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mobile_netpool_station_player/core/theme/app_colors.dart';
import 'package:mobile_netpool_station_player/features/7_Booking_History_Page/model/1.booking/booking_model.dart';
import 'package:mobile_netpool_station_player/features/7_Booking_History_Page/services/helpers.dart';

class StatusBadge extends StatelessWidget {
  final String? code;
  final String? name;
  final bool isLarge;

  const StatusBadge(
      {super.key,
      required this.code,
      required this.name,
      this.isLarge = false});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    Color borderColor;
    IconData icon;

    if (code == 'COMPLETED') {
      bgColor = const Color(0xFF10B981).withOpacity(0.1);
      textColor = const Color(0xFF34D399);
      borderColor = const Color(0xFF10B981).withOpacity(0.2);
      icon = Icons.check_circle_outline;
    } else if (code == 'PENDING' || code == 'NEW') {
      bgColor = const Color(0xFFF59E0B).withOpacity(0.1);
      textColor = const Color(0xFFFBBF24);
      borderColor = const Color(0xFFF59E0B).withOpacity(0.2);
      icon = Icons.access_time;
    } else {
      bgColor = const Color(0xFFEF4444).withOpacity(0.1);
      textColor = const Color(0xFFF87171);
      borderColor = const Color(0xFFEF4444).withOpacity(0.2);
      icon = Icons.cancel_outlined;
    }

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: isLarge ? 16 : 10, vertical: isLarge ? 6 : 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: isLarge ? 16 : 12, color: textColor),
          SizedBox(width: isLarge ? 6 : 4),
          Text(
            (name ?? "Unknown").toUpperCase(),
            style: TextStyle(
              color: textColor,
              fontSize: isLarge ? 12 : 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final BookingModel booking;
  final VoidCallback onTap;

  const BookingCard({super.key, required this.booking, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final startAt = booking.startAt;
    final endAt = booking.endAt;
    final duration = getDuration(startAt, endAt);
    final resourceName = booking.stationResource?.resourceName ?? "";
    final paymentName = booking.paymentMethodName ?? "";
    final totalPrice = booking.totalPrice ?? 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: kCardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: kBorderColor),
          boxShadow: [
            BoxShadow(
              color: AppColors.tableHeader.withOpacity(0.7),
              blurRadius: 10,
              offset: const Offset(0, 3),
            )
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Decorative Glow
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: kPrimaryPurple.withOpacity(0.1),
                  shape: BoxShape.circle,
                  backgroundBlendMode: BlendMode.screen,
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.numbers,
                                    size: 12, color: kTextGrey),
                                const SizedBox(width: 4),
                                Text(
                                  booking.bookingCode ?? "",
                                  style: TextStyle(
                                    color: Colors.purple[200],
                                    fontSize: 11,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                          ],
                        ),
                      ),
                      StatusBadge(
                        code: booking.statusCode,
                        name: booking.statusName,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(height: 1, color: Colors.white.withOpacity(0.05)),
                  const SizedBox(height: 16),

                  // Body
                  // Row(
                  //   children: [
                  //     Container(
                  //       padding: const EdgeInsets.all(8),
                  //       decoration: BoxDecoration(
                  //         color: kCardLightColor,
                  //         borderRadius: BorderRadius.circular(8),
                  //         border: Border.all(
                  //             color: kAccentFuchsia.withOpacity(0.2)),
                  //       ),
                  //       child: const Icon(Icons.monitor,
                  //           size: 16, color: kAccentFuchsia),
                  //     ),
                  //     const SizedBox(width: 12),
                  //     Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         const Text("THIẾT BỊ",
                  //             style: TextStyle(
                  //                 fontSize: 10,
                  //                 color: kTextGrey,
                  //                 fontWeight: FontWeight.bold)),
                  //         Text(resourceName,
                  //             style: TextStyle(
                  //                 color: Colors.purple[50],
                  //                 fontSize: 13,
                  //                 fontWeight: FontWeight.w600)),
                  //       ],
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: kCardLightColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: kPrimaryPurple.withOpacity(0.2)),
                        ),
                        child: const Icon(Icons.calendar_today,
                            size: 16, color: kPrimaryPurple),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("THỜI GIAN (${duration}H)",
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: kTextGrey,
                                    fontWeight: FontWeight.bold)),
                            Row(
                              children: [
                                Text(formatTime(startAt),
                                    style: TextStyle(
                                        color: Colors.purple[200],
                                        fontSize: 13)),
                                const Text(" - ",
                                    style: TextStyle(
                                        color: kTextGrey, fontSize: 13)),
                                Text(formatTime(endAt),
                                    style: TextStyle(
                                        color: Colors.purple[200],
                                        fontSize: 13)),
                                const SizedBox(width: 8),
                                Container(
                                    width: 4,
                                    height: 4,
                                    decoration: const BoxDecoration(
                                        color: kTextGrey,
                                        shape: BoxShape.circle)),
                                const SizedBox(width: 8),
                                Text(formatDate(startAt),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 13)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Footer
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: kPrimaryPurple.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(color: kPrimaryPurple.withOpacity(0.1)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // const Text("TỔNG TIỀN",
                            const Text("",
                                style:
                                    TextStyle(fontSize: 9, color: kTextGrey)),
                            const Text(
                              "",
                            ),
                            // Text(formatCurrency(totalPrice),
                            //     style: const TextStyle(
                            //         color: kAccentFuchsia,
                            //         fontWeight: FontWeight.bold,
                            //         fontSize: 15)),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.payment,
                                size: 14, color: Colors.purple[200]),
                            const SizedBox(width: 6),
                            Text(paymentName,
                                style: TextStyle(
                                    color: Colors.purple[100], fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaginationBar extends StatelessWidget {
  final int currentPage;
  final int totalItems;
  final int pageSize;
  final Function(int) onPageChanged;

  const PaginationBar({
    super.key,
    required this.currentPage,
    required this.totalItems,
    required this.pageSize,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (totalItems == 0) return const SizedBox.shrink();
    int totalPages = (totalItems / pageSize).ceil();
    if (totalPages == 0) totalPages = 1;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: const BoxDecoration(
        color: kCardColor,
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Trang ${currentPage + 1}/$totalPages",
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.white),
                onPressed: currentPage > 0
                    ? () => onPageChanged(currentPage - 1)
                    : null,
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: Colors.white),
                onPressed: currentPage < totalPages - 1
                    ? () => onPageChanged(currentPage + 1)
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MonthPickerHeader extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateChanged;

  const MonthPickerHeader({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBgColor.withOpacity(0.9), // Sticky header bg
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.white),
            onPressed: () {
              // Go to previous month
              onDateChanged(
                  DateTime(selectedDate.year, selectedDate.month - 1));
            },
          ),

          // --- Month Display with Calendar Icon ---
          GestureDetector(
            onTap: () async {
              // Optional: Full Date Picker (Disabled Day) could be implemented here
              // For now simple prev/next is sufficient as per prompt
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: kCardLightColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: kPrimaryPurple.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.calendar_month,
                      size: 16, color: kAccentFuchsia),
                  const SizedBox(width: 8),
                  Text(
                    "Tháng ${selectedDate.month}/${selectedDate.year}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),

          IconButton(
            icon: const Icon(Icons.chevron_right, color: Colors.white),
            onPressed: () {
              // Go to next month
              onDateChanged(
                  DateTime(selectedDate.year, selectedDate.month + 1));
            },
          ),
        ],
      ),
    );
  }
}
