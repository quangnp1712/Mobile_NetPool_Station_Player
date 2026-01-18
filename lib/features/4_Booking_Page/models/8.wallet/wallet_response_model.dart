// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:mobile_netpool_station_player/core/model/base_response_model.dart';
import 'package:mobile_netpool_station_player/features/4_Booking_Page/models/8.wallet/wallet_model.dart';

class WalletModelResponse extends BaseResponse {
  WalletModel? data;

  WalletModelResponse({
    this.data,
    status,
    success,
    errorCode,
    responseAt,
    message,
  });

  factory WalletModelResponse.fromMap(Map<String, dynamic> map) {
    return WalletModelResponse(
      data: map['data'] != null
          ? WalletModel.fromMap(map['data'] as Map<String, dynamic>)
          : null,
      status: map['status'] != null ? map['status'] as String : null,
      success: map['success'] != null ? map['success'] as bool : null,
      errorCode: map['errorCode'] as dynamic,
      responseAt:
          map['responseAt'] != null ? map['responseAt'] as String : null,
      message: map['message'] != null ? map['message'] as String : null,
    );
  }

  factory WalletModelResponse.fromJson(Map<String, dynamic> source) =>
      WalletModelResponse.fromMap(source);
}
