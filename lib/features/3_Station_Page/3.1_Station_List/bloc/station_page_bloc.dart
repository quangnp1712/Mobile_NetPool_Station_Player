import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_netpool_station_player/core/services/location_service.dart';
import 'package:mobile_netpool_station_player/core/utils/debug_logger.dart';
import 'package:mobile_netpool_station_player/core/utils/utf8_encoding.dart';
import 'package:mobile_netpool_station_player/features/3_Station_Page/3.1_Station_List/models/1_station/station_model.dart';
import 'package:mobile_netpool_station_player/features/3_Station_Page/3.1_Station_List/models/1_station/station_response_model.dart';
import 'package:mobile_netpool_station_player/features/3_Station_Page/3.1_Station_List/models/2_space/space_model.dart';
import 'package:mobile_netpool_station_player/features/3_Station_Page/3.1_Station_List/models/2_space/space_response_model.dart';
import 'package:mobile_netpool_station_player/features/3_Station_Page/3.1_Station_List/models/2_space/station_space_model.dart';
import 'package:mobile_netpool_station_player/features/3_Station_Page/3.1_Station_List/models/2_space/station_space_response_model.dart';
import 'package:mobile_netpool_station_player/features/3_Station_Page/3.1_Station_List/repository/booking_repository.dart';
import 'package:mobile_netpool_station_player/features/Common/data/city_controller/city_model.dart';
import 'package:mobile_netpool_station_player/features/Common/data/city_controller/city_repository.dart';

part 'station_page_event.dart';
part 'station_page_state.dart';

