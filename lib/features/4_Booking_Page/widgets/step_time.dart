import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StepTime extends StatefulWidget {
  final List<String> timeSlots;
  final Function(String start, String end) onRangeSelected;

  const StepTime({
    super.key,
    required this.timeSlots,
    required this.onRangeSelected,
  });

  @override
  State<StepTime> createState() => _StepTimeState();
}

class _StepTimeState extends State<StepTime> {
  String? startTime;
  String? endTime;

  void _onTap(String slot) {
    final nowHour = DateTime.now().hour;
    final slotHour = int.parse(slot.split(":")[0]);

    if (slotHour < nowHour) return; // Không cho chọn giờ đã qua

    setState(() {
      if (startTime == null || (startTime != null && endTime != null)) {
        // Chọn start mới
        startTime = slot;
        endTime = null;
      } else if (startTime != null && endTime == null) {
        final startIndex = widget.timeSlots.indexOf(startTime!);
        final endIndex = widget.timeSlots.indexOf(slot);
        if (endIndex >= startIndex) {
          endTime = slot;
          widget.onRangeSelected(startTime!, endTime!);
        } else {
          // nếu chọn trước start thì đổi start
          startTime = slot;
        }
      }
    });
  }

  bool _isInRange(String slot) {
    if (startTime == null || endTime == null) return false;
    final startIndex = widget.timeSlots.indexOf(startTime!);
    final endIndex = widget.timeSlots.indexOf(endTime!);
    final slotIndex = widget.timeSlots.indexOf(slot);
    return slotIndex >= startIndex && slotIndex <= endIndex;
  }

  bool _isDisabled(String slot) {
    final nowHour = DateTime.now().hour;
    final slotHour = int.tryParse(slot.split(":")[0]) ?? 0;
    return slotHour < nowHour;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Chọn thời gian', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.timeSlots.map((slot) {
              final active = _isInRange(slot);
              final isStart = startTime == slot;
              final isEnd = endTime == slot;
              final disabled = _isDisabled(slot);

              return GestureDetector(
                onTap: disabled ? null : () => _onTap(slot),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: active ? Colors.deepPurple : Colors.transparent,
                    border: Border.all(
                      color: isStart || isEnd ? Colors.deepPurple : Colors.grey,
                      width: isStart || isEnd ? 2 : 1,
                    ),
                  ),
                  child: Text(
                    slot,
                    style: TextStyle(
                      color: disabled
                          ? Colors.white24
                          : (active ? Colors.white : Colors.white70),
                      fontWeight: isStart || isEnd ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          if (startTime != null)
            Text('Giờ vào: $startTime', style: const TextStyle(color: Colors.white)),
          if (endTime != null)
            Text('Giờ ra: $endTime', style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
