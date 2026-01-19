// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:mobile_netpool_station_player/core/router/routes.dart';
import 'package:mobile_netpool_station_player/core/theme/app_colors.dart';
import 'package:mobile_netpool_station_player/features/2_Home_Page/bloc/home_page_bloc.dart';
import 'package:mobile_netpool_station_player/features/2_Home_Page/models/1.station/station_model.dart';
import 'package:mobile_netpool_station_player/features/Common/Landing/pages/landing_navigation_bottom.dart';
import 'package:mobile_netpool_station_player/features/Common/snackbar/snackbar.dart';

class AppFonts {
  static const String semibold = 'Semibold';
}

class HomePage extends StatefulWidget {
  final Function callback;

  const HomePage(this.callback, {super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomePageBloc homeBloc = HomePageBloc();
  bool _isLobbyLoading = true;
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
  void initState() {
    super.initState();
    // 1. Check Auth (Nhanh, không cần Skeleton)
    homeBloc.add(HomeCheckAuthEvent());

    // 2. Load Station (Sẽ dùng Skeleton từ State của Bloc)

    // 3. Giả lập load Lobby (Dùng Skeleton Local)
    _simulateLobbyLoading();
  }

  void _simulateLobbyLoading() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLobbyLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // BlocConsumer bao bọc toàn bộ Scaffold để xử lý Logic và Update UI toàn màn hình
    return BlocConsumer<HomePageBloc, HomePageState>(
      bloc: homeBloc,
      listener: (context, state) {
        if (state.stationListStatus == HomeStatus.failure &&
            state.message.isNotEmpty) {
          ShowSnackBar(context, state.message, false);
        }
      },
      builder: (context, state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          // AppBar cập nhật dựa trên state.isLoggedIn
          appBar: HomeAppBar(isLoggedIn: state.isLoggedIn),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3B1F5A), kScaffoldBackground],
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
                    const SizedBox(height: 15.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      // 1. WelcomeCard: Load nhanh, không cần Skeleton
                      child: WelcomeCard(
                        isLoggedIn: state.isLoggedIn,
                        userName: state.userName,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: QuickActionBar(),
                    ),
                    const SizedBox(height: 30),

                    // --- 2. PHẦN LOBBY (Skeleton Loading) ---
                    _buildSectionHeader("GHÉP ĐỘI NHANH",
                        onTapViewMore: () => widget.callback(3)),
                    const SizedBox(height: 12),

                    SizedBox(
                      height: 200,
                      child: _isLobbyLoading
                          ? ListView.separated(
                              padding: const EdgeInsets.only(left: 16.0),
                              scrollDirection: Axis.horizontal,
                              itemCount: 2, // Hiển thị 2 skeleton đang load
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 16),
                              itemBuilder: (context, index) =>
                                  const LobbySkeletonCard(),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.only(left: 16.0),
                              scrollDirection: Axis.horizontal,
                              itemCount: fakeLobbies.length,
                              clipBehavior: Clip.none,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child:
                                      TeamLobbyCard(lobby: fakeLobbies[index]),
                                );
                              },
                            ),
                    ),

                    const SizedBox(height: 30),

                    // --- 3. PHẦN STATION (Skeleton Loading từ Bloc) ---
                    _buildSectionHeader("STATION GẦN BẠN",
                        onTapViewMore: () => widget.callback(1)),
                    const SizedBox(height: 12),

                    if (state.stationListStatus == HomeStatus.loading)
                      // Skeleton loading cho danh sách Station
                      SizedBox(
                        height: 340,
                        child: ListView.separated(
                          padding: const EdgeInsets.only(left: 16.0),
                          scrollDirection: Axis.horizontal,
                          itemCount: 3, // Hiển thị 3 skeleton
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 16),
                          itemBuilder: (context, index) =>
                              const StationSkeletonCard(),
                        ),
                      )
                    else if (state.stations.isEmpty &&
                        state.stationListStatus == HomeStatus.success)
                      const SizedBox(
                        height: 340,
                        child: Center(
                          child: Text("Chưa có Station nào.",
                              style: TextStyle(color: Colors.white70)),
                        ),
                      )
                    else
                      SizedBox(
                        height: 340,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(left: 16.0),
                          scrollDirection: Axis.horizontal,
                          itemCount: state.stations.length,
                          clipBehavior: Clip.none,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child:
                                  StationCard(station: state.stations[index]),
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

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
}

// =============================================================================
// CÁC WIDGET PHỤ TRỢ & SKELETON
// =============================================================================

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

class TeamLobbyCard extends StatelessWidget {
  final TeamLobby lobby;

