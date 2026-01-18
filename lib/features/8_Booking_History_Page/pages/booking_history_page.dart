// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:mobile_netpool_station_player/core/theme/app_colors.dart';
import 'package:mobile_netpool_station_player/features/8_Booking_History_Page/bloc/booking_history_bloc.dart';
import 'package:mobile_netpool_station_player/features/8_Booking_History_Page/model/1.booking/booking_model.dart';
import 'package:mobile_netpool_station_player/features/8_Booking_History_Page/services/helpers.dart';
import 'package:mobile_netpool_station_player/features/8_Booking_History_Page/widgets/widget_booking.dart';
import 'package:mobile_netpool_station_player/features/Common/Landing/pages/landing_navigation_bottom.dart';

class BookingHistoryPage extends StatefulWidget {
  const BookingHistoryPage({super.key});

  @override
  State<BookingHistoryPage> createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  BookingHistoryBloc bloc = BookingHistoryBloc();

  @override
  void initState() {
    super.initState();
    bloc.add(InitBookingHistory());
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingHistoryBloc, BookingHistoryState>(
      bloc: bloc,
      listener: (context, state) {
        if (state.blocState == BlocState.showBookingDetail) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookingDetailPage(
                booking: state.selectedBooking!,
                bloc: bloc,
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: kBgColor,
          body: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: 400,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              kPrimaryPurple.withOpacity(0.15),
                              Colors.transparent,
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildIconButton(
                                      Icons.arrow_back,
                                      () => Get.to(
                                          LandingNavBottomWidget(index: 0)),
                                    ),
                                    const Text(
                                      "Lịch sử đặt chỗ",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    _buildIconButton(Icons.search, () {}),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                MonthPickerHeader(
                                  selectedDate: state.selectedDate,
                                  onDateChanged: (newDate) {
                                    bloc.add(ChangeMonthFilter(newDate));
                                  },
                                ),
                                const SizedBox(height: 16),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      _buildFilterTab(
                                          'ALL', 'Tất cả', state.filter),
                                      _buildFilterTab(
                                          'PENDING', 'Đang chờ', state.filter),
                                      _buildFilterTab('COMPLETED', 'Hoàn thành',
                                          state.filter),
                                      _buildFilterTab(
                                          'CANCELLED', 'Đã hủy', state.filter),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Builder(builder: (context) {
                            if (state.status == BookingHistoryStatus.loading) {
                              return Center(
                                child: CircularProgressIndicator(
                                    color: kPrimaryPurple),
                              );
                            }

                            if (state.bookings.isEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: kCardLightColor,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: kBorderColor),
                                      ),
                                      child: Icon(Icons.calendar_today,
                                          size: 32,
                                          color:
                                              Colors.purple.withOpacity(0.5)),
                                    ),
                                    const SizedBox(height: 16),
                                    const Text("Không tìm thấy lịch đặt nào",
                                        style: TextStyle(color: kTextGrey)),
                                  ],
                                ),
                              );
                            }

                            return Stack(
                              children: [
                                ListView.builder(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: state.bookings.length,
                                  itemBuilder: (context, index) {
                                    final booking = state.bookings[index];
                                    return BookingCard(
                                      booking: booking,
                                      onTap: () {
                                        bloc.add(SelectBookingDetailEvent(
                                            booking.bookingId ?? 0));
                                      },
                                    );
                                  },
                                ),
                                if (state.isLoadingDetail)
                                  Positioned.fill(
                                      child: Container(
                                          color: Colors.black54,
                                          child: Center(
                                              child: CircularProgressIndicator(
                                                  color: kNeonCyan)))),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PaginationBar(
                currentPage: state.currentPage,
                totalItems: state.totalItems,
                pageSize: state.pageSize,
                onPageChanged: (page) => bloc.add(ChangeHistoryPage(page)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: kTextGrey, size: 20),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildFilterTab(String code, String label, String currentFilter) {
    bool isSelected = currentFilter == code;
    return GestureDetector(
      onTap: () => bloc.add(ChangeBookingFilter(code)),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? kPrimaryPurple : kCardLightColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? kPrimaryPurple : Colors.white.withOpacity(0.1),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                      color: kPrimaryPurple.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 2))
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : kTextGrey,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class BookingDetailPage extends StatelessWidget {
  final BookingModel booking;
  final BookingHistoryBloc bloc;

  const BookingDetailPage(
      {super.key, required this.booking, required this.bloc});

  @override
  Widget build(BuildContext context) {
    final startAt = booking.startAt;
    final endAt = booking.endAt;
    final duration = getDuration(startAt, endAt);
    final spec = booking.stationResource?.spec;
    bool showCancel =
        booking.statusCode == 'NEW' || booking.statusCode == 'PENDING';
    bool showPay = booking.statusCode == 'PENDING' &&
        (booking.paymentMethodCode == 'BANK_TRANSFER' ||
            booking.paymentMethodCode == 'WALLET');

    return BlocConsumer<BookingHistoryBloc, BookingHistoryState>(
      bloc: bloc,
      listener: (context, state) {
        if (state.actionStatus == BookingActionStatus.success) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        bool isLoading = state.actionStatus == BookingActionStatus.loading;

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
                            onPressed: () => Navigator.pop(context),
                          ),
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
                                  code: booking.statusCode,
                                  name: booking.statusName,
                                  isLarge: true),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: kCardLightColor,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.white10),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(booking.bookingCode ?? "",
                                        style: TextStyle(
                                            fontFamily: 'monospace',
                                            color: Colors.purple[200])),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.copy,
                                        size: 14, color: kTextGrey),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                formatCurrency(booking.totalPrice),
                                style: const TextStyle(
                                  color: kAccentFuchsia,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          _buildSectionTitle("Địa điểm"),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: kCardColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: kBorderColor),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    booking.station?.avatar ?? "",
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                        width: 60,
                                        height: 60,
                                        color: Colors.grey),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        booking.station?.stationName ?? "",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.location_on,
                                              size: 14, color: kPrimaryPurple),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              booking.station?.address ?? "",
                                              style: const TextStyle(
                                                  color: kTextGrey,
                                                  fontSize: 12),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
                              border: Border.all(color: kBorderColor),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: kPrimaryPurple.withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.computer,
                                          color: kPrimaryPurple),
                                    ),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          booking.stationResource
                                                  ?.resourceName ??
                                              "",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        Text(
                                          "${booking.stationResource?.rowName ?? ""} • ${booking.area?.areaName}",
                                          style: const TextStyle(
                                              color: kTextGrey, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                // PC
                                if (spec?.pc != null) ...[
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: kCardLightColor,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.white10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Row(
                                          children: [
                                            Icon(Icons.memory,
                                                size: 14, color: kTextGrey),
                                            SizedBox(width: 6),
                                            Text("CẤU HÌNH",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: kTextGrey)),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  _buildSpecRow(
                                                      "CPU", spec?.pc?.pcCpu),
                                                  _buildSpecRow(
                                                      "RAM", spec?.pc?.pcRam),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  _buildSpecRow(
                                                      "GPU", spec?.pc?.pcGpu),
                                                  _buildSpecRow("Màn hình",
                                                      spec?.pc?.pcMonitor),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                // PS 5
                                if (spec?.console != null) ...[
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: kCardLightColor,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.white10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Row(
                                          children: [
                                            Icon(Icons.memory,
                                                size: 14, color: kTextGrey),
                                            SizedBox(width: 6),
                                            Text("CẤU HÌNH",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: kTextGrey)),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Column 1
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  _buildSpecRow(
                                                      "Dòng máy",
                                                      spec?.console
                                                          ?.csConsoleModel),
                                                  _buildSpecRow("Màn hình",
                                                      spec?.console?.csTvModel),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            // Column 2
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  _buildSpecRow(
                                                      "Tay cầm",
                                                      spec?.console
                                                          ?.csControllerType),
                                                  _buildSpecRow(
                                                      "Số lượng",
                                                      spec?.console
                                                          ?.csControllerCount
                                                          .toString()),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],

                                // Bida
                                if (spec?.billiardTable != null) ...[
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: kCardLightColor,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.white10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Row(
                                          children: [
                                            Icon(Icons.memory,
                                                size: 14, color: kTextGrey),
                                            SizedBox(width: 6),
                                            Text("CẤU HÌNH",
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    color: kTextGrey)),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Column 1
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  _buildSpecRow(
                                                      "Bàn",
                                                      spec?.billiardTable
                                                          ?.btTableDetail),
                                                  _buildSpecRow(
                                                      "Cơ",
                                                      spec?.billiardTable
                                                          ?.btCueDetail),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            // Column 2
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  _buildSpecRow(
                                                      "Bi",
                                                      spec?.billiardTable
                                                          ?.btBallDetail),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildSectionTitle("Thanh toán"),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: kCardColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: kBorderColor),
                            ),
                            child: Column(
                              children: [
                                _buildPaymentRow("Phương thức",
                                    booking.paymentMethodName ?? ""),
                                const SizedBox(height: 8),
                                _buildPaymentRow("Giá phòng/máy",
                                    "${formatCurrency(booking.area?.price)} / giờ"),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Tổng cộng",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                    Text(formatCurrency(booking.totalPrice),
                                        style: const TextStyle(
                                            color: kAccentFuchsia,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
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
                    border: Border(top: BorderSide(color: Colors.white10)),
                  ),
                  child: SafeArea(
                    child: Row(
                      children: [
                        if (showCancel)
                          Expanded(
                            child: OutlinedButton(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      bloc.add(CancelBookingEvent(
                                          booking.bookingId ?? 0));
                                    },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.redAccent),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
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
                                  : () {
                                      bloc.add(PayBookingEvent(
                                          booking.bookingId ?? 0,
                                          booking.paymentMethodCode ?? ""));
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kGreenColor,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
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
