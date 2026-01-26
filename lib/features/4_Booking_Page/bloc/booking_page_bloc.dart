// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:mobile_netpool_station_player/core/services/authentication_service.dart';
import 'package:mobile_netpool_station_player/core/services/location_service.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/models/1.station/station_model.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/models/1.station/station_response_model.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/models/2.schedule/schedule_list_response_model.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/models/2.schedule/schedule_model.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/models/2.schedule/schedule_response_model.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/models/2.schedule/timeslot_model.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/models/3.space/space_model.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/models/3.space/space_response_model.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/models/3.space/station_space_model.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/models/3.space/station_space_response_model.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/models/4.area/area_list_model.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/models/4.area/area_list_response_model.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/models/5.resource/resoucre_list_response_model.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/models/5.resource/resoucre_model.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/models/5.resource/resoucre_response_model.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/models/6.booking/booking_model.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/models/8.wallet/wallet_response_model.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/repository/booking_repository.dart';
import 'package:mobile_netpool_station_player/features/Common/data/city_controller/city_model.dart';
import 'package:mobile_netpool_station_player/features/Common/data/city_controller/city_repository.dart';

part 'booking_page_event.dart';
part 'booking_page_state.dart';

class BookingPageBloc extends Bloc<BookingPageEvent, BookingPageState> {
  BookingPageBloc() : super(const BookingPageState()) {
    on<BookingInitEvent>(_onStarted);
    on<LoadBookingDataEvent>(_onLoadBookingData);
    on<FetchStationsEvent>(_onFetchStations);

    on<LoadProvincesEvent>(_onLoadProvinces);
    on<SelectProvinceEvent>(_onSelectProvince);
    on<SelectDistrictEvent>(_onSelectDistrict);
    on<ResetFilterEvent>(_onResetFilter);
    on<SearchStationEvent>(_onSearchStation);
    on<FindNearestStationEvent>(_onFindNearestStation);
    on<ChangePageEvent>(_onChangePage);
    on<ToggleStationSelectionModeEvent>((event, emit) =>
        emit(state.copyWith(isSelectingStation: !state.isSelectingStation)));

    on<SelectStationEvent>(_onSelectStation);
    on<SelectDateEvent>(_onSelectDate); // chọn ngày
    on<SelectSpaceEvent>(_onSelectSpace); // chọn loại hình
    on<SelectAreaEvent>(_onSelectArea); // chọn khu vực

    on<SelectTimeEvent>(
        (event, emit) => emit(state.copyWith(selectedTime: event.time)));

    on<ChangeDurationEvent>((event, emit) {
      double newValue = state.duration + event.delta;
      if (newValue >= 0.5 && newValue <= 12) {
        emit(state.copyWith(duration: newValue));
      }
    });

    on<ToggleResourceEvent>(_onToggleResource);
    on<SelectAutoPickEvent>((event, emit) =>
        emit(state.copyWith(bookingType: 'auto', selectedResourceCodes: [])));

    on<ConfirmBookingEvent>(_onConfirmBooking);

    on<GetWalletEvent>(_onGetWallet);
  }

  Future<void> _onStarted(
      BookingInitEvent event, Emitter<BookingPageState> emit) async {
    emit(state.copyWith(status: BookingStatus.loading));
    try {
      final isExpired = await AuthenticationService().checkJwtExpired();
      if (isExpired) {
        emit(state.copyWith(blocState: BookingBlocState.unauthenticated));
      } else {
        final pos = await LocationService().getUserCurrentLocation();

        if (pos != null) {
          // Lưu vị trí vào state và gọi lại sự kiện tìm kiếm
          emit(state.copyWith(
            userLat: pos.latitude.toString(),
            userLong: pos.longitude.toString(),
          ));
        }
        add(LoadBookingDataEvent());
      }
    } catch (e) {
      emit(state.copyWith(
          status: BookingStatus.failure, message: "Lỗi auth: $e"));
    }
  }

