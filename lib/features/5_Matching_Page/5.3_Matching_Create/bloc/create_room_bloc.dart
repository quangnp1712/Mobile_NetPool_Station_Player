import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:mobile_netpool_station_player/core/services/location_service.dart';
import 'package:mobile_netpool_station_player/core/utils/debug_logger.dart';
import 'package:mobile_netpool_station_player/features/5_Matching_Page/5.3_Matching_Create/models/1.station/station_model.dart';
import 'package:mobile_netpool_station_player/features/5_Matching_Page/5.3_Matching_Create/models/1.station/station_response_model.dart';
import 'package:mobile_netpool_station_player/features/5_Matching_Page/5.3_Matching_Create/models/2.space/space_response_model.dart';
import 'package:mobile_netpool_station_player/features/5_Matching_Page/5.3_Matching_Create/models/2.space/station_space_model.dart';
import 'package:mobile_netpool_station_player/features/5_Matching_Page/5.3_Matching_Create/models/2.space/station_space_response_model.dart';
import 'package:mobile_netpool_station_player/features/5_Matching_Page/5.3_Matching_Create/models/3.game/game_model.dart';
import 'package:mobile_netpool_station_player/features/5_Matching_Page/5.3_Matching_Create/models/3.game/game_response_model.dart';
import 'package:mobile_netpool_station_player/features/5_Matching_Page/5.3_Matching_Create/models/4.schedule/request_available_schedule_model.dart';
import 'package:mobile_netpool_station_player/features/5_Matching_Page/5.3_Matching_Create/models/4.schedule/schedule_list_response_model.dart';
import 'package:mobile_netpool_station_player/features/5_Matching_Page/5.3_Matching_Create/models/4.schedule/schedule_model.dart';
import 'package:mobile_netpool_station_player/features/5_Matching_Page/5.3_Matching_Create/models/4.schedule/schedule_response_model.dart';
import 'package:mobile_netpool_station_player/features/5_Matching_Page/5.3_Matching_Create/models/4.schedule/timeslot_model.dart';
import 'package:mobile_netpool_station_player/features/5_Matching_Page/5.3_Matching_Create/models/6.area/area_list_model.dart';
import 'package:mobile_netpool_station_player/features/5_Matching_Page/5.3_Matching_Create/models/6.area/area_list_response_model.dart';
import 'package:mobile_netpool_station_player/features/5_Matching_Page/5.3_Matching_Create/models/7.resource/request_available_schedule_model.dart';
import 'package:mobile_netpool_station_player/features/5_Matching_Page/5.3_Matching_Create/models/7.resource/resoucre_list_response_model.dart';
import 'package:mobile_netpool_station_player/features/5_Matching_Page/5.3_Matching_Create/models/7.resource/resoucre_model.dart';
import 'package:mobile_netpool_station_player/features/5_Matching_Page/5.3_Matching_Create/models/8.wallet/wallet_response_model.dart';
import 'package:mobile_netpool_station_player/features/5_Matching_Page/5.3_Matching_Create/models/9.match_making/matching_model.dart';
import 'package:mobile_netpool_station_player/features/5_Matching_Page/5.3_Matching_Create/repository/matching_repository.dart';

part 'create_room_event.dart';
part 'create_room_state.dart';

class CreateRoomBloc extends Bloc<CreateRoomEvent, CreateRoomState> {
  final IMatchingRepository _repo;

