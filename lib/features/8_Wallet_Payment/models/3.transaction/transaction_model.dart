import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class TransactionDetailModel {
  String? transactionCode;
  double? amount;
  String? paymentTypeName;
  String? paymentMethodName;
  DateTime? paymentCompleteAt;
  String? statusCode;
  String? statusName;
  TransactionDetailModel({
    this.transactionCode,
    this.amount,
    this.paymentTypeName,
    this.paymentMethodName,
    this.paymentCompleteAt,
    this.statusCode,
    this.statusName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'transactionCode': transactionCode,
      'amount': amount,
      'paymentTypeName': paymentTypeName,
      'paymentMethodName': paymentMethodName,
      'paymentCompleteAt': paymentCompleteAt?.millisecondsSinceEpoch,
      'statusCode': statusCode,
      'statusName': statusName,
    };
  }

  factory TransactionDetailModel.fromMap(Map<String, dynamic> map) {
    return TransactionDetailModel(
      transactionCode: map['transactionCode'] != null
          ? map['transactionCode'] as String
          : null,
      amount: map['amount'] != null ? map['amount'] as double : null,
      paymentTypeName: map['paymentTypeName'] != null
          ? map['paymentTypeName'] as String
          : null,
      paymentMethodName: map['paymentMethodName'] != null
          ? map['paymentMethodName'] as String
          : null,
      paymentCompleteAt: map['paymentCompleteAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['paymentCompleteAt'] as int)
          : null,
      statusCode:
          map['statusCode'] != null ? map['statusCode'] as String : null,
      statusName:
          map['statusName'] != null ? map['statusName'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TransactionDetailModel.fromJson(Map<String, dynamic> source) =>
      TransactionDetailModel.fromMap(source);
}