  Future<void> _onLoadBookingData(
      LoadBookingDataEvent event, Emitter<BookingPageState> emit) async {
    emit(state.copyWith(status: BookingStatus.loading));
    try {
      final results = await Future.wait([
        CityRepository().getProvinces(),
        BookingRepository().listStation("", "", "", "", "ACTIVE", "0", "10",
            state.userLong ?? "", state.userLat ?? ""),
        BookingRepository().getPlatformSpace(),
      ]);

      final provinces = _parseList<ProvinceModel>(
          results[0], (j) => ProvinceModel.fromJson(j));

      final stationResp =
          StationDetailModelResponse.fromJson(results[1]['body'] ?? {});
      final stations = stationResp.data ?? [];
      final meta = stationResp.meta;

      final platforms =
          SpaceListModelResponse.fromJson(results[2]['body'] ?? {}).data ?? [];
      final platformMap = {for (var p in platforms) p.spaceId: p};

      if (stations.isNotEmpty) {
        final spaceFutures = stations.map(
            (s) => BookingRepository().getStationSpace(s.stationId.toString()));
        final spaceResults = await Future.wait(spaceFutures);
        for (int i = 0; i < stations.length; i++) {
          final spaces = StationSpaceListModelResponse.fromJson(
                      spaceResults[i]['body'] ?? {})
                  .data ??
              [];
          for (var sp in spaces) {
            sp.space = platformMap[sp.spaceId];
          }
          stations[i].space = spaces;
        }
      }

      emit(state.copyWith(
        status: BookingStatus.success,
        filteredStations: stations,
        provinces: provinces,
        platformSpaces: platforms,
        totalItems: meta?.total ?? 0,
        message: "",
      ));
    } catch (e) {
      emit(state.copyWith(
          status: BookingStatus.failure, message: "Lỗi tải dữ liệu: $e"));
    }
  }

  Future<void> _onFetchStations(
      FetchStationsEvent event, Emitter<BookingPageState> emit) async {
    emit(state.copyWith(status: BookingStatus.loading));
    try {
      final res = await BookingRepository().listStation(
        state.searchQuery,
        state.selectedProvince?.name ?? "",
        "",
        state.selectedDistrict?.name ?? "",
        "ACTIVE",
        state.currentPage.toString(),
        "10",
        state.userLong ?? "",
        state.userLat ?? "",
      );
      final resp = StationDetailModelResponse.fromJson(res['body']);

      final stations = resp.data ?? [];
      if (stations.isNotEmpty) {
        final platformMap = {for (var p in state.platformSpaces) p.spaceId: p};
        final spaceFutures = stations.map(
            (s) => BookingRepository().getStationSpace(s.stationId.toString()));
        final spaceResults = await Future.wait(spaceFutures);
        for (int i = 0; i < stations.length; i++) {
          final spaces = StationSpaceListModelResponse.fromJson(
                      spaceResults[i]['body'] ?? {})
                  .data ??
              [];
          for (var sp in spaces) {
            sp.space = platformMap[sp.spaceId];
          }
          stations[i].space = spaces;
        }
      }

      emit(state.copyWith(
        status: BookingStatus.success,
        filteredStations: stations,
        totalItems: resp.meta?.total ?? 0,
      ));
    } catch (e) {
      emit(state.copyWith(status: BookingStatus.failure, message: "$e"));
    }
  }

  Future<void> _onFindNearestStation(
      FindNearestStationEvent event, Emitter<BookingPageState> emit) async {
    emit(state.copyWith(status: BookingStatus.loading));
    try {
      final pos = await LocationService().getUserCurrentLocation();

      if (pos != null) {
        // Lưu vị trí vào state và gọi lại sự kiện tìm kiếm
        emit(state.copyWith(
          userLat: pos.latitude.toString(),
          userLong: pos.longitude.toString(),
          currentPage: 0, // Reset về trang đầu khi tìm gần nhất
        ));
        add(FetchStationsEvent());
      } else {
        emit(state.copyWith(
            status: BookingStatus.failure, message: "Không lấy được vị trí"));
      }
    } catch (e) {
      emit(state.copyWith(
          status: BookingStatus.failure, message: "Lỗi vị trí: $e"));
    }
  }

