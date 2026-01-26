// ignore_for_file: deprecated_member_use

import 'package:geolocator/geolocator.dart';
import 'package:mobile_netpool_station_player/core/utils/debug_logger.dart';
import 'package:mobile_netpool_station_player/core/utils/shared_preferences_helper.dart';

abstract class ILocationService {
  Future<dynamic> getUserCurrentLocation();
}

class LocationService extends ILocationService {
  @override
  Future getUserCurrentLocation() async {
    final prefs = SharedPreferencesHelper.preferences;
    if (prefs.containsKey("latitude") && prefs.containsKey("longitude")) {
      double? lat = prefs.getDouble("latitude");
      double? long = prefs.getDouble("longitude");
      if (lat != null && long != null) {
        DebugLogger.printLog("Location retrieved from Prefs: $lat, $long");
        return PositionModel(latitude: lat, longitude: long);
      }
    }

    bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (isServiceEnabled == false) {
      return null;
    }
    final checkLocationPermission = await Geolocator.checkPermission();

    if (checkLocationPermission.name == LocationPermission.denied.name) {
      final requestPermission = await Geolocator.requestPermission();

      if (requestPermission.name == LocationPermission.denied.name) {
        prefs.setBool("locationPermission", false);
        prefs.setBool("permissionDeniedForever", false);
        if (prefs.containsKey("latitude")) {
          prefs.remove("latitude");
        }
        if (prefs.containsKey("longitude")) {
          prefs.remove("longitude");
        }
        return null;
      } else if (requestPermission.name ==
          LocationPermission.deniedForever.name) {
        prefs.setBool("locationPermission", false);
        prefs.setBool("permissionDeniedForever", true);
        if (prefs.containsKey("latitude")) {
          prefs.remove("latitude");
        }
        if (prefs.containsKey("longitude")) {
          prefs.remove("longitude");
        }
        return null;
      }
    } else if (checkLocationPermission.name ==
        LocationPermission.deniedForever.name) {
      prefs.setBool("locationPermission", false);
      prefs.setBool("permissionDeniedForever", true);
      if (prefs.containsKey("latitude")) {
        prefs.remove("latitude");
      }
      if (prefs.containsKey("longitude")) {
        prefs.remove("longitude");
      }
      return null;
    }

    prefs.setBool("locationPermission", true);
    prefs.setBool("permissionDeniedForever", false);
    Position position;
    try {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
          timeLimit: const Duration(seconds: 60));
      prefs.setDouble("longitude", position.longitude.abs());
      prefs.setDouble("latitude", position.latitude.abs());
      return position;
    } catch (e) {
      return null;
    }
  }
}

class PositionModel {
  final double latitude;
  final double longitude;
  PositionModel({required this.latitude, required this.longitude});
}
