import 'package:http/http.dart' as http;
import 'package:mobile_netpool_station_player/core/network/exceptions/app_exceptions.dart';
import 'package:mobile_netpool_station_player/core/network/exceptions/exception_handlers.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.3_Register/api/register_api.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.3_Register/model/register_model.dart';

//! Register - station owner !//
abstract class IRegisterRepository {
  Future<Map<String, dynamic>> register(RegisterModel registerModel);
}

class RegisterRepository extends RegisterApi implements IRegisterRepository {
  @override
  Future<Map<String, dynamic>> register(RegisterModel registerModel) async {
    try {
      Uri uri = Uri.parse(RegisterUrl);
      final client = http.Client();
      final response = await client
          .post(
            uri,
            headers: {
              "Access-Control-Allow-Origin": "*",
              'Content-Type': 'application/json',
              'Accept': '*/*',
            },
            body: registerModel.toJson(),
          )
          .timeout(const Duration(seconds: 180));
      return processResponse(response);
    } catch (e) {
      return ExceptionHandlers().getExceptionString(e);
    }
  }
}
