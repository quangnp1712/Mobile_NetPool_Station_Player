import 'dart:convert';

import 'package:mobile_netpool_station_player/features/7_Booking_History_Page/model/2.station/station_detail_model.dart';
import 'package:mobile_netpool_station_player/features/7_Booking_History_Page/model/3.resource/resoucre_model.dart';
import 'package:mobile_netpool_station_player/features/7_Booking_History_Page/model/4.schedule/schedule_model.dart';
import 'package:mobile_netpool_station_player/features/7_Booking_History_Page/model/5.account/account_info_model.dart';
import 'package:mobile_netpool_station_player/features/7_Booking_History_Page/model/6.area/area_list_model.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class BookingModel {
  int? bookingId;
  int? accountId;
  int? scheduleId;
  int? stationResourceId;
  int? matchMakingId;
  int? totalPrice;
  String? bookingCode;
  String? cancelReason;
  String? typeCode;
  String? typeName;
  String? startAt;
  String? endAt;
  String? paymentMethodCode;
  String? paymentMethodName;
  String? statusCode;
  String? statusName;

  AccountInfoModel? account;
  ScheduleModel? schedule;
  StationDetailModel? station;
  StationResourceModel? stationResource;
  AreaModel? area;
  List<BookingMenuModel>? bookingMenus;
  List<BookingSlotModel>? bookingSlots;

  BookingModel({
    this.bookingId,
    this.accountId,
    this.scheduleId,
    this.stationResourceId,
    this.matchMakingId,
    this.totalPrice,
    this.bookingCode,
    this.cancelReason,
    this.typeCode,
    this.typeName,
    this.startAt,
    this.endAt,
    this.paymentMethodCode,
    this.paymentMethodName,
    this.statusCode,
    this.statusName,
    this.account,
    this.schedule,
    this.station,
    this.stationResource,
    this.bookingMenus,
    this.bookingSlots,
    this.area,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'bookingId': bookingId,
      'accountId': accountId,
      'scheduleId': scheduleId,
      'stationResourceId': stationResourceId,
      'matchMakingId': matchMakingId,
      'totalPrice': totalPrice,
      'bookingCode': bookingCode,
      'cancelReason': cancelReason,
      'typeCode': typeCode,
      'typeName': typeName,
      'startAt': startAt,
      'endAt': endAt,
      'paymentMethodCode': paymentMethodCode,
      'paymentMethodName': paymentMethodName,
      'statusCode': statusCode,
      'statusName': statusName,
      'schedule': schedule?.toMap(),
      'stationResource': stationResource?.toMap(),
      'bookingMenus': bookingMenus?.map((x) => x.toMap()).toList(),
      'bookingSlots': bookingSlots?.map((x) => x.toMap()).toList(),
    };
  }

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      bookingId: map['bookingId'] != null ? map['bookingId'] as int : null,
      accountId: map['accountId'] != null ? map['accountId'] as int : null,
      scheduleId: map['scheduleId'] != null ? map['scheduleId'] as int : null,
      stationResourceId: map['stationResourceId'] != null
          ? map['stationResourceId'] as int
          : null,
      matchMakingId:
          map['matchMakingId'] != null ? map['matchMakingId'] as int : null,
      totalPrice: map['totalPrice'] != null ? map['totalPrice'] as int : null,
      bookingCode:
          map['bookingCode'] != null ? map['bookingCode'] as String : null,
      cancelReason:
          map['cancelReason'] != null ? map['cancelReason'] as String : null,
      typeCode: map['typeCode'] != null ? map['typeCode'] as String : null,
      typeName: map['typeName'] != null ? map['typeName'] as String : null,
      startAt: map['startAt'] != null ? map['startAt'] as String : null,
      endAt: map['endAt'] != null ? map['endAt'] as String : null,
      paymentMethodCode: map['paymentMethodCode'] != null
          ? map['paymentMethodCode'] as String
          : null,
      paymentMethodName: map['paymentMethodName'] != null
          ? map['paymentMethodName'] as String
          : null,
      statusCode:
          map['statusCode'] != null ? map['statusCode'] as String : null,
      statusName:
          map['statusName'] != null ? map['statusName'] as String : null,
      schedule: map['schedule'] != null
          ? ScheduleModel.fromMap(map['schedule'] as Map<String, dynamic>)
          : null,
      account: map['account'] != null
          ? AccountInfoModel.fromMap(map['account'] as Map<String, dynamic>)
          : null,
      stationResource: map['stationResource'] != null
          ? StationResourceModel.fromMap(
              map['stationResource'] as Map<String, dynamic>)
          : null,
      bookingMenus: map['bookingMenus'] != null
          ? List<BookingMenuModel>.from(
              (map['bookingMenus'] as List).map(
                (x) => BookingMenuModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      bookingSlots: map['bookingSlots'] != null
          ? List<BookingSlotModel>.from(
              (map['bookingSlots'] as List).map(
                (x) => BookingSlotModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BookingModel.fromJson(Map<String, dynamic> source) =>
      BookingModel.fromMap(source);

  void mergeDetail(BookingModel detail) {
    totalPrice = detail.totalPrice ?? totalPrice;
    typeCode = detail.typeCode ?? typeCode;
    typeName = detail.typeName ?? typeName;
    statusCode = detail.statusCode ?? statusCode;
    statusName = detail.statusName ?? statusName;
    paymentMethodName = detail.paymentMethodName ?? paymentMethodName;
    account = detail.account ?? account;
    schedule = detail.schedule ?? schedule;
    stationResource = detail.stationResource ?? stationResource;
    area = detail.area ?? area;
  }
}

class BookingMenuModel {
  BookingMenuIdModel? bookingMenuId;
  String? menuCode;
  String? menuName;
  String? typeCode;
  String? typeName;
  int? price;
  BookingMenuModel({
    this.bookingMenuId,
    this.menuCode,
    this.menuName,
    this.typeCode,
    this.typeName,
    this.price,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'bookingMenuId': bookingMenuId?.toMap(),
      'menuCode': menuCode,
      'menuName': menuName,
      'typeCode': typeCode,
      'typeName': typeName,
      'price': price,
    };
  }

  factory BookingMenuModel.fromMap(Map<String, dynamic> map) {
    return BookingMenuModel(
      bookingMenuId: map['bookingMenuId'] != null
          ? BookingMenuIdModel.fromMap(
              map['bookingMenuId'] as Map<String, dynamic>)
          : null,
      menuCode: map['menuCode'] != null ? map['menuCode'] as String : null,
      menuName: map['menuName'] != null ? map['menuName'] as String : null,
      typeCode: map['typeCode'] != null ? map['typeCode'] as String : null,
      typeName: map['typeName'] != null ? map['typeName'] as String : null,
      price: map['price'] != null ? map['price'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BookingMenuModel.fromJson(Map<String, dynamic> source) =>
      BookingMenuModel.fromMap(source);
}

class BookingMenuIdModel {
  int? bookingId;
  int? stationMenuId;
  BookingMenuIdModel({
    this.bookingId,
    this.stationMenuId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'bookingId': bookingId,
      'stationMenuId': stationMenuId,
    };
  }

  factory BookingMenuIdModel.fromMap(Map<String, dynamic> map) {
    return BookingMenuIdModel(
      bookingId: map['bookingId'] != null ? map['bookingId'] as int : null,
      stationMenuId:
          map['stationMenuId'] != null ? map['stationMenuId'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BookingMenuIdModel.fromJson(Map<String, dynamic> source) =>
      BookingMenuIdModel.fromMap(source);
}

class BookingSlotModel {
  BookingSlotIdModel? bookingSlotId;
  String? begin;
  String? end;
  String? periodCode;
  String? periodName;
  BookingSlotModel({
    this.bookingSlotId,
    this.begin,
    this.end,
    this.periodCode,
    this.periodName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'bookingSlotId': bookingSlotId?.toMap(),
      'begin': begin,
      'end': end,
      'periodCode': periodCode,
      'periodName': periodName,
    };
  }

  factory BookingSlotModel.fromMap(Map<String, dynamic> map) {
    return BookingSlotModel(
      bookingSlotId: map['bookingSlotId'] != null
          ? BookingSlotIdModel.fromMap(
              map['bookingSlotId'] as Map<String, dynamic>)
          : null,
      begin: map['begin'] != null ? map['begin'] as String : null,
      end: map['end'] != null ? map['end'] as String : null,
      periodCode:
          map['periodCode'] != null ? map['periodCode'] as String : null,
      periodName:
          map['periodName'] != null ? map['periodName'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BookingSlotModel.fromJson(Map<String, dynamic> source) =>
      BookingSlotModel.fromMap(source);
}

class BookingSlotIdModel {
  int? bookingId;
  int? timeSlotId;
  BookingSlotIdModel({
    this.bookingId,
    this.timeSlotId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'bookingId': bookingId,
      'timeSlotId': timeSlotId,
    };
  }

  factory BookingSlotIdModel.fromMap(Map<String, dynamic> map) {
    return BookingSlotIdModel(
      bookingId: map['bookingId'] != null ? map['bookingId'] as int : null,
      timeSlotId: map['timeSlotId'] != null ? map['timeSlotId'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BookingSlotIdModel.fromJson(Map<String, dynamic> source) =>
      BookingSlotIdModel.fromMap(source);
}
