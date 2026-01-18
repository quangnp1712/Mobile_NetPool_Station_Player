// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:mobile_netpool_station_player/core/model/base_response_model.dart';
import 'package:mobile_netpool_station_player/features/8_Booking_History_Page/model/6.area/area_list_model.dart';

class AreaListModelResponse extends BaseResponse {
  AreaModel? data;

  AreaListModelResponse({
    this.data,
    status,
    success,
    errorCode,
    responseAt,
    message,
  });

  factory AreaListModelResponse.fromMap(Map<String, dynamic> map) {
    return AreaListModelResponse(
      data: map['data'] != null
          ? AreaModel.fromMap(map['data'] as Map<String, dynamic>)
          : null,
      status: map['status'] != null ? map['status'] as String : null,
      success: map['success'] != null ? map['success'] as bool : null,
      errorCode: map['errorCode'] as dynamic,
      responseAt:
          map['responseAt'] != null ? map['responseAt'] as String : null,
      message: map['message'] != null ? map['message'] as String : null,
    );
  }

  factory AreaListModelResponse.fromJson(Map<String, dynamic> source) =>
      AreaListModelResponse.fromMap(source);
}