  CreateRoomBloc(this._repo) : super(const CreateRoomState()) {
    on<InitPage>(_onInitPage);
    on<FetchStationsEvent>(_onFetchStations);
    on<SearchStationEvent>((event, emit) {
      emit(state.copyWith(searchQuery: event.query, currentPage: 0));
      add(FetchStationsEvent());
    });
    on<SelectProvinceEvent>((event, emit) {
      emit(state.copyWith(
          selectedProvince: event.province,
          clearSelectedDistrict: true,
          districts: [],
          currentPage: 0));
      add(FetchStationsEvent());
    });
    on<SelectDistrictEvent>((event, emit) {
      emit(state.copyWith(selectedDistrict: event.district, currentPage: 0));
      add(FetchStationsEvent());
    });
    on<ResetFilterEvent>((event, emit) {
      emit(state.copyWith(
          searchQuery: '',
          clearSelectedProvince: true,
          clearSelectedDistrict: true,
          districts: [],
          currentPage: 0));
      add(FetchStationsEvent());
    });
    on<ChangePageEvent>((event, emit) {
      emit(state.copyWith(currentPage: event.page));
      add(FetchStationsEvent());
    });
    on<FindNearestStationEvent>((event, emit) {
      add(FetchStationsEvent());
    });

    on<SelectStation>(_onSelectStation);
    on<SelectSpace>(_onSelectSpace);
    on<SelectGame>(_onSelectGame);
    on<SelectDate>(_onSelectDate);
    on<SelectTimeSlot>(_onSelectTimeSlot);
    on<ChangeDuration>((event, emit) => emit(state.copyWith(
        duration: event.duration, selectedResources: [], resources: [])));
    on<SelectArea>(_onSelectArea);
    on<SearchResources>(_onSearchResources);
    on<ToggleResource>(_onToggleResource);
    on<ChangeHoldingDays>(
        (event, emit) => emit(state.copyWith(holdingDays: event.days)));
    on<SelectPaymentMethod>(
        (event, emit) => emit(state.copyWith(paymentMethod: event.method)));
    on<SubmitBooking>(_onSubmitBooking);
  }

  Future<void> _onInitPage(
      InitPage event, Emitter<CreateRoomState> emit) async {
    emit(state.copyWith(status: RoomStatus.loading));

    // 1. Get Location First (Use mock LocationService)
    try {
      final position = await LocationService().getUserCurrentLocation();
      if (position != null) {
        emit(state.copyWith(
            userLat: position.latitude.toString(),
            userLong: position.longitude.toString()));
      }
    } catch (_) {}

    try {
      final walletRes = await _repo.getWallet();
      if (walletRes['success'] == true) {
        final wallet = WalletModelResponse.fromMap(walletRes['body']).data;
        if (wallet != null) emit(state.copyWith(userBalance: wallet.balance));
      }
    } catch (_) {}

    // 2. Fetch Provinces
    try {
      final provRes = await _repo.getAllProvince("", "100");
      List<String> provinces = [];
      if (provRes['success'] == true && provRes['body']['data'] != null) {
        provinces = List<String>.from(provRes['body']['data']);
      }

      emit(state.copyWith(provinces: provinces));
      add(FetchStationsEvent());
    } catch (e) {
      emit(state.copyWith(status: RoomStatus.failure, message: "Lỗi Init: $e"));
      DebugLogger.printLog("Lỗi $e");
    }
  }

  Future<void> _onFetchStations(
      FetchStationsEvent event, Emitter<CreateRoomState> emit) async {
    emit(state.copyWith(status: RoomStatus.loading));
    try {
      final res = await _repo.listStation(
          state.searchQuery ?? "",
          state.selectedProvince ?? "",
          state.selectedDistrict ?? "",
          "ACTIVE",
          state.currentPage.toString() ?? "",
          state.pageSize.toString() ?? "",
          state.userLong ?? "", // Pass Longitude
          state.userLat ?? "" // Pass Latitude
          );

      if (res['success'] == true) {
        final response = StationDetailModelResponse.fromMap(res['body']);
        final stations = response.data ?? [];

        // Logic: Lọc danh sách quận từ kết quả stations
        List<String> newDistricts = state.districts;

        if (state.selectedProvince != null && state.selectedDistrict == null) {
          final uniqueDistricts = stations
              .map((s) => s.district)
              .where((d) => d != null && d.isNotEmpty)
              .cast<String>()
              .toSet()
              .toList();

          uniqueDistricts.sort();
          newDistricts = uniqueDistricts;
        } else if (state.selectedProvince == null) {
          newDistricts = [];
        }

        emit(state.copyWith(
            status: RoomStatus.success,
            stations: stations,
            totalItems: response.meta?.total ?? 0,
            districts: newDistricts));
      } else {
        emit(state.copyWith(
            status: RoomStatus.failure, message: res['message']));
      }
    } catch (e) {
      emit(state.copyWith(
          status: RoomStatus.failure, message: "Lỗi tìm trạm: $e"));
      DebugLogger.printLog("Lỗi $e");
    }
  }

