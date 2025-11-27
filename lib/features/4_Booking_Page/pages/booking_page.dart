import 'package:flutter/material.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/widgets/booking_bill_preview.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/widgets/booking_progress_bar.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/widgets/step_category.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/widgets/step_seat.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/widgets/step_service.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/widgets/step_time.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/widgets/step_zone.dart';


class BookingPage extends StatefulWidget {
  final Function callback;

  const BookingPage(this.callback, {super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  int currentStep = 0;

  String? selectedCategory;
  String? selectedZone;
  String? selectedSeat;
  String? startTime;
  String? endTime;
  List<String> selectedServices = [];

  final List<String> categories = ['Net', 'Bida', 'PlayStation 5'];
  final Map<String, int> zones = {'Thường': 25000, 'VIP': 50000};
  final List<String> seats = List.generate(12, (i) => 'Ghế ${i + 1}');
  final List<String> timeSlots = List.generate(15, (i) => '${8 + i}:00');
  final List<String> services = ['Coca', 'Redbull', 'Mì ly', 'Snack'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),

      appBar: AppBar(
        title: const Text('Đặt lịch'),
        backgroundColor: const Color(0xFF2B2B2B),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Column(
        children: [
          BookingProgressBar(
            currentStep: currentStep,
            totalStep: 6,
          ),

          Expanded(child: _buildStep()),

          _buildBottomButton(),
        ],
      ),
    );
  }

  // =========================
  // BUILD STEP
  // =========================
  Widget _buildStep() {
    switch (currentStep) {
      case 0:
        return StepCategory(
          categories: categories,
          selected: selectedCategory,
          onSelected: (v) => setState(() => selectedCategory = v),
        );

      case 1:
        return StepZone(
          zones: zones,
          selected: selectedZone,
          onSelected: (v) => setState(() => selectedZone = v),
        );

      case 2:
        return StepSeat(
          seats: seats,
          selected: selectedSeat,
          onSelected: (v) => setState(() => selectedSeat = v),
        );

      case 3:
  return StepTime(
    timeSlots: timeSlots,
    onRangeSelected: (start, end) {
      setState(() {
        startTime = start;
        endTime = end;
      });
    },
  );


      case 4:
        return StepService(
          services: services,
          selected: selectedServices,
          onChanged: (list) => setState(() => selectedServices = list),
        );

      case 5:
        return BookingBillPreview(
          category: selectedCategory ?? '',
          zone: selectedZone ?? '',
          seat: selectedSeat ?? '',
          startTime: startTime ?? '',
          endTime: endTime ?? '',
          services: selectedServices,
          pricePerHour: zones[selectedZone] ?? 25000,
        );

      default:
        return const SizedBox();
    }
  }

  // =========================
  // VALIDATE NEXT
  // =========================
  bool _canNext() {
    switch (currentStep) {
      case 0:
        return selectedCategory != null;
      case 1:
        return selectedZone != null;
      case 2:
        return selectedSeat != null;
      case 3:
        return startTime != null && endTime != null;
      case 4:
        return true; // service không bắt buộc
      case 5:
        return true;
      default:
        return false;
    }
  }

  // =========================
  // BOTTOM BUTTON
  // =========================
  Widget _buildBottomButton() {
    final active = _canNext();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        height: 48,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: active
              ? () {
                  if (currentStep < 5) {
                    setState(() => currentStep++);
                  } else {
                    widget.callback(); // ✅ callback chạy khi hoàn tất
                    Navigator.pop(context);
                  }
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                active ? Colors.deepPurple : Colors.grey.shade700,
          ),
          child: Text(
            currentStep == 5 ? 'Xác nhận đặt' : 'Tiếp tục',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

