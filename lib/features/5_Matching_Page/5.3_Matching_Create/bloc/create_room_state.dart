part of 'create_room_bloc.dart';

enum RoomStatus { initial, loading, success, failure }

class CreateRoomState extends Equatable {
  final RoomStatus status;
  final String message;

  // Data
  final List<StationDetailModel> stations;
  final List<String> provinces;
  final List<String> districts;
  final List<StationSpaceModel> spaces;
  final List<GameModel> games;
  final List<ScheduleModel> schedules;
  final List<TimeslotModel> timeSlots;
  final List<AreaModel> areas;
  final List<StationResourceModel> resources;
  final List<ResourceGroupModel> resourceGroups;

  // Filters & Pagination
  final int currentPage;
  final int totalItems;
  final int pageSize;
  final String searchQuery;
  final String? userLat;
  final String? userLong;

  // Selections
  final StationDetailModel? selectedStation;
  final String? selectedProvince;
  final String? selectedDistrict;
  final StationSpaceModel? selectedSpace;
  final GameModel? selectedGame;
  final ScheduleModel? selectedSchedule;
  final TimeslotModel? selectedTimeSlot;
  final AreaModel? selectedArea;
  final List<StationResourceModel> selectedResources;

  // Logic & Payment
  final double duration;
  final int holdingDays;
  final int maxHoldingDays;
  final bool canHold;
  final bool isLoadingResources;
  final String paymentMethod;
  final double userBalance;

  final int? createdMatchMakingId;

  const CreateRoomState({
    this.status = RoomStatus.initial,
    this.message = '',
    this.stations = const [],
    this.provinces = const [],
    this.districts = const [],
    this.spaces = const [],
    this.games = const [],
    this.schedules = const [],
    this.timeSlots = const [],
    this.areas = const [],
    this.resources = const [],
    this.resourceGroups = const [],
    this.currentPage = 0,
    this.totalItems = 0,
    this.pageSize = 10,
    this.searchQuery = '',
    this.userLat,
    this.userLong,
    this.selectedStation,
    this.selectedProvince,
    this.selectedDistrict,
    this.selectedSpace,
    this.selectedGame,
    this.selectedSchedule,
    this.selectedTimeSlot,
    this.selectedArea,
    this.selectedResources = const [],
    this.duration = 1.0,
    this.holdingDays = 1,
    this.maxHoldingDays = 1,
    this.canHold = false,
    this.isLoadingResources = false,
    this.paymentMethod = 'WALLET',
    this.userBalance = 0.0, // Mock Balance
    this.createdMatchMakingId,
  });

  CreateRoomState copyWith({
    RoomStatus? status,
    String? message,
    List<StationDetailModel>? stations,
    List<String>? provinces,
    List<String>? districts,
    List<StationSpaceModel>? spaces,
    List<GameModel>? games,
    List<ScheduleModel>? schedules,
    List<TimeslotModel>? timeSlots,
    List<AreaModel>? areas,
    List<StationResourceModel>? resources,
    List<ResourceGroupModel>? resourceGroups,
    int? currentPage,
    int? totalItems,
    String? searchQuery,
    String? userLat,
    String? userLong,
    StationDetailModel? selectedStation,
    String? selectedProvince,
    String? selectedDistrict,
    StationSpaceModel? selectedSpace,
    GameModel? selectedGame,
    ScheduleModel? selectedSchedule,
    TimeslotModel? selectedTimeSlot,
    AreaModel? selectedArea,
    List<StationResourceModel>? selectedResources,
    double? duration,
    int? holdingDays,
    int? maxHoldingDays,
    bool? canHold,
    bool? isLoadingResources,
    String? paymentMethod,
    double? userBalance,
    bool clearSelectedProvince = false,
    bool clearSelectedDistrict = false,
    bool clearSchedule = false,
    int? createdMatchMakingId,
  }) {
    return CreateRoomState(
      status: status ?? RoomStatus.initial,
      message: message ?? '',
      stations: stations ?? this.stations,
      provinces: provinces ?? this.provinces,
      districts: districts ?? this.districts,
      spaces: spaces ?? this.spaces,
      games: games ?? this.games,
      schedules: clearSchedule ? [] : (schedules ?? this.schedules),
      timeSlots: clearSchedule ? [] : (timeSlots ?? this.timeSlots),
      areas: areas ?? this.areas,
      resources: resources ?? this.resources,
      resourceGroups: resourceGroups ?? this.resourceGroups,
      currentPage: currentPage ?? this.currentPage,
      totalItems: totalItems ?? this.totalItems,
      searchQuery: searchQuery ?? this.searchQuery,
      userLat: userLat ?? this.userLat,
      userLong: userLong ?? this.userLong,
      selectedStation: selectedStation ?? this.selectedStation,
      selectedProvince: clearSelectedProvince
          ? null
          : (selectedProvince ?? this.selectedProvince),
      selectedDistrict: clearSelectedDistrict
          ? null
          : (selectedDistrict ?? this.selectedDistrict),
      selectedSpace: selectedSpace ?? this.selectedSpace,
      selectedGame: selectedGame ?? this.selectedGame,
      selectedSchedule:
          clearSchedule ? null : (selectedSchedule ?? this.selectedSchedule),
      selectedTimeSlot:
          clearSchedule ? null : (selectedTimeSlot ?? this.selectedTimeSlot),
      selectedArea: selectedArea ?? this.selectedArea,
      selectedResources: selectedResources ?? this.selectedResources,
      duration: duration ?? this.duration,
      holdingDays: holdingDays ?? this.holdingDays,
      maxHoldingDays: maxHoldingDays ?? this.maxHoldingDays,
      canHold: canHold ?? this.canHold,
      isLoadingResources: isLoadingResources ?? this.isLoadingResources,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      userBalance: userBalance ?? this.userBalance,
      createdMatchMakingId: createdMatchMakingId ?? this.createdMatchMakingId,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        stations,
        provinces,
        districts,
        spaces,
        games,
        schedules,
        timeSlots,
        areas,
        resources,
        resourceGroups,
        currentPage,
        totalItems,
        pageSize,
        searchQuery,
        userLat,
        userLong,
        selectedStation,
        selectedProvince,
        selectedDistrict,
        selectedSpace,
        selectedGame,
        selectedSchedule,
        selectedTimeSlot,
        selectedArea,
        selectedResources,
        duration,
        holdingDays,
        maxHoldingDays,
        canHold,
        isLoadingResources,
        paymentMethod,
        createdMatchMakingId,
        userBalance
      ];
}
