// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_netpool_station_player/core/router/routes.dart';
import 'package:mobile_netpool_station_player/core/theme/app_colors.dart';
import 'package:mobile_netpool_station_player/core/utils/debug_logger.dart';
import 'package:mobile_netpool_station_player/features/5_Matching_Page/5.1_Matching/models/matching_detail_response_model.dart';
import 'package:mobile_netpool_station_player/features/5_Matching_Page/5.1_Matching/models/matching_model.dart';
import 'package:mobile_netpool_station_player/features/5_Matching_Page/5.1_Matching/pages/5.2_Matching_Detail/matching_detail_page.dart';
import 'package:mobile_netpool_station_player/features/5_Matching_Page/5.1_Matching/repository/matching_repository.dart';
import 'package:mobile_netpool_station_player/features/5_Matching_Page/5.3_Matching_Create/pages/1.matching_create_page.dart';
import 'package:mobile_netpool_station_player/features/Common/snackbar/snackbar.dart';

class Station {
  final String id;
  final String name;
  final String imageUrl;
  final List<String> tags;
  final String address;
  final String time;
  final String phone;

  Station({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.tags,
    required this.address,
    required this.time,
    required this.phone,
  });
}

class TeamLobby {
  final String id;
  final String title;
  final String gameName;
  final String gameImageUrl;
  final String rank;
  final int currentMembers;
  final int maxMembers;
  final String hostName;
  final String stationName;
  final String address;
  final double distance;
  final String spaceType;
  final String startTime;

  TeamLobby({
    required this.id,
    required this.title,
    required this.gameName,
    required this.gameImageUrl,
    required this.rank,
    required this.currentMembers,
    required this.maxMembers,
    required this.hostName,
    required this.stationName,
    required this.address,
    required this.distance,
    required this.spaceType,
    required this.startTime,
  });
}

final List<TeamLobby> fakeLobbies = [
  TeamLobby(
    id: '1',
    title: 'Leo Rank Cao Thủ',
    gameName: 'League of Legends',
    gameImageUrl:
        'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/LoL_Icon_Flat_GOLD.svg/1200px-LoL_Icon_Flat_GOLD.svg.png',
    rank: 'Kim Cương+',
    currentMembers: 3,
    maxMembers: 5,
    hostName: 'FakerFake',
    stationName: 'Ways Station',
    address: '483 Thống Nhất, GV',
    distance: 1.2,
    spaceType: 'Phòng VIP 5',
    startTime: '20:00 Tối nay',
  ),
  TeamLobby(
    id: '2',
    title: 'Bắn vui vẻ không quạu',
    gameName: 'Valorant',
    gameImageUrl:
        'https://upload.wikimedia.org/wikipedia/commons/thumb/f/fc/Valorant_logo_-_pink_color_version.svg/2560px-Valorant_logo_-_pink_color_version.svg.png',
    rank: 'Mọi rank',
    currentMembers: 2,
    maxMembers: 5,
    hostName: 'JettMain',
    stationName: 'CyberCore QT',
    address: '123 Quang Trung, GV',
    distance: 3.5,
    spaceType: 'Public Zone',
    startTime: 'Ngay bây giờ',
  ),
  TeamLobby(
    id: '3',
    title: 'CS2 Premier',
    gameName: 'CS2',
    gameImageUrl:
        'https://upload.wikimedia.org/wikipedia/commons/2/23/Counter-Strike_2_logo.png',
    rank: '15k+',
    currentMembers: 4,
    maxMembers: 5,
    hostName: 'S1mple',
    stationName: 'Sparta Arena',
    address: 'Phạm Văn Đồng, TĐ',
    distance: 5.0,
    spaceType: 'FPS Zone',
    startTime: '14:30 Chiều nay',
  ),
  TeamLobby(
    id: '4',
    title: 'Đấu Trường Chân Lý',
    gameName: 'TFT',
    gameImageUrl:
        'https://i.pinimg.com/736x/88/4a/05/884a05f3192f98e77a11bf35e076635c.jpg',
    rank: 'Vàng+',
    currentMembers: 6,
    maxMembers: 8,
    hostName: 'Mortdog',
    stationName: 'Vikings Cyber',
    address: 'Quận 10, TP.HCM',
    distance: 2.8,
    spaceType: 'Couple Zone',
    startTime: '21:00 Tối nay',
  ),
];

