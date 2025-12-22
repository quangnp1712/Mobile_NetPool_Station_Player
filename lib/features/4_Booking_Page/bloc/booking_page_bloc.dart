import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile_netpool_station_player/core/services/location_service.dart';
import 'package:mobile_netpool_station_player/core/utils/debug_logger.dart';
import 'package:mobile_netpool_station_player/core/utils/utf8_encoding.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/data/mock_data.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/models/1_station/station_model.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/models/1_station/station_response_model.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/models/2_space/space_model.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/models/2_space/space_response_model.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/models/2_space/station_space_model.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/models/2_space/station_space_response_model.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/models/3_area/area_list_model.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/models/3_area/area_list_response_model.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/models/4_resource/resoucre_model.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/models/4_resource/resoucre_response_model.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/models/4_resource/resoucre_spec_model.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/models/5_helper_model/resource_row.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/repository/booking_repository.dart';
import 'package:mobile_netpool_station_player/features/Common/data/city_controller/city_model.dart';
import 'package:mobile_netpool_station_player/features/Common/data/city_controller/city_repository.dart';
import 'package:mobile_netpool_station_player/features/Common/data/meta/model/meta_model.dart';

part 'booking_page_event.dart';
part 'booking_page_state.dart';

class BookingPageBloc extends Bloc<BookingPageEvent, BookingPageState> {
  final LocationService _locationService = LocationService();

  BookingPageBloc() : super(BookingPageState()) {
    on<LoadBookingDataEvent>(_onLoadBookingData);
    on<LoadProvincesEvent>(_onLoadProvinces);
    on<SelectProvinceEvent>(_onSelectProvince);
    on<SelectDistrictEvent>(_onSelectDistrict);
    on<ChangePageEvent>(_onChangePage);
    on<SearchStationEvent>(_onSearchStation);
    on<FindNearestStationEvent>(_onFindNearestStation);
    on<SelectStationEvent>(_onSelectStation);
    on<ToggleStationSelectionModeEvent>(_onToggleStationSelectionMode);
    on<SelectSpaceEvent>(_onSelectSpace);
    on<SelectAreaEvent>(_onSelectArea);
    on<SelectDateEvent>((event, emit) => emit(state.copyWith(
          selectedDateIndex: event.index,
        )));
    on<SelectTimeEvent>((event, emit) => emit(state.copyWith(
          selectedTime: event.time,
        )));
    on<ChangeDurationEvent>(_onChangeDuration);
    on<ToggleResourceEvent>(_onToggleResource);
    on<SelectAutoPickEvent>(_onSelectAutoPick);
    on<FetchStationsEvent>(_onFetchStations);
    on<ResetFilterEvent>(_onResetFilter);
  }

