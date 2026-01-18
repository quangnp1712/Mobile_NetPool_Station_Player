// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:mobile_netpool_station_player/core/model/base_response_model.dart';
import 'package:mobile_netpool_station_player/features/8_Booking_History_Page/model/1.booking/booking_model.dart';
import 'package:mobile_netpool_station_player/features/Common/data/meta/model/meta_model.dart';

class BookingListModelResponse extends BaseResponse {
  List<BookingModel>? data;
  MetaModel? meta;

  BookingListModelResponse({
    this.data,
    this.meta,
    status,
    success,
    errorCode,
    responseAt,
    message,
  });

  factory BookingListModelResponse.fromMap(Map<String, dynamic> map) {
    return BookingListModelResponse(
      data: map['data'] != null
          ? List<BookingModel>.from(
              (map['data'] as List).map(
                (x) => BookingModel.fromMap(x as Map<String, dynamic>),
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

  factory BookingListModelResponse.fromJson(Map<String, dynamic> source) =>
      BookingListModelResponse.fromMap(source);
}
