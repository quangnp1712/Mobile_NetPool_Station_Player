import 'package:http/http.dart' as http;
import 'package:mobile_netpool_station_player/core/network/exceptions/app_exceptions.dart';
import 'package:mobile_netpool_station_player/core/network/exceptions/exception_handlers.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.1_Authentication/shared_preferences/auth_shared_preferences.dart';
import 'package:mobile_netpool_station_player/features/5_Matching_Page/5.1_Matching/api/matching_api.dart';
import 'package:mobile_netpool_station_player/features/5_Matching_Page/5.1_Matching/models/matching_model.dart';

abstract class IMatchingRepository {
  //! find detail
  Future<Map<String, dynamic>> findDetail(String matchMakingId);

  //! join
  Future<Map<String, dynamic>> join(MatchMakingModel matchMakingId);

  //! find join
  Future<Map<String, dynamic>> findJoin(String matchMakingId);

  //! approve join
  Future<Map<String, dynamic>> approveJoin(
      String matchJoiningRegistrationId, String approve);

  //!  Wallet
  Future<Map<String, dynamic>> getWallet();

  //! thanh toán cọc payment with wallet
  Future<Map<String, dynamic>> paymentWallet(String matchMakingId);

  //! thanh toán cọc payment with bank
  Future<Map<String, dynamic>> paymentTransfer(String matchMakingId);

  //! thanh toán sẵn sàng
  Future<Map<String, dynamic>> paymentReady(
      String matchParticipateId, MatchParticipant paymentMethodCode);

  //! chuẩn bị bắt đầu
  Future<Map<String, dynamic>> readyOpenMaching(String matchMakingId);

  //! bắt đầu
  Future<Map<String, dynamic>> startMaching(String matchMakingId);
}

class MatchingRepository extends MatchingApi implements IMatchingRepository {
  //! find detail
  @override
  Future<Map<String, dynamic>> findDetail(String matchMakingId) async {
    try {
      final String jwtToken = AuthenticationPref.getAccessToken().toString();

      Uri uri = Uri.parse("$apiMatchingUrl/$matchMakingId");
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

  //! join
  @override
  Future<Map<String, dynamic>> join(MatchMakingModel matchMakingId) async {
    try {
      final String jwtToken = AuthenticationPref.getAccessToken().toString();

      Uri uri = Uri.parse(apiMatchingJoinUrl);

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
            body: matchMakingId.toJson(),
          )
          .timeout(const Duration(seconds: 50));
      return processResponse(response);
    } catch (e) {
      return ExceptionHandlers().getExceptionString(e);
    }
  }

  //! find join
  @override
  Future<Map<String, dynamic>> findJoin(String matchMakingId) async {
    try {
      final String jwtToken = AuthenticationPref.getAccessToken().toString();

      Uri uri = Uri.parse("$apiMatchingUrl?matchMakingId=$matchMakingId");
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

  //! approve join
  Future<Map<String, dynamic>> approveJoin(
      String matchJoiningRegistrationId, String approve) async {
    try {
      final String jwtToken = AuthenticationPref.getAccessToken().toString();

      Uri uri =
          Uri.parse("$apiMatchingJoinUrl/$matchJoiningRegistrationId/$approve");
      final client = http.Client();
      final response = await client.patch(
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

  //! thanh toán cọc payment with wallet
  @override
  Future<Map<String, dynamic>> paymentWallet(String matchMakingId) async {
    try {
      final String jwtToken = AuthenticationPref.getAccessToken().toString();

      Uri uri =
          Uri.parse("$apiMatchingUrl/$matchMakingId/deposit/wallet-payment");

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

  //! thanh toán cọc payment with bank
  @override
  Future<Map<String, dynamic>> paymentTransfer(String matchMakingId) async {
    try {
      final String jwtToken = AuthenticationPref.getAccessToken().toString();

      Uri uri = Uri.parse("$apiMatchingUrl/$matchMakingId/deposit/payment");

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

  //! thanh toán sẵn sàng
  @override
  Future<Map<String, dynamic>> paymentReady(
      String matchParticipateId, MatchParticipant paymentMethodCode) async {
    try {
      final String jwtToken = AuthenticationPref.getAccessToken().toString();

      Uri uri =
          Uri.parse("$apiMatchingUrl/participant/$matchParticipateId/payment");

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
            body: paymentMethodCode.toJson(),
          )
          .timeout(const Duration(seconds: 50));
      return processResponse(response);
    } catch (e) {
      return ExceptionHandlers().getExceptionString(e);
    }
  }

  //! chuẩn bị bắt đầu
  @override
  Future<Map<String, dynamic>> readyOpenMaching(String matchMakingId) async {
    try {
      final String jwtToken = AuthenticationPref.getAccessToken().toString();

      Uri uri = Uri.parse("$apiMatchingUrl/$matchMakingId/prepare-to-start");

      final client = http.Client();
      final response = await client.patch(
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

  //!bắt đầu
  @override
  Future<Map<String, dynamic>> startMaching(String matchMakingId) async {
    try {
      final String jwtToken = AuthenticationPref.getAccessToken().toString();

      Uri uri = Uri.parse("$apiMatchingUrl/$matchMakingId/start");

      final client = http.Client();
      final response = await client.patch(
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