  Future<void> _onSelectStation(
      SelectStationEvent event, Emitter<BookingPageState> emit) async {
    emit(state.copyWith(
      status: BookingStatus.loading,
      isSelectingStation: false,
      selectedStation: event.station,
      selectedResourceCodes: [],
    ));

    List<ScheduleModel> validSchedules = [];
    try {
      DateTime now = DateTime.now();
      String dateFrom = DateFormat('yyyy-MM-dd').format(now);
      String dateTo =
          DateFormat('yyyy-MM-dd').format(now.add(Duration(days: 7)));

      final resSche = await BookingRepository().findAllScheduleWithStation(
          event.station.stationId.toString(), dateFrom, dateTo, "", "");
      List<ScheduleModel> allSchedules =
          ScheduleListModelResponse.fromJson(resSche['body']).data ?? [];

      validSchedules =
          allSchedules.where((s) => s.statusCode == 'ENABLED').toList();

      validSchedules.sort((a, b) => (a.date ?? "").compareTo(b.date ?? ""));
    } catch (_) {}

    final stationSpaces = event.station.space ?? [];
    if (stationSpaces.isEmpty) {
      emit(state.copyWith(
          status: BookingStatus.success,
          schedules: validSchedules,
          message: "Station chưa có khu vực"));
      return;
    }
    final defaultSpace = stationSpaces.first;

    List<AreaModel> areas = [];
    try {
      final resArea = await BookingRepository().getArea(
          "",
          event.station.stationId.toString(),
          defaultSpace.stationSpaceId.toString(),
          "ACTIVE",
          "0",
          "10");
      areas = AreaListModelResponse.fromJson(resArea['body']).data ?? [];
    } catch (_) {}

    if (areas.isEmpty) {
      emit(state.copyWith(
          status: BookingStatus.success,
          selectedSpace: defaultSpace,
          schedules: validSchedules,
          areas: [],
          resources: []));
      return;
    }
    final defaultArea = areas.first;

    final resourceList = await _fetchResources(defaultArea.areaId.toString());

    emit(state.copyWith(
      status: BookingStatus.success,
      schedules: validSchedules,
      spaces: stationSpaces,
      selectedSpace: defaultSpace,
      areas: areas,
      selectedArea: defaultArea,
      resources: resourceList,
      selectedDateIndex: 0,
      selectedTime: '',
    ));
  }

  Future<void> _onSelectSpace(
      SelectSpaceEvent event, Emitter<BookingPageState> emit) async {
    emit(state.copyWith(status: BookingStatus.loading));
    try {
      //! api Area - khu vực
      final stationId = state.selectedStation?.stationId.toString() ?? "";
      final res = await BookingRepository().getArea("", stationId,
          event.space.stationSpaceId.toString(), "ACTIVE", "0", "10");
      final areas = AreaListModelResponse.fromJson(res['body']).data ?? [];

      AreaModel? newArea;
      List<StationResourceModel> resourceList = [];

      if (areas.isNotEmpty) {
        newArea = areas.first;
        resourceList = await _fetchResources(newArea.areaId.toString());
      }

      emit(state.copyWith(
        status: BookingStatus.success,
        selectedSpace: event.space,
        areas: areas,
        selectedArea: newArea,
        resources: resourceList,
        // Reset toàn bộ thông tin resource và giờ chơi
        bookingType: null,
        clearBookingType: true,
        selectedResourceCodes: [],
        availableTimes: [],
        selectedTime: '',
      ));
    } catch (e) {
      emit(state.copyWith(
          status: BookingStatus.failure, message: "Lỗi tải Area: $e"));
    }
  }

  Future<void> _onSelectArea(
      SelectAreaEvent event, Emitter<BookingPageState> emit) async {
    emit(state.copyWith(status: BookingStatus.loading));
    try {
      final resourceList = await _fetchResources(event.area.areaId.toString());
      emit(state.copyWith(
        status: BookingStatus.success,
        selectedArea: event.area,
        resources: resourceList,
        // Reset toàn bộ thông tin resource và giờ chơi
        bookingType: null,
        clearBookingType: true,
        selectedResourceCodes: [],
        availableTimes: [],
        selectedTime: '',
      ));
    } catch (e) {
      emit(state.copyWith(
          status: BookingStatus.failure, message: "Lỗi tải máy: $e"));
    }
  }

