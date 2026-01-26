//! matching  !//
// ignore_for_file: non_constant_identifier_names

import 'package:mobile_netpool_station_player/core/network/api/api_endpoints.dart';

class MatchingApi {
  //$ Matching
  final String apiMatchingUrl = "$domainUrl/v1/api/match-making";

  //$ Matching join
  final String apiMatchingJoinUrl =
      "$domainUrl/v1/api/match-joining-registrations";

  final String apiWalletUrl = "$domainUrl/v1/api/wallets";
}
