import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile_netpool_station_player/core/network/exceptions/app_exceptions.dart';
import 'package:mobile_netpool_station_player/core/network/exceptions/exception_handlers.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.1_Authentication/shared_preferences/auth_shared_preferences.dart';
import 'package:mobile_netpool_station_player/features/8_Booking_History_Page/api/booking_history_api.dart';
import 'package:mobile_netpool_station_player/features/8_Booking_History_Page/model/1.booking/booking_model.dart';

abstract class IBookingHistoryRepository {
  Future<Map<String, dynamic>> findAllBooking(
    String? accountId,
    String? dateFrom,
    String? dateTo,
    String? statusCodes,
    String? current,
    String? pageSize,
  );
  Future<Map<String, dynamic>> findDetailBooking(String bookingId);
  Future<Map<String, dynamic>> findDetailStation(String stationId);
  Future<Map<String, dynamic>> getDetailArea(String areaId);
  Future<Map<String, dynamic>> getResouceDetail(
    String? resouceId,
  );
  Future<Map<String, dynamic>> updateBooking(
    BookingModel booking,
  );
  Future<Map<String, dynamic>> cancelBooking(
    String bookingId,
  );
  Future<Map<String, dynamic>> paymentWallet(
    String bookingId,
  );
  Future<Map<String, dynamic>> paymentBankTransfer(
    String bookingId,
  );
}

class BookingHistoryRepository extends BookingHistoryApi
    implements IBookingHistoryRepository {
  //! find All Booking
  @override
  Future<Map<String, dynamic>> findAllBooking(
    String? accountId,
    String? dateFrom,
    String? dateTo,
    String? statusCodes,
    String? current,
    String? pageSize,
  ) async {
    try {
      final String jwtToken = AuthenticationPref.getAccessToken().toString();

      Uri uri = Uri.parse(
          "$apiBookingUrl?dateRange=$dateFrom&dateRange=$dateTo&accountId=$accountId&statusCodes=$statusCodes&current=$current&pageSize=$pageSize");
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

  //! get Booking Detail
  @override
  Future<Map<String, dynamic>> findDetailBooking(String bookingId) async {
    try {
      final String jwtToken = AuthenticationPref.getAccessToken().toString();

      Uri uri = Uri.parse("$apiBookingUrl/$bookingId");
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

  //! get Station Detail
  @override
  Future<Map<String, dynamic>> findDetailStation(String stationId) async {
    try {
      final String jwtToken = AuthenticationPref.getAccessToken().toString();

      Uri uri = Uri.parse("$pubStationUrl/$stationId");
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

  //! get Area Detail
  @override
  Future<Map<String, dynamic>> getDetailArea(String areaId) async {
    try {
      final String jwtToken = AuthenticationPref.getAccessToken().toString();

      Uri uri = Uri.parse("$pubAreaUrl/$areaId");
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

  //! get Resouce Detail
  @override
  Future<Map<String, dynamic>> getResouceDetail(
    String? resouceId,
  ) async {
    try {
      final String jwtToken = AuthenticationPref.getAccessToken().toString();

      Uri uri = Uri.parse("$pubResouceUrl/$resouceId");
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

  //! update Booking
  @override
  Future<Map<String, dynamic>> updateBooking(
    BookingModel booking,
  ) async {
    try {
      final String jwtToken = AuthenticationPref.getAccessToken().toString();

      Uri uri = Uri.parse("$apiBookingUrl/${booking.bookingId}");
      final client = http.Client();
      final response = await client
          .put(
            uri,
            headers: {
              "Access-Control-Allow-Origin": "*",
              'Content-Type': 'application/json',
              'Accept': '*/*',
              'Authorization': 'Bearer $jwtToken',
            },
            body: booking.toJson(),
          )
          .timeout(const Duration(seconds: 50));
      return processResponse(response);
    } catch (e) {
      return ExceptionHandlers().getExceptionString(e);
    }
  }

  //! cancel Booking
  @override
  Future<Map<String, dynamic>> cancelBooking(
    String bookingId,
  ) async {
    try {
      final String jwtToken = AuthenticationPref.getAccessToken().toString();

      Uri uri = Uri.parse("$apiBookingUrl/$bookingId/cancel");
      final client = http.Client();
      final response = await client
          .patch(
            uri,
            headers: {
              "Access-Control-Allow-Origin": "*",
              'Content-Type': 'application/json',
              'Accept': '*/*',
              'Authorization': 'Bearer $jwtToken',
            },
            body: json.encode({
              "cancelReason": "Khách hủy booking",
            }),
          )
          .timeout(const Duration(seconds: 50));
      return processResponse(response);
    } catch (e) {
      return ExceptionHandlers().getExceptionString(e);
    }
  }

  //! paymentWallet
  @override
  Future<Map<String, dynamic>> paymentWallet(
    String bookingId,
  ) async {
    try {
      final String jwtToken = AuthenticationPref.getAccessToken().toString();

      Uri uri = Uri.parse("$apiBookingUrl/$bookingId/wallet-payment");

      final client = http.Client();
      final response = await client.post(
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

//!  paymentBankTransfer
  @override
  Future<Map<String, dynamic>> paymentBankTransfer(
    String bookingId,
  ) async {
    try {
      final String jwtToken = AuthenticationPref.getAccessToken().toString();

      Uri uri = Uri.parse("$apiBookingUrl/$bookingId/payment");
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
}
