// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:mobile_netpool_station_player/core/model/base_response_model.dart';
import 'package:mobile_netpool_station_player/features/7_Booking_History_Page/model/3.resource/resoucre_model.dart';

class ResoucreModelResponse extends BaseResponse {
  StationResourceModel? data;

  ResoucreModelResponse({
    this.data,
    status,
    success,
    errorCode,
    responseAt,
    message,
  });

  factory ResoucreModelResponse.fromMap(Map<String, dynamic> map) {
    return ResoucreModelResponse(
      data: map['data'] != null
          ? StationResourceModel.fromMap(map['data'] as Map<String, dynamic>)
          : null,
      status: map['status'] != null ? map['status'] as String : null,
      success: map['success'] != null ? map['success'] as bool : null,
      errorCode: map['errorCode'] != null ? map['errorCode'] as String : null,
      responseAt:
          map['responseAt'] != null ? map['responseAt'] as String : null,
      message: map['message'] != null ? map['message'] as String : null,
    );
  }

  factory ResoucreModelResponse.fromJson(Map<String, dynamic> source) =>
      ResoucreModelResponse.fromMap(source);
}
