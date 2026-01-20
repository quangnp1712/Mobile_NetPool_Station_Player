import 'dart:convert';

import 'package:mobile_netpool_station_player/features/7_Booking_History_Page/model/4.schedule/timeslot_model.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ScheduleModel {
  int? stationId;
  String? date;
  String? dateFrom;
  String? dateTo;
  TimeSlotConfig? timeSlotConfig;
  int? scheduleId;
  String? statusCode;
  String? statusName;
  bool? allowUpdate;
  List<TimeslotModel>? timeSlots;

  ScheduleModel({
    this.stationId,
    this.date,
    this.dateFrom,
    this.dateTo,
    this.timeSlotConfig,
    this.scheduleId,
    this.statusCode,
    this.statusName,
    this.allowUpdate,
    this.timeSlots,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'stationId': stationId,
      'date': date,
      'dateFrom': dateFrom,
      'dateTo': dateTo,
      'timeSlotConfig': timeSlotConfig?.toMap(),
      'scheduleId': scheduleId,
      'statusCode': statusCode,
      'statusName': statusName,
      'allowUpdate': allowUpdate,
      'timeSlots': timeSlots?.map((x) => x.toMap()).toList(),
    };
  }

  factory ScheduleModel.fromMap(Map<String, dynamic> map) {
    return ScheduleModel(
      stationId: map['stationId'] != null ? map['stationId'] as int : null,
      date: map['date'] != null ? map['date'] as String : null,
      dateFrom: map['dateFrom'] != null ? map['dateFrom'] as String : null,
      dateTo: map['dateTo'] != null ? map['dateTo'] as String : null,
      timeSlotConfig: map['timeSlotConfig'] != null
          ? TimeSlotConfig.fromMap(
              map['timeSlotConfig'] as Map<String, dynamic>)
          : null,
      scheduleId: map['scheduleId'] != null ? map['scheduleId'] as int : null,
      statusCode:
          map['statusCode'] != null ? map['statusCode'] as String : null,
      statusName:
          map['statusName'] != null ? map['statusName'] as String : null,
      allowUpdate:
          map['allowUpdate'] != null ? map['allowUpdate'] as bool : null,
      timeSlots: map['timeSlots'] != null
          ? List<TimeslotModel>.from(
              (map['timeSlots'] as List).map(
                (x) => TimeslotModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ScheduleModel.fromJson(Map<String, dynamic> source) =>
      ScheduleModel.fromMap(source);
}

class TimeSlotConfig {
  String? from;
  String? to;
  String? intervalTypeCode;
  TimeSlotConfig({
    this.from,
    this.to,
    this.intervalTypeCode,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'from': from,
      'to': to,
      'intervalTypeCode': intervalTypeCode,
    };
  }

  factory TimeSlotConfig.fromMap(Map<String, dynamic> map) {
    return TimeSlotConfig(
      from: map['from'] != null ? map['from'] as String : null,
      to: map['to'] != null ? map['to'] as String : null,
      intervalTypeCode: map['intervalTypeCode'] != null
          ? map['intervalTypeCode'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TimeSlotConfig.fromJson(Map<String, dynamic> source) =>
      TimeSlotConfig.fromMap(source);
}