const Color kPrimaryPurple = Color(0xFF7C3AED);
const Color kNeonCyan = Color(0xFF00F0FF);

class MatchingPage extends StatefulWidget {
  final Function callback;

  const MatchingPage(this.callback, {super.key});

  @override
  State<MatchingPage> createState() => _MatchingPageState();
}

class _MatchingPageState extends State<MatchingPage> {
  final TextEditingController _searchController = TextEditingController();
  final MatchingRepository _repo = MatchingRepository();
  String _searchQuery = "";

  bool _isNearMe = false;
  bool _isLoading = true; // State loading ban đầu
  bool _isSearchingApi = false; // State khi đang gọi API
  String? _selectedProvince;
  String? _selectedDistrict;
  String _selectedTag = "All";

  // List này sẽ chứa dữ liệu hiển thị (Fake hoặc Result thật)
  List<TeamLobby> _displayLobbies = [];

  final List<String> _provinces = ["Hồ Chí Minh", "Hà Nội", "Đà Nẵng"];
  final List<String> _districts = [
    "Quận 1",
    "Quận 3",
    "Bình Thạnh",
    "Tân Bình",
    "Thủ Đức"
  ];

  final List<String> _tags = ["All", "LoL", "Valorant", "CS2", "Ranking"];

  @override
  void initState() {
    super.initState();
    _initialLoading();
  }

