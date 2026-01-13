//! Booking  !//
import 'package:mobile_netpool_station_player/core/network/api/api_endpoints.dart';

class BookingApi {
  //$ Station
  final String StationListUrl = "$domainUrl/v1/pub/stations";

  //$ Station Space
  final String stationSpaceUrl = "$domainUrl/v1/pub/station-spaces";

  //$ Platform Space
  final String viewSpaceUrl = "$domainUrl/v1/pub/spaces";

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
}
