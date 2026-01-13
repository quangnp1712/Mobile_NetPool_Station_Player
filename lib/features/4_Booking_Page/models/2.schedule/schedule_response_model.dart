// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:mobile_netpool_station_player/core/model/base_response_model.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/models/2.schedule/schedule_model.dart';
import 'package:mobile_netpool_station_player/features/Common/data/meta/model/meta_model.dart';

class ScheduleModelResponse extends BaseResponse {
  ScheduleModel? data;
  MetaModel? meta;

  ScheduleModelResponse({
    this.data,
    this.meta,
    status,
    success,
    errorCode,
    responseAt,
    message,
  });

  factory ScheduleModelResponse.fromMap(Map<String, dynamic> map) {
    return ScheduleModelResponse(
      data: map['data'] != null
          ? ScheduleModel.fromMap(map['data'] as Map<String, dynamic>)
          : null,
      meta: map['meta'] != null
          ? MetaModel.fromMap(map['meta'] as Map<String, dynamic>)
          : null,
      status: map['status'] != null ? map['status'] as String : null,
      success: map['success'] != null ? map['success'] as bool : null,
      errorCode: map['errorCode'] as dynamic,
      responseAt:
          map['responseAt'] != null ? map['responseAt'] as String : null,
      message: map['message'] != null ? map['message'] as String : null,
    );
  }

  factory ScheduleModelResponse.fromJson(Map<String, dynamic> source) =>
      ScheduleModelResponse.fromMap(source);
}
