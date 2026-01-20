import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class WalletModel {
  int? walletId;
  int? accountId;
  double? balance;
  String? statusCode;
  String? statusName;

  double? amount;
  String? currency;

  String? checkoutUrl;

  WalletModel({
    this.walletId,
    this.accountId,
    this.balance,
    this.statusCode,
    this.statusName,
    this.amount,
    this.currency,
    this.checkoutUrl,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'amount': amount,
      'currency': currency,
    };
  }

  factory WalletModel.fromMap(Map<String, dynamic> map) {
    return WalletModel(
      walletId: map['walletId'] != null ? map['walletId'] as int : null,
      accountId: map['accountId'] != null ? map['accountId'] as int : null,
      balance: map['balance'] != null ? map['balance'] as double : null,
      statusCode:
          map['statusCode'] != null ? map['statusCode'] as String : null,
      statusName:
          map['statusName'] != null ? map['statusName'] as String : null,
      amount: map['amount'] != null ? map['amount'] as double : null,
      currency: map['currency'] != null ? map['currency'] as String : null,
      checkoutUrl:
          map['checkoutUrl'] != null ? map['checkoutUrl'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory WalletModel.fromJson(Map<String, dynamic> source) =>
      WalletModel.fromMap(source);
}