  Future<void> _onSelectStation(
      SelectStation event, Emitter<CreateRoomState> emit) async {
    emit(state.copyWith(
        status: RoomStatus.loading,
        selectedStation: event.station,
        selectedSpace: null,
        spaces: [],
        selectedGame: null,
        games: [],
        clearSchedule: true, // Clear Schedule + TimeSlots
        selectedArea: null,
        areas: [],
        selectedResources: [],
        resourceGroups: [],
        resources: [],
        holdingDays: 1,
        maxHoldingDays: 1,
        canHold: false));

    try {
      // Get Spaces
      final spaceRes =
          await _repo.getAllStationSpace(event.station.stationId.toString());
      List<StationSpaceModel> spaces = [];
      if (spaceRes['success'] == true) {
        spaces =
            StationSpaceListModelResponse.fromMap(spaceRes['body']).data ?? [];
      }

      // Get Schedule
      String dateFrom = DateFormat('yyyy-MM-dd').format(DateTime.now());
      String dateTo = DateFormat('yyyy-MM-dd')
          .format(DateTime.now().add(const Duration(days: 7)));
      final schRes = await _repo.findAllSchedule(
          event.station.stationId.toString(), dateFrom, dateTo, "ENABLED", "7");
      List<ScheduleModel> schedules = [];
      if (schRes['success'] == true) {
        schedules =
            ScheduleListModelResponse.fromMap(schRes['body']).data ?? [];
      }

      emit(state.copyWith(
        status: RoomStatus.success,
        spaces: spaces,
        schedules: schedules,
        selectedSpace: spaces.isNotEmpty ? spaces.first : null,
      ));

      if (spaces.isNotEmpty) {
        add(SelectSpace(spaces.first));
      }
      // Auto select first schedule if available
      if (schedules.isNotEmpty) {
        add(SelectDate(schedules.first));
      }
    } catch (e) {
      emit(state.copyWith(
          status: RoomStatus.failure, message: "Lỗi lấy thông tin trạm: $e"));
      DebugLogger.printLog("Lỗi $e");
    }
  }

  Future<void> _onSelectSpace(
      SelectSpace event, Emitter<CreateRoomState> emit) async {
    emit(state.copyWith(
        status: RoomStatus.loading,
        selectedSpace: event.space,
        selectedGame: null,
        games: [],
        clearSchedule: true, // Reset Time & Schedule
        selectedArea: null,
        areas: [],
        selectedResources: [],
        resources: [],
        resourceGroups: [],
        holdingDays: 1,
        maxHoldingDays: 1,
        canHold: false));

    try {
      // Get Games
      final gameRes = await _repo.getAllGame(
          event.space.stationSpaceId.toString(), "", "", "ENABLE", "0", "50");
      List<GameModel> games = [];
      if (gameRes['success'] == true) {
        games = GameModelResponse.fromMap(gameRes['body']).data ?? [];
      }

      // Get Areas
      final areaRes = await _repo.getArea(
          "",
          state.selectedStation!.stationId.toString(),
          event.space.stationSpaceId.toString(),
          "ACTIVE",
          "0",
          "50");
      List<AreaModel> areas = [];

      if (areaRes['success'] == true) {
        areas = AreaListModelResponse.fromMap(areaRes['body']).data ?? [];
      }

      String dateFrom = DateFormat('yyyy-MM-dd').format(DateTime.now());
      String dateTo = DateFormat('yyyy-MM-dd')
          .format(DateTime.now().add(const Duration(days: 7)));
      final schRes = await _repo.findAllSchedule(
          state.selectedStation!.stationId.toString(),
          dateFrom,
          dateTo,
          "ENABLED",
          "10");
      List<ScheduleModel> schedules = [];
      if (schRes['success'] == true) {
        schedules =
            ScheduleListModelResponse.fromMap(schRes['body']).data ?? [];
        schedules.sort((a, b) => (a.date ?? "").compareTo(b.date ?? ""));
      }

      emit(state.copyWith(
          status: RoomStatus.success,
          games: games,
          areas: areas,
          schedules: schedules,
          selectedArea: areas.isNotEmpty ? areas.first : null));
      if (schedules.isNotEmpty) add(SelectDate(schedules.first));
    } catch (e) {
      emit(state.copyWith(
          status: RoomStatus.failure, message: "Lỗi lấy dịch vụ: $e"));
      DebugLogger.printLog("Lỗi $e");
    }
  }