class StationPageBloc extends Bloc<StationPageEvent, StationPageState> {
  StationPageBloc() : super(StationPageState()) {
    on<InitStationPageEvent>(_onInit);
    on<FetchStationsEvent>(_onFetchStations);
    on<SearchStationEvent>(_onSearch);
    on<SelectProvinceEvent>(_onSelectProvince);
    on<SelectDistrictEvent>(_onSelectDistrict);
    on<SelectTagEvent>(_onSelectTag);
    on<FindNearestStationEvent>(_onFindNearest);
    on<ResetFilterEvent>(_onResetFilter);
    on<ChangePageEvent>(_onChangePage);
  }
  Future<void> _onInit(
      InitStationPageEvent event, Emitter<StationPageState> emit) async {
    emit(state.copyWith(status: StationStatus.loading));

    try {
      //! 1. Load Provinces
      List<ProvinceModel> provinces = [];
      try {
        var results = await CityRepository().getProvinces();
        var responseMessage = results['message'];
        var responseStatus = results['status'];
        var responseSuccess = results['success'];
        var responseBody = results['body'];
        if (responseSuccess || responseStatus == 200) {
          provinces = (responseBody as List)
              .map((e) => ProvinceModel.fromJson(e as Map<String, dynamic>))
              .toList();
          provinces.map((name) => Utf8Encoding().decode(name as String));
        } else {
          DebugLogger.printLog("Lỗi tải Tỉnh/TP");
        }
      } catch (e) {
        DebugLogger.printLog("Lỗi tải Tỉnh/TP: $e");
      }
      //! 2. Load Platform Spaces
      List<PlatformSpaceModel> platformSpaces = [];
      try {
        var resultsPlatformSpaces =
            await StationRepository().getPlatformSpace();
        var responseMessagePlatformSpaces = resultsPlatformSpaces['message'];
        var responseStatusPlatformSpaces = resultsPlatformSpaces['status'];
        var responseSuccessPlatformSpaces = resultsPlatformSpaces['success'];
        var responseBodyPlatformSpaces = resultsPlatformSpaces['body'];

        if (responseSuccessPlatformSpaces ||
            responseStatusPlatformSpaces == 200) {
          SpaceListModelResponse resultsBodyPlatformSpaces =
              SpaceListModelResponse.fromJson(responseBodyPlatformSpaces);

          if (resultsBodyPlatformSpaces.data != null) {
            try {
              platformSpaces = resultsBodyPlatformSpaces.data!;
            } catch (e) {
              platformSpaces = [];
            }
          }
        }
      } catch (e) {
        DebugLogger.printLog("Lỗi tải Platform Spaces: $e");
      }

      //! 3 Load Stations
      List<StationDetailModel> allStations = [];
      try {
        int current = 0; // Chuyển 1->0, 2->1...

        String search = "";

        String province = "";

        String commune = "";

        String district = "";

        String statusCode = "ACTIVE";

        String pageSize = "10";

        var results = await StationRepository().listStation(search, province,
            commune, district, statusCode, current.toString(), pageSize);

        var responseMessage = results['message'];
        var responseStatus = results['status'];
        var responseSuccess = results['success'];
        var responseBody = results['body'];

        StationListMetaModel? meta;
        if (responseSuccess) {
          StationDetailModelResponse stationDetailModelResponse =
              StationDetailModelResponse.fromJson(responseBody);
          meta = stationDetailModelResponse.meta;
          if (stationDetailModelResponse.data != null) {
            if (stationDetailModelResponse.data!.isNotEmpty) {
              allStations = stationDetailModelResponse.data!;
            }
          }
        }
      } catch (e) {
        DebugLogger.printLog("Lỗi tải Platform Spaces: $e");
      }
      //! 4 Load STATION SPACE
      if (allStations.isNotEmpty) {
        for (var station in allStations) {
          List<StationSpaceModel> spaces = [];
          var resultsSpace = await StationRepository()
              .getStationSpace(station.stationId.toString());
          var responseMessageSpace = resultsSpace['message'];
          var responseStatusSpace = resultsSpace['status'];
          var responseSuccessSpace = resultsSpace['success'];
          var responseBodySpace = resultsSpace['body'];
          if (responseSuccessSpace || responseStatusSpace == 200) {
            StationSpaceListModelResponse resultsBodySpace =
                StationSpaceListModelResponse.fromJson(responseBodySpace);
            if (resultsBodySpace.data != null) {
              try {
                spaces = resultsBodySpace.data!;
                if (platformSpaces.isNotEmpty && spaces.isNotEmpty) {
                  final platformMap = {
                    for (var p in platformSpaces) p.spaceId: p
                  };

                  for (var space in spaces) {
                    // Tìm kiếm trong Map cực nhanh
                    PlatformSpaceModel? platform = platformMap[space.spaceId];

                    if (platform != null) {
                      space.space = platform;
                    }
                  }
                  station.space = spaces;
                }
              } catch (e) {
                spaces = [];
              }
            }
          }
        }
      }

      emit(state.copyWith(
        status: StationStatus.success,
        stations: allStations,
        provinces: provinces,
        platformSpaces: platformSpaces,
      ));
    } catch (e) {
      DebugLogger.printLog("Error loading data: $e");
      emit(state.copyWith(
        status: StationStatus.failure,
        message: "Lỗi! Vui lòng thử lại",
      ));
    }
  }

