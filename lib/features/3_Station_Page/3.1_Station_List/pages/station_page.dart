// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_netpool_station_player/core/theme/app_colors.dart';
import 'package:mobile_netpool_station_player/features/3_Station_Page/3.1_Station_List/bloc/station_page_bloc.dart';
import 'package:mobile_netpool_station_player/features/3_Station_Page/3.1_Station_List/models/1_station/station_model.dart';
import 'package:mobile_netpool_station_player/features/3_Station_Page/3.1_Station_List/widgets/helper_widget.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/pages/booking_page.dart';
import 'package:mobile_netpool_station_player/features/Common/data/city_controller/city_model.dart';
import 'package:mobile_netpool_station_player/features/Common/snackbar/snackbar.dart';

class StationPage extends StatefulWidget {
  final Function callback;

  const StationPage(this.callback, {super.key});

  @override
  State<StationPage> createState() => _StationPageState();
}

class _StationPageState extends State<StationPage> {
  StationPageBloc bloc = StationPageBloc();
  final TextEditingController _searchController = TextEditingController();
  final List<String> _uiTags = [
    "All",
    "Net",
    "Bida",
    "PlayStation",
    "VIP",
    "PC High End"
  ];

  @override
  void initState() {
    super.initState();
    bloc.add(InitStationPageEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StationPageBloc, StationPageState>(
      bloc: bloc,
      listener: (context, state) {
        if (state.searchText.isEmpty && _searchController.text.isNotEmpty) {
          _searchController.clear();
        }
        if (state.blocState == StationBlocState.onFetchStations) {
          bloc.add(FetchStationsEvent());
        }
        if (state.status == StationStatus.success && state.message.isNotEmpty) {
          ShowSnackBar(state.message, true);
        }
        if (state.status == StationStatus.failure) {
          ShowSnackBar(state.message, false);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: kBgColor,
          body: Column(
            children: [
              // ================= HEADER CONTAINER =================
              _buildHeader(context, state),

              // ================= LIST STATION =================
              Expanded(
                child: Builder(builder: (context) {
                  if (state.status == StationStatus.loading) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment
                            .center, // Căn giữa nội dung theo chiều dọc
                        children: [
                          const CircularProgressIndicator(color: kNeonCyan),

                          // Chỉ hiển thị text khi có nội dung message (sau 5s delay)
                          if (state.message.isNotEmpty) ...[
                            const SizedBox(
                                height:
                                    16), // Khoảng cách giữa vòng xoay và chữ
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal:
                                      32.0), // Padding 2 bên để chữ không sát lề
                              child: Text(
                                state.message,
                                textAlign:
                                    TextAlign.center, // Căn giữa dòng chữ
                                style: const TextStyle(
                                  color: Colors
                                      .grey, // Màu chữ (bạn có thể đổi thành kNeonCyan hoặc trắng)
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  }

                  if (state.stations.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.location_off,
                              size: 64, color: Colors.white24),
                          SizedBox(height: 16),
                          Text("Không tìm thấy kết quả phù hợp",
                              style: TextStyle(color: Colors.white54)),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    itemCount: state.stations.length,
                    itemBuilder: (context, index) {
                      final s = state.stations[index];
                      return _buildStationCard(context, s);
                    },
                  );
                }),
              ),
              _buildPaginationBar(context, state, bloc),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, StationPageState state) {
    // Tạo danh sách tags động từ state.platformSpaces
    // Bao gồm cả tên và màu sắc để hiển thị ở filter bar (nếu cần)
    final dynamicTags = ["All"];
    if (state.platformSpaces.isNotEmpty) {
      dynamicTags.addAll(state.platformSpaces
          .map((e) => e.typeName ?? "")
          .where((e) => e.isNotEmpty)
          .toSet());
    }

    return Container(
      padding: const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 16),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Row 1: Title + Near Me Button
              const Text("Chọn Station",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              InkWell(
                onTap: () => bloc.add(FindNearestStationEvent()),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                      color: state.isNearMe ? Colors.white : Colors.white12,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white24)),
                  child: Row(
                    children: [
                      Icon(Icons.near_me,
                          color: state.isNearMe
                              ? AppColors.primaryNeon
                              : Colors.white70,
                          size: 14),
                      const SizedBox(width: 4),
                      Text(
                        "Gần tôi",
                        style: TextStyle(
                            color: state.isNearMe
                                ? AppColors.primaryNeon
                                : Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Row 2: Search Bar
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              children: [
                IconButton(
                  icon:
                      const Icon(Icons.search, color: Colors.white54, size: 20),
                  onPressed: () {
                    bloc.add(SearchStationEvent(_searchController.text));
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onSubmitted: (value) => bloc.add(SearchStationEvent(value)),
                    textInputAction: TextInputAction.search,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: const InputDecoration(
                        hintText: "Tìm kiếm...",
                        hintStyle:
                            TextStyle(color: Colors.white38, fontSize: 14),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(bottom: 9)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Row 3: Dropdowns (Province/District) + Refresh

          Row(
            children: [
              Expanded(
                child: Container(
                  height: 38,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<ProvinceModel>(
                      value: state.selectedProvince,
                      hint: const Text("Tỉnh/TP",
                          style: TextStyle(color: Colors.white54, fontSize: 12),
                          overflow: TextOverflow.ellipsis),
                      dropdownColor: kCardColor,
                      icon: const Icon(Icons.keyboard_arrow_down,
                          color: Colors.white54, size: 18),
                      isExpanded: true,
                      style: const TextStyle(fontSize: 13, color: Colors.white),
                      items: state.provinces
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.name,
                                    overflow: TextOverflow.ellipsis),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) bloc.add(SelectProvinceEvent(val));
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // District Dropdown
              Expanded(
                child: Container(
                  height: 38,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<DistrictModel>(
                      value: state.selectedDistrict,
                      hint: const Text("Quận/Huyện",
                          style: TextStyle(color: Colors.white54, fontSize: 12),
                          overflow: TextOverflow.ellipsis),
                      dropdownColor: kCardColor,
                      icon: const Icon(Icons.keyboard_arrow_down,
                          color: Colors.white54, size: 18),
                      isExpanded: true,
                      style: const TextStyle(fontSize: 13, color: Colors.white),
                      items: state.districts
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.name,
                                    overflow: TextOverflow.ellipsis),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) bloc.add(SelectDistrictEvent(val));
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Refresh Button
              Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.refresh, color: kNeonCyan, size: 20),
                  tooltip: "Làm mới",
                  onPressed: () => bloc.add(ResetFilterEvent()),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Row 4: Filter Tags (Động)
          SizedBox(
            height: 28,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: dynamicTags.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final tag = dynamicTags[index];
                final isSelected = tag == state.selectedTag;
                return GestureDetector(
                  onTap: () => bloc.add(SelectTagEvent(tag)),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color:
                          isSelected ? AppColors.primaryNeon : Colors.white10,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                          color: isSelected ? Colors.black : Colors.white70,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 11),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStationCard(BuildContext context, StationDetailModel station) {
    // Collect tags from spaces, bao gồm cả màu sắc
    List<Map<String, String>> displayTags = [];
    if (station.space != null) {
      for (var s in station.space!) {
        final typeName = s.space?.typeName;
        final bgColor = s.space?.metadata?.bgColor;

        if (typeName != null) {
          // Tránh trùng lặp tag
          if (!displayTags.any((element) => element['name'] == typeName)) {
            displayTags.add({'name': typeName, 'color': bgColor ?? ""});
          }
        }
      }
    }

    // Fallback nếu không có tag nào
    if (displayTags.isEmpty) {
      displayTags.add({'name': 'Chưa có loại hình', 'color': ''});
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageHeader(
              station.avatar ?? "", displayTags, station.distance),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  station.stationName ?? "Unknown Station",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  station.address ?? "",
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            size: 18, color: Colors.white54),
                        const SizedBox(width: 6),
                        const Text("08:00 - 23:00",
                            style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                    Row(
                      children: [
                        const SizedBox(width: 10),
                        const Text("-",
                            style: TextStyle(color: Colors.white70)),
                        const SizedBox(width: 10),
                      ],
                    ),

                    // Số điện thoại
                    Row(
                      children: [
                        const Icon(Icons.phone,
                            size: 18, color: Colors.white54),
                        const SizedBox(width: 6),
                        Text(
                          station.hotline ?? "090.xxxxxxx",
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.callback(2);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryPurple,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("Đặt lịch ngay",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

// === PAGINATION BAR ===
  Widget _buildPaginationBar(
      BuildContext context, StationPageState state, StationPageBloc bloc) {
    if (state.totalItems == 0) return const SizedBox.shrink();

    // Tính tổng số trang
    int totalPages = (state.totalItems / state.pageSize).ceil();
    if (totalPages == 0) totalPages = 1;

    // Index trang bắt đầu từ 0, hiển thị từ 1
    int currentDisplayPage = state.currentPage + 1;
    int startItem = (state.currentPage * state.pageSize) + 1;
    int endItem = ((state.currentPage + 1) * state.pageSize);
    if (endItem > state.totalItems) endItem = state.totalItems;

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
            "Hiển thị $startItem - $endItem của ${state.totalItems}",
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
                  "$currentDisplayPage / $totalPages",
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

  Widget _buildImageHeader(
      String imageUrl, List<Map<String, String>> tags, double? distance) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12), topRight: Radius.circular(12)),
          child: Image.network(
            imageUrl,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 180,
                color: Colors.grey[800],
                child: const Center(
                    child:
                        Icon(Icons.image_not_supported, color: Colors.white54)),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                height: 180,
                color: Colors.grey[900],
                child: const Center(
                  child: CircularProgressIndicator(color: kNeonCyan),
                ),
              );
            },
          ),
        ),

        // Chỉ hiện distance nếu khác null
        if (distance != null)
          Positioned(
            bottom: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kNeonCyan.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, size: 14, color: kNeonCyan),
                  const SizedBox(width: 4),
                  Text("${distance.toStringAsFixed(1)} km",
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                ],
              ),
            ),
          ),

        Positioned(
          top: 12,
          left: 12,
          child: Row(
              children: tags
                  .map((tagData) =>
                      _buildTag(tagData['name']!, colorCode: tagData['color']))
                  .toList()),
        ),
      ],
    );
  }

  Widget _buildTag(String text, {String? colorCode}) {
    Color baseColor;
    if (colorCode != null && colorCode.isNotEmpty) {
      baseColor = parseColor(colorCode);
    } else {
      // Fallback color logic
      if (text.toUpperCase().contains('PS'))
        baseColor = kGradientStart;
      else if (text.toUpperCase().contains('BIDA'))
        baseColor = Colors.greenAccent;
      else if (text.toUpperCase().contains('NET'))
        baseColor = Colors.purpleAccent;
      else if (text.toUpperCase().contains('VIP'))
        baseColor = Colors.orangeAccent;
      else if (text.toUpperCase().contains('PC'))
        baseColor = Colors.redAccent;
      else
        baseColor = kLinkActive;
    }

    return Container(
      margin: const EdgeInsets.only(right: 6.0),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: baseColor, // Solid color, no opacity/blur
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Text(
        text,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
      ),
    );
  }
}