  Future<void> _onSelectDate(
      SelectDateEvent event, Emitter<BookingPageState> emit) async {
    // Khi chọn ngày mới => Reset lại lựa chọn resource, giờ chơi
    emit(state.copyWith(
      status: BookingStatus.success,
      selectedDateIndex: event.index,
      selectedResourceCodes: [], // Reset resource về rỗng
      availableTimes: [], // Reset danh sách giờ về rỗng
      selectedTime: '', // Reset giờ đã chọn
      bookingType: null,
      clearBookingType: true,
    ));
  }

  Future<void> _onConfirmBooking(
      ConfirmBookingEvent event, Emitter<BookingPageState> emit) async {
    emit(state.copyWith(
      submissionStatus: BookingSubmissionStatus.loading,
      clearPaymentUrl: true, // Reset url cũ nếu có
    ));
    try {
      // 1. Validate dữ liệu đầu vào
      int? scheduleId = state.schedules[state.selectedDateIndex].scheduleId;
      if (scheduleId == null) throw Exception("Schedule ID not found");

      int? stationResourceId;
      if (state.selectedResourceCodes.isNotEmpty) {
        final resourceCode = state.selectedResourceCodes.first;
        final res = state.resources.firstWhere(
            (r) => r.resourceCode == resourceCode,
            orElse: () => StationResourceModel());
        stationResourceId = res.stationResourceId;
      }
      if (stationResourceId == null) throw Exception("Resource ID not found");

      List<BookingSlotModel> bookingSlots = [];
      int startIndex =
          state.availableTimes.indexWhere((t) => t.begin == state.selectedTime);
      if (startIndex == -1) throw Exception("Time slot not found");

      int slotCount = state.duration.ceil();
      for (int i = 0; i < slotCount; i++) {
        if (startIndex + i < state.availableTimes.length) {
          int? tId = state.availableTimes[startIndex + i].timeSlotId;
          if (tId != null) {
            bookingSlots.add(BookingSlotModel(
                bookingSlotId: BookingSlotIdModel(timeSlotId: tId)));
          }
        }
      }

      final request = BookingModel(
        scheduleId: scheduleId,
        paymentMethodCode: event.paymentMethodCode,
        paymentMethodName: event.paymentMethodName,
        stationResourceId: stationResourceId,
        bookingMenus: [],
        bookingSlots: bookingSlots,
      );

      // 2. Gọi API Create Booking
      final response = await BookingRepository().createBooking(request);

      if (response['success'] == true ||
          response['status'] == 200 ||
          response['status'] == 201) {
        // -- update: Lấy Booking ID từ response (data: 12)
        // Lưu ý: data trả về là int trực tiếp, không phải object
        final String bookingId = response['body']['data'].toString();

        // 3. Xử lý thanh toán theo phương thức
        if (event.paymentMethodCode == 'WALLET') {
          // -- update: Kiểm tra số dư ví
          if (state.userBalance < state.totalPrice) {
            emit(state.copyWith(
                submissionStatus: BookingSubmissionStatus.failure,
                message: "Số dư ví không đủ để thanh toán"));
            return;
          }

          // -- update: Gọi API thanh toán ví (POST)
          final payRes = await BookingRepository().paymentWallet(bookingId);
          if (payRes['success'] == true || payRes['status'] == 200) {
            emit(state.copyWith(
                submissionStatus: BookingSubmissionStatus.success,
                message: "Đặt lịch & Thanh toán ví thành công!"));
          } else {
            emit(state.copyWith(
                submissionStatus: BookingSubmissionStatus.failure,
                message: payRes['message'] ?? "Thanh toán ví thất bại"));
          }
        } else if (event.paymentMethodCode == 'BANK_TRANSFER') {
          // -- update: Gọi API thanh toán ngân hàng (GET) & lấy link
          final payRes =
              await BookingRepository().paymentBankTransfer(bookingId);

          if (payRes['success'] == true || payRes['status'] == 200) {
            final data = payRes['body']['data'];
            // Lấy checkoutUrl từ response json
            String? checkoutUrl = data != null ? data['checkoutUrl'] : null;

            if (checkoutUrl != null) {
              emit(state.copyWith(
                  submissionStatus: BookingSubmissionStatus.success,
                  message: "Đang mở trang thanh toán...",
                  paymentUrl: checkoutUrl // Lưu link để UI mở
                  ));
            } else {
              emit(state.copyWith(
                  submissionStatus: BookingSubmissionStatus.failure,
                  message: "Không tìm thấy link thanh toán"));
            }
          } else {
            emit(state.copyWith(
                submissionStatus: BookingSubmissionStatus.failure,
                message: payRes['message'] ?? "Lỗi tạo giao dịch thanh toán"));
          }
        } else {
          // DIRECT (Tiền mặt)
          emit(state.copyWith(
              submissionStatus: BookingSubmissionStatus.success,
              message: "Đặt lịch thành công! Vui lòng thanh toán tại quầy."));
        }
      } else {
        emit(state.copyWith(
            submissionStatus: BookingSubmissionStatus.failure,
            message: response['message'] ?? "Đặt lịch thất bại"));
      }
    } catch (e) {
      emit(state.copyWith(
          submissionStatus: BookingSubmissionStatus.failure,
          message: e.toString()));
    }
  }

