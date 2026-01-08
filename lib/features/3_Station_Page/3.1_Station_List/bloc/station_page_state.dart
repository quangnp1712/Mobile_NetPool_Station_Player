part of 'station_page_bloc.dart';

enum StationStatus { initial, loading, success, failure }

enum StationBlocState {
  initial,
  onFetchStations,
}

class StationPageState extends Equatable {
  final StationStatus status;
  final StationBlocState blocState;
  final String message;

  // fetchedStations: Danh sách gốc lấy từ API về (cho trang hiện tại)
  final List<StationDetailModel> fetchedStations;
  // stations: Danh sách hiển thị sau khi đã lọc Tag local
  final List<StationDetailModel> stations;

  final List<ProvinceModel> provinces;
  final List<DistrictModel> districts;
  final List<PlatformSpaceModel> platformSpaces;

  final String searchText;
  final ProvinceModel? selectedProvince;
  final DistrictModel? selectedDistrict;
  final String selectedTag;
  final bool isNearMe;

  // Location Data
  final double? latitude;
  final double? longitude;

  final int currentPage;
  final int pageSize;
  final int totalItems;

  const StationPageState({
    this.status = StationStatus.initial,
    this.blocState = StationBlocState.initial,
    this.fetchedStations = const [],
    this.stations = const [],
    this.provinces = const [],
    this.districts = const [],
    this.platformSpaces = const [],
    this.searchText = '',
    this.message = '',
    this.selectedProvince,
    this.selectedDistrict,
    this.selectedTag = 'All',
    this.isNearMe = false,
    this.currentPage = 0,
    this.pageSize = 10,
    this.totalItems = 0,
    this.latitude,
    this.longitude,
  });

  StationPageState copyWith({
    StationStatus? status,
    StationBlocState? blocState,
    List<StationDetailModel>? fetchedStations,
    List<StationDetailModel>? stations,
    List<ProvinceModel>? provinces,
    List<DistrictModel>? districts,
    List<PlatformSpaceModel>? platformSpaces,
    String? searchText,
    String? message,
    ProvinceModel? selectedProvince,
    DistrictModel? selectedDistrict,
    String? selectedTag,
    bool? isNearMe,
    int? currentPage,
    int? pageSize,
    int? totalItems,
    double? latitude,
    double? longitude,
  }) {
    return StationPageState(
      status: status ?? StationStatus.initial,
      blocState: blocState ?? StationBlocState.initial,
      message: message ?? this.message,
      fetchedStations: fetchedStations ?? this.fetchedStations,
      stations: stations ?? this.stations,
      provinces: provinces ?? this.provinces,
      districts: districts ?? this.districts,
      platformSpaces: platformSpaces ?? this.platformSpaces,
      searchText: searchText ?? this.searchText,
      selectedProvince: selectedProvince ?? this.selectedProvince,
      selectedDistrict: selectedDistrict ?? this.selectedDistrict,
      selectedTag: selectedTag ?? this.selectedTag,
      isNearMe: isNearMe ?? this.isNearMe,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      totalItems: totalItems ?? this.totalItems,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  List<Object?> get props => [
        status,
        blocState,
        fetchedStations,
        stations,
        provinces,
        districts,
        platformSpaces,
        searchText,
        message,
        selectedProvince,
        selectedDistrict,
        selectedTag,
        isNearMe,
        currentPage,
        pageSize,
        totalItems,
        latitude,
        longitude,
      ];
}