  Future<void> _onSelectGame(
      SelectGame event, Emitter<CreateRoomState> emit) async {
    // RESET Schedule & Resources
    emit(state.copyWith(
        selectedGame: event.game,
        clearSchedule: true, // Reset Time & Schedule
        selectedResources: [],
        resources: [],
        resourceGroups: [],
        holdingDays: 1,
        maxHoldingDays: 1,
        canHold: false));

    // Refresh schedule (simulated logic as requested)
    String dateFrom = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String dateTo = DateFormat('yyyy-MM-dd')
        .format(DateTime.now().add(const Duration(days: 7)));
    try {
      final schRes = await _repo.findAllSchedule(
          state.selectedStation!.stationId.toString(),
          dateFrom,
          dateTo,
          "ENABLED",
          "10");
      List<ScheduleModel> schedules = [];
      if (schRes['success'] == true) {
        schedules =
            ScheduleListModelResponse.fromMap(schRes['body']).data ?? [];
        schedules.sort((a, b) => (a.date ?? "").compareTo(b.date ?? ""));
      }
      emit(state.copyWith(schedules: schedules));
      if (schedules.isNotEmpty) add(SelectDate(schedules.first));
    } catch (_) {}
  }

  Future<void> _onSelectDate(
      SelectDate event, Emitter<CreateRoomState> emit) async {
    emit(state.copyWith(
      status: RoomStatus.loading,
      selectedSchedule: event.schedule,
      selectedTimeSlot: null,
      timeSlots: [],
      duration: 1.0,
      selectedResources: [],
      resources: [],
      resourceGroups: [],
      holdingDays: 1,
      maxHoldingDays: 1,
      canHold: false,
    ));

    try {
      final res =
          await _repo.findAllTimeSlot(event.schedule.scheduleId.toString());
      List<TimeslotModel> slots = [];
      if (res['success'] == true) {
        final schedule = ScheduleModelResponse.fromMap(res['body']).data;
        slots = schedule?.timeSlots ?? [];
      }

      emit(state.copyWith(status: RoomStatus.success, timeSlots: slots));
    } catch (e) {
      emit(state.copyWith(
          status: RoomStatus.failure, message: "Lỗi lấy khung giờ: $e"));
      DebugLogger.printLog("Lỗi $e");
    }
  }

  Future<void> _onSelectArea(
      SelectArea event, Emitter<CreateRoomState> emit) async {
    // RESET Resources
    emit(state.copyWith(
        selectedArea: event.area,
        selectedResources: [],
        resources: [],
        resourceGroups: [],
        holdingDays: 1,
        maxHoldingDays: 1,
        canHold: false));
  }

  Future<void> _onSelectTimeSlot(
      SelectTimeSlot event, Emitter<CreateRoomState> emit) async {
    // RESET Resources
    emit(state.copyWith(
        selectedTimeSlot: event.timeSlot,
        selectedResources: [],
        resources: [],
        holdingDays: 1,
        maxHoldingDays: 1,
        canHold: false,
        resourceGroups: []));
  }