  Future<void> _onFetchStations(
      FetchStationsEvent event, Emitter<StationPageState> emit) async {
    emit(state.copyWith(status: StationStatus.loading));
    DebugLogger.printLog("_onFetchStations");
    try {
      //! 1. Prepare params from State
      int current = state.currentPage;
      String search = state.searchText;
      String province = state.selectedProvince?.name ?? "";
      String commune = ""; // Not used yet
      String district = state.selectedDistrict?.name ?? "";
      String statusCode = "ACTIVE";
      String pageSize = state.pageSize.toString();
      String tag = state.selectedTag == "All"
          ? ""
          : state.selectedTag; // Pass tag to API if needed (Custom logic)

      // Lấy location từ state nếu có
      double? lat = state.latitude;
      double? long = state.longitude;

      //! 2. Call API Station
      var results = await StationRepository().listStation(search, province,
          commune, district, statusCode, current.toString(), pageSize);

      var responseMessage = results['message'];
      var responseStatus = results['status'];
      var responseSuccess = results['success'];
      var responseBody = results['body'];

      List<StationDetailModel> allStations = [];
      StationListMetaModel? meta;

      if (responseSuccess) {
        StationDetailModelResponse stationDetailModelResponse =
            StationDetailModelResponse.fromJson(responseBody);
        meta = stationDetailModelResponse.meta;
        if (stationDetailModelResponse.data != null) {
          if (stationDetailModelResponse.data!.isNotEmpty) {
            allStations = stationDetailModelResponse.data!;
          }
        }
      }

      //! 4 Load STATION SPACE
      if (allStations.isNotEmpty) {
        for (var station in allStations) {
          List<StationSpaceModel> spaces = [];
          var resultsSpace = await StationRepository()
              .getStationSpace(station.stationId.toString());
          var responseMessageSpace = resultsSpace['message'];
          var responseStatusSpace = resultsSpace['status'];
          var responseSuccessSpace = resultsSpace['success'];
          var responseBodySpace = resultsSpace['body'];
          if (responseSuccessSpace || responseStatusSpace == 200) {
            StationSpaceListModelResponse resultsBodySpace =
                StationSpaceListModelResponse.fromJson(responseBodySpace);
            if (resultsBodySpace.data != null) {
              try {
                spaces = resultsBodySpace.data!;
                if (state.platformSpaces.isNotEmpty && spaces.isNotEmpty) {
                  final platformMap = {
                    for (var p in state.platformSpaces) p.spaceId: p
                  };

                  for (var space in spaces) {
                    // Tìm kiếm trong Map cực nhanh
                    PlatformSpaceModel? platform = platformMap[space.spaceId];

                    if (platform != null) {
                      space.space = platform;
                    }
                  }
                  station.space = spaces;
                }
              } catch (e) {
                spaces = [];
              }
            }
          }
        }
      }
      // Sau khi fetch xong, áp dụng local filter theo tag hiện tại
      List<StationDetailModel> finalStations =
          _applyLocalTagFilter(allStations, state.selectedTag);
      emit(state.copyWith(
        status: StationStatus.success,
        fetchedStations: allStations, // Lưu danh sách gốc
        stations: finalStations, // Lưu danh sách hiển thị
        totalItems: meta?.total ?? 0,
        // currentPage giữ nguyên hoặc update từ meta nếu API trả về
      ));
    } catch (e) {
      DebugLogger.printLog("Error fetching stations: $e");
      emit(state.copyWith(
        status: StationStatus.failure,
        message: "Lỗi! Vui lòng thử lại",
      ));
    }
  }

  // Hàm lọc Tag local
  List<StationDetailModel> _applyLocalTagFilter(
      List<StationDetailModel> stations, String tag) {
    if (tag == "All" || tag.isEmpty) return stations;

    return stations.where((s) {
      if (s.space == null || s.space!.isEmpty) return false;
      return s.space!.any(
          (space) => space.space?.typeName?.toUpperCase() == tag.toUpperCase());
    }).toList();
  }

  void _onSearch(SearchStationEvent event, Emitter<StationPageState> emit) {
    // Reset về trang 0 khi search
    emit(state.copyWith(
      searchText: event.query,
      currentPage: 0,
      blocState: StationBlocState.onFetchStations,
    ));
  }

  Future<void> _onSelectProvince(
      SelectProvinceEvent event, Emitter<StationPageState> emit) async {
    // Khi chọn tỉnh, load quận huyện của tỉnh đó
    emit(state.copyWith(status: StationStatus.loading));

    //! call api districts
    try {
      var results = await CityRepository().getDistricts(event.province.code);
      var responseMessage = results['message'];
      var responseStatus = results['status'];
      var responseSuccess = results['success'];
      var responseBody = results['body'];
      if (responseSuccess || responseStatus == 200) {
        List<DistrictModel> districts = (responseBody["districts"] as List)
            .map((e) => DistrictModel.fromJson(e as Map<String, dynamic>))
            .toList();
        districts.map((name) => Utf8Encoding().decode(name as String));

        emit(StationPageState(
          status: state.status,
          fetchedStations: [],
          stations: [],
          provinces: state.provinces,
          districts: districts,
          platformSpaces: state.platformSpaces,
          searchText: state.searchText,
          selectedProvince: event.province,
          selectedDistrict: null,
          selectedTag: state.selectedTag, // Giữ tag đang chọn
          isNearMe: state.isNearMe,
          currentPage: 0,
          pageSize: state.pageSize,
          totalItems: state.totalItems,
          blocState: StationBlocState.onFetchStations,
        ));
      } else {
        emit(StationPageState(
          fetchedStations: [],
          stations: [],
          provinces: state.provinces,
          districts: [],
          platformSpaces: state.platformSpaces,
          searchText: state.searchText,
          selectedProvince: event.province,
          selectedDistrict: null,
          selectedTag: state.selectedTag, // Giữ tag đang chọn
          isNearMe: state.isNearMe,
          currentPage: 0,
          pageSize: state.pageSize,
          totalItems: state.totalItems,
          status: StationStatus.failure,
          message: "Lỗi! Vui lòng thử lại",
        ));

        DebugLogger.printLog("Lỗi tải Quận/Huyện");
      }
    } catch (e) {
      emit(StationPageState(
        fetchedStations: [],
        stations: [],
        provinces: state.provinces,
        districts: [],
        platformSpaces: state.platformSpaces,
        searchText: state.searchText,
        selectedProvince: event.province,
        selectedDistrict: null,
        selectedTag: state.selectedTag, // Giữ tag đang chọn
        isNearMe: state.isNearMe,
        currentPage: 0,
        pageSize: state.pageSize,
        totalItems: state.totalItems,

        status: StationStatus.failure,
        message: "Lỗi! Vui lòng thử lại",
      ));

      DebugLogger.printLog("Lỗi tải Quận/Huyện: $e");
    }
  }

