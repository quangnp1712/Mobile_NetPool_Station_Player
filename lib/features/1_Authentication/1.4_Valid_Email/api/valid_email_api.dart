//! Valid Email !//
// ignore_for_file: non_constant_identifier_names

import 'package:mobile_netpool_station_player/core/network/api/api_endpoints.dart';

class ValidEmailApi {
  final String SendVerificationCodeUrl =
      "$domainUrl/v1/pub/email-verification/send";
  final String VerifyEmailUrl = "$domainUrl/v1/pub/email-verification/verify";
}
