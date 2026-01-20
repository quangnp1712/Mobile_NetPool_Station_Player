// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:mobile_netpool_station_player/features/8_Wallet_Payment/models/2.wallet_ledger/transaction_model.dart';

class WalletLedgerModel {
  int? walletLedgerId;
  int? walletId;
  double? currentBalance;
  double? changeAmount;
  double? newBalance;
  TransactionDetailModel? transaction;
  WalletLedgerModel({
    this.walletLedgerId,
    this.walletId,
    this.currentBalance,
    this.changeAmount,
    this.newBalance,
    this.transaction,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'walletLedgerId': walletLedgerId,
      'walletId': walletId,
      'currentBalance': currentBalance,
      'changeAmount': changeAmount,
      'newBalance': newBalance,
      'transaction': transaction?.toMap(),
    };
  }

  factory WalletLedgerModel.fromMap(Map<String, dynamic> map) {
    return WalletLedgerModel(
      walletLedgerId:
          map['walletLedgerId'] != null ? map['walletLedgerId'] as int : null,
      walletId: map['walletId'] != null ? map['walletId'] as int : null,
      currentBalance: map['currentBalance'] != null
          ? map['currentBalance'] as double
          : null,
      changeAmount:
          map['changeAmount'] != null ? map['changeAmount'] as double : null,
      newBalance:
          map['newBalance'] != null ? map['newBalance'] as double : null,
      transaction: map['transaction'] != null
          ? TransactionDetailModel.fromMap(
              map['transaction'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory WalletLedgerModel.fromJson(Map<String, dynamic> source) =>
      WalletLedgerModel.fromMap(source);

  bool get isIncome => newBalance! >= currentBalance!;
}
