import 'package:flutter/material.dart';
import 'package:get/get.dart';

// --- MODELS (FROM YOUR REQUEST) ---

class StationDetailModel {
  int? stationId;
  String? avatar;
  String? stationCode;
  String? stationName;
  String? address;
  String? province;
  String? commune;
  String? district;
  String? hotline;
  String? statusCode;
  String? statusName;
  List<MediaModel>? media;
  MetaDataModel? metadata;
  List<StationSpaceModel>? space;
  double? distance;
  double? rating;

  StationDetailModel({
    this.stationId,
    this.avatar,
    this.stationCode,
    this.stationName,
    this.address,
    this.province,
    this.commune,
    this.district,
    this.hotline,
    this.statusCode,
    this.statusName,
    this.media,
    this.metadata,
    this.distance,
    this.rating,
    this.space,
  });
}

class MediaModel {
  String? url;
  MediaModel({this.url});
}

class MetaDataModel {
  String? rejectReason;
  DateTime? rejectAt;
  MetaDataModel({this.rejectReason, this.rejectAt});
}

class PlatformSpaceModel {
  int? spaceId;
  String? typeCode;
  String? typeName;
  String? statusCode;
  String? statusName;
  String? description;
  SpaceMetaDataModel? metadata;

  PlatformSpaceModel({
    this.spaceId,
    this.typeCode,
    this.typeName,
    this.statusCode,
    this.statusName,
    this.description,
    this.metadata,
  });
}

class SpaceMetaDataModel {
  String? icon;
  String? bgColor;
  SpaceMetaDataModel({this.icon, this.bgColor});
}

class StationSpaceModel {
  int? stationSpaceId;
  int? stationId;
  int? spaceId;
  String? spaceCode;
  String? spaceName;
  int? capacity;
  String? statusCode;
  String? statusName;
  SpaceMetaDataModel? metadata;
  PlatformSpaceModel? space;

  StationSpaceModel({
    this.stationSpaceId,
    this.stationId,
    this.spaceId,
    this.spaceCode,
    this.spaceName,
    this.capacity,
    this.statusCode,
    this.statusName,
    this.space,
    this.metadata,
  });
}

class AreaModel {
  int? areaId;
  int? stationSpaceId;
  int? price;
  String? areaCode;
  String? areaName;
  String? statusCode;
  String? statusName;
  String? spaceName;

  AreaModel({
    this.spaceName,
    this.areaId,
    this.stationSpaceId,
    this.price,
    this.areaCode,
    this.areaName,
    this.statusCode,
    this.statusName,
  });
}

class StationResourceModel {
  int? stationResourceId;
  int? areaId;
  ResourceSpecModel? spec;
  String? resourceName;
  String? resourceCode;
  String? typeCode;
  String? typeName;
  String? allowDirectPayment;
  String? statusCode;
  String? statusName;

  StationResourceModel({
    this.stationResourceId,
    this.areaId,
    this.spec,
    this.resourceCode,
    this.resourceName,
    this.typeCode,
    this.typeName,
    this.allowDirectPayment,
    this.statusCode,
    this.statusName,
  });
}

class ResourceSpecModel {
  int? stationResourceSpecId;
  int? stationResourceId;
  String? pcCpu;
  String? pcGpuModel;
  String? pcRam;
  String? pcMonitor;
  String? pcKeyboard;
  String? pcMouse;
  String? pcHeadphone;
  String? btTableDetail;
  String? btCueDetail;
  String? btBallDetail;
  String? csConsoleModel;
  String? csTvModel;
  String? csControllerType;
  int? csControllerCount;

  ResourceSpecModel({
    this.stationResourceSpecId,
    this.stationResourceId,
    this.pcCpu,
    this.pcGpuModel,
    this.pcRam,
    this.pcMonitor,
    this.pcKeyboard,
    this.pcMouse,
    this.pcHeadphone,
    this.btTableDetail,
    this.btCueDetail,
    this.btBallDetail,
    this.csConsoleModel,
    this.csTvModel,
    this.csControllerType,
    this.csControllerCount,
  });
}

// --- ADDITIONAL MODELS FOR MATCHING ---
// Để hiển thị thông tin người tham gia
class MemberModel {
  String name;
  String avatar;
  String role; // Host, Member
  String rank;

  MemberModel(
      {required this.name,
      required this.avatar,
      required this.role,
      required this.rank});
}

