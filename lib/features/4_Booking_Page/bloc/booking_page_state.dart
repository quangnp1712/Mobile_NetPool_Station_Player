part of 'booking_page_bloc.dart';

// status
enum BookingStatus { initial, loading, success, failure }

// blocState
enum BookingBlocState {
  initial,
  locationErrorState,
  filterResetState,
  unauthenticated
}

class BookingPageState extends Equatable {
  final BookingBlocState blocState;
  final BookingStatus status;
  final String message;
  final bool isSelectingStation;

  // Data
  final List<StationDetailModel> filteredStations;
  final int currentPage;
  final int totalItems;
  final int pageSize;
  final String searchQuery;
  final List<ProvinceModel> provinces;
  final List<DistrictModel> districts;
  final ProvinceModel? selectedProvince;
  final DistrictModel? selectedDistrict;

  // Selection
  final StationDetailModel? selectedStation;
  final StationSpaceModel? selectedSpace;
  final AreaModel? selectedArea;
  final int selectedDateIndex;
  final String selectedTime;
  final double duration;
  final String? bookingType;
  final List<String> selectedResourceCodes;

  // Lists
  final List<ScheduleModel> schedules;
  final List<StationSpaceModel> spaces;
  final List<AreaModel> areas;
  final List<PlatformSpaceModel> platformSpaces;
  final List<StationResourceModel> resources;
  final List<TimeslotModel> availableTimes;

  final int? userBalance;

  const BookingPageState({
    this.blocState = BookingBlocState.initial,
    this.status = BookingStatus.initial,
    this.message = '',
    this.isSelectingStation = true,
    this.filteredStations = const [],
    this.currentPage = 0,
    this.totalItems = 0,
    this.pageSize = 10,
    this.searchQuery = '',
    this.provinces = const [],
    this.districts = const [],
    this.selectedProvince,
    this.selectedDistrict,
    this.selectedStation,
    this.selectedSpace,
    this.selectedArea,
    this.selectedDateIndex = 0,
    this.selectedTime = '', // KHÔNG CHỌN MẶC ĐỊNH
    this.duration = 1.0,
    this.bookingType,
    this.selectedResourceCodes = const [],
    this.schedules = const [],
    this.spaces = const [],
    this.areas = const [],
    this.platformSpaces = const [],
    this.resources = const [],
    this.availableTimes = const [],
    this.userBalance = 0,
  });

  double get totalPrice {
    int count =
        selectedResourceCodes.isEmpty ? 1 : selectedResourceCodes.length;
    return duration * (selectedArea?.price ?? 0) * count;
  }

  String get endTime {
    if (selectedTime.isEmpty) return "--:--";
    List<String> parts = selectedTime.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);
    double total = hour + (minute / 60.0) + duration;
    int endH = total.floor() % 24;
    int endM = ((total - total.floor()) * 60).round();
    return "${endH.toString().padLeft(2, '0')}:${endM.toString().padLeft(2, '0')}";
  }

  BookingPageState copyWith({
    BookingBlocState? blocState,
    BookingStatus? status,
    String? message,
    bool? isSelectingStation,
    List<StationDetailModel>? filteredStations,
    int? currentPage,
    int? totalItems,
    String? searchQuery,
    List<ProvinceModel>? provinces,
    List<DistrictModel>? districts,
    ProvinceModel? selectedProvince,
    bool clearSelectedProvince = false,
    DistrictModel? selectedDistrict,
    bool clearSelectedDistrict = false,
    StationDetailModel? selectedStation,
    StationSpaceModel? selectedSpace,
    AreaModel? selectedArea,
    int? selectedDateIndex,
    String? selectedTime,
    double? duration,
    String? bookingType,
    bool clearBookingType = false,
    List<String>? selectedResourceCodes,
    List<ScheduleModel>? schedules,
    List<StationSpaceModel>? spaces,
    List<AreaModel>? areas,
    List<PlatformSpaceModel>? platformSpaces,
    List<StationResourceModel>? resources,
    List<TimeslotModel>? availableTimes,
    int? userBalance,
  }) {
    return BookingPageState(
      blocState: blocState ?? BookingBlocState.initial,
      status: status ?? BookingStatus.initial,
      message: message ?? this.message,
      isSelectingStation: isSelectingStation ?? this.isSelectingStation,
      filteredStations: filteredStations ?? this.filteredStations,
      currentPage: currentPage ?? this.currentPage,
      totalItems: totalItems ?? this.totalItems,
      searchQuery: searchQuery ?? this.searchQuery,
      provinces: provinces ?? this.provinces,
      districts: districts ?? this.districts,
      selectedProvince: clearSelectedProvince
          ? null
          : (selectedProvince ?? this.selectedProvince),
      selectedDistrict: clearSelectedDistrict
          ? null
          : (selectedDistrict ?? this.selectedDistrict),
      selectedStation: selectedStation ?? this.selectedStation,
      selectedSpace: selectedSpace ?? this.selectedSpace,
      selectedArea: selectedArea ?? this.selectedArea,
      selectedDateIndex: selectedDateIndex ?? this.selectedDateIndex,
      selectedTime: selectedTime ?? this.selectedTime,
      duration: duration ?? this.duration,
      bookingType: clearBookingType ? null : (bookingType ?? this.bookingType),
      selectedResourceCodes:
          selectedResourceCodes ?? this.selectedResourceCodes,
      schedules: schedules ?? this.schedules,
      spaces: spaces ?? this.spaces,
      areas: areas ?? this.areas,
      platformSpaces: platformSpaces ?? this.platformSpaces,
      resources: resources ?? this.resources,
      availableTimes: availableTimes ?? this.availableTimes,
      userBalance: userBalance ?? this.userBalance,
    );
  }

  @override
  List<Object?> get props => [
        blocState,
        status,
        message,
        isSelectingStation,
        filteredStations,
        currentPage,
        totalItems,
        searchQuery,
        provinces,
        districts,
        selectedProvince,
        selectedDistrict,
        selectedStation,
        selectedSpace,
        selectedArea,
        selectedDateIndex,
        selectedTime,
        duration,
        bookingType,
        selectedResourceCodes,
        resources,
        availableTimes,
        spaces,
        areas,
        userBalance
      ];
}
