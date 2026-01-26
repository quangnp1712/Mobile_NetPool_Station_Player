// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:mobile_netpool_station_player/core/model/base_response_model.dart';
import 'package:mobile_netpool_station_player/features/5_Matching_Page/5.3_Matching_Create/models/2.space/space_model.dart';
import 'package:mobile_netpool_station_player/features/Common/data/meta/model/meta_model.dart';

class PlatformSpaceModelResponse extends BaseResponse {
  PlatformSpaceModel? data;
  MetaModel? meta;

  PlatformSpaceModelResponse({
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
      'data': data,
      'status': status,
      'success': success,
      'errorCode': errorCode,
      'responseAt': responseAt,
      'message': message,
    };
  }

  factory PlatformSpaceModelResponse.fromMap(Map<String, dynamic> map) {
    return PlatformSpaceModelResponse(
      data: map['data'] != null
          ? PlatformSpaceModel.fromMap(map['data'] as Map<String, dynamic>)
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

  factory PlatformSpaceModelResponse.fromJson(Map<String, dynamic> source) =>
      PlatformSpaceModelResponse.fromMap(source);
}

class SpaceListMetaModel {
  int? pageSize;
  int? current;
  int? total;
  SpaceListMetaModel({
    this.pageSize,
    this.current,
    this.total,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pageSize': pageSize,
      'current': current,
      'total': total,
    };
  }

  factory SpaceListMetaModel.fromMap(Map<String, dynamic> map) {
    return SpaceListMetaModel(
      pageSize: map['pageSize'] != null ? map['pageSize'] as int : null,
      current: map['current'] != null ? map['current'] as int : null,
      total: map['total'] != null ? map['total'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SpaceListMetaModel.fromJson(Map<String, dynamic> source) =>
      SpaceListMetaModel.fromMap(source);
}