  Future<void> _onSearchResources(
      SearchResources event, Emitter<CreateRoomState> emit) async {
    if (state.selectedArea == null ||
        state.selectedSchedule == null ||
        state.selectedTimeSlot == null) {
      emit(state.copyWith(
          status: RoomStatus.failure,
          message: "Vui lòng chọn Ngày, Giờ và Khu vực"));
      return;
    }

    emit(state.copyWith(isLoadingResources: true));
    try {
      String begin = state.selectedTimeSlot!.begin!;
      int beginH = int.parse(begin.split(':')[0]);
      int endH = beginH + state.duration.toInt();
      String end = "${endH.toString().padLeft(2, '0')}:00:00";

      final req = RequestAvailableResourceModel(
          date: state.selectedSchedule!.date!, begin: begin, end: end);
      final res = await _repo.findAllResource(
          state.selectedArea!.areaId.toString(), req);

      if (res['success'] == true) {
        // Parse using new List Response
        final responseData = ResoucreListModelResponse.fromMap(res['body']);
        final groups = responseData.data ?? [];
        // Flatten list for easy logic
        final flatResources = groups
            .expand((g) => g.resources ?? [])
            .cast<StationResourceModel>()
            .toList();

        emit(state.copyWith(
            isLoadingResources: false,
            resourceGroups: groups, // Store groups for UI
            resources: flatResources // Store flat for logic
            ));
      } else {
        emit(state.copyWith(
            isLoadingResources: false, resources: [], resourceGroups: []));
      }
    } catch (e) {
      emit(state.copyWith(
          isLoadingResources: false,
          status: RoomStatus.failure,
          message: "Lỗi tìm máy: $e"));
    }
  }

  Future<void> _onToggleResource(
      ToggleResource event, Emitter<CreateRoomState> emit) async {
    if (!event.resource.isAvailable) return;
    List<StationResourceModel> currentSelected =
        List.from(state.selectedResources);
    if (currentSelected
        .any((e) => e.stationResourceId == event.resource.stationResourceId)) {
      currentSelected.removeWhere(
          (e) => e.stationResourceId == event.resource.stationResourceId);
    } else {
      currentSelected.add(event.resource);
    }

    bool canHold = false;
    int holdingDays = 1;
    int maxDays = 1;

    if (currentSelected.isNotEmpty) {
      try {
        String begin = state.selectedTimeSlot!.begin!;
        int beginH = int.parse(begin.split(':')[0]);
        String end =
            "${(beginH + state.duration.toInt()).toString().padLeft(2, '0')}:00:00";

        final req = RequestAvailableScheduleModel(
          stationId: state.selectedStation!.stationId!,
          dateFrom: state.selectedSchedule!.date!,
          begin: begin,
          end: end,
          stationResourceId:
              currentSelected.map((e) => e.stationResourceId!).toList(),
        );

        final res = await _repo.findScheduleAvailable(req);
        if (res['success'] == true && res['body']['data'] != null) {
          final list =
              ScheduleListModelResponse.fromMap(res['body']).data ?? [];
          if (list.isNotEmpty) {
            // Tính số ngày liên tiếp
            list.sort((a, b) => (a.date ?? "").compareTo(b.date ?? ""));

            DateTime start = DateTime.parse(state.selectedSchedule!.date!);
            int consecutiveCount = 0;

            for (var schedule in list) {
              DateTime current = DateTime.parse(schedule.date!);
              if (current.difference(start).inDays == consecutiveCount) {
                consecutiveCount++;
              } else {
                break;
              }
            }

            maxDays = consecutiveCount > 0 ? consecutiveCount : 1;
            canHold = maxDays > 1;
          }
        }
      } catch (_) {}
    }

    // Reset holding days if exceeds max
    if (holdingDays > maxDays) holdingDays = 1;

    emit(state.copyWith(
        selectedResources: currentSelected,
        canHold: canHold,
        maxHoldingDays: maxDays,
        holdingDays: holdingDays));
  }