class LobbyDetailModel {
  String title;
  String gameName;
  String startTime;
  int currentMembers;
  int maxMembers;
  StationDetailModel station;
  List<MemberModel> members;
  AreaModel? selectedArea;
  StationResourceModel? selectedResource;
  // Thêm danh sách máy đã đặt để demo UI
  List<String>? reservedMachineNames;

  LobbyDetailModel({
    required this.title,
    required this.gameName,
    required this.startTime,
    required this.currentMembers,
    required this.maxMembers,
    required this.station,
    required this.members,
    this.selectedArea,
    this.selectedResource,
    this.reservedMachineNames,
  });
}

// --- MOCK DATA ---
final mockStation = StationDetailModel(
  stationId: 1,
  stationName: "CyberCore Gaming Premium",
  address: "123 Nguyễn Văn Lượng, Gò Vấp, TP.HCM",
  hotline: "0901234567",
  rating: 4.8,
  distance: 1.5,
  avatar:
      "https://images.unsplash.com/photo-1542751371-adc38448a05e?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80",
);

final mockMembers = [
  MemberModel(
      name: "FakerFake",
      avatar: "https://i.pravatar.cc/150?u=1",
      role: "Host",
      rank: "Kim Cương"),
  MemberModel(
      name: "YasuoHasagi",
      avatar: "https://i.pravatar.cc/150?u=2",
      role: "Member",
      rank: "Bạch Kim"),
  MemberModel(
      name: "SupportNoWard",
      avatar: "https://i.pravatar.cc/150?u=3",
      role: "Member",
      rank: "Vàng"),
];

final mockResource = StationResourceModel(
  resourceName: "Máy VIP 05",
  typeName: "PC",
  spec: ResourceSpecModel(
    pcCpu: "i9 13900K",
    pcGpuModel: "RTX 4090",
    pcRam: "32GB",
    pcMonitor: "BenQ 240Hz",
    pcKeyboard: "Logitech G Pro",
    pcMouse: "Logitech G Pro X Superlight",
    pcHeadphone: "HyperX Cloud II",
  ),
);

final mockArea = AreaModel(
  areaName: "VIP Zone",
  price: 15000,
);

final mockLobby = LobbyDetailModel(
  title: "Leo Rank Cao Thủ - Cần Support cứng",
  gameName: "League of Legends",
  startTime: "20:00 Tối Nay (24/10)",
  currentMembers: 3,
  maxMembers: 5,
  station: mockStation,
  members: mockMembers,
  selectedArea: mockArea,
  selectedResource: mockResource,
  reservedMachineNames: ["VIP-05", "VIP-06", "VIP-07"],
);

// --- THEME CONSTANTS ---
const Color kBgColor = Color(0xFF09090B);
const Color kCardColor = Color(0xFF18181B);
const Color kPrimaryNeon = Color(0xFF00F0FF);
const Color kSecondaryPurple = Color(0xFF7C3AED);
const Color kTextWhite = Colors.white;
const Color kTextGrey = Color(0xFFA1A1AA);

// --- MAIN PAGE ---