  const TeamLobbyCard({super.key, required this.lobby});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade800,
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/logo_no_bg.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 10),
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
          const Divider(color: Colors.white10, height: 16),
          Row(
            children: [
              const Icon(Icons.access_time_filled,
                  color: Colors.orangeAccent, size: 14),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  lobby.startTime,
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
          const SizedBox(height: 6),
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

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isLoggedIn;

  const HomeAppBar({
    super.key,
    this.isLoggedIn = false,
  });

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
      titleSpacing: 16,
      centerTitle: false,
      title: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: GradientWidget(
          child: Image.asset(
            'assets/images/logo_no_bg.png',
            color: Colors.white,
            height: 60,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.gamepad, size: 40, color: Colors.white),
          ),
        ),
      ),
      actions: [
        if (!isLoggedIn)
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 10.0),
            child: Center(
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
                  minimumSize: const Size(0, 36),
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
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

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

class QuickActionBar extends StatefulWidget {
  const QuickActionBar({super.key});

  @override
  State<QuickActionBar> createState() => _QuickActionBarState();
}

class _QuickActionBarState extends State<QuickActionBar> {
  final List<Map<String, dynamic>> actions = [
    {'icon': Icons.account_balance_wallet, 'label': 'Nạp tiền'},
    {'icon': Icons.calendar_month, 'label': 'Đặt lịch'},
    {'icon': Icons.history, 'label': 'Lịch sử'},
  ];

  void _onActionTap(String label) {
    if (label == 'Lịch sử') {
      Get.toNamed(bookingHistoryPageRoute);
    } else if (label == 'Nạp tiền') {
    } else if (label == 'Đặt lịch') {
      Get.offAll(() => const LandingNavBottomWidget(index: 2));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: actions.length,
        itemBuilder: (context, index) {
          final action = actions[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
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
                      size: 26,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    action['label'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
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

class StationCard extends StatelessWidget {
  final StationDetailModel station;
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
    final String imageUrl = station.avatar ?? '';

    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          child: imageUrl.isEmpty
              ? _buildImagePlaceholder()
              : Image.network(
                  imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 180,
                      width: double.infinity,
                      color: Colors.black26,
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: kLinkActive,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return _buildImagePlaceholder();
                  },
                ),
        ),
        Positioned(
          top: 12,
          left: 12,
          child: Row(
            children: (station.space ?? [])
                .map((s) => _buildTag(s.spaceName ?? '', s.metadata?.bgColor))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2C),
        gradient: LinearGradient(
          colors: [Colors.grey[900]!, const Color(0xFF25254B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.image_not_supported_outlined, color: kHintColor, size: 40),
          SizedBox(height: 8),
          Text(
            "Hình ảnh không khả dụng",
            style: TextStyle(
                color: kHintColor, fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(station.stationName ?? 'Không có tên',
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text(station.address ?? '',
              style: const TextStyle(color: kHintColor, fontSize: 13),
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    _infoRow(Icons.phone, station.hotline ?? '09.xxx.xxx',
                        Colors.blue),
                    const SizedBox(height: 4),
                    if (station.distance != null) ...[
                      _infoRow(
                          Icons.location_on,
                          "${station.distance?.toStringAsFixed(1) ?? '0'} km",
                          Colors.redAccent),
                    ]
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    backgroundColor: kLinkActive,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                child: const Text("ĐẶT LỊCH",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12)),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 6),
        Expanded(
            child: Text(text,
                style: const TextStyle(color: kHintColor, fontSize: 12),
                overflow: TextOverflow.ellipsis)),
      ],
    );
  }

  Widget _buildTag(String text, String? colorHex) {
    Color tagColor = kLinkActive;
    if (colorHex != null) {
      try {
        tagColor = Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
      } catch (_) {}
    }

    return Container(
      margin: const EdgeInsets.only(right: 6.0),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: tagColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Text(text,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
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

class WelcomeCard extends StatefulWidget {
  final bool isLoggedIn;
  final String? userName;

  const WelcomeCard({super.key, required this.isLoggedIn, this.userName});

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
    _timer.cancel();
    super.dispose();
  }

  String _getGreeting() {
    final hour = _now.hour;
    if (hour >= 5 && hour < 11) {
      return "Chào buổi sáng";
    } else if (hour >= 11 && hour < 13) {
      return "Chào buổi trưa";
    } else if (hour >= 13 && hour < 18) {
      return "Chào buổi chiều";
    } else {
      return "Chào buổi tối";
    }
  }

  String _getFormattedDate() {
    List<String> weekDays = [
      "Thứ 2",
      "Thứ 3",
      "Thứ 4",
      "Thứ 5",
      "Thứ 6",
      "Thứ 7",
      "Chủ Nhật"
    ];
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
              Row(
                children: [
                  Text(
                    _getGreeting(),
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  // Hiển thị tên kế bên câu chào nếu đã đăng nhập
                  if (widget.isLoggedIn && widget.userName != null)
                    Text(
                      ", ${widget.userName!}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                ],
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

// -----------------------------------------------------------------------------
// SKELETON WIDGETS
// -----------------------------------------------------------------------------

class ShimmerLoading extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;

  const ShimmerLoading({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Tạo controller lặp đi lặp lại
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            // Gradient di chuyển để tạo hiệu ứng lấp lánh
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const [
                Colors.white10,
                Colors.white24, // Màu sáng hơn ở giữa
                Colors.white10,
              ],
              stops: [
                _controller.value - 0.3,
                _controller.value,
                _controller.value + 0.3,
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Skeleton Card cho Station
class StationSkeletonCard extends StatelessWidget {
  const StationSkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: kBoxBackground,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder với Shimmer
          const ShimmerLoading(
            width: double.infinity,
            height: 180,
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title line
                const ShimmerLoading(height: 16, width: 200),
                const SizedBox(height: 8),
                // Address line
                const ShimmerLoading(height: 12, width: 150),
                const SizedBox(height: 16),
                // Info & Button
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          ShimmerLoading(height: 10, width: 80),
                          SizedBox(height: 6),
                          ShimmerLoading(height: 10, width: 60),
                        ],
                      ),
                    ),
                    const ShimmerLoading(
                      height: 30,
                      width: 80,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton Card cho Lobby
class LobbySkeletonCard extends StatelessWidget {
  const LobbySkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kBoxBackground,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const ShimmerLoading(
                width: 48,
                height: 48,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    ShimmerLoading(height: 10, width: 80),
                    SizedBox(height: 6),
                    ShimmerLoading(height: 14, width: 120),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          const ShimmerLoading(
            width: double.infinity,
            height: 36,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ],
      ),
    );
  }
}
