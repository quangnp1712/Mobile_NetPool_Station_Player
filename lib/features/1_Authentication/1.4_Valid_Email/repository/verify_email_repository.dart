// ignore_for_file: non_constant_identifier_names

import 'package:http/http.dart' as http;
import 'package:mobile_netpool_station_player/core/network/exceptions/app_exceptions.dart';
import 'package:mobile_netpool_station_player/core/network/exceptions/exception_handlers.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.4_Valid_Email/api/valid_email_api.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.4_Valid_Email/model/verify_email_model.dart';

abstract class IVerifyEmailRepository {
  Future<Map<String, dynamic>> SendVerifyCode(VerfyEmailModel verifyEmailModel);
  Future<Map<String, dynamic>> VerifyEmail(VerfyEmailModel verifyEmailModel);
}

class VerifyEmailRepository extends ValidEmailApi
    implements IVerifyEmailRepository {
  @override
  Future<Map<String, dynamic>> SendVerifyCode(
      VerfyEmailModel verifyEmailModel) async {
    try {
      Uri uri = Uri.parse(SendVerificationCodeUrl);
      final client = http.Client();
      final response = await client
          .post(
            uri,
            headers: {
              "Access-Control-Allow-Origin": "*",
              'Content-Type': 'application/json',
              'Accept': '*/*',
            },
            body: verifyEmailModel.toJson(),
          )
          .timeout(const Duration(seconds: 180));
      return processResponse(response);
    } catch (e) {
      return ExceptionHandlers().getExceptionString(e);
    }
  }

  @override
  Future<Map<String, dynamic>> VerifyEmail(
      VerfyEmailModel verifyEmailModel) async {
    try {
      Uri uri = Uri.parse(VerifyEmailUrl);
      final client = http.Client();
      final response = await client
          .post(
            uri,
            headers: {
              "Access-Control-Allow-Origin": "*",
              'Content-Type': 'application/json',
              'Accept': '*/*',
            },
            body: verifyEmailModel.toJson(),
          )
          .timeout(const Duration(seconds: 180));
      return processResponse(response);
    } catch (e) {
      return ExceptionHandlers().getExceptionString(e);
    }
  }
}
