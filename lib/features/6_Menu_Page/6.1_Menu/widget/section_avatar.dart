// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class MenuAvatarSection extends StatefulWidget {
  final String username;
  final String avatarUrl;

  const MenuAvatarSection({
    super.key,
    required this.username,
    required this.avatarUrl,
  });

  @override
  State<MenuAvatarSection> createState() => _MenuAvatarSectionState();
}

class _MenuAvatarSectionState extends State<MenuAvatarSection> {
  late String currentAvatar;
  late String currentName;

  @override
  void initState() {
    super.initState();
    currentAvatar = widget.avatarUrl;
    currentName = widget.username;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.purpleAccent.withOpacity(0.3),
          backgroundImage:
              currentAvatar.isNotEmpty ? NetworkImage(currentAvatar) : null,
          child: currentAvatar.isEmpty
              ? const Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 50,
                )
              : null,
        ),
        const SizedBox(height: 12),
        Text(
          currentName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        const Divider(
          color: Colors.white24,
          thickness: 1,
          indent: 40,
          endIndent: 40,
        ),
      ],
    );
  }
}