  Future<void> _onSubmitBooking(
      SubmitBooking event, Emitter<CreateRoomState> emit) async {
    if (state.selectedStation == null) {
      emit(state.copyWith(
          status: RoomStatus.failure, message: "Chưa chọn Trạm"));
      return;
    }
    if (state.selectedResources.isEmpty) {
      emit(state.copyWith(
          status: RoomStatus.failure,
          message: "Vui lòng chọn ít nhất 1 máy/ghế"));
      return;
    }

    var resourceTypeCode = state.selectedSpace?.spaceCode;
    var resourceTypeName = state.selectedSpace?.spaceName;
    try {
      String code = resourceTypeCode?.toUpperCase() ?? "";

      if (['PC', 'NET', 'INTERNET'].any((e) => code.contains(e))) {
        resourceTypeCode = "PC";
      } else if (['BIDA', 'BILLIARD', 'POOL'].any((e) => code.contains(e))) {
        resourceTypeCode = "BILLIARD";
      } else if (['CONSOLE', 'PS', 'PLAYSTATION']
          .any((e) => code.contains(e))) {
        resourceTypeCode = "CONSOLE";
      }
    } catch (_) {}

    // Construct MatchMakingModel
    String getPaymentName(String code) {
      switch (code) {
        case 'WALLET':
          return 'Ví hệ thống';
        case 'BANK_TRANSFER':
          return 'Chuyển khoản (QR)';
        case 'DIRECT':
          return 'Tiền mặt';
        default:
          return 'Khác';
      }
    }

    try {
      // Calculate Time Slot IDs
      int startIndex = state.timeSlots.indexWhere(
          (t) => t.timeSlotId == state.selectedTimeSlot!.timeSlotId);
      List<Map<String, dynamic>> slots = [];
      if (startIndex != -1) {
        for (int i = 0; i < state.duration.toInt(); i++) {
          if (startIndex + i < state.timeSlots.length) {
            slots.add({
              "id": {"timeSlotId": state.timeSlots[startIndex + i].timeSlotId}
            });
          }
        }
      }

      // Calculate Schedules List based on Holding Days
      List<Map<String, dynamic>> schedules = [];
      if (state.selectedSchedule != null && state.schedules.isNotEmpty) {
        int startSchIndex = state.schedules.indexWhere(
            (s) => s.scheduleId == state.selectedSchedule!.scheduleId);
        if (startSchIndex != -1) {
          for (int i = 0; i < state.holdingDays; i++) {
            if (startSchIndex + i < state.schedules.length) {
              schedules.add({
                "id": {
                  "scheduleId": state.schedules[startSchIndex + i].scheduleId
                }
              });
            }
          }
        }
      }

      // Construct Resources
      List<Map<String, dynamic>> resources = state.selectedResources
          .map((r) => {
                "id": {"stationResourceId": r.stationResourceId}
              })
          .toList();

      final bookingRequest = MatchMakingModel(
          stationId: state.selectedStation!.stationId,
          resourceTypeCode: resourceTypeCode,
          resourceTypeName: resourceTypeName,
          paymentMethodCode: state.paymentMethod,
          paymentMethodName: getPaymentName(state.paymentMethod),
          slots: slots,
          resources: resources,
          schedules: schedules,
          gameId: state.selectedGame?.gameId);

      final res = await _repo.createMatchMaking(bookingRequest);

      if (res['success'] == true) {
        int? matchMakingId = res['body']['data'] as int;
        emit(state.copyWith(
          status: RoomStatus.success,
          createdMatchMakingId: matchMakingId,
          message: "Đặt phòng thành công! - Id:$matchMakingId",
        ));
      } else {
        emit(state.copyWith(
            status: RoomStatus.failure, message: res['message']));
        DebugLogger.printLog(res['message']);
      }
    } catch (e) {
      emit(state.copyWith(
          status: RoomStatus.failure, message: "Lỗi đặt phòng: $e"));
      DebugLogger.printLog("Lỗi đặt phòng: $e");
    }
  }
}
