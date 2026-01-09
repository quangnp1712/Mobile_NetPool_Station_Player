import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:mobile_netpool_station_player/core/router/routes.dart';
import 'package:mobile_netpool_station_player/features/6_Menu_Page/6.1_Menu/bloc/menu_page_bloc.dart';
import 'package:mobile_netpool_station_player/features/6_Menu_Page/6.1_Menu/shared_preferences/menu_shared_pref.dart';

class MenuPage extends StatefulWidget {
  final Function? callback;

  const MenuPage(this.callback, {super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  MenuPageBloc bloc = MenuPageBloc();
  // ignore: unused_field
  int _selectedIndex = 4; // tab Tài khoản đang chọn

  @override
  void initState() {
    super.initState();
    bloc.add(MenuStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MenuPageBloc, MenuPageState>(
      bloc: bloc,
      listener: (context, state) {
        // Xử lý chuyển hướng khi chưa đăng nhập hoặc hết hạn token
        if (state.status == MenuStatus.unauthenticated) {
          MenuSharedPref.setIsMenuRoute(true);
          Get.toNamed(loginPageRoute);
        }

        if (state.status == MenuStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message ?? "Có lỗi xảy ra")),
          );
        }
      },
      builder: (context, state) {
        // Hiển thị loading khi đang check token hoặc load data
        if (state.status == MenuStatus.loading ||
            state.status == MenuStatus.initial) {
          return const Scaffold(
            backgroundColor: Color(0xFF121212),
            body: Center(
                child: CircularProgressIndicator(color: Colors.purpleAccent)),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFF121212),
          appBar: const MenuAppBar(),
          body: RefreshIndicator(
            onRefresh: () async {
              bloc.add(MenuStarted());
            },
            color: Colors.purpleAccent,
            backgroundColor: const Color(0xFF1E1E1E),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  MenuAvatarSection(
                    username: state.accountInfo?.username ?? "",
                    avatarUrl: state.accountInfo?.avatar ?? "",
                    email: state.accountInfo?.email ?? "",
                    phoneNumber: state.accountInfo?.phone ?? "",
                  ),
                  const SizedBox(height: 24),
                  // 🟣 NHÓM 1: CÁ NHÂN & XÃ HỘI
                  _buildSectionHeader('Hoạt động'),
                  MenuOptionCard(
                    icon: Icons.people_alt_outlined,
                    title: 'Bạn bè & Nhóm',
                    badgeCount: 3,
                    onTap: () {
                      // TODO: Mở danh sách bạn bè
                    },
                  ),
                  MenuOptionCard(
                    icon: Icons.emoji_events_outlined,
                    title: 'Thành tích & Huy hiệu',
                    onTap: () {
                      // TODO: Xem thành tích
                    },
                  ),
                  MenuOptionCard(
                    icon: Icons.bookmark_border,
                    title: 'Kịch bản đã lưu',
                    onTap: () {
                      // TODO: Xem mục đã lưu
                    },
                  ),

                  const SizedBox(height: 16),

                  // 🟣 NHÓM 2: TÀI KHOẢN & VÍ
                  _buildSectionHeader('Tài khoản'),
                  MenuOptionCard(
                    icon: Icons.person_outline,
                    title: 'Hồ sơ cá nhân',
                    onTap: () {
                      Get.toNamed(profilePageRoute);
                    },
                  ),
                  MenuOptionCard(
                    icon: Icons.account_balance_wallet_outlined,
                    title: 'Ví NetPool',
                    subtitle: 'Số dư: 50.000 đ',
                    onTap: () {
                      Get.toNamed(walletPageRoute);
                    },
                  ),

                  const SizedBox(height: 16),

                  // 🟣 NHÓM 3: HỆ THỐNG
                  _buildSectionHeader('Ứng dụng'),
                  MenuOptionCard(
                    icon: Icons.settings_outlined,
                    title: 'Cài đặt chung',
                    onTap: () {
                      // TODO: điều hướng UI
                    },
                  ),
                  MenuOptionCard(
                    icon: Icons.help_outline,
                    title: 'Hỗ trợ & FAQ',
                    onTap: () {
                      // TODO: điều hướng UI
                    },
                  ),

                  // Nút đăng xuất

                  MenuLogoutButton(
                    onTap: () {
                      bloc.add(MenuLogoutRequested());
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 24.0, top: 8.0),
                    child: Text(
                      'Phiên bản 1.0.2',
                      style: TextStyle(color: Colors.white24, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8, top: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}

class MenuAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MenuAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
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
      title: const Text(
        'Trung Tâm Cá Nhân',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.videogame_asset_rounded,
              color: Colors.purpleAccent,
              size: 26,
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_active_rounded,
              color: Colors.white, size: 26),
          onPressed: () {
            // 🔔 TODO: xử lý mở trang thông báo
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

class MenuAvatarSection extends StatelessWidget {
  final String username;
  final String avatarUrl;
  final String email;
  final String phoneNumber;

  const MenuAvatarSection({
    super.key,
    required this.username,
    required this.avatarUrl,
    this.email = '',
    this.phoneNumber = '',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),

        // Avatar đơn giản hóa, thêm viền cho đẹp
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
                color: Colors.purpleAccent.withOpacity(0.5), width: 2),
          ),
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.purpleAccent.withOpacity(0.1),
            backgroundImage:
                avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
            child: avatarUrl.isEmpty
                ? const Icon(Icons.person_rounded,
                    color: Colors.white, size: 50)
                : null,
          ),
        ),

        const SizedBox(height: 12),

        // Tên người dùng
        Text(
          username,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),

        const SizedBox(height: 8),

        // Hiển thị Email
        if (email.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.email_outlined, size: 14, color: Colors.grey[400]),
              const SizedBox(width: 6),
              Text(
                email,
                style: TextStyle(color: Colors.grey[400], fontSize: 14),
              ),
            ],
          ),

        // Hiển thị SĐT
        if (phoneNumber.isNotEmpty) ...[
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.phone_outlined, size: 14, color: Colors.grey[400]),
              const SizedBox(width: 6),
              Text(
                phoneNumber,
                style: TextStyle(color: Colors.grey[400], fontSize: 14),
              ),
            ],
          ),
        ],

        const SizedBox(height: 20),
        const Divider(
            color: Colors.white10, thickness: 1, indent: 40, endIndent: 40),
      ],
    );
  }
}

class MenuOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final int badgeCount;
  final VoidCallback onTap;

  const MenuOptionCard({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.badgeCount = 0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.purpleAccent[100], size: 22),
        ),
        title: Text(title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500)),
        subtitle: subtitle != null
            ? Text(subtitle!,
                style: TextStyle(color: Colors.grey[400], fontSize: 12))
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (badgeCount > 0)
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  badgeCount > 9 ? '9+' : '$badgeCount',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                ),
              ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

class MenuLogoutButton extends StatelessWidget {
  final VoidCallback onTap;

  const MenuLogoutButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.red.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.logout_rounded, color: Colors.red),
              SizedBox(width: 8),
              Text(
                'Đăng xuất',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