  Future<List<TimeslotModel>> _fetchTimeSlotsForSchedule(
      ScheduleModel schedule, String stationResourceId) async {
    try {
      final res = await BookingRepository().findDetailWithResource(
        schedule.scheduleId.toString(),
        stationResourceId,
      );

      // Parse JSON
      final detailData = ScheduleModelResponse.fromJson(res['body']).data;
      List<TimeslotModel> slots = detailData?.timeSlots ?? [];

      bool isDayValid = (detailData?.statusCode == "ENABLED");

      DateTime now = DateTime.now();
      DateTime? scheduleDate = DateTime.tryParse(schedule.date ?? "");

      bool isToday = false;
      if (scheduleDate != null) {
        isToday = scheduleDate.year == now.year &&
            scheduleDate.month == now.month &&
            scheduleDate.day == now.day;
      }

      for (var slot in slots) {
        bool isTimeValid = true;

        if (isToday && slot.begin != null) {
          try {
            List<String> parts = slot.begin!.split(':');
            if (parts.length >= 2) {
              int hour = int.parse(parts[0]);
              int minute = int.parse(parts[1]);
              // Tạo thời gian slot dựa trên ngày hôm nay
              DateTime slotTime =
                  DateTime(now.year, now.month, now.day, hour, minute);

              // Nếu giờ slot nhỏ hơn giờ hiện tại => không hợp lệ
              if (slotTime.isBefore(now)) {
                isTimeValid = false;
              }
            }
          } catch (_) {}
        }

        // Kiểm tra allowBooking == true hoặc null
        bool isBookingAllowed =
            slot.allowBooking == true || slot.allowBooking == null;

        // Tổng hợp điều kiện
        slot.isSelectable = isDayValid && isTimeValid && isBookingAllowed;
      }

      // Sắp xếp lại theo giờ begin
      slots.sort((a, b) => (a.begin ?? "").compareTo(b.begin ?? ""));

      return slots;
    } catch (e) {
      return [];
    }
  }

  Future<List<StationResourceModel>> _fetchResources(String areaId) async {
    try {
      // 1. Get List
      final res =
          await BookingRepository().getResouce("", areaId, "ENABLE", "0", "20");
      List<StationResourceModel> resources =
          ResoucreListModelResponse.fromJson(res['body']).data ?? [];

      for (var i = 0; i < resources.length; i++) {
        final detailRes = await BookingRepository()
            .getResouceDetail(resources[i].stationResourceId.toString());
        final detailData =
            ResoucreModelResponse.fromJson(detailRes['body']).data;
        if (detailData?.spec != null) {
          resources[i].spec = detailData!.spec;
        }
      }
      return resources;
    } catch (e) {
      return [];
    }
  }

