import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class RequestAvailableResourceModel {
  String date;
  String begin;
  String end;
  RequestAvailableResourceModel({
    required this.date,
    required this.begin,
    required this.end,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date,
      'begin': begin,
      'end': end,
    };
  }

  String toJson() => json.encode(toMap());
}