  Future<void> _onLoadBookingData(
      LoadBookingDataEvent event, Emitter<BookingPageState> emit) async {
    emit(state.copyWith(status: BookingStatus.loading));

    //! call api provinces
    List<ProvinceModel> provincesList = [];
    try {
      var results = await CityRepository().getProvinces();
      var responseMessage = results['message'];
      var responseStatus = results['status'];
      var responseSuccess = results['success'];
      var responseBody = results['body'];
      if (responseSuccess || responseStatus == 200) {
        provincesList = (responseBody as List)
            .map((e) => ProvinceModel.fromJson(e as Map<String, dynamic>))
            .toList();
        provincesList.map((name) => Utf8Encoding().decode(name as String));
      } else {
        emit(state.copyWith(
          status: BookingStatus.initial,
        ));
        DebugLogger.printLog("Lỗi tải Tỉnh/TP");
      }
    } catch (e) {
      emit(state.copyWith(
        status: BookingStatus.initial,
      ));
      DebugLogger.printLog("Lỗi tải Tỉnh/TP: $e");
    }

    //! call api allStations
    //add(FetchStations());
    try {
      int current = 0; // Chuyển 1->0, 2->1...

      String search = "";

      String province = "";

      String commune = "";

      String district = "";

      String statusCode = "ACTIVE";

      String pageSize = "10";

      var results = await BookingRepository().listStation(search, province,
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
      //! 2. API PLATFORM SPACE
      List<PlatformSpaceModel> platformSpaces = [];
      var resultsPlatformSpaces = await BookingRepository().getPlatformSpace();
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

      //! 3. API STATION SPACE
      if (allStations.isNotEmpty) {
        for (var station in allStations) {
          List<StationSpaceModel> spaces = [];
          var resultsSpace = await BookingRepository()
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
                    final platform = platformMap[space.spaceId];

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
        status: BookingStatus.success,
        filteredStations: allStations,
        currentPage: 0,
        totalItems: meta?.total ?? 0,
        hasReachedMaxStations: allStations.length >= (meta?.total as int),
        platformSpaces: platformSpaces,
        provinces: provincesList,
      ));
    } catch (e) {
      DebugLogger.printLog(e.toString());
    }
  }

// CORE: Handler chính để lấy danh sách station
  Future<void> _onFetchStations(
      FetchStationsEvent event, Emitter<BookingPageState> emit) async {
    emit(state.copyWith(status: BookingStatus.loading));
    try {
      int current = state.currentPage;

      String search = state.searchQuery;

      String province = state.selectedProvince?.name.toString() ?? "";

      String commune = "";

      String district = state.selectedDistrict?.name.toString() ?? "";

      String statusCode = "ACTIVE";

      String pageSize = "10";

      var results = await BookingRepository().listStation(search, province,
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
      //! 2. API STATION SPACE
      if (allStations.isNotEmpty) {
        for (var station in allStations) {
          List<StationSpaceModel> spaces = [];
          var resultsSpace = await BookingRepository()
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
                    final platform = platformMap[space.spaceId];

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
        status: BookingStatus.success,
        filteredStations: allStations,
        totalItems: meta?.total ?? 0,
      ));
    } catch (e) {
      DebugLogger.printLog(e.toString());
    }
  }

  Future<void> _onResetFilter(
      ResetFilterEvent event, Emitter<BookingPageState> emit) async {
    emit(state.copyWith(
      searchQuery: '',
      selectedDistrict: null,
      selectedProvince: null,
      clearSelectedDistrict: true,
      clearSelectedProvince: true,
      currentPage: 0,
      districts: [], // Xóa list quận nếu reset TP
    ));
    add(FetchStationsEvent());
  }

  // --- LOCATION & FILTER LOGIC ---
  Future<void> _onLoadProvinces(
      LoadProvincesEvent event, Emitter<BookingPageState> emit) async {
    emit(state.copyWith(status: BookingStatus.loading));
    //! call api provinces
    try {
      var results = await CityRepository().getProvinces();
      var responseMessage = results['message'];
      var responseStatus = results['status'];
      var responseSuccess = results['success'];
      var responseBody = results['body'];
      if (responseSuccess || responseStatus == 200) {
        List<ProvinceModel> provincesList = (responseBody as List)
            .map((e) => ProvinceModel.fromJson(e as Map<String, dynamic>))
            .toList();
        provincesList.map((name) => Utf8Encoding().decode(name as String));

        emit(state.copyWith(
          provinces: provincesList,
        ));
      } else {
        emit(state.copyWith(
          status: BookingStatus.initial,
        ));
        DebugLogger.printLog("Lỗi tải Tỉnh/TP");
      }
    } catch (e) {
      emit(state.copyWith(
        status: BookingStatus.initial,
      ));
      DebugLogger.printLog("Lỗi tải Tỉnh/TP: $e");
    }
  }

  Future<void> _onSelectProvince(
      SelectProvinceEvent event, Emitter<BookingPageState> emit) async {
    emit(state.copyWith(status: BookingStatus.loading));
    //! call api districts
    try {
      var results = await CityRepository().getDistricts(event.province.code);
      var responseMessage = results['message'];
      var responseStatus = results['status'];
      var responseSuccess = results['success'];
      var responseBody = results['body'];
      if (responseSuccess || responseStatus == 200) {
        List<DistrictModel> districtsList = (responseBody["districts"] as List)
            .map((e) => DistrictModel.fromJson(e as Map<String, dynamic>))
            .toList();
        districtsList.map((name) => Utf8Encoding().decode(name as String));

        emit(state.copyWith(
          status: BookingStatus.success,
          selectedProvince: event.province,
          districts: districtsList,
          selectedDistrict: null,
          clearSelectedDistrict: true,
          currentPage: 0,
          searchQuery: "",
        ));
        add(FetchStationsEvent());
      } else {
        emit(state.copyWith(
          status: BookingStatus.success,
          selectedProvince: event.province,
          districts: [],
          selectedDistrict: null,
          clearSelectedDistrict: true,
          currentPage: 0,
          searchQuery: "",
        ));
        add(FetchStationsEvent());

        DebugLogger.printLog("Lỗi tải Quận/Huyện");
      }
    } catch (e) {
      emit(state.copyWith(
        status: BookingStatus.success,
        selectedProvince: event.province,
        districts: [],
        selectedDistrict: null,
        clearSelectedDistrict: true,
        currentPage: 0,
        searchQuery: "",
      ));
      add(FetchStationsEvent());

      DebugLogger.printLog("Lỗi tải Quận/Huyện: $e");
    }
  }

  Future<void> _onSelectDistrict(
      SelectDistrictEvent event, Emitter<BookingPageState> emit) async {
    emit(state.copyWith(selectedDistrict: event.district, currentPage: 0));
    add(FetchStationsEvent());
  }

  Future<void> _onChangePage(
      ChangePageEvent event, Emitter<BookingPageState> emit) async {
    emit(state.copyWith(currentPage: event.pageIndex));
    add(FetchStationsEvent());
  }

  void _onSearchStation(
      SearchStationEvent event, Emitter<BookingPageState> emit) async {
    emit(state.copyWith(searchQuery: event.query, currentPage: 0));
    add(FetchStationsEvent());
  }

  // mock data
  Future<void> _onFindNearestStation(
      FindNearestStationEvent event, Emitter<BookingPageState> emit) async {
    emit(state.copyWith(
        status: BookingStatus.loading, blocState: BookingBlocState.initial));
    final position = await _locationService.getUserCurrentLocation();
    if (position != null) {
      final List<StationDetailModel> updatedStations =
          _allMockStations.map((s) {
        double newDist = (Random().nextInt(50) / 10) + 0.1;
        return StationDetailModel(
          stationId: s.stationId,
          stationName: s.stationName,
          address: s.address,
          rating: s.rating,
          stationCode: s.stationCode,
          distance: newDist,
        );
      }).toList();
      updatedStations.sort((a, b) => a.distance!.compareTo(b.distance!));

      final pagedData = updatedStations.take(state.pageSize).toList();

      emit(state.copyWith(
        status: BookingStatus.success,
        filteredStations: pagedData,
        currentPage: 0,
        totalItems: updatedStations.length,
        message: "Đã tìm thấy các trạm gần bạn",
      ));
    } else {
      emit(state.copyWith(
          status: BookingStatus.failure,
          message: "Không thể lấy vị trí.",
          blocState: BookingBlocState.locationErrorState));
    }
  }

  Future<void> _onSelectStation(
      SelectStationEvent event, Emitter<BookingPageState> emit) async {
    emit(state.copyWith(
        status: BookingStatus.loading,
        isSelectingStation: false,
        selectedStation: event.station));
    List<StationSpaceModel>? stationSpaces = event.station.space;
    if (stationSpaces != null) {
      if (stationSpaces.isNotEmpty) {
        final defaultSpace = stationSpaces[0];
        try {
          //! Call API Areas
          List<AreaModel> areas = [];

          var results = await BookingRepository().getArea(
            "",
            state.selectedStation?.stationId.toString() ?? "",
            defaultSpace.spaceId.toString(),
            "ACTIVE",
            "0",
            "10",
          );
          var responseMessage = results['message'];
          var responseStatus = results['status'];
          var responseSuccess = results['success'];
          var responseBody = results['body'];

          if (responseSuccess || responseStatus == 200) {
            AreaListModelResponse resultsBody =
                AreaListModelResponse.fromJson(responseBody);

            //! Lọc dữ liệu
            if (resultsBody.data != null) {
              try {
                areas = resultsBody.data!;
              } catch (e) {
                areas = [];
              }
            }
          }
          final defaultAreas = areas;
          final defaultArea =
              defaultAreas.isNotEmpty ? defaultAreas.first : null;

          //!  Resource
          String search = "";
          int current = 0;
          final pageSize = "10";
          String? areaId = defaultArea?.areaId?.toString() ??
              state.selectedArea?.areaId.toString() ??
              "";
          String statusCodes = "ACTIVE";

          if (defaultArea == null) {
            emit(state.copyWith(
              resourceRows: [],
            ));
            return;
          }

          //! Call Api Resource List - Find All
          List<StationResourceModel> resources = [];

          var resultsResource = await BookingRepository().getResouce(
              search, areaId, statusCodes, current.toString(), pageSize);
          var responseMessageResource = resultsResource['message'];
          var responseStatusResource = resultsResource['status'];
          var responseSuccessResource = resultsResource['success'];
          var responseBodyResource = resultsResource['body'];

          ResoucreListModelResponse resultsBodyResource =
              ResoucreListModelResponse.fromJson(responseBody);
          if (resultsBodyResource.data != null) {
            if (resultsBodyResource.data!.isNotEmpty) {
              try {
                resources = resultsBodyResource.data!;
                for (var resouce in resources) {
                  resouce.spec = ResourceSpecModel(
                    // NET
                    pcCpu: "Core i5-12400F",
                    pcRam: "16GB DDR4",
                    pcGpuModel: "RTX 3060 12GB",
                    pcMonitor: "MSI 27inch 165Hz",
                    pcKeyboard: "Logitech G610",
                    pcMouse: "Logitech G102",
                    pcHeadphone: "HyperX Cloud II",
                    //PS
                    csConsoleModel: "PS5 Standard",
                    csTvModel: "Sony Bravia 4K 55 inch",
                    csControllerType: "DualSense White",
                    csControllerCount: 2,
                    //BIDA
                    btTableDetail: "KKKing Empire Series 2",
                    btCueDetail: "Cơ CLB Carbon (4 gậy)",
                    btBallDetail: "Dynaspheres Palladium",
                  );
                }
              } catch (e) {
                resources = [];
              }
            }
          }

          emit(state.copyWith(
              status: BookingStatus.success,
              spaces: stationSpaces,
              selectedSpace: defaultSpace,
              areas: defaultAreas,
              selectedArea: defaultArea,
              resourceRows: _generateMockResources(defaultSpace.spaceCode!,
                  defaultArea.areaName ?? 'Standard')));

          DebugLogger.printLog("$responseStatus - $responseMessage");
        } catch (e) {
          emit(state.copyWith(
              status: BookingStatus.failure, message: "Lỗi tải dữ liệu"));
          DebugLogger.printLog("Lỗi tải dữ liệu: $e");
        }
      }
    }
    if (stationSpaces == null || stationSpaces.isEmpty) {
      emit(state.copyWith(
          status: BookingStatus.failure,
          message: "Trạm này chưa có khu vực nào hoạt động"));
    }
  }

  void _onToggleStationSelectionMode(
      ToggleStationSelectionModeEvent event, Emitter<BookingPageState> emit) {
    emit(state.copyWith(
      isSelectingStation: !state.isSelectingStation,
    ));
  }

  Future<void> _onSelectSpace(
      SelectSpaceEvent event, Emitter<BookingPageState> emit) async {
    emit(state.copyWith(status: BookingStatus.loading));
    await Future.delayed(const Duration(milliseconds: 200));
    final newAreas = kAreasMock[event.space.spaceCode] ?? [];
    final newArea = newAreas.isNotEmpty ? newAreas.first : null;
    emit(state.copyWith(
        status: BookingStatus.success,
        selectedSpace: event.space,
        areas: newAreas,
        selectedArea: newArea,
        bookingType: null,
        clearBookingType: true,
        selectedResourceCodes: [],
        resourceRows: _generateMockResources(
            event.space.spaceCode!, newArea?.areaName ?? 'Standard')));
  }

  Future<void> _onSelectArea(
      SelectAreaEvent event, Emitter<BookingPageState> emit) async {
    emit(state.copyWith(status: BookingStatus.loading));
    await Future.delayed(const Duration(milliseconds: 150));
    emit(state.copyWith(
        status: BookingStatus.success,
        selectedArea: event.area,
        bookingType: null,
        clearBookingType: true,
        selectedResourceCodes: [],
        resourceRows: _generateMockResources(state.selectedSpace!.spaceCode!,
            event.area.areaName ?? 'Standard')));
  }

  void _onChangeDuration(
      ChangeDurationEvent event, Emitter<BookingPageState> emit) {
    double newValue = state.duration + event.delta;
    if (newValue >= 0.5 && newValue <= 12)
      emit(state.copyWith(
        duration: newValue,
      ));
  }

  void _onToggleResource(
      ToggleResourceEvent event, Emitter<BookingPageState> emit) {
    List<String> currentSelected = List.from(state.selectedResourceCodes);
    String? newBookingType = 'manual';
    if (currentSelected.contains(event.resourceCode)) {
      currentSelected.remove(event.resourceCode);
      if (currentSelected.isEmpty) newBookingType = null;
    } else {
      currentSelected.add(event.resourceCode);
    }
    emit(state.copyWith(
      selectedResourceCodes: currentSelected,
      bookingType: newBookingType,
      clearBookingType: newBookingType == null,
    ));
  }

  void _onSelectAutoPick(
      SelectAutoPickEvent event, Emitter<BookingPageState> emit) {
    emit(state.copyWith(
      bookingType: 'auto',
      selectedResourceCodes: [],
    ));
  }

  List<ResourceRow> _generateMockResources(String spaceCode, String areaName) {
    // Logic tạo mock data giữ nguyên
    ResourceSpecModel spec;
    String rowPrefix;
    if (spaceCode == 'NET') {
      spec = ResourceSpecModel(
          pcCpu: "Intel Core i5-12400F",
          pcRam: "16GB DDR4",
          pcGpuModel: "RTX 3060 12GB",
          pcMonitor: "MSI 27inch 165Hz",
          pcKeyboard: "Logitech G610",
          pcMouse: "Logitech G102",
          pcHeadphone: "HyperX Cloud II");
      rowPrefix = "PC";
    } else if (spaceCode == 'BIDA') {
      spec = ResourceSpecModel(
          btTableDetail: "Bàn Aileex 9020 Nhập Khẩu",
          btCueDetail: "Cơ Carbon Fury",
          btBallDetail: "Bóng Aramith Pro Cup TV");
      rowPrefix = "Table";
    } else {
      spec = ResourceSpecModel(
          csConsoleModel: "PlayStation 5 Standard",
          csTvModel: "Sony Bravia 4K 55 inch",
          csControllerType: "DualSense Wireless",
          csControllerCount: 2);
      rowPrefix = "PS";
    }
    return [
      ResourceRow(
          'A',
          'Dãy A ($areaName)',
          List.generate(
              4,
              (i) => StationResourceModel(
                  stationResourceId: i,
                  resourceCode: '$rowPrefix-A${i + 1}',
                  resourceName: '$rowPrefix-A0${i + 1}',
                  statusCode: i == 2 ? 'BUSY' : 'AVAILABLE',
                  spec: spec))),
      ResourceRow(
          'B',
          'Dãy B ($areaName)',
          List.generate(
              4,
              (i) => StationResourceModel(
                  stationResourceId: 10 + i,
                  resourceCode: '$rowPrefix-B${i + 1}',
                  resourceName: '$rowPrefix-B0${i + 1}',
                  statusCode: 'AVAILABLE',
                  spec: spec))),
    ];
  }

  final List<StationDetailModel> _allMockStations = List.generate(
      20,
      (index) => StationDetailModel(
            stationId: index,
            stationName: 'Station ${index + 1}',
            address: 'Địa chỉ ${index + 1}, Quận ${(index % 5) + 1}, TP.HCM',
            distance: (index * 0.5) + 1.0,
            rating: 4.0 + (index % 10) / 10,
            statusCode: 'ACTIVE',
            // REMOVED availableSpaceCodes param as it doesn't exist in model
          ));
  Future<Map<String, dynamic>> _mockListStationApi({
    String? search,
    String? province,
    String? district,
    int current = 0,
    int pageSize = 5,
  }) async {
    // 1. Filter logic (Server side)
    List<StationDetailModel> result = _allMockStations.where((s) {
      bool matchSearch = search == null ||
          search.isEmpty ||
          (s.stationName?.toLowerCase().contains(search.toLowerCase()) ??
              false) ||
          (s.address?.toLowerCase().contains(search.toLowerCase()) ?? false);

      bool matchDistrict = district == null ||
          district.isEmpty ||
          (s.address?.contains(district) ?? false);

      return matchSearch && matchDistrict;
    }).toList();

    // 2. Pagination logic (Server side)
    int total = result.length;
    int startIndex = current * pageSize;
    int endIndex = min(startIndex + pageSize, total);

    List<StationDetailModel> paginatedResult = [];
    if (startIndex < total) {
      paginatedResult = result.sublist(startIndex, endIndex);
    }

    // 3. Response Structure
    await Future.delayed(const Duration(milliseconds: 800));
    return {
      "meta": {"pageSize": pageSize, "current": current, "total": total},
      "data": paginatedResult,
      "status": "200",
      "success": true,
    };
  }
}