  // Fake loading ban đầu cho mượt
  void _initialLoading() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      setState(() {
        _isLoading = false;
        _displayLobbies = fakeLobbies; // Load mock data ban đầu
      });
    }
  }

  // Hàm mapping từ Model thật sang Model UI (Trick)
  TeamLobby _convertModelToLobby(MatchMakingModel model) {
    return TeamLobby(
      id: model.matchMakingId.toString(),
      title: model.typeName ?? model.matchMakingCode ?? "Phòng chơi",
      gameName: "Game", // Có thể map từ resources nếu có
      gameImageUrl: model.station?.avatar ??
          "https://cdn-icons-png.flaticon.com/512/808/808439.png",
      rank: "Tự do",
      currentMembers: model.participants?.length ?? 0,
      maxMembers: model.limitParticipant ?? 0,
      hostName: "Chủ phòng",
      stationName: model.station?.stationName ?? "Unknown Station",
      address: model.station?.address ?? "Unknown Address",
      distance: model.station?.distance ?? 0.0,
      spaceType: model.description ?? "Zone",
      startTime: model.startAt != null
          ? "${model.startAt!.hour}:${model.startAt!.minute} ${model.startAt!.day}/${model.startAt!.month}"
          : "Chưa xác định",
    );
  }

  // Hàm gọi API tìm kiếm
  Future<void> _handleSearchById(String id) async {
    if (id.isEmpty) {
      // Reset về mock data nếu ô tìm kiếm trống
      setState(() {
        _displayLobbies = fakeLobbies;
        _searchQuery = "";
      });
      return;
    }

    setState(() {
      _isSearchingApi = true;
    });

    final result = await _repo.findDetail(id);

    if (mounted) {
      setState(() {
        _isSearchingApi = false;
      });

      if (result['success'] == true && result['body']['data'] != null) {
        try {
          MatchMakingDetailModelResponse realModel =
              MatchMakingDetailModelResponse.fromMap(result['body']);

          // Trick: Convert model thật sang UI model và chỉ hiển thị 1 kết quả
          setState(() {
            _displayLobbies = [_convertModelToLobby(realModel.data!)];
            _searchQuery = id;
          });
        } catch (e) {
          ShowSnackBar(context, "Không thể xử lý dữ liệu: $e", false);
        }
      } else {
        ShowSnackBar(
            context, result['message'] ?? "Không tìm thấy phòng", false);
      }
    }
  }

  // Filter local cho mock data (nếu đang không hiển thị kết quả API)
  List<TeamLobby> get _filteredLobbies {
    // Nếu đang hiển thị kết quả search API (chỉ có 1 item) thì trả về luôn
    if (_displayLobbies.length == 1 && _searchQuery.isNotEmpty) {
      return _displayLobbies;
    }

    List<TeamLobby> list = _displayLobbies;

    // Local filter cho mock data
    if (_searchQuery.isNotEmpty && list.length > 1) {
      list = list
          .where((p) =>
              p.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              p.stationName
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              p.hostName.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    if (_selectedTag != "All" && list.length > 1) {
      if (_selectedTag == "Ranking") {
        list = list.where((p) => p.rank.contains("+")).toList();
      } else if (_selectedTag == "LoL") {
        list = list
            .where((p) => p.gameName.contains("League") || p.gameName == "LoL")
            .toList();
      } else {
        list = list.where((p) => p.gameName.contains(_selectedTag)).toList();
      }
    }

    if (_isNearMe && list.length > 1) {
      list = list.where((p) => p.distance < 3.0).toList();
      list.sort((a, b) => a.distance.compareTo(b.distance));
    }

    return list;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: _isLoading
                ? _buildLoadingState()
                : _isSearchingApi
                    ? _buildLoadingState() // Loading khi search API
                    : _filteredLobbies.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            itemCount: _filteredLobbies.length,
                            itemBuilder: (context, index) {
                              return MatchCard(lobby: _filteredLobbies[index]);
                            },
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppColors.primaryNeon),
          const SizedBox(height: 16),
          Text(
            "Đang tìm phòng...",
            style: TextStyle(color: Colors.white.withOpacity(0.7)),
          )
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 16),
      decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF2B0C4E),
              Color(0xFF5A1CCB),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
          border: Border(bottom: BorderSide(color: Colors.white10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Ghép đội",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                      fontFamily: 'Courier',
                      letterSpacing: 1.5)),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Get.to(() => CreateRoomPage());
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF9F55FF), kPrimaryPurple],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: kPrimaryPurple.withOpacity(0.4),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.add_circle_outline,
                              color: Colors.white, size: 16),
                          SizedBox(width: 4),
                          Text(
                            "Tạo phòng",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _isNearMe = !_isNearMe;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: _isNearMe
                            ? AppColors.primaryNeon.withOpacity(0.2)
                            : Colors.white10,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: _isNearMe
                                ? AppColors.primaryNeon
                                : Colors.white24),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.near_me,
                              color: _isNearMe
                                  ? AppColors.primaryNeon
                                  : Colors.white70,
                              size: 14),
                          const SizedBox(width: 4),
                          Text(
                            "Gần tôi",
                            style: TextStyle(
                                color: _isNearMe
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
            ],
          ),
          const SizedBox(height: 16),
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
                    // Gọi search API khi ấn nút kính lúp
                    _handleSearchById(_searchController.text);
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onSubmitted: (value) {
                      // Gọi search API khi ấn Enter
                      _handleSearchById(value);
                    },
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: "Nhập ID phòng để tìm...",
                      hintStyle: TextStyle(color: Colors.white38, fontSize: 14),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(bottom: 5),
                    ),
                  ),
                ),
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.close,
                        color: Colors.white54, size: 18),
                    onPressed: () {
                      _searchController.clear();
                      _handleSearchById(""); // Reset về mock data
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
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
                    child: DropdownButton<String>(
                      value: _selectedProvince,
                      hint: const Text("Tỉnh/TP",
                          style: TextStyle(color: Colors.white54, fontSize: 12),
                          overflow: TextOverflow.ellipsis),
                      dropdownColor: AppColors.cardBg,
                      icon: const Icon(Icons.keyboard_arrow_down,
                          color: Colors.white54, size: 18),
                      isExpanded: true,
                      style: const TextStyle(fontSize: 13, color: Colors.white),
                      items: _provinces
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e, overflow: TextOverflow.ellipsis),
                              ))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedProvince = val;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 38,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedDistrict,
                      hint: const Text("Quận/Huyện",
                          style: TextStyle(color: Colors.white54, fontSize: 12),
                          overflow: TextOverflow.ellipsis),
                      dropdownColor: AppColors.cardBg,
                      icon: const Icon(Icons.keyboard_arrow_down,
                          color: Colors.white54, size: 18),
                      isExpanded: true,
                      style: const TextStyle(fontSize: 13, color: Colors.white),
                      items: _districts
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e, overflow: TextOverflow.ellipsis),
                              ))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedDistrict = val;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.refresh,
                      color: AppColors.primaryNeon, size: 20),
                  tooltip: "Làm mới",
                  onPressed: () {
                    setState(() {
                      _selectedProvince = null;
                      _selectedDistrict = null;
                      _searchController.clear();
                      _searchQuery = "";
                      _selectedTag = "All";
                      _isNearMe = false;
                      _displayLobbies = fakeLobbies; // Reset về fake
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 28,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _tags.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final tag = _tags[index];
                final isSelected = tag == _selectedTag;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTag = tag;
                    });
                  },
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.manage_search, size: 64, color: Colors.grey[800]),
          const SizedBox(height: 16),
          Text(
            "KHÔNG TÌM THẤY PHÒNG",
            style: TextStyle(
                color: Colors.grey[600], fontSize: 14, letterSpacing: 1.5),
          ),
        ],
      ),
    );
  }
}

