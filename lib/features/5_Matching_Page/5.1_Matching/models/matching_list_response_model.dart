// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:mobile_netpool_station_player/core/model/base_response_model.dart';
import 'package:mobile_netpool_station_player/features/5_Matching_Page/5.1_Matching/models/matching_model.dart';
import 'package:mobile_netpool_station_player/features/Common/data/meta/model/meta_model.dart';

class MatchMakingListModelResponse extends BaseResponse {
  List<MatchMakingJoinModel>? data;
  MetaModel? meta;

  MatchMakingListModelResponse({
    this.data,
    this.meta,
    status,
    success,
    errorCode,
    responseAt,
    message,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'data': data?.map((x) => x.toMap()).toList(),
      'status': status,
      'success': success,
      'errorCode': errorCode,
      'responseAt': responseAt,
      'message': message,
    };
  }

  factory MatchMakingListModelResponse.fromMap(Map<String, dynamic> map) {
    return MatchMakingListModelResponse(
      data: map['data'] != null
          ? List<MatchMakingJoinModel>.from(
              (map['data'] as List).map(
                (x) => MatchMakingJoinModel.fromMap(x as Map<String, dynamic>),
              ),
            )
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

  String toJson() => json.encode(toMap());

  factory MatchMakingListModelResponse.fromJson(Map<String, dynamic> source) =>
      MatchMakingListModelResponse.fromMap(source);
}
