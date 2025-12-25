import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_netpool_station_player/core/router/routes.dart';
import 'package:mobile_netpool_station_player/core/theme/app_colors.dart';
// Lưu ý: Các import bên dưới là giả định dựa trên cấu trúc dự án của bạn.
// Hãy đảm bảo đường dẫn import chính xác trong dự án thực tế.
/*
import 'package:mobile_netpool_station_player/core/theme/app_colors.dart';
import 'package:mobile_netpool_station_player/core/theme/app_text_styles.dart';
import 'package:mobile_netpool_station_player/features/2_Home_Page/models/station_model.dart';
*/

class AppFonts {
  static const String semibold = 'Semibold';
}
// --------------------------------------------------------------------------

// --- MODEL STATION (Định nghĩa lại để code chạy được) ---
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

// --------------------------------------------------------------------------
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

class HomePage extends StatefulWidget {
  final Function callback;

  const HomePage(this.callback, {super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // --- TRẠNG THÁI GIẢ LẬP ---
  // TODO: Thay thế bằng logic kiểm tra Auth thật (SharedPreferences / Provider / Bloc)
  bool isLoggedIn = false;

  // --- DỮ LIỆU GIẢ ---
  final List<Station> fakeStations = [
    Station(
      id: '1',
      name: 'Ways Station - 483 Thống Nhất',
      imageUrl: 'assets/images/STATION.png',
      tags: ['NET', 'PLAYSTATION', 'BIDA'],
      address: '483 Thống Nhất, P.16, Q.Gò Vấp, TP.HCM',
      time: '05:00 - 24:00',
      phone: '0944844344',
    ),
    Station(
      id: '2',
      name: 'CyberCore Gaming - Quang Trung',
      imageUrl: 'assets/images/STATION.png',
      tags: ['NET', 'VIP'],
      address: '123 Quang Trung, P.10, Q.Gò Vấp, TP.HCM',
      time: 'Cả ngày',
      phone: '0123456789',
    ),
    Station(
      id: '3',
      name: 'PS5 Zone - Lê Văn Thọ',
      imageUrl: 'assets/images/STATION.png',
      tags: ['PLAYSTATION', 'VIP'],
      address: '456 Lê Văn Thọ, P.9, Q.Gò Vấp, TP.HCM',
      time: '09:00 - 23:00',
      phone: '0987654321',
    ),
    Station(
      id: '4',
      name: 'Bida King - Phan Văn Trị',
      imageUrl: 'assets/images/STATION.png',
      tags: ['BIDA', 'FOOD'],
      address: '789 Phan Văn Trị, P.5, Q.Gò Vấp, TP.HCM',
      time: '10:00 - 02:00',
      phone: '0112233445',
    ),
  ];

// --- DỮ LIỆU TEAM LOBBY GIẢ (Mới) ---
  final List<TeamLobby> fakeLobbies = [
    TeamLobby(
      id: '1',
      title: 'Leo Rank Cao Thủ',
      gameName: 'League of Legends',
      gameImageUrl: 'assets/images/lol_logo.png', // Giả định path
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
      gameImageUrl: 'assets/images/valorant_logo.png',
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
      gameImageUrl: 'assets/images/cs2_logo.png',
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
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Cho phép body tràn lên sau AppBar (để hiển thị background gradient đẹp hơn)
      extendBodyBehindAppBar: true,

      // 2. HomeAppBar - Truyền trạng thái đăng nhập vào
      appBar: HomeAppBar(isLoggedIn: isLoggedIn),

      // Body với nền Gradient
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF3B1F5A), // Màu tím đậm
              kScaffoldBackground, // Màu nền tối
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.5],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Đệm cho AppBar (vì extendBodyBehindAppBar = true)
                const SizedBox(height: 15.0),

                // 1. WELCOME CARD
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: WelcomeCard(),
                ),
                const SizedBox(height: 20),

                // 2. QUICK ACTION CARD
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: QuickActionBar(),
                ),

