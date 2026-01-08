import 'package:http/http.dart' as http;
import 'package:mobile_netpool_station_player/core/network/exceptions/app_exceptions.dart';
import 'package:mobile_netpool_station_player/core/network/exceptions/exception_handlers.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.1_Authentication/shared_preferences/auth_shared_preferences.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/api/booking_api.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/models/4_resource/resoucre_model.dart';

abstract class IBookingRepository {
  Future<Map<String, dynamic>> listStation(
    String? search,
    String? province,
    String? commune,
    String? district,
    String? statusCodes,
    String? current,
    String? pageSize,
  );
  Future<Map<String, dynamic>> getStationSpace(String stationId);
  Future<Map<String, dynamic>> getPlatformSpace();
  Future<Map<String, dynamic>> getArea(
    String? search,
    String? stationId,
    String? spaceId,
    String? statusCodes,
    String? current,
    String? pageSize,
  );
  Future<Map<String, dynamic>> getResouce(
    String? search,
    String? areaId,
    String? statusCodes,
    String? current,
    String? pageSize,
  );
}

class BookingRepository extends BookingApi implements IBookingRepository {
  //! List Station
  @override
  Future<Map<String, dynamic>> listStation(
    String? search,
    String? province,
    String? commune,
    String? district,
    String? statusCodes,
    String? current,
    String? pageSize,
  ) async {
    try {
      final String jwtToken = AuthenticationPref.getAccessToken().toString();

      Uri uri = Uri.parse(
          "$StationListUrl?search=$search&province=$province&commune=$commune&district=$district&statusCodes=$statusCodes&current=$current&pageSize=$pageSize");
      final client = http.Client();
      final response = await client.get(
        uri,
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'Authorization': 'Bearer $jwtToken',
        },
      ).timeout(const Duration(seconds: 180));
      return processResponse(response);
    } catch (e) {
      return ExceptionHandlers().getExceptionString(e);
    }
  }

  //! Station Space
  @override
  Future<Map<String, dynamic>> getStationSpace(String stationId) async {
    try {
      final String jwtToken = AuthenticationPref.getAccessToken().toString();

      Uri uri = Uri.parse("$stationSpaceUrl/all?stationId=$stationId");
      final client = http.Client();
      final response = await client.get(
        uri,
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'Authorization': 'Bearer $jwtToken',
        },
      ).timeout(const Duration(seconds: 180));
      return processResponse(response);
    } catch (e) {
      return ExceptionHandlers().getExceptionString(e);
    }
  }

  //! Platform Space
  @override
  Future<Map<String, dynamic>> getPlatformSpace() async {
    try {
      final String jwtToken = AuthenticationPref.getAccessToken().toString();

      Uri uri = Uri.parse(viewSpaceUrl);
      final client = http.Client();
      final response = await client.get(
        uri,
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'Authorization': 'Bearer $jwtToken',
        },
      ).timeout(const Duration(seconds: 180));
      return processResponse(response);
    } catch (e) {
      return ExceptionHandlers().getExceptionString(e);
    }
  }

  //! Area - Khu vực
  @override
  Future<Map<String, dynamic>> getArea(
    String? search,
    String? stationId,
    String? spaceId,
    String? statusCodes,
    String? current,
    String? pageSize,
  ) async {
    try {
      final String jwtToken = AuthenticationPref.getAccessToken().toString();

      Uri uri = Uri.parse(
          "$pubAreaUrl?search=$search&stationId=$stationId&spaceId=$spaceId&statusCodes=$statusCodes&current=$current&pageSize=$pageSize");
      final client = http.Client();
      final response = await client.get(
        uri,
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'Authorization': 'Bearer $jwtToken',
        },
      ).timeout(const Duration(seconds: 180));
      return processResponse(response);
    } catch (e) {
      return ExceptionHandlers().getExceptionString(e);
    }
  }

  //! getResouce
  @override
  Future<Map<String, dynamic>> getResouce(
    String? search,
    String? areaId,
    String? statusCodes,
    String? current,
    String? pageSize,
  ) async {
    try {
      final String jwtToken = AuthenticationPref.getAccessToken().toString();

      Uri uri = Uri.parse(
          "$pubResouceUrl?search=$search&areaId=$areaId&statusCodes=$statusCodes&current=$current&pageSize=$pageSize");
      final client = http.Client();
      final response = await client.get(
        uri,
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'Authorization': 'Bearer $jwtToken',
        },
      ).timeout(const Duration(seconds: 180));
      return processResponse(response);
    } catch (e) {
      return ExceptionHandlers().getExceptionString(e);
    }
  }
}
