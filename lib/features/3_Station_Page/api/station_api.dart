//! Station  !//
import 'package:mobile_netpool_station_player/core/network/api/api_endpoints.dart';

class StationApi {
  //$ Station
  final String StationListUrl = "$domainUrl/v1/pub/stations";

  //$ Station Space
  final String stationSpaceUrl = "$domainUrl/v1/pub/station-spaces";

  //$ Platform Space
  final String viewSpaceUrl = "$domainUrl/v1/pub/spaces";
}
