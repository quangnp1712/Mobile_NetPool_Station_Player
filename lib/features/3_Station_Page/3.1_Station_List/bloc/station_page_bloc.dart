// ignore_for_file: unused_catch_stack, unused_local_variable, depend_on_referenced_packages

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
    emit(state.copyWith(status: StationStatus.loading, message: ""));

    final stopwatch = Stopwatch()..start();

    bool isInitFinished = false;

    try {
      //! --- CƠ CHẾ THÔNG BÁO CHỜ ---
      Future.delayed(const Duration(seconds: 5)).then((_) {
        if (!isInitFinished && !emit.isDone) {
          emit(state.copyWith(
            status: StationStatus.loading,
            message: "Dữ liệu đang được xử lý, vui lòng đợi thêm chút nữa...",
          ));
        }
      });

      final results = await Future.wait([
        CityRepository().getProvinces(), // Index 0
        StationRepository().getPlatformSpace(), // Index 1
        StationRepository()
            .listStation("", "", "", "", "ACTIVE", "0", "5"), // Index 2
      ]);

      final provinces = _parseListResponse<ProvinceModel>(
              results[0], (json) => ProvinceModel.fromJson(json)) ??
          [];

      final platformSpaces = _parseListResponse<PlatformSpaceModel>(results[1],
              (json) => SpaceListModelResponse.fromJson(json).data ?? [],
              isWrapper: true) ??
          [];

      final platformMap = {for (var p in platformSpaces) p.spaceId: p};

      final stationResponse = _parseResponse<StationDetailModelResponse>(
          results[2], (json) => StationDetailModelResponse.fromJson(json));
      final allStations = stationResponse?.data ?? [];
      final meta = stationResponse?.meta;

      if (allStations.isNotEmpty) {
        final spaceFutures = allStations
            .map((station) => StationRepository()
                .getStationSpace(station.stationId.toString()))
            .toList();

        final spaceResults = await Future.wait(spaceFutures);

        for (int i = 0; i < allStations.length; i++) {
          final station = allStations[i];
          final result = spaceResults[i];

          final spaces = _parseListResponse<StationSpaceModel>(
                  result,
                  (json) =>
                      StationSpaceListModelResponse.fromJson(json).data ?? [],
                  isWrapper: true) ??
              [];

          if (spaces.isNotEmpty && platformMap.isNotEmpty) {
            for (var space in spaces) {
              space.space = platformMap[space.spaceId];
            }
            station.space = spaces;
          }
        }
      }

      isInitFinished = true;

      stopwatch.stop();
      DebugLogger.printLog(
          "🚀 Init Page hoàn tất: ${stopwatch.elapsedMilliseconds}ms");

      emit(state.copyWith(
        status: StationStatus.initial,
        stations: allStations,
        provinces: provinces,
        platformSpaces: platformSpaces,
        totalItems: meta?.total ?? 0,
        message: "",
      ));
    } catch (e, stackTrace) {
      isInitFinished = true;
      DebugLogger.printLog("Lỗi Init Station: $e\n$stackTrace");
      emit(state.copyWith(
        status: StationStatus.failure,
        message: "Lỗi khởi tạo dữ liệu, vui lòng thử lại!",
      ));
    }
  }

  T? _parseResponse<T>(
      dynamic result, T Function(Map<String, dynamic>) fromJson) {
    if (result['success'] == true || result['status'] == 200) {
      if (result['body'] != null) return fromJson(result['body']);
    }
    return null;
  }

  List<T>? _parseListResponse<T>(
      dynamic result, dynamic Function(dynamic) parser,
      {bool isWrapper = false}) {
    if (result['success'] == true || result['status'] == 200) {
      final body = result['body'];
      if (body != null) {
        try {
          if (isWrapper) {
            return parser(body) as List<T>;
          } else {
            return (body as List).map((e) => parser(e) as T).toList();
          }
        } catch (e) {
          DebugLogger.printLog("Parse Error ($T): $e");
        }
      }
    }
    return [];
  }

  Future<void> _onFetchStations(
      FetchStationsEvent event, Emitter<StationPageState> emit) async {
    emit(state.copyWith(status: StationStatus.loading, message: ""));

    final stopwatch = Stopwatch()..start();

    bool isTaskFinished = false;

    try {
      Future.delayed(const Duration(seconds: 5)).then((_) {
        if (!isTaskFinished && !emit.isDone) {
          emit(state.copyWith(
            status: StationStatus.loading,
            message: "Dữ liệu đang được xử lý, vui lòng đợi thêm chút nữa...",
          ));
        }
      });

      //! 1. Prepare params
      final params = _buildParams(state);

      //! 2. Call API Station
      final stationResult = await StationRepository().listStation(
          params['search'],
          params['province'],
          "",
          params['district'],
          "ACTIVE",
          params['current'],
          params['pageSize']);

      final stationResponse = _parseResponse<StationDetailModelResponse>(
          stationResult, (json) => StationDetailModelResponse.fromJson(json));

      final allStations = stationResponse?.data ?? [];
      final meta = stationResponse?.meta;

      //! 3. Batch Loading Station Space
      if (allStations.isNotEmpty) {
        final platformMap = state.platformSpaces.isNotEmpty
            ? {for (var p in state.platformSpaces) p.spaceId: p}
            : <int?, PlatformSpaceModel>{};

        final spaceFutures = allStations
            .map((station) => StationRepository()
                .getStationSpace(station.stationId.toString()))
            .toList();

        final spaceResults = await Future.wait(spaceFutures);

        for (int i = 0; i < allStations.length; i++) {
          final station = allStations[i];
          final result = spaceResults[i];

          final spaces = _parseListResponse<StationSpaceModel>(
                  result,
                  (json) =>
                      StationSpaceListModelResponse.fromJson(json).data ?? [],
                  isWrapper: true) ??
              [];

          if (spaces.isNotEmpty && platformMap.isNotEmpty) {
            for (var space in spaces) {
              space.space = platformMap[space.spaceId];
            }
          }
          station.space = spaces;
        }
      }

      isTaskFinished = true;

      //! 4. Apply Filter & Emit Success
      List<StationDetailModel> finalStations =
          _applyLocalTagFilter(allStations, state.selectedTag);

      stopwatch.stop();
      DebugLogger.printLog(
          "✅ Fetch hoàn tất: ${stopwatch.elapsedMilliseconds}ms");

      emit(state.copyWith(
        status: StationStatus.initial,
        fetchedStations: allStations,
        stations: finalStations,
        totalItems: meta?.total ?? 0,
        message: "",
      ));
    } catch (e, stackTrace) {
      isTaskFinished = true;
      DebugLogger.printLog("❌ Error: $e");
      emit(state.copyWith(
        status: StationStatus.failure,
        message: "Lỗi kết nối, vui lòng thử lại!",
      ));
    }
  }

  Map<String, dynamic> _buildParams(StationPageState state) {
    return {
      'current': state.currentPage.toString(),
      'search': state.searchText,
      'province': state.selectedProvince?.name ?? "",
      'district': state.selectedDistrict?.name ?? "",
      'pageSize': state.pageSize.toString(),
    };
  }

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
    emit(state.copyWith(
      searchText: event.query,
      currentPage: 0,
      blocState: StationBlocState.onFetchStations,
    ));
  }

  Future<void> _onSelectProvince(
      SelectProvinceEvent event, Emitter<StationPageState> emit) async {
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
          status: StationStatus.initial,
          message: "",
          fetchedStations: [],
          stations: [],
          provinces: state.provinces,
          districts: districts,
          platformSpaces: state.platformSpaces,
          searchText: state.searchText,
          selectedProvince: event.province,
          selectedDistrict: null,
          selectedTag: state.selectedTag,
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
          selectedTag: state.selectedTag,
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
        selectedTag: state.selectedTag,
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
      stations: filtered,
    ));
  }

  Future<void> _onFindNearest(
      FindNearestStationEvent event, Emitter<StationPageState> emit) async {
    if (state.isNearMe) {
      emit(state.copyWith(
        isNearMe: false,
        latitude: null,
        longitude: null,
        currentPage: 0,
      ));
      add(FetchStationsEvent());
    } else {
      emit(state.copyWith(status: StationStatus.loading));
      try {
        final position = await LocationService().getUserCurrentLocation();
        if (position != null) {
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
          emit(state.copyWith(isNearMe: false));
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
