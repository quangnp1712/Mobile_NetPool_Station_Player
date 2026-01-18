// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:mobile_netpool_station_player/core/router/routes.dart';
import 'package:mobile_netpool_station_player/core/theme/app_colors.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/bloc/booking_page_bloc.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/models/1.station/station_model.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/models/5.resource/resoucre_model.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/models/5.resource/resoucre_spec_model.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/pages/bill_preview_page.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/shared_preferences/booking_shared_pref.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/widget/helper_widget.dart';
import 'package:mobile_netpool_station_player/features/Common/data/city_controller/city_model.dart';
import 'package:mobile_netpool_station_player/features/Common/snackbar/snackbar.dart';

class BookingPage extends StatefulWidget {
  final Function callback;

  const BookingPage(this.callback, {super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final TextEditingController _searchController = TextEditingController();

  BookingPageBloc bloc = BookingPageBloc();
  Timer? _loadingTimer;
  @override
  void initState() {
    super.initState();
    bloc.add(BookingInitEvent());
  }

  void _startLoadingTimer() {
    _loadingTimer?.cancel();
    _loadingTimer = Timer(const Duration(seconds: 4), () {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Hệ thống đang tải, vui lòng chờ..."),
            duration: Duration(seconds: 4),
            backgroundColor: kPrimaryPurple,
          ),
        );
      }
    });
  }

  void _cancelLoadingTimer() {
    if (_loadingTimer != null && _loadingTimer!.isActive) {
      _loadingTimer!.cancel();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _loadingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingPageBloc, BookingPageState>(
      bloc: bloc,
      listener: (context, state) {
        if (state.blocState == BookingBlocState.unauthenticated) {
          BookingSharedPref.setIsBookingRoute(true);
          Get.toNamed(loginPageRoute);
        }
        if (state.blocState == BookingBlocState.locationErrorState) {
          ShowSnackBar(state.message, false);
        }
        if (state.blocState == BookingBlocState.filterResetState) {
          _searchController.clear();
        }
        if (state.status == BookingStatus.loading) {
          _startLoadingTimer();
        } else {
          _cancelLoadingTimer();
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: kBgColor,
          body: _bookingPageBodyWidget(state),
          bottomSheet: _bookingPageBottomSheet(state),
        );
      },
    );
  }

  Widget _bookingPageBodyWidget(BookingPageState state) {
    if (state.isSelectingStation) {
      return _buildStationSelectionScreen(context, state);
    }
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 180),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context, state),
                    const SizedBox(height: 16),
                    _buildSectionTitle(Icons.calendar_today, "Chọn ngày"),
                    _buildDateTimeline(context, state),
                    const SizedBox(height: 16),
                    if (state.schedules.isNotEmpty) ...[
                      _buildContextSelector(context, state),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildSectionTitle(Icons.grid_view, "Sơ đồ máy",
                                noPadding: true),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                  color: kNeonCyan.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Row(
                                children: const [
                                  Icon(Icons.group, color: kNeonCyan, size: 12),
                                  SizedBox(width: 4),
                                  Text("Máy liền kề",
                                      style: TextStyle(
                                          color: kNeonCyan,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildAutoPickButton(context, state),
                      const SizedBox(height: 16),
                      _buildResourceRows(context, state),
                      const SizedBox(height: 24),
                      if (state.resources.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildSectionTitle(Icons.access_time, "Giờ chơi",
                                  noPadding: true),
                              _buildDurationControl(context, state),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildTimeList(context, state),
                      ],
                    ]
                  ],
                ),
              ),
              if (state.status == BookingStatus.loading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black54,
                    child: Center(
                      child: CircularProgressIndicator(color: kNeonCyan),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _bookingPageBottomSheet(BookingPageState state) {
    if (state.isSelectingStation || state.selectedStation == null) {
      return const SizedBox.shrink();
    }
    return _buildBottomSheet(context, state);
  }

  Widget _buildStationSelectionScreen(
      BuildContext context, BookingPageState state) {
    return Scaffold(
      backgroundColor: kBgColor,
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: _buildStationSelectionHeader(context, state),
                    ),
                    if (state.filteredStations.isEmpty &&
                        state.status != BookingStatus.loading)
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Center(
                              child: Text("Không tìm thấy trạm nào",
                                  style: TextStyle(color: Colors.white54))),
                        ),
                      ),
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final s = state.filteredStations[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _buildStationCard(context, s),
                            );
                          },
                          childCount: state.filteredStations.length,
                        ),
                      ),
                    ),
                  ],
                ),
                if (state.status == BookingStatus.loading)
                  Container(
                    color: kBgColor.withOpacity(0.5),
                    child: const Center(
                        child: CircularProgressIndicator(color: kNeonCyan)),
                  ),
              ],
            ),
          ),
          _buildPaginationBar(context, state),
        ],
      ),
    );
  }

  Widget _buildStationSelectionHeader(
      BuildContext context, BookingPageState state) {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2B0C4E), Color(0xFF5A1CCB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Chọn Station",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber.withOpacity(0.5)),
            ),
            child: Row(
              children: const [
                Icon(Icons.info_outline, color: Colors.amberAccent, size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Vui lòng chọn trạm trước khi đặt lịch",
                    style: TextStyle(
                      color: Colors.amberAccent,
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () => bloc.add(FindNearestStationEvent()),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                      color: Colors.white24, shape: BoxShape.circle),
                  child: const Icon(Icons.near_me, color: kNeonCyan, size: 16),
                ),
                const SizedBox(width: 8),
                const Text("Tìm trạm gần đây (Vị trí hiện tại)",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        decoration: TextDecoration.underline)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.white54, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => bloc.add(SearchStationEvent(value)),
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        hintText: "Tìm theo tên, địa chỉ...",
                        hintStyle:
                            TextStyle(color: Colors.white38, fontSize: 14),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(bottom: 4)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<ProvinceModel>(
                      value: state.selectedProvince,
                      hint: const Text("Tỉnh/TP",
                          style:
                              TextStyle(color: Colors.white54, fontSize: 13)),
                      dropdownColor: kCardColor,
                      icon: const Icon(Icons.keyboard_arrow_down,
                          color: Colors.white54),
                      isExpanded: true,
                      items: state.provinces
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.name,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 13)),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          bloc.add(SelectProvinceEvent(val));
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<DistrictModel>(
                      value: state.selectedDistrict,
                      hint: const Text("Quận/Huyện",
                          style:
                              TextStyle(color: Colors.white54, fontSize: 13)),
                      dropdownColor: kCardColor,
                      icon: const Icon(Icons.keyboard_arrow_down,
                          color: Colors.white54),
                      isExpanded: true,
                      items: state.districts
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.name,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 13)),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          bloc.add(SelectDistrictEvent(val));
                        }
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.refresh, color: kNeonCyan),
                  tooltip: "Làm mới bộ lọc",
                  onPressed: () {
                    bloc.add(ResetFilterEvent());
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationBar(BuildContext context, BookingPageState state) {
    if (state.totalItems == 0) return const SizedBox.shrink();

    int totalPages = (state.totalItems / state.pageSize).ceil();
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
            "Hiển thị ${(state.currentPage * state.pageSize) + 1} - ${((state.currentPage + 1) * state.pageSize).clamp(0, state.totalItems)} của ${state.totalItems}",
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                color: Colors.white,
                disabledColor: Colors.white10,
                onPressed: state.currentPage > 0
                    ? () => bloc.add(ChangePageEvent(state.currentPage - 1))
                    : null,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: kNeonCyan.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: kNeonCyan.withOpacity(0.3)),
                ),
                child: Text(
                  "${state.currentPage + 1} / $totalPages",
                  style: const TextStyle(
                      color: kNeonCyan, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                color: Colors.white,
                disabledColor: Colors.white10,
                onPressed: state.currentPage < totalPages - 1
                    ? () => bloc.add(ChangePageEvent(state.currentPage + 1))
                    : null,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStationCard(BuildContext context, StationDetailModel s) {
    return InkWell(
      onTap: () => bloc.add(SelectStationEvent(s)),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: kCardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(8)),
              child: s.avatar != null && s.avatar!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        s.avatar!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.storefront,
                                color: Colors.white24, size: 30),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              color: kNeonCyan,
                              strokeWidth: 2,
                            ),
                          );
                        },
                      ),
                    )
                  : const Icon(Icons.storefront,
                      color: Colors.white24, size: 30),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(s.stationName ?? "",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                      s.distance != null
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                  color: kNeonCyan.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4)),
                              child: Text("${s.distance?.toStringAsFixed(1)}km",
                                  style: const TextStyle(
                                      color: kNeonCyan,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold)),
                            )
                          : Container(),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(s.address ?? "",
                      style:
                          const TextStyle(color: Colors.white54, fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (s.space?.any((e) => e.space?.typeName == 'NET') ??
                          false)
                        _buildSpaceBadge(Icons.desktop_windows, "NET"),
                      if (s.space?.any((e) =>
                              e.space?.typeName == 'PS' ||
                              e.space?.typeName == 'PLAYSTATION') ??
                          false)
                        _buildSpaceBadge(Icons.videogame_asset, "PLAYSTATION"),
                      if (s.space?.any((e) => e.space?.typeName == 'BIDA') ??
                          false)
                        _buildSpaceBadge(Icons.sports_baseball, "BIDA"),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSpaceBadge(IconData icon, String label) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: Colors.white70),
          const SizedBox(width: 3),
          Text(label,
              style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 9,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, BookingPageState state) {
    return Container(
      padding: const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.fromARGB(255, 99, 24, 134), Color(0xFF5A1CCB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => bloc.add(ToggleStationSelectionModeEvent()),
            icon: const Icon(Icons.arrow_back_ios_new,
                color: Colors.white, size: 20),
            style: IconButton.styleFrom(backgroundColor: Colors.white10),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => bloc.add(ToggleStationSelectionModeEvent()),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_on, color: kNeonCyan, size: 14),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          state.selectedStation?.stationName ?? "Chọn Station",
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down,
                          color: Colors.white70, size: 16),
                    ],
                  ),
                  Text(
                    "Cách bạn ${state.selectedStation?.distance ?? 0}km",
                    style: const TextStyle(color: Colors.white60, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContextSelector(BuildContext context, BookingPageState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(Icons.videogame_asset, "Loại hình"),
        if (state.spaces.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: state.spaces.map((s) {
                bool isSelected = state.selectedSpace == s;
                return Expanded(
                  child: InkWell(
                    onTap: () => bloc.add(SelectSpaceEvent(s)),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? kprimaryGlow.withOpacity(0.8)
                            : kCardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: isSelected ? kNeonCyan : Colors.white10),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                    color: kprimaryGlow.withOpacity(0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2))
                              ]
                            : [],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          getIcon(s.spaceCode,
                              color: isSelected ? Colors.white : Colors.white54,
                              size: 24),
                          const SizedBox(height: 4),
                          Text(
                            s.spaceCode ?? "",
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.white54,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        const SizedBox(height: 16),
        _buildSectionTitle(Icons.map, "Khu vực"),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: state.areas.map((a) {
              bool isSelected = state.selectedArea == a;
              return InkWell(
                onTap: () => bloc.add(SelectAreaEvent(a)),
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color.fromARGB(253, 203, 48, 224)
                            .withOpacity(0.2)
                        : kCardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: isSelected ? kprimaryGlow : Colors.white10),
                  ),
                  child: Row(
                    children: [
                      Text(
                        a.areaName ?? "",
                        style: TextStyle(
                          color: isSelected ? kTextWhite : Colors.white70,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      if (a.price != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            formatCurrency(a.price!.toDouble()),
                            style: const TextStyle(
                                color: Colors.white54, fontSize: 10),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(IconData icon, String title,
      {bool noPadding = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: noPadding ? 0 : 16.0),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey),
          const SizedBox(width: 4),
          Text(title.toUpperCase(),
              style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5)),
        ],
      ),
    );
  }

  Widget _buildDateTimeline(BuildContext context, BookingPageState state) {
    if (state.schedules.isEmpty) {
      return const SizedBox(
          height: 75,
          child: Center(
              child: Text("Chưa có lịch hoạt động",
                  style: TextStyle(color: Colors.white54, fontSize: 13))));
    }

    return SizedBox(
      height: 75,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        scrollDirection: Axis.horizontal,
        itemCount: state.schedules.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final schedule = state.schedules[index];
          DateTime? date = DateTime.tryParse(schedule.date ?? "");

          bool isSelected = state.selectedDateIndex == index;

          String weekdayStr = "---";
          String dayStr = "--";
          if (date != null) {
            weekdayStr = "T${date.weekday + 1}";
            if (date.weekday == 7) weekdayStr = "CN";
            dayStr = "${date.day}/${date.month}";
          }

          return GestureDetector(
            onTap: () => bloc.add(SelectDateEvent(index)),
            child: Container(
              width: 55,
              decoration: BoxDecoration(
                color: isSelected ? kprimaryGlow : kCardColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: isSelected ? kprimaryGlow : Colors.transparent),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                            color: kprimaryGlow.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 2))
                      ]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(weekdayStr,
                      style: TextStyle(
                          color: isSelected ? Colors.white70 : Colors.grey,
                          fontSize: 11)),
                  Text(dayStr,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDurationControl(BuildContext context, BookingPageState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
          color: kCardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white10)),
      child: Row(
        children: [
          InkWell(
            onTap: () => bloc.add(const ChangeDurationEvent(-0.5)),
            child: const Padding(
                padding: EdgeInsets.all(6),
                child: Icon(Icons.remove, color: Colors.white, size: 16)),
          ),
          Container(
            width: 45,
            alignment: Alignment.center,
            child: Text("${state.duration}h",
                style: const TextStyle(
                    color: kprimaryGlow,
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
          ),
          InkWell(
            onTap: () => bloc.add(const ChangeDurationEvent(0.5)),
            child: const Padding(
                padding: EdgeInsets.all(6),
                child: Icon(Icons.add, color: Colors.white, size: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeList(BuildContext context, BookingPageState state) {
    // Logic hiển thị: Nếu chưa chọn resource (và không phải auto) thì nhắc người dùng
    if (state.selectedResourceCodes.isEmpty && state.bookingType != 'auto') {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Text("Vui lòng chọn máy để xem giờ trống",
            style: TextStyle(
                color: kNeonCyan, fontSize: 13, fontStyle: FontStyle.italic)),
      );
    }

    if (state.availableTimes.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Text("Không có giờ nào khả dụng cho máy này",
            style: TextStyle(color: Colors.white30, fontSize: 13)),
      );
    }

    return SizedBox(
        height: 40,
        child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: state.availableTimes.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (ctx, i) {
              final slot = state.availableTimes[i];
              String t = slot.begin ?? "--:--";
              bool sel = state.selectedTime == t;

              bool isDisabled = !slot.isSelectable;

              return InkWell(
                  onTap: isDisabled ? null : () => bloc.add(SelectTimeEvent(t)),
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: isDisabled
                              ? Colors.white10
                              : (sel
                                  ? kprimaryGlow.withOpacity(0.15)
                                  : kCardColor),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: isDisabled
                                  ? Colors.transparent
                                  : (sel ? kprimaryGlow : Colors.transparent))),
                      child: Text(t,
                          style: TextStyle(
                              color: isDisabled
                                  ? Colors.white24
                                  : (sel ? kprimaryGlow : Colors.white60),
                              fontWeight:
                                  sel ? FontWeight.bold : FontWeight.normal,
                              decoration: isDisabled
                                  ? TextDecoration.lineThrough
                                  : null))));
            }));
  }

  Widget _buildAutoPickButton(BuildContext context, BookingPageState state) {
    bool isAuto = state.bookingType == 'auto';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: () => bloc.add(SelectAutoPickEvent()),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: isAuto
                ? LinearGradient(
                    colors: [Colors.green[800]!, Colors.green[600]!])
                : null,
            color: isAuto ? null : kCardColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: isAuto ? kGreenColor : Colors.white10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: isAuto ? kGreenColor : Colors.white10,
                        shape: BoxShape.circle),
                    child:
                        const Icon(Icons.bolt, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Tự động chọn (Auto)",
                          style: TextStyle(
                              color: isAuto ? Colors.white : Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontSize: 14)),
                      const SizedBox(height: 2),
                      const Text("Hệ thống sẽ tìm máy tốt nhất cho bạn",
                          style:
                              TextStyle(color: Colors.white38, fontSize: 11)),
                    ],
                  ),
                ],
              ),
              if (isAuto) const Icon(Icons.check_circle, color: kGreenColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResourceRows(BuildContext context, BookingPageState state) {
    if (state.resources.isEmpty) {
      return const Center(
          child: Padding(
              padding: EdgeInsets.all(20),
              child: Text("Không có máy nào trong khu vực này",
                  style: TextStyle(color: Colors.white30))));
    }

    Map<String, List<StationResourceModel>> groups = {};
    for (var r in state.resources) {
      String key = r.rowName ?? r.rowCode ?? "Khác";
      if (!groups.containsKey(key)) groups[key] = [];
      groups[key]!.add(r);
    }

    return Column(
        children: groups.entries.map((entry) {
      String rowName = entry.key;
      List<StationResourceModel> rowResources = entry.value;
      rowResources
          .sort((a, b) => (a.displayOrder ?? 0).compareTo(b.displayOrder ?? 0));
      String areaName = state.selectedArea?.areaName ?? "";

      return Padding(
          padding: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
                Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                        color: kNeonCyan, shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Text(" $rowName ($areaName)".toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Container(height: 12, width: 1, color: Colors.white24),
                const SizedBox(width: 8),
                if (rowResources.isNotEmpty && rowResources.first.spec != null)
                  InkWell(
                    onTap: () => _showSpecDetails(
                        context, state, rowName, rowResources.first.spec),
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
                      child: Text(
                        "Xem cấu hình",
                        style: const TextStyle(
                          color: kNeonCyan,
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                          decoration: TextDecoration.underline,
                          decorationColor: kNeonCyan,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemCount: rowResources.length,
                itemBuilder: (ctx, i) {
                  final res = rowResources[i];
                  bool isSelected =
                      state.selectedResourceCodes.contains(res.resourceCode);
                  bool isBusy = res.statusCode == 'BUSY';

                  Color bgColor = isBusy
                      ? Colors.white10
                      : (isSelected ? kCardColor : kCardColor);
                  Color borderColor = isBusy
                      ? Colors.transparent
                      : (isSelected ? kprimaryGlow : Colors.white10);
                  Color iconColor = isBusy
                      ? Colors.white24
                      : (isSelected ? kprimaryGlow : Colors.white54);

                  return InkWell(
                    onTap: isBusy
                        ? null
                        : () =>
                            bloc.add(ToggleResourceEvent(res.resourceCode!)),
                    child: Container(
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: borderColor, width: isSelected ? 2 : 1),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                    color: kprimaryGlow.withOpacity(0.3),
                                    blurRadius: 10,
                                    spreadRadius: 1)
                              ]
                            : [],
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                getIcon(state.selectedSpace?.spaceCode ?? "PC",
                                    size: 32, color: iconColor),
                                const SizedBox(height: 8),
                                Text(
                                  res.resourceName ?? "",
                                  style: TextStyle(
                                    color: isBusy
                                        ? Colors.white24
                                        : (isSelected
                                            ? Colors.white
                                            : Colors.white70),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: isBusy ? kBusyColor : kGreenColor,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: (isBusy ? kBusyColor : kGreenColor)
                                        .withOpacity(0.6),
                                    blurRadius: 6,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                })
          ]));
    }).toList());
  }

  void _showSpecDetails(BuildContext context, BookingPageState state,
      String title, ResourceSpecModel? spec) {
    if (spec == null) return;

    Map<String, dynamic> details = {};
    if (spec.pc != null) {
      details = spec.pc!.toMap();
    } else if (spec.billiardTable != null) {
      details = spec.billiardTable!.toMap();
    } else if (spec.console != null) {
      details = spec.console!.toMap();
    } else {
      details = {};
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: kCardColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 20),
            Row(
              children: [
                getIcon(
                  state.selectedSpace?.metadata?.icon,
                  color: kprimaryGlow,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Cấu hình chi tiết - $title",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(color: Colors.white10),
            const SizedBox(height: 10),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (details.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text("Chưa có thông tin cấu hình",
                            style: TextStyle(color: Colors.white54)),
                      )
                    else
                      ...details.entries
                          .where((e) =>
                              e.value != null && e.value!.toString().isNotEmpty)
                          .map((e) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        flex: 2,
                                        child: Text(_formatKey(e.key),
                                            style: const TextStyle(
                                                color: Colors.white54,
                                                fontSize: 13))),
                                    Expanded(
                                        flex: 3,
                                        child: Text(e.value!.toString(),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500))),
                                  ],
                                ),
                              )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryPurple,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Đã hiểu",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatKey(String key) {
    switch (key) {
      case 'pcCpu':
        return 'CPU';
      case 'pcRam':
        return 'RAM';
      case 'pcGpu':
        return 'GPU (Card)';
      case 'pcMonitor':
        return 'Màn hình';
      case 'pcKeyboard':
        return 'Bàn phím';
      case 'pcMouse':
        return 'Chuột';
      case 'pcHeadphone':
        return 'Tai nghe';
      case 'btTableDetail':
        return 'Loại Bàn';
      case 'btCueDetail':
        return 'Loại Cơ';
      case 'btBallDetail':
        return 'Loại Bóng';
      case 'csConsoleModel':
        return 'Máy Console';
      case 'csTvModel':
        return 'Màn hình TV';
      case 'csControllerType':
        return 'Tay cầm';
      case 'csControllerCount':
        return 'Số lượng';
      default:
        return key;
    }
  }

  Widget _buildBottomSheet(BuildContext context, BookingPageState state) {
    bool hasSel = state.bookingType != null && state.selectedTime.isNotEmpty;

    String selectedName = "Chưa chọn";
    if (state.selectedResourceCodes.isNotEmpty) {
      try {
        final code = state.selectedResourceCodes.first;
        final res = state.resources.firstWhere((e) => e.resourceCode == code,
            orElse: () => StationResourceModel(resourceName: code));
        selectedName = res.resourceName ?? code;
      } catch (_) {}
    } else if (state.bookingType == 'auto') {
      selectedName = "Tự động chọn";
    }

    return Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
            color: kCardColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: SafeArea(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Đã chọn:",
                      style: TextStyle(color: Colors.white54, fontSize: 12)),
                  Text(selectedName,
                      style: const TextStyle(
                          color: kprimaryGlow,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Text(formatCurrency(state.totalPrice),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold))
          ]),
          const SizedBox(height: 16),
          SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                  onPressed: hasSel
                      ? () {
                          // -- update: Gọi event lấy thông tin ví khi ấn nút xác nhận
                          bloc.add(GetWalletEvent());
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => BillPreviewPage(
                                      state: state, bloc: bloc)));
                        }
                      : null,
                  style:
                      ElevatedButton.styleFrom(backgroundColor: kPrimaryPurple),
                  child: const Text("XÁC NHẬN ĐẶT LỊCH",
                      style: TextStyle(color: Colors.white))))
        ])));
  }
}
