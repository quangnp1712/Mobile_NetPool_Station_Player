//! Booking  !//
// ignore_for_file: non_constant_identifier_names

import 'package:mobile_netpool_station_player/core/network/api/api_endpoints.dart';

class MatchingApi {
  // Station
  final String StationListUrl = "$domainUrl/v1/pub/stations";

  // Station Space
  final String pubSpaceUrl = "$domainUrl/v1/pub/station-spaces";

  // Game
  final String pubGameUrl = "$domainUrl/v1/pub/games";

  //$ Platform Space
  final String pubPlatformSpaceUrl = "$domainUrl/v1/pub/spaces";

  //$ Area
  final String pubAreaUrl = "$domainUrl/v1/pub/areas";

  //$  Resouce
  final String pubResouceUrl = "$domainUrl/v1/pub/station-resources";
  final String apiResouceUrl = "$domainUrl/v1/api/station-resources";

  //$  Resouce Spec
  final String pubResouceSpecUrl = "$domainUrl/v1/pub/station-resources/specs";
  final String apiResouceSpecUrl = "$domainUrl/v1/api/station-resources/specs";

  //$  Schedule
  final String pubScheduleUrl = "$domainUrl/v1/pub/schedules";

  //$  Booking
  final String pubBookingUrl = "$domainUrl/v1/pub/bookings";
  final String apiBookingUrl = "$domainUrl/v1/api/bookings";

  //$ Wallet
  final String apiWalletUrl = "$domainUrl/v1/api/wallets";

  //$ match making
  final String apiMatchMkingUrl = "$domainUrl/v1/api/match-making";
}
