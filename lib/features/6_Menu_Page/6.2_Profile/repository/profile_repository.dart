import 'package:http/http.dart' as http;
import 'package:mobile_netpool_station_player/core/network/exceptions/app_exceptions.dart';
import 'package:mobile_netpool_station_player/core/network/exceptions/exception_handlers.dart';
import 'package:mobile_netpool_station_player/features/6_Menu_Page/6.2_Profile/api/profile_api.dart';

abstract class IProfileRepository {
  Future<Map<String, dynamic>> getProfile(String accountId);
}

class ProfileRepository extends ProfileApi implements IProfileRepository {
  //! Platform Space
  @override
  Future<Map<String, dynamic>> getProfile(String accountId) async {
    try {
      Uri uri = Uri.parse("$profileUrl/$accountId");
      final client = http.Client();
      final response = await client.get(
        uri,
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*',
        },
      ).timeout(const Duration(seconds: 180));
      return processResponse(response);
    } catch (e) {
      return ExceptionHandlers().getExceptionString(e);
    }
  }
}
