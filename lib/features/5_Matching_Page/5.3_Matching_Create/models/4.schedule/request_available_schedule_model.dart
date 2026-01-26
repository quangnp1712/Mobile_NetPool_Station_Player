import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class RequestAvailableScheduleModel {
  int stationId;
  String dateFrom;
  String begin;
  String end;
  List<int> stationResourceId;
  RequestAvailableScheduleModel({
    required this.stationId,
    required this.dateFrom,
    required this.begin,
    required this.end,
    required this.stationResourceId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'stationId': stationId,
      'dateFrom': dateFrom,
      'begin': begin,
      'end': end,
      'stationResourceId': stationResourceId,
    };
  }

  String toJson() => json.encode(toMap());
}
