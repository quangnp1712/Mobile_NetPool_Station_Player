import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:mobile_netpool_station_player/core/services/authentication_service.dart';
import 'package:mobile_netpool_station_player/core/services/location_service.dart';
import 'package:mobile_netpool_station_player/core/utils/debug_logger.dart';
import 'package:mobile_netpool_station_player/core/utils/utf8_encoding.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/data/mock_data.dart';
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
import 'package:mobile_netpool_station_player/features/4_Booking_Page/models/5.resource/resoucre_spec_model.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/repository/booking_repository.dart';
import 'package:mobile_netpool_station_player/features/Common/data/city_controller/city_model.dart';
import 'package:mobile_netpool_station_player/features/Common/data/city_controller/city_repository.dart';
import 'package:mobile_netpool_station_player/features/Common/data/meta/model/meta_model.dart';

part 'booking_page_event.dart';
part 'booking_page_state.dart';

class BookingPageBloc extends Bloc<BookingPageEvent, BookingPageState> {
  // Inject Services Real (Giả định đã có class tương ứng)

  BookingPageBloc() : super(const BookingPageState()) {
    on<BookingInitEvent>(_onStarted);
    on<LoadBookingDataEvent>(_onLoadBookingData);
    on<FetchStationsEvent>(_onFetchStations);

    // Filters & Location
    on<LoadProvincesEvent>(_onLoadProvinces);
    on<SelectProvinceEvent>(_onSelectProvince);
    on<SelectDistrictEvent>(_onSelectDistrict);
    on<ResetFilterEvent>(_onResetFilter);
    on<SearchStationEvent>(_onSearchStation);
    on<FindNearestStationEvent>(_onFindNearestStation);
    on<ChangePageEvent>(_onChangePage);
    on<ToggleStationSelectionModeEvent>((event, emit) =>
        emit(state.copyWith(isSelectingStation: !state.isSelectingStation)));

    // Booking Flow
    on<SelectStationEvent>(_onSelectStation);
    on<SelectSpaceEvent>(_onSelectSpace);
    on<SelectAreaEvent>(_onSelectArea);

    on<SelectDateEvent>(_onSelectDate);
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
  }