                const SizedBox(height: 30),

                // 4. MỤC: TÌM ĐỒNG ĐỘI (MỚI)
                // Đây là tính năng cốt lõi cho Role Player -> Nên đưa lên trên hoặc ngay sau Station
                _buildSectionHeader("GHÉP ĐỘI NHANH", onTapViewMore: () {
                  debugPrint("Xem thêm ghép đội");
                }),
                const SizedBox(height: 12),
                SizedBox(
                  height: 200, // Chiều cao cho card lobby
                  child: ListView.builder(
                    padding: const EdgeInsets.only(left: 16.0),
                    scrollDirection: Axis.horizontal,
                    itemCount: fakeLobbies.length,
                    clipBehavior: Clip.none,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: TeamLobbyCard(lobby: fakeLobbies[index]),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),

                // 5. MỤC: STATION GẦN BẠN
                _buildSectionHeader("STATION GẦN BẠN", onTapViewMore: () {
                  debugPrint("Xem thêm station");
                }),
                const SizedBox(height: 12),
                SizedBox(
                  height: 340,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(left: 16.0),
                    scrollDirection: Axis.horizontal,
                    itemCount: fakeStations.length,
                    clipBehavior: Clip.none,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: StationCard(station: fakeStations[index]),
                      );
                    },
                  ),
                ),
                // Đệm dưới cùng (Đã bỏ Tin tức & Sự kiện)
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Helper Widget cho Header có nút Xem thêm
Widget _buildSectionHeader(String title,
    {required VoidCallback onTapViewMore}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            letterSpacing: 1.1,
            color: kHintColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        GestureDetector(
          onTap: onTapViewMore,
          child: const Text(
            "Xem thêm",
            style: TextStyle(
              color: kLinkActive,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );
}

// --- WIDGET MỚI: TEAM LOBBY CARD (GHÉP ĐỘI) ---
class TeamLobbyCard extends StatelessWidget {
  final TeamLobby lobby;

  const TeamLobbyCard({super.key, required this.lobby});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280, // Tăng chiều rộng
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kBoxBackground,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.white10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 6.0,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER: GAME + TIME + SPACE TYPE
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ảnh Game (Avatar)
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade800,
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                    // Giả lập ảnh game
                    image: AssetImage('assets/images/logo_no_bg.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Thông tin Game & Host
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lobby.gameName.toUpperCase(),
                      style: const TextStyle(
                          color: kLinkActive,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      lobby.title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.person, size: 10, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          lobby.hostName,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Slot Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                      color: Colors.deepPurpleAccent.withOpacity(0.5)),
                ),
                child: Column(
                  children: [
                    Text(
                      "${lobby.currentMembers}/${lobby.maxMembers}",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "Slot",
                      style: TextStyle(color: Colors.white70, fontSize: 8),
                    )
                  ],
                ),
              )
            ],
          ),

          const Divider(
              color: Colors.white10,
              height: 16), // FIX: Giảm height từ 20 xuống 16

          // BODY: INFO ROWS (Thông tin nhanh)
          // 1. Thời gian & Lịch hẹn
          Row(
            children: [
              const Icon(Icons.access_time_filled,
                  color: Colors.orangeAccent, size: 14),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  lobby.startTime, // Ví dụ: "20:00 Tối nay"
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  lobby.rank,
                  style: const TextStyle(
                      color: kLinkActive,
                      fontSize: 10,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6), // FIX: Giảm height từ 8 xuống 6

          // 2. Địa điểm & Khoảng cách
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.redAccent, size: 14),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  "${lobby.stationName} • ${lobby.distance}km",
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const Spacer(),

          // FOOTER: BUTTON JOIN
          SizedBox(
            width: double.infinity,
            height: 36,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryPurple,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.zero,
                elevation: 4,
              ),
              child: const Text("Tham gia ngay",
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}

// --- HOME APP BAR ---
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isLoggedIn; // Nhận biến trạng thái

  const HomeAppBar({super.key, this.isLoggedIn = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2B0C4E), Color(0xFF5A1CCB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
      ),
      // Cấu hình vị trí: Logo sát trái, button sát phải
      titleSpacing: 16, // Khoảng cách từ mép trái màn hình đến logo
      centerTitle: false, // Tắt căn giữa để logo nằm bên trái

      title: Padding(
        padding: const EdgeInsets.only(
            top: 10.0), // Đẩy logo xuống 1 khoảng để căn giữa đẹp hơn
        child: GradientWidget(
          child: Image.asset(
            'assets/images/logo_no_bg.png',
            color: Colors.white,
            height: 60, // Giới hạn chiều cao logo
            errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.gamepad,
                size: 40,
                color: Colors.white), // Fallback icon
          ),
        ),
      ),
      actions: [
        // LOGIC: Chỉ hiện nút Đăng nhập khi chưa login
        if (!isLoggedIn)
          Padding(
            padding: const EdgeInsets.only(
                right: 16, top: 10.0), // Căn chỉnh button cùng mức với logo
            child: Center(
              // Center giúp căn giữa button theo chiều dọc trong AppBar
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed(loginPageRoute);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8A2BE2),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  minimumSize: const Size(0, 36), // Chiều cao tối thiểu hợp lý
                ),
                child: const Text(
                  'Đăng nhập',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          )
        else
          // Tùy chọn: Hiện avatar hoặc nút thông báo khi đã login
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 10.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey[800],
              child: const Icon(Icons.person, color: Colors.white),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

// --- GRADIENT WIDGET ---
class GradientWidget extends StatelessWidget {
  final Widget child;
  const GradientWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [kGradientStart, kGradientEnd],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(bounds),
      child: child,
    );
  }
}