  void _onSelectDistrict(
      SelectDistrictEvent event, Emitter<StationPageState> emit) {
    emit(state.copyWith(
      selectedDistrict: event.district,
      currentPage: 0,
      blocState: StationBlocState.onFetchStations,
    ));
  }

  void _onSelectTag(SelectTagEvent event, Emitter<StationPageState> emit) {
    final newTag = event.tag;
    List<StationDetailModel> filtered =
        _applyLocalTagFilter(state.fetchedStations, newTag);

    emit(state.copyWith(
      selectedTag: newTag,
      stations: filtered, // Chỉ update danh sách hiển thị
      // Lưu ý: currentPage giữ nguyên vì đang lọc trên trang hiện tại
    ));
  }

  Future<void> _onFindNearest(
      FindNearestStationEvent event, Emitter<StationPageState> emit) async {
    //  Tắt đi và reset
    if (state.isNearMe) {
      emit(state.copyWith(
        isNearMe: false,
        latitude: null,
        longitude: null,
        currentPage: 0,
      ));
      add(FetchStationsEvent());
    } else {
      //  Bật lên, lấy vị trí rồi gọi API
      emit(state.copyWith(status: StationStatus.loading));
      try {
        final position = await LocationService().getUserCurrentLocation();
        if (position != null) {
          // Ép kiểu dynamic về Position của Geolocator
          double lat = 0;
          double long = 0;
          if (position is Position) {
            lat = position.latitude;
            long = position.longitude;
          }

          emit(state.copyWith(
            isNearMe: true,
            latitude: lat,
            longitude: long,
            currentPage: 0,
          ));
          add(FetchStationsEvent());
        } else {
          emit(state.copyWith(
              status: StationStatus.failure,
              message:
                  "Không thể lấy vị trí. Vui lòng kiểm tra quyền truy cập.",
              isNearMe: false));
        }
      } catch (e) {
        emit(state.copyWith(
            status: StationStatus.failure,
            message: "Lỗi lấy vị trí: $e",
            isNearMe: false));
      }
    }
  }

  void _onResetFilter(ResetFilterEvent event, Emitter<StationPageState> emit) {
    // Reset toàn bộ filter, giữ lại danh sách tĩnh (provinces, platformSpaces)
    emit(StationPageState(
      status: state.status,
      fetchedStations: [],
      stations: [],
      provinces: state.provinces,
      districts: [],
      platformSpaces: state.platformSpaces,
      searchText: '',
      selectedProvince: null,
      selectedDistrict: null,
      selectedTag: 'All',
      isNearMe: false,
      currentPage: 0,
      pageSize: 10,
      totalItems: 0,
      blocState: StationBlocState.onFetchStations,
    ));
  }

  void _onChangePage(ChangePageEvent event, Emitter<StationPageState> emit) {
    emit(state.copyWith(
      currentPage: event.pageIndex,
      blocState: StationBlocState.onFetchStations,
    ));
  }
}
