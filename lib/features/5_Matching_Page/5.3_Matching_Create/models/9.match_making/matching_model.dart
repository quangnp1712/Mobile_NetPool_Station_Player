import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class MatchMakingModel {
  int? matchMakingId;
  int? stationId;
  int? gameId;
  String? matchMakingCode;
  int? limitParticipant;
  double? totalPrice;
  DateTime? startAt;
  DateTime? expiredAt;
  DateTime? playAt;
  String? statusCode;
  String? statusName;
  bool? allowJoin;
  bool? allowView;

  // New fields from JSON Request
  int? numberOfHoldingDay;
  String? resourceTypeCode;
  String? resourceTypeName;
  String? typeCode;
  String? typeName;
  String? paymentMethodCode;
  String? paymentMethodName;

  List<Map<String, dynamic>>? slots;
  List<Map<String, dynamic>>? schedules;
  List<Map<String, dynamic>>? resources;
  List<MatchParticipant>? participants;
  MatchMakingModel({
    this.matchMakingId,
    this.stationId,
    this.gameId,
    this.matchMakingCode,
    this.limitParticipant,
    this.totalPrice,
    this.startAt,
    this.expiredAt,
    this.playAt,
    this.statusCode,
    this.statusName,
    this.allowJoin,
    this.allowView,
    this.numberOfHoldingDay,
    this.resourceTypeCode,
    this.resourceTypeName,
    this.typeCode,
    this.typeName,
    this.paymentMethodCode,
    this.paymentMethodName,
    this.slots,
    this.schedules,
    this.resources,
    this.participants,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'stationId': stationId,
      'gameId': gameId,
      'resourceTypeCode': resourceTypeCode,
      'resourceTypeName': resourceTypeName,
      'paymentMethodCode': paymentMethodCode,
      'paymentMethodName': paymentMethodName,
      'slots': slots,
      'schedules': schedules,
      'resources': resources,
    };
  }

  factory MatchMakingModel.fromMap(Map<String, dynamic> map) {
    return MatchMakingModel(
      matchMakingId:
          map['matchMakingId'] != null ? map['matchMakingId'] as int : null,
      stationId: map['stationId'] != null ? map['stationId'] as int : null,
      matchMakingCode: map['matchMakingCode'] != null
          ? map['matchMakingCode'] as String
          : null,
      limitParticipant: map['limitParticipant'] != null
          ? map['limitParticipant'] as int
          : null,
      totalPrice:
          map['totalPrice'] != null ? map['totalPrice'] as double : null,
      startAt: map['startAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['startAt'] as int)
          : null,
      expiredAt: map['expiredAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['expiredAt'] as int)
          : null,
      playAt: map['playAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['playAt'] as int)
          : null,
      statusCode:
          map['statusCode'] != null ? map['statusCode'] as String : null,
      statusName:
          map['statusName'] != null ? map['statusName'] as String : null,
      allowJoin: map['allowJoin'] != null ? map['allowJoin'] as bool : null,
      allowView: map['allowView'] != null ? map['allowView'] as bool : null,
      numberOfHoldingDay: map['numberOfHoldingDay'] != null
          ? map['numberOfHoldingDay'] as int
          : null,
      resourceTypeCode: map['resourceTypeCode'] != null
          ? map['resourceTypeCode'] as String
          : null,
      resourceTypeName: map['resourceTypeName'] != null
          ? map['resourceTypeName'] as String
          : null,
      typeCode: map['typeCode'] != null ? map['typeCode'] as String : null,
      typeName: map['typeName'] != null ? map['typeName'] as String : null,
      paymentMethodCode: map['paymentMethodCode'] != null
          ? map['paymentMethodCode'] as String
          : null,
      paymentMethodName: map['paymentMethodName'] != null
          ? map['paymentMethodName'] as String
          : null,
      // slots: map['slots'] != null
      //     ? List<MatchSlot>.from(
      //         (map['slots'] as List<int>).map<MatchSlot?>(
      //           (x) => MatchSlot.fromMap(x as Map<String, dynamic>),
      //         ),
      //       )
      //     : null,
      // resources: map['resources'] != null
      //     ? List<MatchResource>.from(
      //         (map['resources'] as List<int>).map<MatchResource?>(
      //           (x) => MatchResource.fromMap(x as Map<String, dynamic>),
      //         ),
      //       )
      //     : null,
      participants: map['participants'] != null
          ? List<MatchParticipant>.from(
              (map['participants'] as List<int>).map<MatchParticipant?>(
                (x) => MatchParticipant.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MatchMakingModel.fromJson(String source) =>
      MatchMakingModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class MatchSlot {
  MatchSlotId? id;
  String? begin;
  String? end;
  MatchSlot({
    this.begin,
    this.end,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'begin': begin,
      'end': end,
    };
  }

  factory MatchSlot.fromMap(Map<String, dynamic> map) {
    return MatchSlot(
      begin: map['begin'] != null ? map['begin'] as String : null,
      end: map['end'] != null ? map['end'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MatchSlot.fromJson(Map<String, dynamic> source) =>
      MatchSlot.fromMap(source);
}

class MatchSlotId {
  int? matchMakingId;
  int? timeSlotId;
  MatchSlotId({
    this.matchMakingId,
    this.timeSlotId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'matchMakingId': matchMakingId,
      'timeSlotId': timeSlotId,
    };
  }

  factory MatchSlotId.fromMap(Map<String, dynamic> map) {
    return MatchSlotId(
      matchMakingId:
          map['matchMakingId'] != null ? map['matchMakingId'] as int : null,
      timeSlotId: map['timeSlotId'] != null ? map['timeSlotId'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MatchSlotId.fromJson(Map<String, dynamic> source) =>
      MatchSlotId.fromMap(source);
}

class MatchResource {
  MatchResourceId? id;
  String? typeCode;
  String? typeName;
  double? price;
  MatchResource({
    this.typeCode,
    this.typeName,
    this.price,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'typeCode': typeCode,
      'typeName': typeName,
      'price': price,
    };
  }

  factory MatchResource.fromMap(Map<String, dynamic> map) {
    return MatchResource(
      typeCode: map['typeCode'] != null ? map['typeCode'] as String : null,
      typeName: map['typeName'] != null ? map['typeName'] as String : null,
      price: map['price'] != null ? map['price'] as double : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MatchResource.fromJson(Map<String, dynamic> source) =>
      MatchResource.fromMap(source);
}

class MatchResourceId {
  int? matchMakingId;
  int? stationResourceId;
  MatchResourceId({
    this.matchMakingId,
    this.stationResourceId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'matchMakingId': matchMakingId,
      'stationResourceId': stationResourceId,
    };
  }

  factory MatchResourceId.fromMap(Map<String, dynamic> map) {
    return MatchResourceId(
      matchMakingId:
          map['matchMakingId'] != null ? map['matchMakingId'] as int : null,
      stationResourceId: map['stationResourceId'] != null
          ? map['stationResourceId'] as int
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MatchResourceId.fromJson(Map<String, dynamic> source) =>
      MatchResourceId.fromMap(source);
}

class MatchParticipant {
  int? matchParticipantId;
  int? accountId;
  int? matchMakingId;
  String? typeCode;
  String? typeName;
  String? paymentMethodCode;
  String? paymentMethodName;
  String? readyStatusCode;
  String? readyStatusName;
  double? shareAmount;
  String? statusCode;
  String? statusName;
  MatchAccount? account;
  MatchParticipant({
    this.matchParticipantId,
    this.accountId,
    this.matchMakingId,
    this.typeCode,
    this.typeName,
    this.paymentMethodCode,
    this.paymentMethodName,
    this.readyStatusCode,
    this.readyStatusName,
    this.shareAmount,
    this.statusCode,
    this.statusName,
    this.account,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'matchParticipantId': matchParticipantId,
      'accountId': accountId,
      'matchMakingId': matchMakingId,
      'typeCode': typeCode,
      'typeName': typeName,
      'paymentMethodCode': paymentMethodCode,
      'paymentMethodName': paymentMethodName,
      'readyStatusCode': readyStatusCode,
      'readyStatusName': readyStatusName,
      'shareAmount': shareAmount,
      'statusCode': statusCode,
      'statusName': statusName,
      'account': account?.toMap(),
    };
  }

  factory MatchParticipant.fromMap(Map<String, dynamic> map) {
    return MatchParticipant(
      matchParticipantId: map['matchParticipantId'] != null
          ? map['matchParticipantId'] as int
          : null,
      accountId: map['accountId'] != null ? map['accountId'] as int : null,
      matchMakingId:
          map['matchMakingId'] != null ? map['matchMakingId'] as int : null,
      typeCode: map['typeCode'] != null ? map['typeCode'] as String : null,
      typeName: map['typeName'] != null ? map['typeName'] as String : null,
      paymentMethodCode: map['paymentMethodCode'] != null
          ? map['paymentMethodCode'] as String
          : null,
      paymentMethodName: map['paymentMethodName'] != null
          ? map['paymentMethodName'] as String
          : null,
      readyStatusCode: map['readyStatusCode'] != null
          ? map['readyStatusCode'] as String
          : null,
      readyStatusName: map['readyStatusName'] != null
          ? map['readyStatusName'] as String
          : null,
      shareAmount:
          map['shareAmount'] != null ? map['shareAmount'] as double : null,
      statusCode:
          map['statusCode'] != null ? map['statusCode'] as String : null,
      statusName:
          map['statusName'] != null ? map['statusName'] as String : null,
      account: map['account'] != null
          ? MatchAccount.fromMap(map['account'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MatchParticipant.fromJson(Map<String, dynamic> source) =>
      MatchParticipant.fromMap(source);
}

class MatchAccount {
  int? accountId;
  int? roleId;
  String? avatar;
  String? username;
  String? password;
  String? identification;
  String? phone;
  String? email;
  String? statusCode;
  String? statusName;

  MatchAccount({
    this.accountId,
    this.roleId,
    this.avatar,
    this.username,
    this.password,
    this.identification,
    this.phone,
    this.email,
    this.statusCode,
    this.statusName,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'accountId': accountId,
      'roleId': roleId,
      'avatar': avatar,
      'username': username,
      'password': password,
      'identification': identification,
      'phone': phone,
      'email': email,
      'statusCode': statusCode,
      'statusName': statusName,
    };
  }

  factory MatchAccount.fromMap(Map<String, dynamic> map) {
    return MatchAccount(
      accountId: map['accountId'] != null ? map['accountId'] as int : null,
      roleId: map['roleId'] != null ? map['roleId'] as int : null,
      avatar: map['avatar'] != null ? map['avatar'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      identification: map['identification'] != null
          ? map['identification'] as String
          : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      statusCode:
          map['statusCode'] != null ? map['statusCode'] as String : null,
      statusName:
          map['statusName'] != null ? map['statusName'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MatchAccount.fromJson(Map<String, dynamic> source) =>
      MatchAccount.fromMap(source);
}
