import 'dart:convert';

import 'package:mobile_netpool_station_player/features/4_Booking_Page/models/5.resource/resoucre_spec_model.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class StationResourceModel {
  // model
  int? stationResourceId;
  int? areaId;
  ResourceSpecModel? spec;
  String? resourceName;
  String? resourceCode;
  String? typeCode;
  String? typeName;
  bool? allowDirectPayment;
  String? statusCode;
  String? statusName;

  int? displayOrder;
  String? rowCode;
  String? rowName;

  int? price;

  StationResourceModel({
    this.stationResourceId,
    this.areaId,
    this.spec,
    this.resourceCode,
    this.resourceName,
    this.typeCode,
    this.typeName,
    this.allowDirectPayment,
    this.statusCode,
    this.statusName,
    this.displayOrder,
    this.rowCode,
    this.rowName,
    this.price,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'stationResourceId': stationResourceId,
      'areaId': areaId,
      'spec': spec?.toMap(),
      'resourceCode': resourceCode,
      'resourceName': resourceName,
      'typeCode': typeCode,
      'typeName': typeName,
      'allowDirectPayment': allowDirectPayment,
      'statusCode': statusCode,
      'statusName': statusName,
      'displayOrder': displayOrder,
      'rowCode': rowCode,
      'rowName': rowName,
      'price': price,
    };
  }

  factory StationResourceModel.fromMap(Map<String, dynamic> map) {
    return StationResourceModel(
      stationResourceId: map['stationResourceId'] != null
          ? map['stationResourceId'] as int
          : null,
      areaId: map['areaId'] != null ? map['areaId'] as int : null,
      spec: map['spec'] != null
          ? ResourceSpecModel.fromMap(map['spec'] as Map<String, dynamic>)
          : null,
      resourceCode:
          map['resourceCode'] != null ? map['resourceCode'] as String : null,
      resourceName:
          map['resourceName'] != null ? map['resourceName'] as String : null,
      typeCode: map['typeCode'] != null ? map['typeCode'] as String : null,
      typeName: map['typeName'] != null ? map['typeName'] as String : null,
      allowDirectPayment: map['allowDirectPayment'] != null
          ? map['allowDirectPayment'] as bool
          : null,
      statusCode:
          map['statusCode'] != null ? map['statusCode'] as String : null,
      statusName:
          map['statusName'] != null ? map['statusName'] as String : null,
      rowCode: map['rowCode'] != null ? map['rowCode'] as String : null,
      rowName: map['rowName'] != null ? map['rowName'] as String : null,
      displayOrder:
          map['displayOrder'] != null ? map['displayOrder'] as int : null,
      price: map['price'] != null ? map['price'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory StationResourceModel.fromJson(Map<String, dynamic> source) =>
      StationResourceModel.fromMap(source);

  StationResourceModel copyWith({
    int? stationResourceId,
    int? areaId,
    int? price,
    ResourceSpecModel? spec,
    String? resourceCode,
    String? resourceName,
    String? typeCode,
    String? typeName,
    bool? allowDirectPayment,
    String? statusCode,
    String? statusName,
    int? displayOrder,
    String? rowCode,
    String? rowName,
  }) {
    return StationResourceModel(
      stationResourceId: stationResourceId ?? this.stationResourceId,
      areaId: areaId ?? this.areaId,
      price: price ?? this.price,
      spec: spec ?? this.spec,
      resourceCode: resourceCode ?? this.resourceCode,
      resourceName: resourceName ?? this.resourceName,
      typeCode: typeCode ?? this.typeCode,
      typeName: typeName ?? this.typeName,
      allowDirectPayment: allowDirectPayment ?? this.allowDirectPayment,
      statusCode: statusCode ?? this.statusCode,
      statusName: statusName ?? this.statusName,
      displayOrder: displayOrder ?? this.displayOrder,
      rowCode: rowCode ?? this.rowCode,
      rowName: rowName ?? this.rowName,
    );
  }
}
