import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class TimeslotModel {
  int? timeSlotId;
  int? scheduleId;
  String? begin;
  String? end;
  bool? allowBooking;
  String? periodCode;
  String? periodName;
  String? statusCode;
  String? statusName;

  TimeslotModel({
    this.timeSlotId,
    this.scheduleId,
    this.begin,
    this.end,
    this.allowBooking,
    this.periodCode,
    this.periodName,
    this.statusCode,
    this.statusName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'timeSlotId': timeSlotId,
      'scheduleId': scheduleId,
      'begin': begin,
      'end': end,
      'allowBooking': allowBooking,
      'periodCode': periodCode,
      'periodName': periodName,
      'statusCode': statusCode,
      'statusName': statusName,
    };
  }

  factory TimeslotModel.fromMap(Map<String, dynamic> map) {
    return TimeslotModel(
      timeSlotId: map['timeSlotId'] != null ? map['timeSlotId'] as int : null,
      scheduleId: map['scheduleId'] != null ? map['scheduleId'] as int : null,
      begin: map['begin'] != null ? map['begin'] as String : null,
      end: map['end'] != null ? map['end'] as String : null,
      allowBooking:
          map['allowBooking'] != null ? map['allowBooking'] as bool : false,
      periodCode:
          map['periodCode'] != null ? map['periodCode'] as String : null,
      periodName:
          map['periodName'] != null ? map['periodName'] as String : null,
      statusCode:
          map['statusCode'] != null ? map['statusCode'] as String : null,
      statusName:
          map['statusName'] != null ? map['statusName'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TimeslotModel.fromJson(Map<String, dynamic> source) =>
      TimeslotModel.fromMap(source);
}