  Future<void> _onStarted(
      BookingInitEvent event, Emitter<BookingPageState> emit) async {
    emit(state.copyWith(status: BookingStatus.loading));
    try {
      final isExpired = await AuthenticationService().checkJwtExpired();
      if (isExpired) {
        emit(state.copyWith(blocState: BookingBlocState.unauthenticated));
      } else {
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
      // 1. Parallel fetch
      final results = await Future.wait([
        CityRepository().getProvinces(),
        BookingRepository().listStation("", "", "", "", "ACTIVE", "0", "10"),
        BookingRepository().getPlatformSpace(),
      ]);

      // 2. Process Provinces
      final provinces = _parseList<ProvinceModel>(
          results[0], (j) => ProvinceModel.fromJson(j));

      // 3. Process Stations
      final stationResp =
          StationDetailModelResponse.fromJson(results[1]['body'] ?? {});
      final stations = stationResp.data ?? [];
      final meta = stationResp.meta;

      // 4. Process Platform Space
      final platforms =
          SpaceListModelResponse.fromJson(results[2]['body'] ?? {}).data ?? [];
      final platformMap = {for (var p in platforms) p.spaceId: p};

      // 5. Fetch Spaces for Stations (Batch)
      if (stations.isNotEmpty) {
        final spaceFutures = stations.map(
            (s) => BookingRepository().getStationSpace(s.stationId.toString()));
        final spaceResults = await Future.wait(spaceFutures);
        for (int i = 0; i < stations.length; i++) {
          final spaces = StationSpaceListModelResponse.fromJson(
                      spaceResults[i]['body'] ?? {})
                  .data ??
              [];
          for (var sp in spaces) sp.space = platformMap[sp.spaceId];
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
          "10");
      final resp = StationDetailModelResponse.fromJson(res['body']);

      // Load Spaces detail for stations (needed for UI icons)
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
          for (var sp in spaces) sp.space = platformMap[sp.spaceId];
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

  // --- BOOKING FLOW: STATION -> SPACE -> AREA -> RESOURCE (REAL DATA CHAIN) ---

  Future<void> _onSelectStation(
      SelectStationEvent event, Emitter<BookingPageState> emit) async {
    emit(state.copyWith(
        status: BookingStatus.loading,
        isSelectingStation: false,
        selectedStation: event.station));

    List<ScheduleModel> validSchedules = [];
    try {
      // Logic lấy 7 ngày
      DateTime now = DateTime.now();
      String dateFrom = DateFormat('yyyy-MM-dd').format(now);
      String dateTo =
          DateFormat('yyyy-MM-dd').format(now.add(Duration(days: 7)));

      final res = await BookingRepository().findAllScheduleWithStation(
          event.station.stationId.toString(), dateFrom, dateTo, "", "");
      List<ScheduleModel> allSchedules =
          ScheduleListModelResponse.fromJson(res['body']).data ?? [];

      // LOGIC LỌC: Chỉ lấy ENABLED
      validSchedules =
          allSchedules.where((s) => s.statusCode == 'ENABLED').toList();

      // Sort theo ngày cho chắc chắn
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
      final res = await BookingRepository().getArea(
          "",
          event.station.stationId.toString(),
          defaultSpace.spaceId.toString(),
          "ACTIVE",
          "0",
          "10");
      areas = AreaListModelResponse.fromJson(res['body']).data ?? [];
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

    // --- UPDATED: Fetch timeslots for first day immediately
    List<TimeslotModel> initialTimes = [];
    if (validSchedules.isNotEmpty) {
      initialTimes = await _fetchTimeSlotsForSchedule(validSchedules[0]);
    }

    emit(state.copyWith(
      status: BookingStatus.success,
      schedules: validSchedules,
      spaces: stationSpaces,
      selectedSpace: defaultSpace,
      areas: areas,
      selectedArea: defaultArea,
      resources: resourceList,
      availableTimes: initialTimes,
      selectedDateIndex: 0,
      selectedTime: '',
    ));
  }

  Future<void> _onSelectSpace(
      SelectSpaceEvent event, Emitter<BookingPageState> emit) async {
    emit(state.copyWith(status: BookingStatus.loading));
    // 1. Fetch new Areas for new Space (REAL API)
    try {
      final stationId = state.selectedStation?.stationId.toString() ?? "";
      final res = await BookingRepository().getArea(
          "", stationId, event.space.spaceId.toString(), "ACTIVE", "0", "10");
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
          bookingType: null,
          clearBookingType: true,
          selectedResourceCodes: []));
    } catch (e) {
      emit(state.copyWith(
          status: BookingStatus.failure, message: "Lỗi tải Area: $e"));
    }
  }

  Future<void> _onSelectArea(
      SelectAreaEvent event, Emitter<BookingPageState> emit) async {
    emit(state.copyWith(status: BookingStatus.loading));
    // 1. Fetch Resources for new Area (REAL API)
    try {
      final resourceList = await _fetchResources(event.area.areaId.toString());
      emit(state.copyWith(
          status: BookingStatus.success,
          selectedArea: event.area,
          resources: resourceList,
          bookingType: null,
          clearBookingType: true,
          selectedResourceCodes: []));
    } catch (e) {
      emit(state.copyWith(
          status: BookingStatus.failure, message: "Lỗi tải máy: $e"));
    }
  }

  Future<void> _onSelectDate(
      SelectDateEvent event, Emitter<BookingPageState> emit) async {
    emit(state.copyWith(status: BookingStatus.loading));

    // --- UPDATED: Fetch timeslots async when date changes
    List<TimeslotModel> newTimes = [];
    if (event.index < state.schedules.length) {
      newTimes = await _fetchTimeSlotsForSchedule(state.schedules[event.index]);
    }

    emit(state.copyWith(
        status: BookingStatus.success,
        selectedDateIndex: event.index,
        availableTimes: newTimes,
        selectedTime: ''));
  }

  // --- HELPERS ---

// --- UPDATED: Helper to fetch TimeSlots
  Future<List<TimeslotModel>> _fetchTimeSlotsForSchedule(
      ScheduleModel schedule) async {
    try {
      final res = await BookingRepository()
          .findDetailWithSchedule(schedule.scheduleId.toString());
      final detailData = ScheduleModelResponse.fromJson(res['body']).data;
      List<TimeslotModel> slots = detailData?.timeSlots ?? [];

      // Check điều kiện ngày (Status ENABLED & allowUpdate)
      bool isDayValid = (detailData?.statusCode == "ENABLED" &&
          detailData?.allowUpdate == true);

      // --- UPDATED: Check giờ quá khứ nếu là hôm nay ---
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

        // Nếu là hôm nay, kiểm tra giờ
        if (isToday && slot.begin != null) {
          try {
            List<String> parts = slot.begin!.split(':');
            if (parts.length >= 2) {
              int hour = int.parse(parts[0]);
              int minute = int.parse(parts[1]);
              DateTime slotTime =
                  DateTime(now.year, now.month, now.day, hour, minute);

              // Nếu giờ slot nhỏ hơn giờ hiện tại -> Invalid
              if (slotTime.isBefore(now)) {
                isTimeValid = false;
              }
            }
          } catch (_) {}
        }

        // Kết hợp điều kiện ngày và điều kiện giờ
        slot.isSelectable = isDayValid && isTimeValid;
      }
      // ---------------------------------------------------

      return slots;
    } catch (e) {
      return [];
    }
  }

  Future<List<StationResourceModel>> _fetchResources(String areaId) async {
    try {
      // 1. Get List
      final res =
          await BookingRepository().getResouce("", areaId, "ACTIVE", "0", "20");
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

  void _onToggleResource(
      ToggleResourceEvent event, Emitter<BookingPageState> emit) {
    List<String> current = List.from(state.selectedResourceCodes);
    if (current.contains(event.resourceCode)) {
      // Nếu đã chọn rồi thì bỏ chọn
      current.remove(event.resourceCode);
    } else {
      // Nếu chưa chọn thì XÓA hết cái cũ và chọn cái mới (Chỉ cho phép 1)
      current.clear();
      current.add(event.resourceCode);
    }
    emit(state.copyWith(
        selectedResourceCodes: current,
        bookingType: current.isEmpty ? null : 'manual',
        clearBookingType: current.isEmpty));
  }

  // Filter Handlers
  Future<void> _onLoadProvinces(
      LoadProvincesEvent event, Emitter<BookingPageState> emit) async {
    /* Implemented in init */
  }
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
