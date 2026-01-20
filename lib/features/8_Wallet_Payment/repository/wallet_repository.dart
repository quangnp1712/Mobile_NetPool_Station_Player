import 'package:http/http.dart' as http;
import 'package:mobile_netpool_station_player/core/network/exceptions/app_exceptions.dart';
import 'package:mobile_netpool_station_player/core/network/exceptions/exception_handlers.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.1_Authentication/shared_preferences/auth_shared_preferences.dart';
import 'package:mobile_netpool_station_player/features/8_Wallet_Payment/api/wallet_api.dart';
import 'package:mobile_netpool_station_player/features/8_Wallet_Payment/models/1.wallet/wallet_model.dart';

abstract class IWalletRepository {
  Future<Map<String, dynamic>> getPaymentHistory(
    String? dateTo,
    String? dateFrom,
  );

  Future<Map<String, dynamic>> getWallet();

  Future<Map<String, dynamic>> addMoneyToWallet(WalletModel walletModel);
}

class WalletRepository extends WalletApi implements IWalletRepository {
  //! getPaymentHistory
  @override
  Future<Map<String, dynamic>> getPaymentHistory(
    String? dateFrom,
    String? dateTo,
  ) async {
    try {
      final String jwtToken = AuthenticationPref.getAccessToken().toString();

      Uri uri = Uri.parse(
          "$apiWalletLedgertUrl?timeRange=$dateFrom&timeRange=$dateTo");
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

  //! paymentWallet
  @override
  Future<Map<String, dynamic>> addMoneyToWallet(
    WalletModel walletModel,
  ) async {
    try {
      final String jwtToken = AuthenticationPref.getAccessToken().toString();

      Uri uri = Uri.parse(apiPaymentWallettUrl);

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
            body: walletModel.toJson(),
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
}
