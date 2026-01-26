import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobile_netpool_station_player/core/theme/app_colors.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/widget/helper_widget.dart';
import 'package:mobile_netpool_station_player/features/5_Matching_Page/5.1_Matching/pages/5.2_Matching_Detail/matching_detail_page.dart';
import 'package:mobile_netpool_station_player/features/5_Matching_Page/5.3_Matching_Create/bloc/create_room_bloc.dart';
import 'package:mobile_netpool_station_player/features/5_Matching_Page/5.3_Matching_Create/models/1.station/station_model.dart';
import 'package:mobile_netpool_station_player/features/5_Matching_Page/5.3_Matching_Create/models/4.schedule/timeslot_model.dart';
import 'package:mobile_netpool_station_player/features/5_Matching_Page/5.3_Matching_Create/repository/matching_repository.dart';
import 'package:mobile_netpool_station_player/features/Common/snackbar/snackbar.dart';

const Color kPrimaryPurple = Color(0xFF9333EA);
const Color kBgColor = Color(0xFF0F0E17);
const Color kCardColor = Color(0xFF1A1A2E);
const Color kTextGray = Colors.grey;

class CreateRoomPage extends StatefulWidget {
  const CreateRoomPage({super.key});
  @override
  State<CreateRoomPage> createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  late CreateRoomBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = CreateRoomBloc(MatchingRepository())..add(InitPage());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  String _getVietnameseDay(DateTime date) {
    if (date.weekday == 7) return 'CN';
    return 'T${date.weekday + 1}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocConsumer<CreateRoomBloc, CreateRoomState>(
        listener: (context, state) {
          if (state.status == RoomStatus.failure) {
            ShowSnackBar(context, state.message, false);
          } else if (state.status == RoomStatus.success &&
              state.createdMatchMakingId != null) {
            ShowSnackBar(context, state.message, true);

            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => MatchingDetailPage(
                        matchMakingId: state.createdMatchMakingId!)));
          }
        },
        builder: (context, state) {
          double price = state.selectedArea?.price?.toDouble() ?? 0;
          double total = price *
              state.duration *
              (state.selectedResources.isNotEmpty
                  ? state.selectedResources.length
                  : 1);

          bool canSubmit = state.selectedStation != null &&
              state.selectedResources.isNotEmpty;

          return Scaffold(
            backgroundColor: kBgColor,
            appBar: AppBar(
              title: const Text("Đặt Phòng & Ghép Đội",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: AppColors.textMain)),
              backgroundColor: kBgColor,
              elevation: 0,
            ),
            body: Column(
              children: [
                if (state.status == RoomStatus.loading &&
                    state.selectedStation != null)
                  const LinearProgressIndicator(color: kPrimaryPurple),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader(1, "Chọn Trạm (Station)"),
                        _buildStationCard(context, state),
                        const SizedBox(height: 24),
                        _buildSectionHeader(2, "Dịch vụ (Service)"),
                        _buildSpaceSelector(context, state),
                        const SizedBox(height: 24),
                        _buildSectionHeader(3, "Game"),
                        _buildGameSelector(context, state),
                        const SizedBox(height: 24),
                        _buildSectionHeader(4, "Thời gian & Lịch trình"),
                        _buildScheduleSelector(context, state),
                        const SizedBox(height: 24),
                        _buildSectionHeader(5, "Khu vực (Area)"),
                        _buildAreaSelector(context, state),
                        const SizedBox(height: 24),
                        _buildSectionHeader(6, "Chọn Máy/Ghế"),
                        _buildResourceGrid(context, state),
                        const SizedBox(height: 24),
                        _buildSectionHeader(7, "Số ngày giữ chỗ"),
                        _buildHoldingSelector(context, state),
                        const SizedBox(height: 24),
                        _buildSectionHeader(8, "Thanh toán"),
                        _buildPaymentSection(context, state),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
                _buildBottomBar(context, state, total, canSubmit),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(int step, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
                color: kPrimaryPurple, shape: BoxShape.circle),
            child: Text("$step",
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMain)),
          ),
          const SizedBox(width: 8),
          Text(title,
              style: const TextStyle(
                  color: AppColors.textMain, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildStationCard(BuildContext context, CreateRoomState state) {
    return InkWell(
      onTap: () async {
        final result = await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: const Color(0xFF0F0E17),
          builder: (_) => StationSelectorModal(bloc: _bloc, state: state),
        );
        if (result is StationDetailModel) {
          _bloc.add(SelectStation(result));
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: kCardColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
              color: state.selectedStation != null
                  ? kPrimaryPurple
                  : Colors.white10),
        ),
        child: Row(
          children: [
            const Icon(Icons.store, color: Colors.grey),
            const SizedBox(width: 12),
            Expanded(
              child: state.selectedStation == null
                  ? const Text("Nhấn để chọn trạm",
                      style: TextStyle(color: Colors.grey))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(state.selectedStation!.stationName ?? "",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textMain)),
                        Text(state.selectedStation!.address ?? "",
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey)),
                      ],
                    ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildSpaceSelector(BuildContext context, CreateRoomState state) {
    if (state.selectedStation == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Text("Vui lòng chọn trạm trước",
            style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
      );
    }
    if (state.status == RoomStatus.loading &&
        state.selectedStation != null &&
        state.spaces.isEmpty) {
      return const Text("Đang tải dữ liệu...",
          style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic));
    }
    if (state.spaces.isEmpty) {
      return const Text("Trạm này chưa có dịch vụ nào.",
          style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic));
    }

    return Wrap(
      spacing: 8,
      children: state.spaces.map((space) {
        bool isSelected =
            state.selectedSpace?.stationSpaceId == space.stationSpaceId;
        return ChoiceChip(
          label: Text(space.spaceName ?? ""),
          selected: isSelected,
          onSelected: (val) {
            if (val) _bloc.add(SelectSpace(space));
          },
          selectedColor: kPrimaryPurple,
          backgroundColor: kCardColor,
          labelStyle:
              TextStyle(color: isSelected ? AppColors.textMain : Colors.grey),
        );
      }).toList(),
    );
  }

  Widget _buildGameSelector(BuildContext context, CreateRoomState state) {
    if (state.selectedSpace == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Text("Vui lòng chọn loại hình dịch vụ trước",
            style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
      );
    }
    if (state.status == RoomStatus.loading &&
        state.selectedSpace != null &&
        state.games.isEmpty) {
      return const Center(
          child: Text("Đang tải dữ liệu...",
              style:
                  TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)));
    }
    if (state.games.isEmpty) return const SizedBox();
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: state.games.length,
        separatorBuilder: (c, i) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final game = state.games[index];
          bool isSelected = state.selectedGame?.gameId == game.gameId;

          String imageUrl = game.image ?? "";
          bool hasImage = imageUrl.isNotEmpty;

          return GestureDetector(
            onTap: () => _bloc.add(SelectGame(game)),
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: isSelected ? Colors.green : Colors.transparent,
                        width: 2),
                    color: hasImage ? null : kPrimaryPurple.withOpacity(0.5),
                    image: hasImage
                        ? DecorationImage(
                            image: NetworkImage(imageUrl), fit: BoxFit.cover)
                        : null,
                  ),
                  child: !hasImage
                      ? Center(
                          child: Text(
                              game.gameName.isNotEmpty
                                  ? game.gameName[0].toUpperCase()
                                  : "?",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)))
                      : null,
                ),
                const SizedBox(height: 4),
                Text(game.gameName ?? "",
                    style: TextStyle(
                        fontSize: 10,
                        color: isSelected ? Colors.green : Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildScheduleSelector(BuildContext context, CreateRoomState state) {
    if (state.selectedStation == null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: kCardColor, borderRadius: BorderRadius.circular(8)),
        width: double.infinity,
        child: const Center(
            child: Text("Vui lòng chọn trạm trước",
                style: TextStyle(
                    color: Colors.grey, fontStyle: FontStyle.italic))),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: kCardColor, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Ngày",
              style: TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 8),
          if (state.schedules.isEmpty)
            const Center(
                child: Text("Không có lịch trình",
                    style: TextStyle(color: Colors.white54)))
          else
            SizedBox(
              height: 70,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: state.schedules.length,
                separatorBuilder: (c, i) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final schedule = state.schedules[index];
                  bool isSelected =
                      state.selectedSchedule?.scheduleId == schedule.scheduleId;
                  DateTime date =
                      DateTime.tryParse(schedule.date ?? "") ?? DateTime.now();
                  return GestureDetector(
                    onTap: () => _bloc.add(SelectDate(schedule)),
                    child: Container(
                      width: 60,
                      decoration: BoxDecoration(
                        color: isSelected ? kPrimaryPurple : kCardColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color:
                                isSelected ? kPrimaryPurple : Colors.white10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(_getVietnameseDay(date),
                              style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      isSelected ? Colors.white : Colors.grey)),
                          const SizedBox(height: 4),
                          Text(DateFormat('dd').format(date),
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 16),
          const Text("Khung giờ",
              style: TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 8),
          if (state.status == RoomStatus.loading && state.timeSlots.isEmpty)
            const Center(
                child: Padding(
                    padding: EdgeInsets.all(8),
                    child: CircularProgressIndicator(strokeWidth: 2)))
          else if (state.timeSlots.isEmpty)
            const Text("Không có khung giờ trống",
                style: TextStyle(
                    color: Colors.white54, fontStyle: FontStyle.italic))
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 2.2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: state.timeSlots.length,
              itemBuilder: (context, index) {
                final slot = state.timeSlots[index];
                String timeDisplay = slot.begin?.substring(0, 5) ?? "";

                final startSlot = state.selectedTimeSlot;
                bool isSelected = false;
                bool isInRange = false;
                bool isAllowed = slot.allowBooking == true;

                int startIndex = -1;
                if (startSlot != null) {
                  startIndex = state.timeSlots
                      .indexWhere((s) => s.timeSlotId == startSlot.timeSlotId);
                }

                if (startIndex != -1) {
                  int durationSlots = state.duration.toInt();
                  if (index >= startIndex &&
                      index < startIndex + durationSlots) {
                    isInRange = true;
                  }
                  if (index == startIndex) isSelected = true;
                }

                Color bgColor = isAllowed ? kCardColor : Colors.white10;
                Color borderColor =
                    isAllowed ? Colors.white10 : Colors.transparent;
                Color textColor = isAllowed ? Colors.white70 : Colors.white24;

                if (isSelected) {
                  bgColor = kPrimaryPurple;
                  borderColor = kPrimaryPurple;
                  textColor = Colors.white;
                } else if (isInRange) {
                  bgColor = kPrimaryPurple.withOpacity(0.5);
                  borderColor = kPrimaryPurple.withOpacity(0.5);
                  textColor = Colors.white;
                }

                return InkWell(
                  onTap: isAllowed
                      ? () {
                          if (startIndex == -1 || index <= startIndex) {
                            _bloc.add(SelectTimeSlot(slot));
                            _bloc.add(ChangeDuration(1.0));
                          } else {
                            double newDuration =
                                (index - startIndex + 1).toDouble();
                            _bloc.add(ChangeDuration(newDuration));
                          }
                        }
                      : null,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: borderColor),
                    ),
                    child: Text(
                      timeDisplay,
                      style: TextStyle(
                        color: textColor,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildAreaSelector(BuildContext context, CreateRoomState state) {
    if (state.selectedSpace == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Text("Vui lòng chọn loại hình dịch vụ trước",
            style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
      );
    }
    if (state.status == RoomStatus.loading &&
        state.selectedSpace != null &&
        state.areas.isEmpty) {
      return const Center(
          child: Text("Đang tải dữ liệu...",
              style:
                  TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)));
    }
    if (state.areas.isEmpty) {
      return const Text("---", style: TextStyle(color: Colors.grey));
    }
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: state.areas.length,
        separatorBuilder: (c, i) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final area = state.areas[index];
          bool isSelected = state.selectedArea?.areaId == area.areaId;
          return GestureDetector(
            onTap: () => _bloc.add(SelectArea(area)),
            child: Container(
              width: 140,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    isSelected ? kPrimaryPurple.withOpacity(0.2) : kCardColor,
                border: Border.all(
                    color: isSelected ? kPrimaryPurple : Colors.transparent),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(area.areaName ?? "",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textMain),
                      maxLines: 1),
                  Text("${NumberFormat("#,###").format(area.price)}đ/h",
                      style: const TextStyle(
                          fontSize: 12, color: Colors.pinkAccent)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildResourceGrid(BuildContext context, CreateRoomState state) {
    if (state.selectedArea == null || state.selectedTimeSlot == null) {
      return Center(
          child: Text("Chọn Khu vực & Thời gian trước",
              style: const TextStyle(color: Colors.grey)));
    }

    if (state.isLoadingResources) {
      return const Center(
          child: Text("Đang tải dữ liệu...",
              style:
                  TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)));
    }

    if (state.resourceGroups.isEmpty) {
      return Center(
        child: ElevatedButton(
          onPressed: () => _bloc.add(SearchResources()),
          child: const Text("Tìm máy trống"),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.resourceGroups.length,
      separatorBuilder: (c, i) => const SizedBox(height: 24),
      itemBuilder: (context, groupIndex) {
        final group = state.resourceGroups[groupIndex];
        final resources = group.resources ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                  color: kPrimaryPurple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: kPrimaryPurple.withOpacity(0.5))),
              child: Text(
                group.rowName ?? "Khu vực ${groupIndex + 1}",
                style: const TextStyle(
                    color: kNeonCyan, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8),
              itemCount: resources.length,
              itemBuilder: (context, index) {
                final res = resources[index];
                bool isSelected = state.selectedResources
                    .any((e) => e.stationResourceId == res.stationResourceId);
                bool isAvail = res.isAvailable;
                return InkWell(
                  onTap: () => _bloc.add(ToggleResource(res)),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: !isAvail
                          ? Colors.white10
                          : (isSelected ? kPrimaryPurple : kCardColor),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                          color:
                              isSelected ? Colors.white : Colors.transparent),
                    ),
                    child: Center(
                      child: Text(
                        res.resourceName ?? "${index + 1}",
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 10,
                            color:
                                !isAvail ? Colors.white24 : AppColors.textMain,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildHoldingSelector(BuildContext context, CreateRoomState state) {
    if (state.selectedResources.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Text("Vui lòng chọn máy/ghế trước",
            style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
      );
    }

    DateTime startDate = DateTime.now();
    if (state.selectedSchedule?.date != null) {
      startDate = DateTime.parse(state.selectedSchedule!.date!);
    }

    return SizedBox(
      height: 70, // Tăng chiều cao để chứa thêm ngày tháng
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        separatorBuilder: (c, i) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          int days = index + 1;
          bool isEnabled = days <= state.maxHoldingDays;
          bool isSelected = days == state.holdingDays;

          // Tính ngày tương ứng (Ngày thứ 1 là start date, Ngày thứ 2 là start date + 1...)
          DateTime date = startDate.add(Duration(days: index));

          return GestureDetector(
            onTap: isEnabled ? () => _bloc.add(ChangeHoldingDays(days)) : null,
            child: Container(
              width: 90,
              decoration: BoxDecoration(
                color: isSelected
                    ? kPrimaryPurple
                    : (isEnabled ? kCardColor : Colors.white10),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: isSelected
                        ? kPrimaryPurple
                        : (isEnabled ? Colors.white10 : Colors.transparent)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("$days ngày",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors.white
                              : (isEnabled
                                  ? AppColors.textMain
                                  : Colors.grey))),
                  const SizedBox(height: 4),
                  if (isEnabled)
                    Text(
                        "${_getVietnameseDay(date)}, ${DateFormat('dd/MM').format(date)}",
                        style: TextStyle(
                            fontSize: 11,
                            color: isSelected ? Colors.white70 : Colors.grey)),
                  if (!isEnabled)
                    const Text("Không thể",
                        style:
                            TextStyle(fontSize: 10, color: Colors.redAccent)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPaymentSection(BuildContext context, CreateRoomState state) {
    return Column(
      children: [
        _buildPaymentCard(
          id: 'WALLET',
          title: "Ví NetPool",
          description: "Thanh toán nhanh, không phí",
          icon: Icons.account_balance_wallet,
          balance: state.userBalance,
          selectedId: state.paymentMethod,
        ),
        _buildPaymentCard(
          id: 'BANK_TRANSFER',
          title: "Chuyển khoản (QR)",
          description: "VietQR, MoMo, ZaloPay",
          icon: Icons.qr_code_2,
          selectedId: state.paymentMethod,
        ),
      ],
    );
  }

  Widget _buildPaymentCard({
    required String id,
    required String title,
    required String description,
    required IconData icon,
    required String selectedId,
    double? balance,
  }) {
    final bool isSelected = selectedId == id;
    return GestureDetector(
      onTap: () => _bloc.add(SelectPaymentMethod(id)),
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
            width: isSelected ? 1.5 : 1,
          ),
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
                      child: Text("Số dư: ${formatCurrency(balance)}",
                          style: const TextStyle(
                              color: kGreenColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w500)),
                    ),
                ],
              ),
            ),
            Icon(isSelected ? Icons.check_circle : Icons.circle_outlined,
                color: isSelected ? kNeonCyan : kTextGrey, size: 18)
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, CreateRoomState state,
      double total, bool canSubmit) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: kCardColor,
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Tổng tạm tính",
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  Text("${NumberFormat("#,###").format(total)}đ",
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textMain)),
                ],
              ),
            ),
            IgnorePointer(
              ignoring: !canSubmit,
              child: Opacity(
                opacity: canSubmit ? 1.0 : 0.5,
                child: ElevatedButton(
                  onPressed: () => _bloc.add(SubmitBooking()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryPurple,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                  ),
                  child: const Text("Xác Nhận",
                      style: TextStyle(
                          color: AppColors.textMain,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StationSelectorModal extends StatefulWidget {
  final CreateRoomBloc bloc;
  final CreateRoomState state;
  const StationSelectorModal(
      {super.key, required this.bloc, required this.state});

  @override
  State<StationSelectorModal> createState() => _StationSelectorModalState();
}

class _StationSelectorModalState extends State<StationSelectorModal> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.state.searchQuery;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.bloc,
      child: BlocBuilder<CreateRoomBloc, CreateRoomState>(
        builder: (context, state) {
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
                          if (state.stations.isEmpty &&
                              state.status != RoomStatus.loading)
                            const SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.only(top: 40),
                                child: Center(
                                    child: Text("Không tìm thấy trạm nào",
                                        style:
                                            TextStyle(color: Colors.white54))),
                              ),
                            ),
                          SliverPadding(
                            padding: const EdgeInsets.all(16),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final s = state.stations[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: _buildStationListItem(context, s),
                                  );
                                },
                                childCount: state.stations.length,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (state.status == RoomStatus.loading)
                        Container(
                          color: kBgColor.withOpacity(0.5),
                          child: const Center(
                              child:
                                  CircularProgressIndicator(color: kNeonCyan)),
                        ),
                    ],
                  ),
                ),
                _buildPaginationBar(context, state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStationSelectionHeader(
      BuildContext context, CreateRoomState state) {
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
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              const Text("Chọn Station",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain)),
            ],
          ),
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
            onTap: () => widget.bloc.add(FindNearestStationEvent()),
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
                        color: AppColors.textMain,
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
                    onChanged: (value) =>
                        widget.bloc.add(SearchStationEvent(value)),
                    style: const TextStyle(color: AppColors.textMain),
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
                    child: DropdownButton<String>(
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
                                child: Text(e,
                                    style: const TextStyle(
                                        color: AppColors.textMain,
                                        fontSize: 13)),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          widget.bloc.add(SelectProvinceEvent(val));
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
                    child: DropdownButton<String>(
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
                                child: Text(e,
                                    style: const TextStyle(
                                        color: AppColors.textMain,
                                        fontSize: 13)),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          widget.bloc.add(SelectDistrictEvent(val));
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
                    widget.bloc.add(ResetFilterEvent());
                    _searchController.clear();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationBar(BuildContext context, CreateRoomState state) {
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
                    ? () =>
                        widget.bloc.add(ChangePageEvent(state.currentPage - 1))
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
                    ? () =>
                        widget.bloc.add(ChangePageEvent(state.currentPage + 1))
                    : null,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStationListItem(
      BuildContext context, StationDetailModel station) {
    return ListTile(
      tileColor: kCardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      leading: (station.avatar != null && station.avatar!.isNotEmpty)
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                station.avatar!,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(width: 60, height: 60, color: Colors.grey),
              ),
            )
          : Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(8)),
              child:
                  const Icon(Icons.image_not_supported, color: Colors.white)),
      title: Text(station.stationName ?? "",
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: AppColors.textMain)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(station.address ?? "",
              style: const TextStyle(color: kTextGray),
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
          if (station.distance != null && station.distance! > 0)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                children: [
                  const Icon(Icons.near_me, size: 12, color: kNeonCyan),
                  const SizedBox(width: 4),
                  Text(
                    "${(station.distance! / 1000).toStringAsFixed(1)} km",
                    style: const TextStyle(color: kNeonCyan, fontSize: 12),
                  ),
                ],
              ),
            ),
        ],
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: kTextGray),
      onTap: () => Navigator.pop(context, station),
    );
  }
}
