import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_netpool_station_player/core/theme/app_colors.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/bloc/booking_page_bloc.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/data/mock_data.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/models/1_station/station_model.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/models/4_resource/resoucre_spec_model.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/widget/helper_widget.dart';
import 'package:mobile_netpool_station_player/features/Common/data/city_controller/city_model.dart';

class BookingPage extends StatefulWidget {
  final Function callback;

  const BookingPage(this.callback, {super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final TextEditingController _searchController = TextEditingController();

  BookingPageBloc bloc = BookingPageBloc();
  @override
  void initState() {
    super.initState();
    bloc.add(LoadBookingDataEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingPageBloc, BookingPageState>(
      bloc: bloc,
      listener: (context, state) {
        // Lắng nghe lỗi vị trí
        if (state.blocState == BookingBlocState.locationErrorState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
        // Lắng nghe sự kiện Reset để xóa text tìm kiếm
        if (state.blocState == BookingBlocState.filterResetState) {
          _searchController.clear();
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
    // 1. Màn hình chọn Station
    if (state.isSelectingStation || state.selectedStation == null) {
      return _buildStationSelectionScreen(context, state);
    }

    // 2. Màn hình Booking chính
    return Column(
      children: [
        _buildHeader(context, state),
        Expanded(
          child: Stack(
            children: [
              // Layer 1: Nội dung chính
              SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildContextSelector(context, state),
                    const SizedBox(height: 16),
                    _buildSectionTitle(Icons.calendar_today, "Chọn ngày"),
                    _buildDateTimeline(context, state),
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 24),
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
                  ],
                ),
              ),

              // Layer 2: Loading Indicator (Overlay)
              if (state.status == BookingStatus.loading)
                Container(
                  color: kBgColor.withOpacity(0.5), // Làm tối nền một chút
                  child: const Center(
                    child: CircularProgressIndicator(color: kNeonCyan),
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
          Container(
            padding:
                const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 20),
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
                const SizedBox(height: 12),

                // Location Button
                InkWell(
                  onTap: () => bloc.add(FindNearestStationEvent()),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            color: Colors.white24, shape: BoxShape.circle),
                        child: const Icon(Icons.near_me,
                            color: kNeonCyan, size: 16),
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

                // Search Box
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
                          controller: _searchController, // Gán controller
                          onChanged: (value) =>
                              bloc.add(SearchStationEvent(value)),
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                              hintText: "Tìm theo tên, địa chỉ...",
                              hintStyle: TextStyle(
                                  color: Colors.white38, fontSize: 14),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(bottom: 4)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Location Filters & Reset Button
                Row(
                  children: [
                    // City Filter
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
                                style: TextStyle(
                                    color: Colors.white54, fontSize: 13)),
                            dropdownColor: kCardColor,
                            icon: const Icon(Icons.keyboard_arrow_down,
                                color: Colors.white54),
                            isExpanded: true,
                            items: state.provinces
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e.name,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 13)),
                                    ))
                                .toList(),
                            onChanged: (val) {
                              if (val != null)
                                bloc.add(SelectProvinceEvent(val));
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // District Filter
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
                                style: TextStyle(
                                    color: Colors.white54, fontSize: 13)),
                            dropdownColor: kCardColor,
                            icon: const Icon(Icons.keyboard_arrow_down,
                                color: Colors.white54),
                            isExpanded: true,
                            items: state.districts
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e.name,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 13)),
                                    ))
                                .toList(),
                            onChanged: (val) {
                              if (val != null)
                                bloc.add(SelectDistrictEvent(val));
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // RESET BUTTON
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
          ),

          Expanded(
            child: Stack(
              children: [
                if (state.filteredStations.isEmpty &&
                    state.status != BookingStatus.loading)
                  const Center(
                      child: Text("Không tìm thấy trạm nào",
                          style: TextStyle(color: Colors.white54))),
                ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.filteredStations.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final s = state.filteredStations[index];
                    return _buildStationCard(context, s);
                  },
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

          // Pagination Bar
          _buildPaginationBar(context, state),
        ],
      ),
    );
  }

  Widget _buildPaginationBar(BuildContext context, BookingPageState state) {
    if (state.totalItems == 0) return const SizedBox.shrink();

    // Tính tổng số trang (đảm bảo ít nhất 1 trang)
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
          // Info text: Hiển thị 1-5 của 20
          Text(
            "Hiển thị ${(state.currentPage * state.pageSize) + 1} - ${((state.currentPage + 1) * state.pageSize).clamp(0, state.totalItems)} của ${state.totalItems}",
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),

          // Controls
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
          colors: [Color(0xFF2B0C4E), Color(0xFF5A1CCB)],
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
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter_list, color: Colors.white, size: 20),
            style: IconButton.styleFrom(backgroundColor: Colors.white10),
          ),
        ],
      ),
    );
  }

  Widget _buildContextSelector(BuildContext context, BookingPageState state) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                color: kCardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10)),
            child: Row(
              children: state.spaces.map((space) {
                bool isActive =
                    state.selectedSpace?.stationSpaceId == space.stationSpaceId;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => bloc.add(SelectSpaceEvent(space)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          color: isActive ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Use helper function here
                          getIcon(space.metadata?.icon,
                              size: 16,
                              color:
                                  isActive ? kPrimaryPurple : Colors.white60),
                          const SizedBox(width: 6),
                          Text(space.spaceCode!,
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: isActive
                                      ? kPrimaryPurple
                                      : Colors.white60)),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: state.areas.map((area) {
              bool isActive = state.selectedArea?.areaId == area.areaId;
              return GestureDetector(
                onTap: () => bloc.add(SelectAreaEvent(area)),
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isActive ? kNeonCyan.withOpacity(0.1) : kCardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: isActive ? kNeonCyan : Colors.white10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(area.areaName ?? "",
                          style: TextStyle(
                              color: isActive ? kNeonCyan : Colors.white70,
                              fontSize: 13,
                              fontWeight: FontWeight.bold)),
                      Text("${formatCurrency(area.price ?? 0)}/h",
                          style: TextStyle(
                              color: isActive
                                  ? kNeonCyan.withOpacity(0.7)
                                  : Colors.white38,
                              fontSize: 11)),
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
    return SizedBox(
      height: 75,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        scrollDirection: Axis.horizontal,
        itemCount: 14,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          DateTime date = DateTime.now().add(Duration(days: index));
          bool isSelected = state.selectedDateIndex == index;
          String weekday = "T${date.weekday + 1}";
          if (date.weekday == 7) weekday = "CN";
          return GestureDetector(
            onTap: () => bloc.add(SelectDateEvent(index)),
            child: Container(
              width: 55,
              decoration: BoxDecoration(
                color: isSelected ? kPrimaryPurple : kCardColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: isSelected ? kPrimaryPurple : Colors.transparent),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                            color: kPrimaryPurple.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 2))
                      ]
                    : [],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(weekday,
                      style: TextStyle(
                          color: isSelected ? Colors.white70 : Colors.grey,
                          fontSize: 11)),
                  Text("${date.day}",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
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
                    color: kNeonCyan,
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
    // Helper để kiểm tra giờ đã qua
    bool _isTimePassed(String timeStr) {
      final now = DateTime.now();
      final parts = timeStr.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      // Tạo mốc thời gian của khung giờ đó trong ngày hôm nay
      final timeDate = DateTime(now.year, now.month, now.day, hour, minute);

      // Nếu giờ đó < giờ hiện tại => đã qua
      return timeDate.isBefore(now);
    }

    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: kStartTimes.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          String time = kStartTimes[index];
          bool isSelected = state.selectedTime == time;
          bool isPast = false;
          if (state.selectedDateIndex == 0) {
            isPast = _isTimePassed(time);
          }
          return IgnorePointer(
            ignoring: isPast, // Không cho click nếu đã qua
            child: Opacity(
              opacity: isPast ? 0.3 : 1.0, // Làm mờ nếu đã qua
              child: GestureDetector(
                onTap: () => bloc.add(SelectTimeEvent(time)),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color:
                        isSelected ? kNeonCyan.withOpacity(0.15) : kCardColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: isSelected ? kNeonCyan : Colors.transparent),
                  ),
                  child: Text(time,
                      style: TextStyle(
                          color: isSelected ? kNeonCyan : Colors.white60,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal)),
                ),
              ),
            ),
          );
        },
      ),
    );
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
    if (state.resourceRows.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(30.0),
        child: Center(
            child: Text("Vui lòng chọn Khu vực để xem máy",
                style: TextStyle(color: Colors.white30))),
      );
    }

    return Column(
      children: state.resourceRows.map((row) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row Header
              Row(
                children: [
                  Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                          color: kNeonCyan, shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  Text(row.label.toUpperCase(),
                      style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Container(height: 12, width: 1, color: Colors.white24),
                  const SizedBox(width: 8),
                  // Link xem cấu hình
                  if (row.resources.isNotEmpty)
                    InkWell(
                      onTap: () => _showSpecDetails(
                          context, state, row.label, row.resources.first.spec),
                      borderRadius: BorderRadius.circular(4),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 2),
                        child: Text(
                          "Xem cấu hình",
                          style: TextStyle(
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

              // Resource Grid
              GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.0,
                ),
                itemCount: row.resources.length,
                itemBuilder: (context, index) {
                  final resource = row.resources[index];
                  bool isSelected = state.selectedResourceCodes
                      .contains(resource.resourceCode);
                  bool isBusy = resource.statusCode == 'BUSY';

                  return InkWell(
                    onTap: isBusy
                        ? null
                        : () => bloc
                            .add(ToggleResourceEvent(resource.resourceCode!)),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isBusy
                            ? Colors.black26
                            : (isSelected ? kPrimaryPurple : kCardColor),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: isSelected ? kNeonCyan : Colors.transparent,
                            width: isSelected ? 1.5 : 0),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                    color: kNeonCyan.withOpacity(0.3),
                                    blurRadius: 8)
                              ]
                            : [],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Use helper

                              getIcon(
                                state.selectedSpace?.metadata?.icon,
                                color: isBusy
                                    ? kBusyColor.withOpacity(0.5)
                                    : (isSelected ? kNeonCyan : Colors.white54),
                                size: 22,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                resource.resourceName ?? "",
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : (isBusy
                                          ? Colors.white30
                                          : Colors.white70),
                                  fontSize: 13,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          if (isSelected)
                            Positioned(
                                top: 6,
                                right: 6,
                                child: Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                        color: kNeonCyan,
                                        shape: BoxShape.circle))),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  void _showSpecDetails(BuildContext context, BookingPageState state,
      String title, ResourceSpecModel? spec) {
    if (spec == null) return;
    final details = spec.toMap();

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
                // Use helper

                getIcon(
                  state.selectedSpace?.metadata?.icon,
                  color: kNeonCyan,
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
            Divider(color: Colors.white10),
            const SizedBox(height: 10),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Lọc bỏ các giá trị null hoặc rỗng trước khi map
                    ...details.entries
                        .where((e) =>
                            e.value != null && e.value!.toString().isNotEmpty)
                        .map((e) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
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
    bool hasSelection = state.bookingType != null;
    String statusText = "Vui lòng chọn máy";
    if (state.bookingType == 'auto') {
      statusText = "⚡ Chế độ Auto-Pick";
    } else if (state.selectedResourceCodes.isNotEmpty)
      statusText = "Đã chọn: ${state.selectedResourceCodes.length} máy";

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
              color: Colors.black45, blurRadius: 10, offset: Offset(0, -2))
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(statusText,
                        style: const TextStyle(
                            color: kNeonCyan,
                            fontWeight: FontWeight.bold,
                            fontSize: 14)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                            "${state.selectedTime} - ${state.endTime} (${state.duration}h)",
                            style: const TextStyle(
                                color: Colors.white54, fontSize: 12)),
                        const SizedBox(width: 8),
                        const Icon(Icons.circle, size: 4, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(state.selectedArea?.areaName ?? "",
                            style: const TextStyle(
                                color: Colors.white54, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(formatCurrency(state.totalPrice),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    Text("${formatCurrency(state.selectedArea?.price ?? 0)}/h",
                        style: const TextStyle(
                            color: Colors.white38, fontSize: 10)),
                  ],
                )
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: hasSelection ? () {} : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryPurple,
                  disabledBackgroundColor: Colors.grey[800],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: hasSelection ? 4 : 0,
                  shadowColor: kPrimaryPurple.withOpacity(0.5),
                ),
                child: Text(
                  hasSelection ? "XÁC NHẬN ĐẶT LỊCH" : "CHỌN MÁY ĐỂ TIẾP TỤC",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: hasSelection ? Colors.white : Colors.white38),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
