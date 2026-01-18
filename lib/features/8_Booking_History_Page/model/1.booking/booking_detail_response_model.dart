// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:mobile_netpool_station_player/core/model/base_response_model.dart';
import 'package:mobile_netpool_station_player/features/8_Booking_History_Page/model/1.booking/booking_model.dart';

class BookingDetailModelResponse extends BaseResponse {
  BookingModel? data;

  BookingDetailModelResponse({
    this.data,
    status,
    success,
    errorCode,
    responseAt,
    message,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'data': data,
      'status': status,
      'success': success,
      'errorCode': errorCode,
      'responseAt': responseAt,
      'message': message,
    };
  }

  factory BookingDetailModelResponse.fromMap(Map<String, dynamic> map) {
    return BookingDetailModelResponse(
      data: map['data'] != null
          ? BookingModel.fromMap(map['data'] as Map<String, dynamic>)
          : null,
      status: map['status'] != null ? map['status'] as String : null,
      success: map['success'] != null ? map['success'] as bool : null,
      errorCode: map['errorCode'] as dynamic,
      responseAt:
          map['responseAt'] != null ? map['responseAt'] as String : null,
      message: map['message'] != null ? map['message'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BookingDetailModelResponse.fromJson(Map<String, dynamic> source) =>
      BookingDetailModelResponse.fromMap(source);
}
