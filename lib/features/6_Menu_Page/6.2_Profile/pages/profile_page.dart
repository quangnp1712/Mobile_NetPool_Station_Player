import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_netpool_station_player/features/6_Menu_Page/6.2_Profile/bloc/profile_page_bloc.dart';
import 'package:mobile_netpool_station_player/features/6_Menu_Page/6.2_Profile/models/account_info_model.dart';
import 'package:mobile_netpool_station_player/features/Common/Landing/pages/landing_navigation_bottom.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfilePage> {
  ProfilePageBloc bloc = ProfilePageBloc();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _idController;
  late TextEditingController _captchaController;

  @override
  void initState() {
    super.initState();
    bloc.add(ProfileStarted());
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _idController = TextEditingController();
    _captchaController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _idController.dispose();
    _captchaController.dispose();
    super.dispose();
  }

  void _populateControllers(AccountInfoModel info) {
    if (_nameController.text.isEmpty)
      _nameController.text = info.username ?? '';
    if (_emailController.text.isEmpty) _emailController.text = info.email ?? '';
    if (_phoneController.text.isEmpty) _phoneController.text = info.phone ?? '';
    if (_idController.text.isEmpty)
      _idController.text = info.identification ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfilePageBloc, ProfilePageState>(
      bloc: bloc,
      listener: (context, state) {
        if (state.status == ProfileStatus.success &&
            state.accountInfo != null) {
          _populateControllers(state.accountInfo!);
        }
        if (state.status == ProfileStatus.updateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message ?? "Thành công")),
          );
        }
        if (state.status == ProfileStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text(state.message ?? "Có lỗi xảy ra: ${state.message}"),
                backgroundColor: Colors.red),
          );
        }
        if (state.isClearCaptchaController) {
          _captchaController.clear();
          if (!state.isCaptchaVerified && state.isEditing) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text("Mã Captcha không đúng"),
                  backgroundColor: Colors.orange),
            );
          }
        }
      },
      builder: (context, state) {
        final bool isLoading = state.status == ProfileStatus.loading ||
            state.status == ProfileStatus.updating;

        final info = state.accountInfo ?? AccountInfoModel();
        final bool isEnable = info.statusCode == 'ENABLE';
        final bool isEditing = state.isEditing;

        return Scaffold(
          backgroundColor: const Color(0xFF121212),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Get.to(LandingNavBottomWidget(index: 4)),
            ),
            title: const Text(
              'Hồ sơ cá nhân',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(isEditing ? Icons.check : Icons.edit,
                    color: Colors.purpleAccent),
                onPressed: () {
                  if (isEditing) {
                    // Logic Lưu
                    if (!state.isCaptchaVerified) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                "Vui lòng xác thực CAPTCHA trước khi lưu")),
                      );
                      return;
                    }

                    final updatedInfo = info.copyWith(
                      username: _nameController.text,
                      phone: _phoneController.text,
                      password: "nguyencchay",
                      // avatar đã được update trong state khi pick
                    );
                    bloc.add(ProfileUpdated(updatedInfo));
                  } else {
                    // Bật chế độ sửa
                    bloc.add(const ProfileEditToggled(true));
                  }
                },
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF2B0C4E), Color(0xFF121212)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          body: Stack(
            children: [
              // Lớp 1: Nội dung chính
              SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // Avatar
                    _buildAvatarUploader(context, state),

                    const SizedBox(height: 16),

                    // Badge Trạng thái
                    if (info.statusName != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isEnable
                              ? Colors.green.withOpacity(0.2)
                              : Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: isEnable ? Colors.green : Colors.red),
                        ),
                        child: Text(
                          info.statusName!,
                          style: TextStyle(
                            color: isEnable
                                ? Colors.greenAccent
                                : Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),

                    const SizedBox(height: 32),

                    // Các trường nhập liệu
                    _buildTextField(
                      label: "Tên tài khoản (Username)",
                      icon: Icons.person_outline,
                      controller: _nameController,
                      enabled: isEditing,
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      label: "Số điện thoại (Phone)",
                      icon: Icons.phone_outlined,
                      controller: _phoneController,
                      enabled: isEditing,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      label: "Email",
                      icon: Icons.email_outlined,
                      controller: _emailController,
                      enabled: false,
                      hint: "Email",
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      label: "CMND/CCCD (Identification)",
                      icon: Icons.badge_outlined,
                      controller: _idController,
                      enabled: false,
                    ),

                    const SizedBox(height: 20),

                    // CAPTCHA Section
                    if (isEditing) ...[
                      const Divider(color: Colors.white24),
                      const SizedBox(height: 10),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Xác thực bảo mật",
                            style: TextStyle(color: Colors.grey, fontSize: 14)),
                      ),
                      const SizedBox(height: 10),
                      _buildCaptchaSection(context, state),
                      const SizedBox(height: 10),
                    ],

                    if (isEditing)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          "* Các thông tin định danh (Email, CCCD) không thể tự chỉnh sửa.",
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                              fontStyle: FontStyle.italic),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    const SizedBox(height: 20),

                    if (isEditing)
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: state.isCaptchaVerified
                              ? () {
                                  final updatedInfo = info.copyWith(
                                    username: _nameController.text,
                                    phone: _phoneController.text,
                                    password: "defaultPassword",
                                  );
                                  bloc.add(ProfileUpdated(updatedInfo));
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purpleAccent,
                            disabledBackgroundColor: Colors.grey[800],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Lưu Thay Đổi",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      )
                  ],
                ),
              ),

              // Lớp 2: Loading Overlay
              if (isLoading)
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black.withOpacity(0.5), // Nền mờ phía trước
                  child: const Center(
                    child:
                        CircularProgressIndicator(color: Colors.purpleAccent),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // --- Widget Avatar Uploader ---
  Widget _buildAvatarUploader(BuildContext context, ProfilePageState state) {
    ImageProvider? bg;
    final String? avatarUrl = state.accountInfo?.avatar;

    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      if (avatarUrl.startsWith('http')) {
        bg = NetworkImage(avatarUrl);
      } else if (avatarUrl.startsWith('data:image')) {
        try {
          bg = MemoryImage(base64Decode(avatarUrl.split(',').last));
        } catch (_) {}
      }
    }

    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Colors.purpleAccent.withOpacity(0.5), width: 2),
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.purpleAccent.withOpacity(0.1),
                  backgroundImage: bg,
                  child: bg == null
                      ? const Icon(Icons.person, size: 60, color: Colors.white)
                      : null,
                ),
              ),
              if (state.isEditing)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () => bloc.add(ProfilePickAvatar()),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.purpleAccent,
                        shape: BoxShape.circle,
                      ),
                      child: state.isPickingImage
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : const Icon(Icons.camera_alt,
                              color: Colors.white, size: 20),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Widget Captcha ---
  Widget _buildCaptchaSection(BuildContext context, ProfilePageState state) {
    // Màu cho text captcha
    Color _getRandomCaptchaColor() {
      return Colors.primaries[Random().nextInt(Colors.primaries.length)];
    }

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // Khung hiển thị mã Captcha
        Container(
          width: 150,
          height: 50,
          decoration: BoxDecoration(
              color: Colors.grey[300], borderRadius: BorderRadius.circular(8)),
          child: Stack(children: [
            Center(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: state.captchaText
                        .split('')
                        .map((char) => Transform.rotate(
                            angle: (Random().nextDouble() * 0.4) - 0.2,
                            child: Text(char,
                                style: GoogleFonts.permanentMarker(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: _getRandomCaptchaColor(),
                                    decoration: TextDecoration.lineThrough))))
                        .toList())),
            Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                    icon: const Icon(Icons.refresh,
                        color: Colors.blueGrey, size: 20),
                    onPressed: () => bloc.add(ProfileGenerateCaptcha())))
          ]),
        ),

        // Ô nhập mã Captcha
        SizedBox(
          width: 180,
          child: TextFormField(
              controller: _captchaController,
              readOnly: state.isCaptchaVerified,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Nhập mã",
                hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none),
                suffixIcon: IconButton(
                    icon: state.isVerifyingCaptcha
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.purpleAccent))
                        : Icon(
                            state.isCaptchaVerified
                                ? Icons.check_circle
                                : Icons.arrow_forward,
                            color: state.isCaptchaVerified
                                ? Colors.green
                                : Colors.grey),
                    onPressed: state.isCaptchaVerified
                        ? null
                        : () => bloc.add(
                            ProfileVerifyCaptcha(_captchaController.text))),
              )),
        )
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool enabled = true,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          enabled: enabled,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: TextStyle(
              color: enabled ? Colors.white : Colors.grey[400], fontSize: 16),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[700]),
            prefixIcon:
                Icon(icon, color: enabled ? Colors.purpleAccent : Colors.grey),
            filled: true,
            fillColor: const Color(0xFF1E1E1E),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Colors.purpleAccent, width: 1),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: Colors.grey.withOpacity(0.1), width: 1),
            ),
          ),
        ),
      ],
    );
  }
}
