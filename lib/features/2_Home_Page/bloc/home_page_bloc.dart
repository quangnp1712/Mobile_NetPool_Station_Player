import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/utils.dart';
import 'package:mobile_netpool_station_player/core/services/authentication_service.dart';
import 'package:mobile_netpool_station_player/core/services/location_service.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.1_Authentication/shared_preferences/auth_shared_preferences.dart';
import 'package:mobile_netpool_station_player/features/2_Home_Page/models/1.station/station_model.dart';
import 'package:mobile_netpool_station_player/features/2_Home_Page/models/1.station/station_response_model.dart';
import 'package:mobile_netpool_station_player/features/2_Home_Page/models/2.space/space_model.dart';
import 'package:mobile_netpool_station_player/features/2_Home_Page/models/2.space/space_response_model.dart';
import 'package:mobile_netpool_station_player/features/2_Home_Page/models/2.space/station_space_model.dart';
import 'package:mobile_netpool_station_player/features/2_Home_Page/models/2.space/station_space_response_model.dart';
import 'package:mobile_netpool_station_player/features/2_Home_Page/repository/home_page_repository.dart';

part 'home_page_event.dart';
part 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc() : super(const HomePageState()) {
    on<HomeCheckAuthEvent>(_onCheckAuth);
    on<HomeFetchListStationEvent>(_onFetchListStation);
  }

  Future<void> _onCheckAuth(
    HomeCheckAuthEvent event,
    Emitter<HomePageState> emit,
  ) async {
    emit(state.copyWith(stationListStatus: HomeStatus.loading));

    final authService = AuthenticationService();
    final bool isExpired = await authService.checkJwtExpired();

    if (!isExpired) {
      String? fullName = AuthenticationPref.getUserName();
      if (fullName != null && fullName.isNotEmpty) {
        // Logic lấy tên cuối cùng
        final displayName = fullName.trim().split(' ').last;
        emit(state.copyWith(isLoggedIn: true, userName: displayName));
      }
    } else {
      emit(state.copyWith(isLoggedIn: false, userName: ""));
    }
    final position = await LocationService().getUserCurrentLocation();
    if (position != null) {
      double lat = 0;
      double long = 0;
      if (position is Position) {
        lat = position.latitude;
        long = position.longitude;
      }
    } else {}
    add(HomeFetchListStationEvent(current: 0, pageSize: 5));
  }

  /// Xử lý logic load Station
  Future<void> _onFetchListStation(
    HomeFetchListStationEvent event,
    Emitter<HomePageState> emit,
  ) async {
    emit(state.copyWith(stationListStatus: HomeStatus.loading));

    try {
      // 1. Gọi song song List Station và Get Platform Space
      final results = await Future.wait([
        //$ listStation
        HomePageRepository().listStation(
          event.search ?? "",
          event.province ?? "",
          event.commune ?? "",
          event.district ?? "",
          "ACTIVE",
          event.current.toString(),
          event.pageSize.toString(),
        ),
        //$ getPlatformSpace
        HomePageRepository().getPlatformSpace(),
      ]);

      final stationResults = results[0];
      final platformSpaceResults = results[1];

      // Parse kết quả
      final stationResponse =
          StationDetailModelResponse.fromMap(stationResults["body"]);
      final platformSpaceResponse =
          SpaceListModelResponse.fromMap(platformSpaceResults["body"]);

      if (stationResults['success'] == true && stationResponse.data != null) {
        List<StationDetailModel> stations = stationResponse.data!;
        List<PlatformSpaceModel> platformSpaces =
            platformSpaceResponse.data ?? [];

        // 2. Sau khi có danh sách station, lấy stationId để gọi getStationSpace
        // Tạo list futures để gọi song song cho tất cả station (tránh await trong loop)
        List<Future<Map<String, dynamic>>> stationSpaceFutures = [];

        for (var station in stations) {
          if (station.stationId != null) {
            stationSpaceFutures.add(HomePageRepository()
                .getStationSpace(station.stationId.toString()));
          }
        }

        // Chờ tất cả các call getStationSpace hoàn tất
        final allStationSpacesResults = await Future.wait(stationSpaceFutures);

        // 3. Xử lý logic gán dữ liệu
        for (int i = 0; i < stations.length; i++) {
          var station = stations[i];
          var result = allStationSpacesResults[i];

          // Parse response của từng station
          var stationSpaceResponse =
              StationSpaceListModelResponse.fromMap(result['body']);

          if (result['success'] == true && stationSpaceResponse.data != null) {
            List<StationSpaceModel> currentStationSpaces =
                stationSpaceResponse.data!;

            // Duyệt qua từng StationSpace của trạm hiện tại
            for (var sSpace in currentStationSpaces) {
              // 4. So sánh spaceID để tìm PlatformSpace tương ứng
              final matchingPlatformSpace = platformSpaces.firstWhereOrNull(
                  (pSpace) => pSpace.spaceId == sSpace.spaceId);

              if (matchingPlatformSpace != null) {
                // 5. Gán PlatformSpace vào StationSpace để lấy metadata (icon, bgColor)
                sSpace.space = matchingPlatformSpace;
              }
            }
            // Cập nhật lại list space cho station
            station.space = currentStationSpaces;
          }
        }

        // Emit state thành công với dữ liệu đã được mapping đầy đủ
        emit(state.copyWith(
          stationListStatus: HomeStatus.success,
          stations: stations,
          stationMeta: stationResponse.meta,
        ));
      } else {
        emit(state.copyWith(
          stationListStatus: HomeStatus.failure,
          message:
              stationResponse.message ?? "Không tải được danh sách Station",
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        stationListStatus: HomeStatus.failure,
        message: e.toString(),
      ));
    }
  }
}
