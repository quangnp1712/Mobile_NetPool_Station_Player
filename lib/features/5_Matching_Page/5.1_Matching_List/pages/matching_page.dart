import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_netpool_station_player/core/router/routes.dart';
import 'package:mobile_netpool_station_player/core/theme/app_colors.dart';

// --- DATA MODELS ---

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
  final String title; // Tiêu đề phòng
  final String gameName; // Tên game
  final String gameImageUrl; // Ảnh game
  final String rank; // Điều kiện rank
  final int currentMembers; // Số người hiện tại
  final int maxMembers; // Số người tối đa
  final String hostName; // Tên chủ phòng
  final String stationName; // Tên quán
  final String address; // Địa chỉ (Show chi tiết hoặc rút gọn)
  final double distance; // Khoảng cách
  final String spaceType; // Loại phòng: Public, VIP, Couple...
  final String startTime; // Thời gian bắt đầu (Lịch hẹn)

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

// --- MOCK DATA ---
// Lưu ý: Đã đổi assets thành network url để hiển thị được trên bản preview này
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

// --- CONSTANTS FOR THEME ---
const Color kPrimaryPurple = Color(0xFF7C3AED); // Fallback
const Color kNeonCyan = Color(0xFF00F0FF); // Fallback

// --- MAIN WIDGET ---

class MatchingPage extends StatefulWidget {
  final Function callback;

  const MatchingPage(this.callback, {super.key});

  @override
  State<MatchingPage> createState() => _MatchingPageState();
}

class _MatchingPageState extends State<MatchingPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  // Filter States
  bool _isNearMe = false;
  String? _selectedProvince;
  String? _selectedDistrict;
  String _selectedTag = "All";

  // Mock Dropdown Data
  final List<String> _provinces = ["Hồ Chí Minh", "Hà Nội", "Đà Nẵng"];
  final List<String> _districts = [
    "Quận 1",
    "Quận 3",
    "Bình Thạnh",
    "Tân Bình",
    "Thủ Đức"
  ];

  // Tags được cập nhật theo Game để phù hợp với data mới
  final List<String> _tags = ["All", "LoL", "Valorant", "CS2", "Ranking"];

  List<TeamLobby> get _filteredLobbies {
    List<TeamLobby> list = fakeLobbies;

    // Search logic
    if (_searchQuery.isNotEmpty) {
      list = list
          .where((p) =>
              p.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              p.stationName
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              p.hostName.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // Tag Filter Logic
    if (_selectedTag != "All") {
      if (_selectedTag == "Ranking") {
        // Giả sử logic lọc rank (ví dụ có dấu + là rank cao)
        list = list.where((p) => p.rank.contains("+")).toList();
      } else if (_selectedTag == "LoL") {
        list = list
            .where((p) => p.gameName.contains("League") || p.gameName == "LoL")
            .toList();
      } else {
        list = list.where((p) => p.gameName.contains(_selectedTag)).toList();
      }
    }

    // Near Me Logic
    if (_isNearMe) {
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
          // 1. Custom Header
          _buildHeader(context),

          // 2. Main List Content
          Expanded(
            child: _filteredLobbies.isEmpty
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
          // Row 1: Title + Near Me Button
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
              InkWell(
                onTap: () {
                  setState(() {
                    _isNearMe = !_isNearMe;
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: _isNearMe
                        ? AppColors.primaryNeon.withOpacity(0.2)
                        : Colors.white10,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color:
                            _isNearMe ? AppColors.primaryNeon : Colors.white24),
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

          const SizedBox(height: 16),

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
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: "Tìm phòng, game, quán...",
                      hintStyle: TextStyle(color: Colors.white38, fontSize: 14),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(bottom: 5),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Row 3: Dropdowns + Refresh
          Row(
            children: [
              // Province Dropdown
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
                    });
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Row 4: Filter Tags
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

// --- SUB-WIDGET: UPDATED MATCH CARD ---

class MatchCard extends StatelessWidget {
  final TeamLobby lobby;

  const MatchCard({super.key, required this.lobby});

  @override
  Widget build(BuildContext context) {
    // Tính toán % slot đã đầy để hiển thị màu sắc
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
            print("Tap on Lobby: ${lobby.title}");
            Get.toNamed(matchingDetailPageRoute);
          },
          splashColor: AppColors.primaryNeon.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header: Game Logo + Title + Slot Count
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Game Image
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

                    // Title & Host
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
                          // Row hiển thị Host và Station (UPDATED)
                          Row(
                            children: [
                              // Host Info
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

                              // Station Info (UPDATED: Icon + Prefix)
                              Icon(Icons.store,
                                  size: 12, color: Colors.blueAccent),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  "Station: ${lobby.stationName}", // Thêm prefix "Station: "
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

                    // Slot Count Badge
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

                // 2. Info Chips Row (Rank, Time, Space)
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

                // 3. Footer: Distance + Action Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Distance & Address
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

                    // Large Join Button
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
                          Get.toNamed(matchingDetailPageRoute);
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
