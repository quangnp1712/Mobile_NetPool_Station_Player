part of 'booking_page_bloc.dart';

// status
enum BookingStatus { initial, loading, success, failure }

// blocState
enum BookingBlocState { initial, locationErrorState, filterResetState }

class BookingPageState extends Equatable {
  final BookingBlocState blocState;
  final BookingStatus status;
  final String message;

  final bool isSelectingStation;

  // Station Selection & Pagination Data
  final List<StationDetailModel>
      filteredStations; // Danh sách hiển thị hiện tại
  final bool hasReachedMaxStations; // Đã tải hết tất cả trang chưa
  final int currentPage; // 'current' trong meta
  final int totalItems; // 'total' trong meta
  final int pageSize; // 'pageSize' trong meta
  final String searchQuery; // Lưu lại để dùng khi LoadMore

  // Location Filters
  final List<ProvinceModel> provinces;
  final List<DistrictModel> districts;
  final ProvinceModel? selectedProvince;
  final DistrictModel? selectedDistrict;

  final StationDetailModel? selectedStation;
  final StationSpaceModel? selectedSpace;
  final AreaModel? selectedArea;

  final int selectedDateIndex;
  final String selectedTime;
  final double duration;
  final String? bookingType;
  final List<String> selectedResourceCodes;
  final List<ResourceRow> resourceRows;

  // Data Lists
  final List<StationSpaceModel> spaces;
  final List<AreaModel> areas;
  final List<PlatformSpaceModel> platformSpaces;

  const BookingPageState({
    this.blocState = BookingBlocState.initial,
    this.status = BookingStatus.initial,
    this.message = '',
    this.isSelectingStation = true,
    this.filteredStations = const [],
    this.hasReachedMaxStations = false,
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
    this.selectedTime = '14:00',
    this.duration = 2.0,
    this.bookingType,
    this.selectedResourceCodes = const [],
    this.resourceRows = const [],
    this.spaces = const [],
    this.areas = const [],
    this.platformSpaces = const [],
  });

  double get totalPrice {
    int machineCount =
        selectedResourceCodes.isEmpty ? 1 : selectedResourceCodes.length;
    return duration * (selectedArea?.price ?? 0) * machineCount;
  }

  String get endTime {
    List<String> parts = selectedTime.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);
    double totalHours = hour + (minute / 60.0) + duration;
    int endHour = totalHours.floor() % 24;
    int endMinute = ((totalHours - totalHours.floor()) * 60).round();
    return "${endHour.toString().padLeft(2, '0')}:${endMinute.toString().padLeft(2, '0')}";
  }

  BookingPageState copyWith({
    BookingBlocState? blocState,
    BookingStatus? status,
    String? message,
    bool? isSelectingStation,
    List<StationDetailModel>? filteredStations,
    bool? hasReachedMaxStations,
    int? currentPage,
    int? totalItems,
    int? pageSize,
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
    List<ResourceRow>? resourceRows,
    List<StationSpaceModel>? spaces,
    List<AreaModel>? areas,
    List<PlatformSpaceModel>? platformSpaces,
  }) {
    return BookingPageState(
      blocState: blocState ?? this.blocState,
      status: status ?? this.status,
      message: message ?? this.message,
      isSelectingStation: isSelectingStation ?? this.isSelectingStation,
      filteredStations: filteredStations ?? this.filteredStations,
      hasReachedMaxStations:
          hasReachedMaxStations ?? this.hasReachedMaxStations,
      currentPage: currentPage ?? this.currentPage,
      totalItems: totalItems ?? this.totalItems,
      pageSize: pageSize ?? this.pageSize,
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
      resourceRows: resourceRows ?? this.resourceRows,
      spaces: spaces ?? this.spaces,
      areas: areas ?? this.areas,
      platformSpaces: platformSpaces ?? this.platformSpaces,
    );
  }

  @override
  List<Object?> get props => [
        blocState,
        status,
        message,
        isSelectingStation,
        filteredStations,
        hasReachedMaxStations,
        currentPage,
        totalItems,
        pageSize,
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
        resourceRows,
        spaces,
        areas,
        platformSpaces,
      ];
}
