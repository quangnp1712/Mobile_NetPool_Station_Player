// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:mobile_netpool_station_player/core/model/base_response_model.dart';
import 'package:mobile_netpool_station_player/features/5_Matching_Page/5.1_Matching/models/matching_model.dart';

class MatchMakingDetailModelResponse extends BaseResponse {
  MatchMakingModel? data;

  MatchMakingDetailModelResponse({
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

  factory MatchMakingDetailModelResponse.fromMap(Map<String, dynamic> map) {
    return MatchMakingDetailModelResponse(
      data: map['data'] != null
          ? MatchMakingModel.fromMap(map['data'] as Map<String, dynamic>)
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

  factory MatchMakingDetailModelResponse.fromJson(
          Map<String, dynamic> source) =>
      MatchMakingDetailModelResponse.fromMap(source);
}
