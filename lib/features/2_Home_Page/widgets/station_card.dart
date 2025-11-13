import 'package:flutter/material.dart';
import 'package:mobile_netpool_station_player/core/theme/app_colors.dart';
import 'package:mobile_netpool_station_player/features/2_Home_Page/models/station_model.dart';

class StationCard extends StatelessWidget {
  final Station station; // Nhận model
  const StationCard({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300, // Chiều rộng cố định cho list cuộn ngang
      decoration: BoxDecoration(
        color: kBoxBackground,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: kGradientEnd, // Viền tím phát sáng
            blurRadius: 2.0,
            spreadRadius: 2.0,
            offset: const Offset(0, 0),
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

  // Phần header (ảnh, tags, tim)
  Widget _buildImageHeader() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12.0),
            topRight: Radius.circular(12.0),
          ),
          child: Image.asset(
            station.imageUrl, // <-- Dùng ảnh từ model
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 180,
                child: const Center(
                  child: Icon(Icons.image_not_supported, color: kHintColor),
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

  // --- PHẦN SỬA: DÙNG ROW CHO (INFO + BUTTON) ---
  Widget _buildInfoSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Căn trái cho text
        children: [
          // 1. Tên (bình thường)
          Text(
            station.name,
            style: Theme.of(context).textTheme.titleMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          // 2. Địa chỉ (bình thường)
          Text(
            station.address,
            style: TextStyle(color: kHintColor, fontSize: 13),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),

          // 3. Hàng chứa (Giờ + SĐT) và (Nút)
          Row(
            crossAxisAlignment: CrossAxisAlignment.end, // Căn nút xuống dưới
            children: [
              // Cột trái (Giờ + SĐT)
              Expanded(
                // Cho phép cột này chiếm hết không gian
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
              // Khoảng cách giữa
              const SizedBox(width: 8),
              // Cột phải (Nút)
              ElevatedButton(
                onPressed: () {
                  // TODO: Xử lý sự kiện đặt lịch
                },
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
                    color: Colors.black,
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
  // --- KẾT THÚC PHẦN SỬA ---

  // Widget _buildTag (giữ nguyên)
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

  // Widget _buildInfoRow (giữ nguyên, có Expanded là đúng)
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
            style: TextStyle(color: kHintColor, fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
