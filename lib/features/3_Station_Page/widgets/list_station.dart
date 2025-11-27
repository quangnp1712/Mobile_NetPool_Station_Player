import 'package:flutter/material.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/pages/booking_page.dart';

// Các màu dùng trong tag
const Color kLinkActive = Colors.purpleAccent;
const Color kGradientStart = Colors.blueAccent;

class ListStation extends StatefulWidget {
  const ListStation({super.key});

  @override
  State<ListStation> createState() => _ListStationState();
}

class _ListStationState extends State<ListStation> {
  // Sau này bạn sẽ thay bằng API call
  final List<Map<String, dynamic>> stations = [
    {
      "name": "Way Station - 483 Thống Nhất",
      "address": "483 Thống Nhất, P.16, Q.Gò Vấp, TP.HCM",
      "image": "assets/images/STATION.png",
      "open": "08:00",
      "close": "23:00",
      "phone": "0901234567",
      "tags": ["Net", "VIP"]
    },
    {
      "name": "Gaming Center Q7",
      "address": "123 Nguyễn Thị Minh Khai, Q.3, TP.HCM",
      "image": "assets/images/STATION.png",
      "open": "09:00",
      "close": "22:00",
      "phone": "0907654321",
      "tags": ["Bida", "PlayStation"]
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: stations.length,
        itemBuilder: (context, index) {
          final s = stations[index];

          return _buildStationCard(
            imageUrl: s["image"],
            name: s["name"],
            address: s["address"],
            openTime: s["open"],
            closeTime: s["close"],
            phone: s["phone"],
            tags: List<String>.from(s["tags"]),
          );
        },
      ),
    );
  }

  // ==========================
  // STATION CARD UI
  // ==========================
  Widget _buildStationCard({
    required String imageUrl,
    required String name,
    required String address,
    required String openTime,
    required String closeTime,
    required String phone,
    required List<String> tags,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageHeader(imageUrl, tags),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Tên station
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                // Địa chỉ
                Text(
                  address,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 8),

                // Giờ mở cửa
                Row(
                  children: [
                    const Icon(Icons.access_time,
                        size: 18, color: Colors.white54),
                    const SizedBox(width: 6),
                    Text(
                      "$openTime - $closeTime",
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // Số điện thoại
                Row(
                  children: [
                    const Icon(Icons.phone,
                        size: 18, color: Colors.white54),
                    const SizedBox(width: 6),
                    Text(
                      phone,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Nút đặt lịch
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookingPage(() {
            // callback để trống, sau này dùng gì thì thêm
          }),
        ),
        );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple, // màu nền
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Đặt lịch ngay",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black, // màu chữ
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================
  // IMAGE HEADER + TAGS + TIM
  // ==========================
  Widget _buildImageHeader(String imageUrl, List<String> tags) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
          child: Image.asset(
            imageUrl,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),

        // Icon tim
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
              color: Colors.pinkAccent,
              size: 20,
            ),
          ),
        ),

        // Tags bên trái
        Positioned(
          top: 12,
          left: 12,
          child: Row(
            children: tags.map((t) => _buildTag(t)).toList(),
          ),
        ),
      ],
    );
  }

  // ==========================
  // TAG PILL UI
  // ==========================
  Widget _buildTag(String text) {
    Color tagColor = kLinkActive;

    if (text.toUpperCase() == 'PLAYSTATION') {
      tagColor = kGradientStart;
    } else if (text.toUpperCase() == 'BIDA') {
      tagColor = Colors.greenAccent;
    } else if (text.toUpperCase() == 'NET') {
      tagColor = Colors.purpleAccent;
    } else if (text.toUpperCase() == 'VIP') {
      tagColor = Colors.orangeAccent;
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
}