// --- QUICK ACTION BAR ---
class QuickActionBar extends StatefulWidget {
  const QuickActionBar({super.key});

  @override
  State<QuickActionBar> createState() => _QuickActionBarState();
}

class _QuickActionBarState extends State<QuickActionBar> {
  // CẬP NHẬT: Bổ sung thêm các tính năng quan trọng cho Role Player
  final List<Map<String, dynamic>> actions = [
    {
      'icon': Icons.account_balance_wallet,
      'label': 'Nạp tiền'
    }, // Mới: Cần thiết cho thanh toán
    {'icon': Icons.calendar_month, 'label': 'Đặt lịch'}, // Cốt lõi
    {
      'icon': Icons.confirmation_number,
      'label': 'Voucher'
    }, // Mới: Khuyến mãi/Quà tặng
    {'icon': Icons.history, 'label': 'Lịch sử'}, // Rút gọn tên cho gọn
  ];

  void _onActionTap(String label) {
    debugPrint('👉 Bạn đã chọn: $label');
  }

  @override
  Widget build(BuildContext context) {
    // SỬA: Chuyển sang SingleChildScrollView để cuộn ngang nếu danh sách dài
    return SizedBox(
      height: 90, // Chiều cao cố định cho vùng action
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: actions.length,
        itemBuilder: (context, index) {
          final action = actions[index];
          return Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 12), // Khoảng cách giữa các item
            child: GestureDetector(
              onTap: () => _onActionTap(action['label'] as String),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFF9C27B0),
                      shape: BoxShape.circle,
                      // Thêm hiệu ứng bóng nhẹ cho nút
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    child: Icon(
                      action['icon'] as IconData,
                      size: 26, // Giảm size một chút để cân đối
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    action['label'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12, // Tăng nhẹ font size cho dễ đọc
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// --- STATION CARD ---
class StationCard extends StatelessWidget {
  final Station station;
  const StationCard({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: kBoxBackground,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: kGradientEnd.withOpacity(0.3),
            blurRadius: 4.0,
            spreadRadius: 1.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageHeader(),
          _buildInfoSection(context),
        ],
      ),
    );
  }

  Widget _buildImageHeader() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12.0),
            topRight: Radius.circular(12.0),
          ),
          child: Image.asset(
            station.imageUrl,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 180,
                color: Colors.grey[850],
                child: const Center(
                  child: Icon(Icons.image_not_supported,
                      color: kHintColor, size: 50),
                ),
              );
            },
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite_border,
              color: kLinkActive,
              size: 20,
            ),
          ),
        ),
        Positioned(
          top: 12,
          left: 12,
          child: Row(
            children: station.tags.map((tag) => _buildTag(tag)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            station.name,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            station.address,
            style: const TextStyle(color: kHintColor, fontSize: 13),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(
                      icon: Icons.access_time_filled,
                      text: station.time,
                      iconColor: Colors.greenAccent[400]!,
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      icon: Icons.phone,
                      text: station.phone,
                      iconColor: kLinkForgot,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: kLinkActive,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  "ĐẶT LỊCH NGAY",
                  style: TextStyle(
                    color: AppColors.textMain,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    Color tagColor = kLinkActive;
    if (text.toUpperCase() == 'PLAYSTATION') {
      tagColor = kGradientStart;
    } else if (text.toUpperCase() == 'BIDA') {
      tagColor = Colors.greenAccent;
    }

    return Container(
      margin: const EdgeInsets.only(right: 6.0),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: tagColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String text,
    required Color iconColor,
  }) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: kHintColor, fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// --- WELCOME CARD ---
class WelcomeCard extends StatefulWidget {
  const WelcomeCard({super.key});

  @override
  State<WelcomeCard> createState() => _WelcomeCardState();
}

class _WelcomeCardState extends State<WelcomeCard> {
  late DateTime _now;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    // Cập nhật mỗi giây để đảm bảo thời gian luôn đúng
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _now = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Hủy timer khi widget bị hủy để tránh rò rỉ bộ nhớ
    super.dispose();
  }

  String _getGreeting() {
    final hour = _now.hour;
    if (hour >= 5 && hour < 11) {
      return "Chào buổi sáng";
    } else if (hour >= 11 && hour < 13) {
      // 11:00 - 12:59: Chào buổi trưa
      return "Chào buổi trưa";
    } else if (hour >= 13 && hour < 18) {
      // 13:00 - 17:59: Chào buổi chiều
      return "Chào buổi chiều";
    } else {
      return "Chào buổi tối";
    }
  }

  String _getFormattedDate() {
    // Định dạng thủ công cho tiếng Việt: Thứ X, dd/MM/yyyy
    List<String> weekDays = [
      "Thứ 2",
      "Thứ 3",
      "Thứ 4",
      "Thứ 5",
      "Thứ 6",
      "Thứ 7",
      "Chủ Nhật"
    ];
    // weekday trả về từ 1 (Thứ 2) đến 7 (Chủ Nhật)
    String weekDay = weekDays[_now.weekday - 1];
    String day = _now.day.toString().padLeft(2, '0');
    String month = _now.month.toString().padLeft(2, '0');
    String year = _now.year.toString();

    return "$weekDay, $day/$month/$year";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: kBoxBackground,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: kGradientEnd,
            blurRadius: 2.0,
            spreadRadius: 2.0,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: kBoxBackground,
            child: Icon(
              Icons.person,
              size: 40,
              color: kHintColor,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${_getGreeting()}, Mike",
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _getFormattedDate(),
                style: const TextStyle(
                  color: kHintColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
// --- CÁC MODELS BỔ SUNG (Đã sửa lỗi thiếu ngoặc đóng) ---

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
  MediaModel({
    this.url,
  });
}

class MetaDataModel {
  String? rejectReason;
  DateTime? rejectAt;
  MetaDataModel({
    this.rejectReason,
    this.rejectAt,
  });
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
  SpaceMetaDataModel({
    this.icon,
    this.bgColor,
  });
}
