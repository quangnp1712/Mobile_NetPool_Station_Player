// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:mobile_netpool_station_player/core/theme/app_colors.dart';
import 'package:mobile_netpool_station_player/features/8_Booking_History_Page/bloc/booking_history_bloc.dart';
import 'package:mobile_netpool_station_player/features/8_Booking_History_Page/model/1.booking/booking_model.dart';
import 'package:mobile_netpool_station_player/features/8_Booking_History_Page/pages/booking_detail_page.dart';
import 'package:mobile_netpool_station_player/features/8_Booking_History_Page/services/helpers.dart';
import 'package:mobile_netpool_station_player/features/8_Booking_History_Page/widgets/widget_booking.dart';
import 'package:mobile_netpool_station_player/features/Common/Landing/pages/landing_navigation_bottom.dart';
import 'package:mobile_netpool_station_player/features/Common/snackbar/snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

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
                                          'CANCELED', 'Đã hủy', state.filter),
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
