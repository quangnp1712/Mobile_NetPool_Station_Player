// ignore_for_file: non_constant_identifier_names, use_super_parameters, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Vẫn cần Get để lấy context

void ShowSnackBar(String message, bool success) {
  OverlayEntry? overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) {
      return Positioned(
        top: 20,
        right: 20,
        child: _ToastWidget(
          message: message,
          success: success,
          onClose: () {
            overlayEntry?.remove();
          },
        ),
      );
    },
  );

  Overlay.of(Get.overlayContext!).insert(overlayEntry);
}

class _ToastWidget extends StatefulWidget {
  final String message;
  final bool success;
  final VoidCallback onClose;

  const _ToastWidget({
    Key? key,
    required this.message,
    required this.success,
    required this.onClose,
  }) : super(key: key);

  @override
  _ToastWidgetState createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  late Color backgroundColor;
  late Color progressBarColor;
  late IconData iconData;

  @override
  void initState() {
    super.initState();

    // 1. Cài đặt màu sắc
    if (widget.success) {
      backgroundColor = const Color(0xFFE6F7ED);
      progressBarColor = const Color(0xFF28A745);
      iconData = Icons.check_circle;
    } else {
      backgroundColor = const Color(0xFFFDEBEC);
      progressBarColor = const Color(0xFFDC3545);
      iconData = Icons.error;
    }

    // 2. Cài đặt AnimationController cho progress bar
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5), // 10 giây
    );

    _progressController.reverse(from: 1.0);

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        widget.onClose();
      }
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 400,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(iconData, color: progressBarColor, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.message,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    icon: Icon(Icons.close, color: Colors.grey[600], size: 20),
                    onPressed: widget.onClose,
                  ),
                ],
              ),
            ),
            AnimatedBuilder(
              animation: _progressController,
              builder: (context, child) {
                return LinearProgressIndicator(
                  value: _progressController.value,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progressBarColor,
                  ),
                  minHeight: 5,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