class MatchCard extends StatelessWidget {
  final TeamLobby lobby;

  const MatchCard({super.key, required this.lobby});

  @override
  Widget build(BuildContext context) {
    final double fillPercent = lobby.currentMembers / lobby.maxMembers;
    final Color slotColor = fillPercent >= 1.0
        ? Colors.redAccent
        : (fillPercent >= 0.8 ? Colors.orangeAccent : const Color(0xFF00FF94));

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            DebugLogger.printLog("Tap on Lobby: ${lobby.title}");
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => MatchingDetailPage(
                        matchMakingId: int.parse(lobby.id))));
          },
          splashColor: AppColors.primaryNeon.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black26,
                        border: Border.all(color: Colors.white12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          lobby.gameImageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => const Icon(
                              Icons.videogame_asset,
                              color: Colors.white54),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lobby.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.person,
                                  size: 12, color: kPrimaryPurple),
                              const SizedBox(width: 4),
                              Text(
                                "Host: ${lobby.hostName}",
                                style: TextStyle(
                                    color: Colors.grey[400], fontSize: 11),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                  width: 3,
                                  height: 3,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[600],
                                      shape: BoxShape.circle)),
                              const SizedBox(width: 8),
                              Icon(Icons.store,
                                  size: 12, color: Colors.blueAccent),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  "Station: ${lobby.stationName}",
                                  style: TextStyle(
                                      color: Colors.grey[400], fontSize: 11),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: slotColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: slotColor.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.group, size: 12, color: slotColor),
                          const SizedBox(width: 4),
                          Text(
                            "${lobby.currentMembers}/${lobby.maxMembers}",
                            style: TextStyle(
                              color: slotColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildInfoChip(
                        Icons.emoji_events, lobby.rank, Colors.amber),
                    _buildInfoChip(
                        Icons.access_time, lobby.startTime, Colors.blueAccent),
                    _buildInfoChip(Icons.meeting_room, lobby.spaceType,
                        Colors.purpleAccent),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.location_on,
                                  size: 14, color: AppColors.primaryNeon),
                              const SizedBox(width: 4),
                              Text(
                                "${lobby.distance} km",
                                style: const TextStyle(
                                    color: AppColors.primaryNeon,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            lobby.address,
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 11),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      height: 36,
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [kPrimaryPurple, Color(0xFF5A1CCB)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: kPrimaryPurple.withOpacity(0.4),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ]),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => MatchingDetailPage(
                                      matchMakingId: int.parse(lobby.id))));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                        ),
                        child: const Text(
                          "THAM GIA",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
                color: color, fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