class MatchingDetailPage extends StatelessWidget {
  const MatchingDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      body: CustomScrollView(
        slivers: [
          // 1. App Bar Image Header
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: kBgColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              onPressed: () {},
            ),
            actions: [
              IconButton(icon: const Icon(Icons.share), onPressed: () {}),
              IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    mockLobby.station.avatar ?? "",
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          kBgColor.withOpacity(0.9),
                        ],
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
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: kPrimaryNeon.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                                color: kPrimaryNeon.withOpacity(0.5)),
                          ),
                          child: Text(
                            mockLobby.gameName.toUpperCase(),
                            style: const TextStyle(
                              color: kPrimaryNeon,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          mockLobby.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
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
                  // --- Info Cards ---
                  _buildTimeCard(),
                  const SizedBox(height: 16),

                  // --- Station Info ---
                  _buildSectionTitle("Địa điểm"),
                  const SizedBox(height: 8),
                  _buildStationInfoCard(mockLobby.station),
                  const SizedBox(height: 16),

                  // --- Specs / Area Info ---
                  if (mockLobby.selectedResource != null) ...[
                    _buildSectionTitle("Máy & Khu vực"),
                    const SizedBox(height: 8),
                    // Card 1: Danh sách máy đã đặt
                    _buildReservedMachinesCard(),
                    const SizedBox(height: 8),
                    // Card 2: Cấu hình chi tiết (đã bỏ tên máy)
                    _buildSpecsCard(mockLobby.selectedResource!.spec!),
                    const SizedBox(height: 16),
                  ],

                  // --- Members ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionTitle(
                          "Đội hình (${mockLobby.currentMembers}/${mockLobby.maxMembers})"),
                      TextButton(
                          onPressed: () {},
                          child: const Text("Xem tất cả",
                              style:
                                  TextStyle(color: kPrimaryNeon, fontSize: 12)))
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildMemberList(),

                  const SizedBox(height: 100), // Space for bottom button
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomAction(context),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        color: kTextGrey,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildTimeCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: kSecondaryPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child:
                const Icon(Icons.access_time_filled, color: kSecondaryPurple),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Thời gian bắt đầu",
                  style: TextStyle(color: kTextGrey, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  mockLobby.startTime,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
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
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.store, color: Colors.blueAccent, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  station.stationName ?? "Unknown Station",
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white10, height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on, color: kTextGrey, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  station.address ?? "Chưa cập nhật địa chỉ",
                  style: const TextStyle(
                      color: kTextGrey, fontSize: 13, height: 1.4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.phone, color: kTextGrey, size: 16),
              const SizedBox(width: 8),
              Text(
                station.hotline ?? "---",
                style: const TextStyle(color: kTextGrey, fontSize: 13),
              ),
              const Spacer(),
              const Icon(Icons.star, color: Colors.amber, size: 14),
              const SizedBox(width: 4),
              Text(
                "${station.rating}",
                style: const TextStyle(
                    color: Colors.amber, fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildReservedMachinesCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                mockArea.areaName ?? "Khu vực chung",
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: kPrimaryNeon.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "${mockLobby.currentMembers} Máy",
                  style: const TextStyle(
                      color: kPrimaryNeon,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            "Danh sách máy:",
            style: TextStyle(color: kTextGrey, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: (mockLobby.reservedMachineNames ?? [])
                .map((name) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Text(
                        name,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ))
                .toList(),
          )
        ],
      ),
    );
  }

  Widget _buildSpecsCard(ResourceSpecModel spec) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kCardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Thông số cấu hình", // Đã bỏ tên máy cụ thể
                style: TextStyle(color: kTextGrey, fontWeight: FontWeight.bold),
              ),
              Text(
                "${mockArea.price}đ/h",
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Divider(color: Colors.white10, height: 24),
          _buildSpecRow("CPU", spec.pcCpu),
          _buildSpecRow("VGA", spec.pcGpuModel),
          _buildSpecRow("RAM", spec.pcRam),
          _buildSpecRow("Monitor", spec.pcMonitor),
          _buildSpecRow("Gear", "${spec.pcKeyboard} | ${spec.pcMouse}"),
        ],
      ),
    );
  }

  Widget _buildSpecRow(String label, String? value) {
    if (value == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(label,
                style: const TextStyle(color: kTextGrey, fontSize: 12)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(color: Colors.white, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: mockLobby.members.length,
      itemBuilder: (context, index) {
        final member = mockLobby.members[index];
        final isHost = member.role == "Host";
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: kCardColor,
            borderRadius: BorderRadius.circular(8),
            border: isHost
                ? Border.all(color: kSecondaryPurple.withOpacity(0.5))
                : null,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(member.avatar),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.name,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      member.rank,
                      style: const TextStyle(color: kTextGrey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              if (isHost)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: kSecondaryPurple,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    "HOST",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: kCardColor,
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kCardColor,
                  side: const BorderSide(color: Colors.white24),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("Quay lại",
                    style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [kSecondaryPurple, Color(0xFF5A1CCB)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: kSecondaryPurple.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () => _showJoinBottomSheet(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    "THAM GIA NGAY",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showJoinBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        // Biến tạm để quản lý state trong BottomSheet
        String selectedRole = "Chưa chọn";
        bool bookMachine = true;

        // Mock icons for roles
        final Map<String, IconData> roleIcons = {
          "Top": Icons.shield,
          "Jungle": Icons.forest,
          "Mid": Icons.flash_on,
          "ADC": Icons.gps_fixed,
          "Support": Icons.favorite,
        };

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFF1E1E24),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle Bar
                  Center(
                      child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                              color: Colors.grey[600],
                              borderRadius: BorderRadius.circular(2)))),
                  const SizedBox(height: 24),

                  // Title
                  const Text(
                    "XÁC NHẬN THAM GIA",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Bạn đang tham gia vào phòng '${mockLobby.title}'",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),

                  // Confirm Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Handle Join Logic
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kSecondaryPurple,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text("XÁC NHẬN & VÀO PHÒNG",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
