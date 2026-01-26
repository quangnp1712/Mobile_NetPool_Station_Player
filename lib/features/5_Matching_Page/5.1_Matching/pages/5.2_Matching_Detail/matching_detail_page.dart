// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: unused_local_variable, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mobile_netpool_station_player/core/theme/app_colors.dart';
import 'package:mobile_netpool_station_player/features/5_Matching_Page/5.1_Matching/bloc/maching_detail_bloc.dart';

import 'package:mobile_netpool_station_player/features/5_Matching_Page/5.1_Matching/models/matching_model.dart';
import 'package:mobile_netpool_station_player/features/5_Matching_Page/5.1_Matching/repository/matching_repository.dart';
import 'package:mobile_netpool_station_player/features/Common/Landing/pages/landing_navigation_bottom.dart';
import 'package:mobile_netpool_station_player/features/Common/snackbar/snackbar.dart';

// --- MAIN PAGE ---

class MatchingDetailPage extends StatefulWidget {
  final int? matchMakingId;
  const MatchingDetailPage({
    super.key,
    this.matchMakingId,
  });

  @override
  State<MatchingDetailPage> createState() => _MatchingDetailPageState();
}

class _MatchingDetailPageState extends State<MatchingDetailPage> {
  late MatchingDetailBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = MatchingDetailBloc(MatchingRepository())
      ..add(MatchingDetailInitEvent(widget.matchMakingId!));
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocConsumer<MatchingDetailBloc, MatchingDetailState>(
        bloc: _bloc,
        listener: (context, state) {
          // Lắng nghe sự kiện để hiển thị thông báo
          if (state.actionStatus == MatchingActionStatus.failure &&
              state.errorMessage.isNotEmpty) {
            ShowSnackBar(context, state.errorMessage, false);
          }
          if (state.actionStatus == MatchingActionStatus.success &&
              state.actionMessage.isNotEmpty) {
            ShowSnackBar(context, state.actionMessage, true);
          }
          if (state.status == MatchingStatus.failure) {
            ShowSnackBar(context, state.errorMessage, false);
          }
        },
        builder: (context, state) {
          // Stack Loading Action Overlay
          return Scaffold(
            backgroundColor: kBgColor,
            body: Stack(
              children: [
                // Layer 1: Content or Skeleton
                state.status == MatchingStatus.loading
                    ? _buildSkeletonLoading()
                    : _buildMainContent(context, state),

                // Layer 2: Action Loading Overlay (Khi Join/Approve)
                if (state.actionStatus == MatchingActionStatus.loading)
                  Container(
                    color: Colors.black.withOpacity(0.7),
                    child: const Center(
                      child: CircularProgressIndicator(color: kPrimaryNeon),
                    ),
                  ),
              ],
            ),
            bottomNavigationBar: state.status == MatchingStatus.loading
                ? null
                : _buildBottomAction(context, state),
          );
        },
      ),
    );
  }

  // --- MAIN CONTENT ---
  Widget _buildMainContent(BuildContext context, MatchingDetailState state) {
    final data = state.data;
    if (data == null)
      return const Center(
          child:
              Text("Không có dữ liệu", style: TextStyle(color: Colors.white)));

    final int currentMembers = data.participants?.length ?? 0;
    final int maxMembers = data.resources?.length ?? 0;
    final station = data.station;

    return CustomScrollView(
      slivers: [
        // 1. App Bar Image Header
        SliverAppBar(
          expandedHeight: 200,
          pinned: true,
          backgroundColor: kBgColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new,
                size: 20, color: Colors.white),
            onPressed: () {
              Get.offAll(() => const LandingNavBottomWidget(index: 3));
            },
          ),
          actions: [
            IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () {}),
            if (state.isHost)
              IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white),
                  onPressed: () {}),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  station?.avatar ??
                      "https://via.placeholder.com/400x200?text=No+Image",
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(color: Colors.grey[900]),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, kBgColor.withOpacity(0.95)],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _buildTag(
                              (data.matchMakingCode ?? "UNKNOWN").toUpperCase(),
                              kPrimaryNeon),
                          const SizedBox(width: 8),
                          _buildTag(
                              (data.statusName ?? data.statusCode ?? "Unknown")
                                  .toUpperCase(),
                              Colors.orange),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        data.typeName ??
                            data.matchMakingCode ??
                            "Chi tiết phòng máy",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                      if (data.description != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            data.description!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 13),
                          ),
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),

        // 2. Body Content
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTimeCard(data),
                const SizedBox(height: 16),
                if (station != null) ...[
                  _buildSectionTitle("Địa điểm"),
                  const SizedBox(height: 8),
                  _buildStationInfoCard(station),
                  const SizedBox(height: 16),
                ],
                if (data.resources != null && data.resources!.isNotEmpty) ...[
                  _buildSectionTitle("Chi phí & Tài nguyên"),
                  const SizedBox(height: 8),
                  ...data.resources!.map((r) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: _buildResourceCard(r),
                      )),
                  const SizedBox(height: 16),
                ],
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSectionTitle(
                        "Đội hình ($currentMembers/${maxMembers == 0 ? '?' : maxMembers})"),
                    TextButton(
                        onPressed: () {},
                        child: const Text("Xem tất cả",
                            style:
                                TextStyle(color: kPrimaryNeon, fontSize: 12)))
                  ],
                ),
                const SizedBox(height: 8),
                if (data.participants != null && data.participants!.isNotEmpty)
                  _buildMemberList(data.participants!)
                else
                  const Text("Chưa có thành viên nào tham gia.",
                      style: TextStyle(
                          color: Colors.white38, fontStyle: FontStyle.italic)),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(text,
          style: TextStyle(
              color: color, fontWeight: FontWeight.bold, fontSize: 10)),
    );
  }

  // --- SKELETON LOADING ---
  Widget _buildSkeletonLoading() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              height: 200,
              width: double.infinity,
              color: Colors.white.withOpacity(0.05)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSkeletonBox(height: 100, width: double.infinity),
                const SizedBox(height: 24),
                _buildSkeletonBox(height: 20, width: 100),
                const SizedBox(height: 8),
                _buildSkeletonBox(height: 120, width: double.infinity),
                const SizedBox(height: 24),
                _buildSkeletonBox(height: 20, width: 150),
                const SizedBox(height: 8),
                _buildSkeletonBox(height: 60, width: double.infinity),
                const SizedBox(height: 24),
                _buildSkeletonBox(height: 20, width: 120),
                const SizedBox(height: 8),
                _buildSkeletonBox(height: 60, width: double.infinity),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSkeletonBox({required double height, required double width}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12)),
    );
  }

  // --- WIDGET COMPONENTS (Time, Station, Resource, Member) ---
  // (Giữ nguyên UI như phiên bản trước, chỉ copy lại)

  Widget _buildSectionTitle(String title) {
    return Text(title.toUpperCase(),
        style: const TextStyle(
            color: kTextGrey,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1));
  }

  Widget _buildTimeCard(MatchMakingModel data) {
    final dateFormat = DateFormat("dd/MM/yyyy");
    final currencyFormat = NumberFormat("#,##0", "vi_VN");

    // 1. Tính toán Khung giờ từ Slots (Begin của slot đầu - End của slot cuối)
    String timeSlotString = "Chưa xác định giờ";
    if (data.slots != null && data.slots!.isNotEmpty) {
      // Giả sử slots đã được sort hoặc lấy đúng thứ tự
      String start = data.slots!.first.begin ?? "?";
      String end = data.slots!.last.end ?? "?";

      // Format ngắn gọn HH:mm nếu string có dạng HH:mm:ss
      if (start.length > 5) start = start.substring(0, 5);
      if (end.length > 5) end = end.substring(0, 5);

      timeSlotString = "$start - $end";
    }

    // 2. Tính toán Ngày chơi từ startAt -> expiredAt
    List<String> dates = [];
    if (data.startAt != null && data.expiredAt != null) {
      DateTime current = data.startAt!;
      // Lưu ý: expiredAt là ngày kết thúc
      // Reset về 00:00:00 để so sánh ngày
      DateTime endDate = DateUtils.dateOnly(data.expiredAt!);
      DateTime iter = DateUtils.dateOnly(current);

      // Loop từ ngày bắt đầu đến ngày kết thúc
      while (!iter.isAfter(endDate)) {
        dates.add(dateFormat.format(iter));
        iter = iter.add(const Duration(days: 1));
      }
    } else if (data.startAt != null) {
      dates.add(dateFormat.format(data.startAt!));
    }
    String scheduleString =
        dates.isEmpty ? "Chưa xác định ngày" : dates.join(", ");

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: kCardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white10)),
      child: Column(
        children: [
          // Row 1: Giờ & Giá tiền
          Row(
            children: [
              Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: kSecondaryPurple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.access_time_filled,
                      color: kSecondaryPurple, size: 20)),
              const SizedBox(width: 12),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    const Text("Khung giờ",
                        style: TextStyle(color: kTextGrey, fontSize: 12)),
                    Text(timeSlotString,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16))
                  ])),
              // Layout Tổng tiền
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text("Tổng chi phí",
                      style: TextStyle(color: kTextGrey, fontSize: 12)),
                  Text(
                    "${currencyFormat.format(data.totalPrice ?? 0)}đ",
                    style: const TextStyle(
                        color: kPrimaryNeon,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ],
              )
            ],
          ),

          const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Divider(color: Colors.white10)),

          // Row 2: Danh sách ngày
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.calendar_month,
                      color: Colors.blueAccent, size: 20)),
              const SizedBox(width: 12),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    const Text("Ngày chơi",
                        style: TextStyle(color: kTextGrey, fontSize: 12)),
                    Text(scheduleString,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 14))
                  ])),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildStationInfoCard(StationDetailModel station) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: kCardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white10)),
      child: Column(
        children: [
          Row(children: [
            const Icon(Icons.store, color: Colors.blueAccent, size: 20),
            const SizedBox(width: 8),
            Expanded(
                child: Text(station.stationName ?? "Unknown Station",
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)))
          ]),
          const Divider(color: Colors.white10, height: 24),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.location_on, color: kTextGrey, size: 16),
            const SizedBox(width: 8),
            Expanded(
                child: Text(station.address ?? "Chưa cập nhật địa chỉ",
                    style: const TextStyle(
                        color: kTextGrey, fontSize: 13, height: 1.4)))
          ]),
          const SizedBox(height: 8),
          Row(children: [
            const Icon(Icons.phone, color: kTextGrey, size: 16),
            const SizedBox(width: 8),
            Text(station.hotline ?? "---",
                style: const TextStyle(color: kTextGrey, fontSize: 13)),
            const Spacer(),
            if (station.rating != null) ...[
              const Icon(Icons.star, color: Colors.amber, size: 14),
              const SizedBox(width: 4),
              Text("${station.rating}",
                  style: const TextStyle(
                      color: Colors.amber, fontWeight: FontWeight.bold))
            ]
          ])
        ],
      ),
    );
  }

  Widget _buildResourceCard(MatchResource resource) {
    final currencyFormat = NumberFormat("#,##0", "vi_VN");
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: kCardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(resource.typeName ?? "Tài nguyên",
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
                const SizedBox(height: 4),
                Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(4)),
                    child: Text(resource.typeCode ?? "CODE",
                        style: const TextStyle(color: kTextGrey, fontSize: 10)))
              ])),
          Text("${currencyFormat.format(resource.price ?? 0)}đ",
              style: const TextStyle(
                  color: kPrimaryNeon,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildMemberList(List<MatchParticipant> participants) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: participants.length,
      itemBuilder: (context, index) {
        final member = participants[index];
        final isHost = member.typeCode == "HOST";
        final account = member.account;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: kCardColor,
              borderRadius: BorderRadius.circular(8),
              border: isHost
                  ? Border.all(color: kSecondaryPurple.withOpacity(0.5))
                  : null),
          child: Row(
            children: [
              CircleAvatar(
                  radius: 20,
                  backgroundImage: account?.avatar != null
                      ? NetworkImage(account!.avatar!)
                      : null,
                  backgroundColor: Colors.grey[800],
                  child: account?.avatar == null
                      ? const Icon(Icons.person, color: Colors.white)
                      : null),
              const SizedBox(width: 12),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(account?.username ?? "Unknown User",
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    Row(children: [
                      if (account?.rank != null)
                        Text(account!.rank!,
                            style: const TextStyle(
                                color: kTextGrey, fontSize: 12)),
                      const SizedBox(width: 8),
                      Text("• ${member.statusName ?? '...'}",
                          style: TextStyle(
                              color: member.statusName == "Sẵn sàng"
                                  ? Colors.greenAccent
                                  : kTextGrey,
                              fontSize: 12))
                    ])
                  ])),
              if (isHost)
                Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                        color: kSecondaryPurple,
                        borderRadius: BorderRadius.circular(4)),
                    child: const Text("HOST",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold))),
            ],
          ),
        );
      },
    );
  }

  // --- BOTTOM BAR ---
  Widget _buildBottomAction(BuildContext context, MatchingDetailState state) {
    if (state.isHost) return _buildHostBottomAction(context, state);
    if (state.isMember) return _buildMemberBottomAction();
    return _buildGuestBottomAction(context, state);
  }

  Widget _buildHostBottomAction(
      BuildContext context, MatchingDetailState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
          color: kCardColor,
          border: Border(top: BorderSide(color: Colors.white10))),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: () => _showJoinRequestsBottomSheet(context),
          style: ElevatedButton.styleFrom(
              backgroundColor: kSecondaryPurple,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              elevation: 4),
          child:
              const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.checklist, color: Colors.white),
            SizedBox(width: 8),
            Text("DUYỆT YÊU CẦU THAM GIA",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
          ]),
        ),
      ),
    );
  }

  Widget _buildMemberBottomAction() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
          color: kCardColor,
          border: Border(top: BorderSide(color: Colors.white10))),
      child: SafeArea(
        child: ElevatedButton(
            onPressed: null,
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8))),
            child: const Text("BẠN ĐÃ THAM GIA PHÒNG NÀY",
                style: TextStyle(
                    color: Colors.white54, fontWeight: FontWeight.bold))),
      ),
    );
  }

  Widget _buildGuestBottomAction(
      BuildContext context, MatchingDetailState state) {
    final bool canJoin = state.data?.allowJoin ?? false;
    final bool isFull = (state.data?.participants?.length ?? 0) >=
        (state.data?.limitParticipant ?? 0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
          color: kCardColor,
          border: Border(top: BorderSide(color: Colors.white10))),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
                child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: kCardColor,
                        side: const BorderSide(color: Colors.white24),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                    child: const Text("Quay lại",
                        style: TextStyle(color: Colors.white)))),
            const SizedBox(width: 12),
            Expanded(
                flex: 2,
                child: Container(
                    decoration: BoxDecoration(
                        gradient: (canJoin && !isFull)
                            ? const LinearGradient(
                                colors: [kSecondaryPurple, Color(0xFF5A1CCB)])
                            : const LinearGradient(
                                colors: [Colors.grey, Colors.grey]),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: (canJoin && !isFull)
                            ? [
                                BoxShadow(
                                    color: kSecondaryPurple.withOpacity(0.4),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4))
                              ]
                            : []),
                    child: ElevatedButton(
                        onPressed:
                            // (canJoin && !isFull)
                            //     ? () => _showConfirmJoinDialog(context)
                            //     : null,
                            () => _showConfirmJoinDialog(context),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8))),
                        child: Text(
                            isFull
                                ? "PHÒNG ĐÃ ĐẦY"
                                : (canJoin
                                    ? "THAM GIA NGAY"
                                    : "KHÔNG THỂ THAM GIA"),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold))))),
          ],
        ),
      ),
    );
  }

  // --- ACTIONS & DIALOGS ---
  void _showConfirmJoinDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
              color: Color(0xFF1E1E24),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("XÁC NHẬN THAM GIA",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              const Text("Bạn có chắc muốn gửi yêu cầu tham gia phòng này?",
                  style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 24),
              SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _bloc.add(MatchingDetailJoinRoomEvent());
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: kSecondaryPurple,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      child: const Text("GỬI YÊU CẦU",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)))),
            ],
          ),
        );
      },
    );
  }

  void _showJoinRequestsBottomSheet(BuildContext context) {
    // Kích hoạt load requests khi mở sheet
    _bloc.add(MatchingDetailLoadRequestsEvent());

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        // Cần BlocProvider.value để sheet truy cập được Bloc bên ngoài
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (ctx, controller) {
            return Container(
              decoration: const BoxDecoration(
                  color: kCardColor,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(24))),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                          color: Colors.grey[600],
                          borderRadius: BorderRadius.circular(2))),
                  const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text("DANH SÁCH YÊU CẦU",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16))),
                  const Divider(color: Colors.white10),
                  Expanded(
                    child: BlocBuilder<MatchingDetailBloc, MatchingDetailState>(
                      bloc: _bloc,
                      builder: (context, state) {
                        if (state.joinRequests.isEmpty) {
                          return const Center(
                              child: Text("Chưa có yêu cầu nào.",
                                  style: TextStyle(color: Colors.white54)));
                        }
                        return ListView.builder(
                          controller: controller,
                          itemCount: state.joinRequests.length,
                          itemBuilder: (context, index) {
                            return _buildRequestItem(
                                context, state.joinRequests[index]);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRequestItem(BuildContext context, MatchMakingJoinModel request) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            CircleAvatar(
                radius: 20,
                backgroundImage: request.account?.avatar != null
                    ? NetworkImage(request.account!.avatar!)
                    : null,
                backgroundColor: Colors.grey,
                child: request.account?.avatar == null
                    ? const Icon(Icons.person)
                    : null),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(request.account?.username ?? "Unknown",
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  Text(request.message ?? "Muốn tham gia...",
                      style: const TextStyle(color: Colors.grey, fontSize: 12))
                ])),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4)),
                child: Text(request.statusName ?? "Pending",
                    style: const TextStyle(color: Colors.blue, fontSize: 10)))
          ]),
          const SizedBox(height: 12),
          // Chỉ hiển thị nút nếu status chưa accept/deny (ví dụ logic demo)
          Row(
            children: [
              Expanded(
                  child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _bloc.add(MatchingDetailApproveEvent(
                            request.matchJoiningRegistrationId.toString(),
                            "deny"));
                      },
                      style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                          foregroundColor: Colors.red),
                      child: const Text("TỪ CHỐI"))),
              const SizedBox(width: 12),
              Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _bloc.add(MatchingDetailApproveEvent(
                            request.matchJoiningRegistrationId.toString(),
                            "accept"));
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      child: const Text("CHẤP NHẬN",
                          style: TextStyle(color: Colors.white)))),
            ],
          )
        ],
      ),
    );
  }
}
