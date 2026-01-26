import 'package:http/http.dart' as http;
import 'package:mobile_netpool_station_player/core/network/exceptions/app_exceptions.dart';
import 'package:mobile_netpool_station_player/core/network/exceptions/exception_handlers.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.1_Authentication/shared_preferences/auth_shared_preferences.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/api/booking_api.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/models/6.booking/booking_model.dart';
import 'package:mobile_netpool_station_player/features/5_Matching_Page/5.3_Matching_Create/api/matching_api.dart';
import 'package:mobile_netpool_station_player/features/5_Matching_Page/5.3_Matching_Create/models/4.schedule/request_available_schedule_model.dart';
import 'package:mobile_netpool_station_player/features/5_Matching_Page/5.3_Matching_Create/models/7.resource/request_available_schedule_model.dart';
import 'package:mobile_netpool_station_player/features/5_Matching_Page/5.3_Matching_Create/models/9.match_making/matching_model.dart';

abstract class IMatchingRepository {
  //! 1. Station
  Future<Map<String, dynamic>> listStation(
    String search,
    String province,
    String district,
    String statusCodes,
    String current,
    String pageSize,
    String longitude,
    String latitude,
  );

  Future<Map<String, dynamic>> getAllProvince(
    String current,
    String pageSize,
  );

  //! 2. space
  Future<Map<String, dynamic>> getAllStationSpace(String stationId);

  //! 3. Game
  Future<Map<String, dynamic>> getAllGame(
    String stationSpaceId,
    String search,
    String genreCodes,
    String statusCodes,
    String current,
    String pageSize,
  );

  //! 4. Schedule
  Future<Map<String, dynamic>> findAllSchedule(
    String stationId,
    String dateFrom,
    String dateTo,
    String statusCodes, // ENABLED
    String pageSize,
  );
  Future<Map<String, dynamic>> findAllTimeSlot(
    String scheduleId,
  );

  //! 6. area
  Future<Map<String, dynamic>> getArea(
    String search,
    String stationId,
    String stationSpaceId,
    String statusCodes,
    String current,
    String pageSize,
  );

  //! 7.Resource
  Future<Map<String, dynamic>> findAllResource(
    String areaId,
    RequestAvailableResourceModel requestModel,
  );

  //! 8. ds schedule được chờ
  Future<Map<String, dynamic>> findScheduleAvailable(
      RequestAvailableScheduleModel requestModel);

  //! 9. Wallet
  Future<Map<String, dynamic>> getWallet();

  //! 10. create Match Making
  Future<Map<String, dynamic>> createMatchMaking(
      MatchMakingModel matchMakingModel);

  //! 9. getPlatformSpace
  Future<Map<String, dynamic>> getPlatformSpace(String spaceId);
}

