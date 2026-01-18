// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mobile_netpool_station_player/core/theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final bool obscureText;

  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.controller,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.autovalidateMode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          obscureText: obscureText,
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'SegoeUI SemiBold', // Từ code mẫu
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: kHintColor, fontSize: 16),
            prefixIcon: Icon(icon, color: Colors.white, size: 22),
            prefixIconConstraints: const BoxConstraints(minWidth: 40),
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: kUnderlineColor, width: 1.5),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: kGradientEnd, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
