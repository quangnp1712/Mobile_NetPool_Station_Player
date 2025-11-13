import 'package:flutter/material.dart';
import 'package:mobile_netpool_station_player/core/theme/app_colors.dart';
import 'package:mobile_netpool_station_player/core/theme/app_text_styles.dart';
import 'package:mobile_netpool_station_player/features/2_Home_Page/models/station_model.dart';
import 'package:mobile_netpool_station_player/features/2_Home_Page/widgets/appbar.dart';
import 'package:mobile_netpool_station_player/features/2_Home_Page/widgets/quick_action_bar.dart';
import 'package:mobile_netpool_station_player/features/2_Home_Page/widgets/search.dart';
import 'package:mobile_netpool_station_player/features/2_Home_Page/widgets/station_card.dart';
import 'package:mobile_netpool_station_player/features/2_Home_Page/widgets/welcome_card.dart';

class HomePage extends StatefulWidget {
  final Function callback;

  const HomePage(this.callback, {super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // --- DỮ LIỆU GIẢ (Giữ nguyên) ---
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
  // --- KẾT THÚC DỮ LIỆU GIẢ ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. SỬA: Cho phép body tràn ra sau AppBar
      extendBodyBehindAppBar: true,

      // 2. HomeAppBar
      appBar: const HomeAppBar(),

      // 4. BODY (Giữ nguyên nền gradient)
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF3B1F5A), // Màu tím
              kScaffoldBackground, // Màu đen
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
                // 5. SỬA: Thêm đệm cho AppBar cao
                //    (Đẩy nội dung xuống, tránh bị AppBar che)
                const SizedBox(height: 15.0),

                // 1. WELCOME CARD (Dính sát mép)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: WelcomeCard(),
                ),
                const SizedBox(height: 20),

                // 2. QUICK ACTION CARD ()
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: QuickActionBar(),
                ),
                const SizedBox(height: 20),

                // 2. THANH TÌM KIẾM (Có padding)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: HomeSearchBar(),
                ),
                const SizedBox(height: 30),

                // 3. TIÊU ĐỀ (Có padding)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text("STATION GẦN BẠN",
                      style: TextStyle(
                          letterSpacing: 1.1,
                          color: kHintColor,
                          fontSize: 16,
                          fontFamily: AppFonts.semibold)),
                ),

                // 4. DANH SÁCH CUỘN NGANG (Có padding)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: SizedBox(
                    height: 340,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(
                          left: 16.0), // Padding trái cho thẻ đầu tiên
                      scrollDirection: Axis.horizontal,
                      itemCount: fakeStations.length,
                      clipBehavior: Clip.none, // Hiển thị viền sáng
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              right: 16.0), // Padding phải cho các thẻ
                          child: StationCard(station: fakeStations[index]),
                        );
                      },
                    ),
                  ),
                ),
                // Đệm dưới cùng
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