class MatchingRepository extends MatchingApi implements IMatchingRepository {
  //! List Station
  @override
  Future<Map<String, dynamic>> listStation(
    String search,
    String province,
    String district,
    String statusCodes,
    String current,
    String pageSize,
    String longitude,
    String latitude,
  ) async {
    try {
      final String jwtToken = AuthenticationPref.getAccessToken().toString();

      Uri uri = Uri.parse(
          "$StationListUrl?search=$search&province=$province&commune=&district=$district&distance=50&statusCodes=$statusCodes&current=$current&pageSize=$pageSize&longitude=$longitude&latitude=$latitude");
      final client = http.Client();
      final response = await client.get(
        uri,
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'Authorization': 'Bearer $jwtToken',
        },
      ).timeout(const Duration(seconds: 30));
      return processResponse(response);
    } catch (e) {
      return ExceptionHandlers().getExceptionString(e);
    }
  }

  //! List Province
  @override
  Future<Map<String, dynamic>> getAllProvince(
    String current,
    String pageSize,
  ) async {
    try {
      final String jwtToken = AuthenticationPref.getAccessToken().toString();

      Uri uri = Uri.parse(
          "$StationListUrl/province?current=$current&pageSize=$pageSize");
      final client = http.Client();
      final response = await client.get(
        uri,
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'Authorization': 'Bearer $jwtToken',
        },
      ).timeout(const Duration(seconds: 30));
      return processResponse(response);
    } catch (e) {
      return ExceptionHandlers().getExceptionString(e);
    }
  }

  //! get Space
  @override
  Future<Map<String, dynamic>> getAllStationSpace(
    String stationId,
  ) async {
    try {
      final String jwtToken = AuthenticationPref.getAccessToken().toString();

      Uri uri = Uri.parse("$pubSpaceUrl/all?stationId=$stationId");
      final client = http.Client();
      final response = await client.get(
        uri,
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'Authorization': 'Bearer $jwtToken',
        },
      ).timeout(const Duration(seconds: 40));
      return processResponse(response);
    } catch (e) {
      return ExceptionHandlers().getExceptionString(e);
    }
  }

  //! get All Game
  @override
  Future<Map<String, dynamic>> getAllGame(
    String stationSpaceId,
    String search,
    String genreCodes,
    String statusCodes,
    String current,
    String pageSize,
  ) async {
    try {
      final String jwtToken = AuthenticationPref.getAccessToken().toString();

      Uri uri = Uri.parse(
          "$pubGameUrl?stationSpaceId=$stationSpaceId&search=$search&genreCodes=$genreCodes&statusCodes=$statusCodes&current=$current&pageSize=$pageSize");
      final client = http.Client();
      final response = await client.get(
        uri,
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'Authorization': 'Bearer $jwtToken',
        },
      ).timeout(const Duration(seconds: 50));
      return processResponse(response);
    } catch (e) {
      return ExceptionHandlers().getExceptionString(e);
    }
  }

  //! findAllSchedule
  @override
  Future<Map<String, dynamic>> findAllSchedule(
    String stationId,
    String dateFrom,
    String dateTo,
    String statusCodes,
    String pageSize,
  ) async {
    try {
      final String jwtToken = AuthenticationPref.getAccessToken().toString();

      Uri uri = Uri.parse(
          "$pubScheduleUrl/station?stationId=$stationId&dateRange=$dateFrom&dateRange=$dateTo&statusCodes=$statusCodes&pageSize=$pageSize");
      final client = http.Client();
      final response = await client.get(
        uri,
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'Authorization': 'Bearer $jwtToken',
        },
      ).timeout(const Duration(seconds: 50));
      return processResponse(response);
    } catch (e) {
      return ExceptionHandlers().getExceptionString(e);
    }
  }

  //! find timeslot with resource
  @override
  Future<Map<String, dynamic>> findAllTimeSlot(
    String scheduleId,
  ) async {
    try {
      final String jwtToken = AuthenticationPref.getAccessToken().toString();

      Uri uri = Uri.parse("$pubScheduleUrl/$scheduleId");
      final client = http.Client();
      final response = await client.get(
        uri,
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'Authorization': 'Bearer $jwtToken',
        },
      ).timeout(const Duration(seconds: 50));
      return processResponse(response);
    } catch (e) {
      return ExceptionHandlers().getExceptionString(e);
    }
  }

  //! Area - Khu vực
  @override
  Future<Map<String, dynamic>> getArea(
    String search,
    String stationId,
    String stationSpaceId,
    String statusCodes,
    String current,
    String pageSize,
  ) async {
    try {
      final String jwtToken = AuthenticationPref.getAccessToken().toString();

      Uri uri = Uri.parse(
          "$pubAreaUrl?search=$search&stationId=$stationId&stationSpaceId=$stationSpaceId&statusCodes=$statusCodes&current=$current&pageSize=$pageSize");
      final client = http.Client();
      final response = await client.get(
        uri,
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'Authorization': 'Bearer $jwtToken',
        },
      ).timeout(const Duration(seconds: 30));
      return processResponse(response);
    } catch (e) {
      return ExceptionHandlers().getExceptionString(e);
    }
  }

  //! findAllResource
  @override
  Future<Map<String, dynamic>> findAllResource(
    String areaId,
    RequestAvailableResourceModel requestModel,
  ) async {
    try {
      final String jwtToken = AuthenticationPref.getAccessToken().toString();
      Uri uri = Uri.parse("$pubResouceUrl/row/$areaId/available");

      final client = http.Client();
      final response = await client
          .post(
            uri,
            headers: {
              "Access-Control-Allow-Origin": "*",
              'Content-Type': 'application/json',
              'Accept': '*/*',
              'Authorization': 'Bearer $jwtToken',
            },
            body: requestModel.toJson(),
          )
          .timeout(const Duration(seconds: 50));
      return processResponse(response);
    } catch (e) {
      return ExceptionHandlers().getExceptionString(e);
    }
  }

  //! findScheduleAvailable
  @override
  Future<Map<String, dynamic>> findScheduleAvailable(
    RequestAvailableScheduleModel requestModel,
  ) async {
    try {
      final String jwtToken = AuthenticationPref.getAccessToken().toString();
      Uri uri = Uri.parse("$pubScheduleUrl/list/by-date-count");

      final client = http.Client();
      final response = await client
          .post(
            uri,
            headers: {
              "Access-Control-Allow-Origin": "*",
              'Content-Type': 'application/json',
              'Accept': '*/*',
              'Authorization': 'Bearer $jwtToken',
            },
            body: requestModel.toJson(),
          )
          .timeout(const Duration(seconds: 50));
      return processResponse(response);
    } catch (e) {
      return ExceptionHandlers().getExceptionString(e);
    }
  }

  //! createMatchMaking
  @override
  Future<Map<String, dynamic>> createMatchMaking(
    MatchMakingModel matchMakingModel,
  ) async {
    try {
      final String jwtToken = AuthenticationPref.getAccessToken().toString();
      Uri uri = Uri.parse(apiMatchMkingUrl);

      final client = http.Client();
      final response = await client
          .post(
            uri,
            headers: {
              "Access-Control-Allow-Origin": "*",
              'Content-Type': 'application/json',
              'Accept': '*/*',
              'Authorization': 'Bearer $jwtToken',
            },
            body: matchMakingModel.toJson(),
          )
          .timeout(const Duration(seconds: 50));
      return processResponse(response);
    } catch (e) {
      return ExceptionHandlers().getExceptionString(e);
    }
  }

  //! get wallet
  @override
  Future<Map<String, dynamic>> getWallet() async {
    try {
      final String jwtToken = AuthenticationPref.getAccessToken().toString();

      Uri uri = Uri.parse("$apiWalletUrl/me");
      final client = http.Client();
      final response = await client.get(
        uri,
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'Authorization': 'Bearer $jwtToken',
        },
      ).timeout(const Duration(seconds: 30));
      return processResponse(response);
    } catch (e) {
      return ExceptionHandlers().getExceptionString(e);
    }
  }

  //!  getPlatformSpace
  @override
  Future<Map<String, dynamic>> getPlatformSpace(String spaceId) async {
    try {
      final String jwtToken = AuthenticationPref.getAccessToken().toString();

      Uri uri = Uri.parse("$pubPlatformSpaceUrl/$spaceId");
      final client = http.Client();
      final response = await client.get(
        uri,
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'Authorization': 'Bearer $jwtToken',
        },
      ).timeout(const Duration(seconds: 30));
      return processResponse(response);
    } catch (e) {
      return ExceptionHandlers().getExceptionString(e);
    }
  }
}
