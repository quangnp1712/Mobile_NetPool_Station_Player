import 'package:flutter/material.dart';

class ProfileBody extends StatefulWidget {
  const ProfileBody({super.key});

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  // Text controllers giữ dữ liệu hiện tại
  final TextEditingController nameController =
      TextEditingController(text: 'Anh Tuấn');
  final TextEditingController cccdController =
      TextEditingController(text: '123456789');
  final TextEditingController phoneController =
      TextEditingController(text: '0912345678');
  final TextEditingController emailController =
      TextEditingController(text: 'antu@example.com');

  @override
  void dispose() {
    nameController.dispose();
    cccdController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Widget _buildReadOnlyField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      readOnly: true, // 🔹 chỉ xem, không bật bàn phím
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white24),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            ),
            const SizedBox(height: 16),
            _buildReadOnlyField('Họ tên', nameController),
            const SizedBox(height: 12),
            _buildReadOnlyField('Căn cước công dân', cccdController),
            const SizedBox(height: 12),
            _buildReadOnlyField('Số điện thoại', phoneController),
            const SizedBox(height: 12),
            _buildReadOnlyField('Email', emailController),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: điều hướng sang page EditProfilePage sau
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Cập nhật thông tin',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
