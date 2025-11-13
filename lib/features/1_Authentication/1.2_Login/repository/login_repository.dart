import 'package:http/http.dart' as http;
import 'package:mobile_netpool_station_player/core/network/exceptions/app_exceptions.dart';
import 'package:mobile_netpool_station_player/core/network/exceptions/exception_handlers.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.2_Login/api/login_api.dart';
import 'package:mobile_netpool_station_player/features/1_Authentication/1.2_Login/model/login_model.dart';

abstract class ILoginRepository {
  Future<Map<String, dynamic>> login(LoginModel loginModel);
}

class LoginRepository extends LoginApi implements ILoginRepository {
  @override
  Future<Map<String, dynamic>> login(LoginModel loginModel) async {
    try {
      Uri uri = Uri.parse(LoginUrl);
      final client = http.Client();
      final response = await client
          .post(
            uri,
            headers: {
              "Access-Control-Allow-Origin": "*",
              'Content-Type': 'application/json',
              'Accept': '*/*',
            },
            body: loginModel.toJson(),
          )
          .timeout(const Duration(seconds: 180));
      return processResponse(response);
    } catch (e) {
      return ExceptionHandlers().getExceptionString(e);
    }
  }
}