  Future<void> _onToggleResource(
      ToggleResourceEvent event, Emitter<BookingPageState> emit) async {
    // 1. Cập nhật danh sách resource đã chọn
    List<String> current = List.from(state.selectedResourceCodes);
    if (current.contains(event.resourceCode)) {
      current.remove(event.resourceCode);
    } else {
      current.clear(); // Logic chọn 1 máy duy nhất tại 1 thời điểm
      current.add(event.resourceCode);
    }

    // 2. Cập nhật state UI trước
    emit(state.copyWith(
        selectedResourceCodes: current,
        bookingType: current.isEmpty ? null : 'manual',
        clearBookingType: current.isEmpty,
        status: BookingStatus.loading)); // Set loading nhẹ

    List<TimeslotModel> newTimes = [];

    // 3. Nếu có resource được chọn, gọi API lấy timeslot
    if (current.isNotEmpty && state.schedules.isNotEmpty) {
      try {
        final resModel = state.resources.firstWhere(
            (r) => r.resourceCode == event.resourceCode,
            orElse: () => StationResourceModel());

        if (resModel.stationResourceId != null) {
          // Gọi hàm lấy timeslot với stationResourceId
          newTimes = await _fetchTimeSlotsForSchedule(
            state.schedules[state.selectedDateIndex],
            resModel.stationResourceId.toString(),
          );
        }
      } catch (_) {}
    }

    // 4. Emit state cuối cùng với danh sách giờ mới
    emit(state.copyWith(
      status: BookingStatus.success,
      availableTimes: newTimes,
      selectedTime: '', // Reset giờ đã chọn khi đổi máy
    ));
  }

  Future<void> _onLoadProvinces(
      LoadProvincesEvent event, Emitter<BookingPageState> emit) async {}
  Future<void> _onSelectProvince(
      SelectProvinceEvent event, Emitter<BookingPageState> emit) async {
    emit(state.copyWith(status: BookingStatus.loading));
    try {
      final res = await CityRepository().getDistricts(event.province.code);
      final districts = (res['body']['districts'] as List)
          .map((e) => DistrictModel.fromJson(e))
          .toList();
      emit(state.copyWith(
          status: BookingStatus.success,
          selectedProvince: event.province,
          districts: districts,
          selectedDistrict: null,
          clearSelectedDistrict: true,
          currentPage: 0));
      add(FetchStationsEvent());
    } catch (_) {
      emit(state.copyWith(status: BookingStatus.success));
    }
  }

  Future<void> _onSelectDistrict(
      SelectDistrictEvent event, Emitter<BookingPageState> emit) async {
    emit(state.copyWith(selectedDistrict: event.district, currentPage: 0));
    add(FetchStationsEvent());
  }

  Future<void> _onResetFilter(
      ResetFilterEvent event, Emitter<BookingPageState> emit) async {
    emit(state.copyWith(
        searchQuery: '',
        selectedDistrict: null,
        clearSelectedDistrict: true,
        selectedProvince: null,
        clearSelectedProvince: true,
        currentPage: 0,
        districts: []));
    add(FetchStationsEvent());
  }

  Future<void> _onGetWallet(
      GetWalletEvent event, Emitter<BookingPageState> emit) async {
    try {
      final res = await BookingRepository().getWallet();
      if (res['success'] == true ||
          res['status'] == 200 ||
          res['status'] == '200') {
        final walletData = WalletModelResponse.fromJson(res['body']).data;
        if (walletData != null) {
          emit(state.copyWith(userBalance: walletData.balance));
        }
      }
    } catch (e) {
      // In case of error, just keep the old balance or set to 0
      print("Error fetching wallet: $e");
    }
  }

  void _onSearchStation(
      SearchStationEvent event, Emitter<BookingPageState> emit) {
    emit(state.copyWith(searchQuery: event.query, currentPage: 0));
    add(FetchStationsEvent());
  }

  Future<void> _onChangePage(
      ChangePageEvent event, Emitter<BookingPageState> emit) async {
    emit(state.copyWith(currentPage: event.pageIndex));
    add(FetchStationsEvent());
  }

  List<T> _parseList<T>(dynamic result, T Function(dynamic) fromJson) {
    if (result['success'] == true || result['status'] == 200) {
      return (result['body'] as List).map((e) => fromJson(e)).toList();
    }
    return [];
  }
}
