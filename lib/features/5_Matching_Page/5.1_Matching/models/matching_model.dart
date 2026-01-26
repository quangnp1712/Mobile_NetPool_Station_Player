import 'dart:convert';

class MatchMakingModel {
  int? matchMakingId;
  int? stationId;
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
  List<MatchSlot>? slots;
  List<MatchResource>? resources;
  List<MatchParticipant>? participants;
  String? typeName;
  String? description;
  StationDetailModel? station;
  List<ScheduleModel>? schedules;

  MatchMakingModel({
    this.matchMakingId,
    this.stationId,
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
    this.slots,
    this.resources,
    this.participants,
    this.typeName,
    this.description,
    this.station,
    this.schedules,
  });

  factory MatchMakingModel.fromMap(Map<String, dynamic> map) {
    return MatchMakingModel(
      matchMakingId: map['matchMakingId'] as int?,
      stationId: map['stationId'] as int?,
      matchMakingCode: map['matchMakingCode'] as String?,
      limitParticipant: map['limitParticipant'] as int?,
      totalPrice: (map['totalPrice'] as num?)?.toDouble(),

      // CẬP NHẬT: Parse DateTime từ String (JSON: "2026-01-25")
      startAt: map['startAt'] != null
          ? DateTime.tryParse(map['startAt'].toString())
          : null,
      expiredAt: map['expiredAt'] != null
          ? DateTime.tryParse(map['expiredAt'].toString())
          : null,
      playAt: map['playAt'] != null
          ? DateTime.tryParse(map['playAt'].toString())
          : null,

      statusCode: map['statusCode'] as String?,
      statusName: map['statusName'] as String?,
      allowJoin: map['allowJoin'] as bool?,
      allowView: map['allowView'] as bool?,

      slots: map['slots'] != null
          ? List<MatchSlot>.from(
              (map['slots'] as List)
                  .map((x) => MatchSlot.fromMap(x as Map<String, dynamic>)),
            )
          : null,
      resources: map['resources'] != null
          ? List<MatchResource>.from(
              (map['resources'] as List)
                  .map((x) => MatchResource.fromMap(x as Map<String, dynamic>)),
            )
          : null,
      participants: map['participants'] != null
          ? List<MatchParticipant>.from(
              (map['participants'] as List).map(
                  (x) => MatchParticipant.fromMap(x as Map<String, dynamic>)),
            )
          : null,

      typeName: map['typeName'] as String?,
      description: map['description'] as String?,

      station: map['station'] != null
          ? StationDetailModel.fromMap(map['station'] as Map<String, dynamic>)
          : null,

      schedules: map['schedules'] != null
          ? List<ScheduleModel>.from(
              (map['schedules'] as List)
                  .map((x) => ScheduleModel.fromMap(x as Map<String, dynamic>)),
            )
          : null,
    );
  }

  factory MatchMakingModel.fromJson(Map<String, dynamic> source) =>
      MatchMakingModel.fromMap(source);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'matchMakingId': matchMakingId,
      'stationId': stationId,
      'matchMakingCode': matchMakingCode,
      'limitParticipant': limitParticipant,
      'totalPrice': totalPrice,
      'startAt': startAt?.toIso8601String(), // Cập nhật format String
      'expiredAt': expiredAt?.toIso8601String(),
      'playAt': playAt?.toIso8601String(),
      'statusCode': statusCode,
      'statusName': statusName,
      'allowJoin': allowJoin,
      'allowView': allowView,
      'slots': slots?.map((x) => x.toJson()).toList(),
      'resources': resources?.map((x) => x.toJson()).toList(),
      'participants': participants?.map((x) => x.toJson()).toList(),
      'typeName': typeName,
      'description': description,
      'station': station?.toJson(),
      'schedules': schedules?.map((x) => x.toJson()).toList(),
    };
  }

  String toJson() => json.encode(toMap());
}

class MatchSlot {
  MatchSlotId? id;
  String? begin;
  String? end;

  MatchSlot({this.id, this.begin, this.end});

  factory MatchSlot.fromMap(Map<String, dynamic> map) {
    return MatchSlot(
      id: map['id'] != null ? MatchSlotId.fromMap(map['id']) : null,
      begin: map['begin'] as String?,
      end: map['end'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id?.toJson(),
        'begin': begin,
        'end': end,
      };
}

class MatchSlotId {
  int? matchMakingId;
  int? timeSlotId;

  MatchSlotId({this.matchMakingId, this.timeSlotId});

  factory MatchSlotId.fromMap(Map<String, dynamic> map) {
    return MatchSlotId(
      matchMakingId: map['matchMakingId'] as int?,
      timeSlotId: map['timeSlotId'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'matchMakingId': matchMakingId,
        'timeSlotId': timeSlotId,
      };
}

class MatchResource {
  MatchResourceId? id;
  String? typeCode;
  String? typeName;
  double? price;

  MatchResource({this.id, this.typeCode, this.typeName, this.price});

  factory MatchResource.fromMap(Map<String, dynamic> map) {
    return MatchResource(
      id: map['id'] != null ? MatchResourceId.fromMap(map['id']) : null,
      typeCode: map['typeCode'] as String?,
      typeName: map['typeName'] as String?,
      price: (map['price'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id?.toJson(),
        'typeCode': typeCode,
        'typeName': typeName,
        'price': price,
      };
}

class MatchResourceId {
  int? matchMakingId;
  int? stationResourceId;

  MatchResourceId({this.matchMakingId, this.stationResourceId});

  factory MatchResourceId.fromMap(Map<String, dynamic> map) {
    return MatchResourceId(
      matchMakingId: map['matchMakingId'] as int?,
      stationResourceId: map['stationResourceId'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'matchMakingId': matchMakingId,
        'stationResourceId': stationResourceId,
      };
}

class ScheduleModel {
  ScheduleId? id;
  DateTime? date;

  ScheduleModel({this.id, this.date});

  factory ScheduleModel.fromMap(Map<String, dynamic> map) {
    return ScheduleModel(
      id: map['id'] != null ? ScheduleId.fromMap(map['id']) : null,
      date: map['date'] != null
          ? DateTime.tryParse(map['date'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id?.toJson(),
        'date': date != null
            ? "${date!.year}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}"
            : null,
      };
}

class ScheduleId {
  int? scheduleId;
  int? matchMakingId;

  ScheduleId({this.scheduleId, this.matchMakingId});

  factory ScheduleId.fromMap(Map<String, dynamic> map) {
    return ScheduleId(
      scheduleId: map['scheduleId'] as int?,
      matchMakingId: map['matchMakingId'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'scheduleId': scheduleId,
        'matchMakingId': matchMakingId,
      };
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

  String? rank; // Rank game (bổ sung cho UI)

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
    this.rank,
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

class StationDetailModel {
  int? stationId;
  String? avatar;
  String? stationCode;
  String? stationName;
  String? address;
  String? province;
  String? commune;
  String? district;
  String? hotline;
  String? statusCode;
  String? statusName;
  List<MediaModel>? media;
  MetaDataModel? metadata;
  List<StationSpaceModel>? space;

  double? latitude;
  double? longitude;

  double? distance;

  double? rating;
  StationDetailModel({
    this.stationId,
    this.avatar,
    this.stationCode,
    this.stationName,
    this.address,
    this.province,
    this.commune,
    this.district,
    this.hotline,
    this.statusCode,
    this.statusName,
    this.media,
    this.metadata,
    this.distance,
    this.rating,
    this.space,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'stationId': stationId,
      'avatar': avatar,
      'stationCode': stationCode,
      'stationName': stationName,
      'address': address,
      'province': province,
      'commune': commune,
      'district': district,
      'hotline': hotline,
      'statusCode': statusCode,
      'statusName': statusName,
      'metadata': metadata?.toMap(),
    };
  }

  factory StationDetailModel.fromMap(Map<String, dynamic> map) {
    return StationDetailModel(
      stationId: map['stationId'] != null ? map['stationId'] as int : null,
      avatar: map['avatar'] != null ? map['avatar'] as String : null,
      stationCode:
          map['stationCode'] != null ? map['stationCode'] as String : null,
      stationName:
          map['stationName'] != null ? map['stationName'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      province: map['province'] != null ? map['province'] as String : null,
      commune: map['commune'] != null ? map['commune'] as String : null,
      district: map['district'] != null ? map['district'] as String : null,
      hotline: map['hotline'] != null ? map['hotline'] as String : null,
      statusCode:
          map['statusCode'] != null ? map['statusCode'] as String : null,
      statusName:
          map['statusName'] != null ? map['statusName'] as String : null,
      media: map['media'] != null
          ? List<MediaModel>.from(
              (map['media'] as List).map(
                (x) => MediaModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      metadata: map['metadata'] != null
          ? MetaDataModel.fromMap(map['metadata'] as Map<String, dynamic>)
          : null,
      latitude:
          map['latitude'] != null ? (map['latitude'] as num).toDouble() : null,
      longitude: map['longitude'] != null
          ? (map['longitude'] as num).toDouble()
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory StationDetailModel.fromJson(Map<String, dynamic> source) =>
      StationDetailModel.fromMap(source);
}

class MediaModel {
  String? url;
  MediaModel({
    this.url,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url,
    };
  }

  factory MediaModel.fromMap(Map<String, dynamic> map) {
    return MediaModel(
      url: map['url'] != null ? map['url'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MediaModel.fromJson(Map<String, dynamic> source) =>
      MediaModel.fromMap(source);
}

class MetaDataModel {
  String? rejectReason;
  DateTime? rejectAt;
  MetaDataModel({
    this.rejectReason,
    this.rejectAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'rejectReason': rejectReason,
      'rejectAt': rejectAt?.millisecondsSinceEpoch,
    };
  }

  factory MetaDataModel.fromMap(Map<String, dynamic> map) {
    return MetaDataModel(
      rejectReason:
          map['rejectReason'] != null ? map['rejectReason'] as String : null,
      rejectAt: map['rejectAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['rejectAt'] as int)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MetaDataModel.fromJson(Map<String, dynamic> source) =>
      MetaDataModel.fromMap(source);
}

class StationSpaceModel {
  int? stationSpaceId;
  int? stationId;
  int? spaceId;
  String? spaceCode;
  String? spaceName;
  int? capacity;
  String? statusCode;
  String? statusName;
  SpaceMetaDataModel? metadata;

  // bổ sung
  PlatformSpaceModel? space;

  // contruction
  StationSpaceModel({
    this.stationSpaceId,
    this.stationId,
    this.spaceId,
    this.spaceCode,
    this.spaceName,
    this.capacity,
    this.statusCode,
    this.statusName,
    this.space,
    this.metadata,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'stationId': stationId,
      'spaceId': spaceId,
      'spaceCode': spaceCode,
      'spaceName': spaceName,
      'capacity': capacity,
      'metadata': metadata?.toMap(),
    };
  }

  factory StationSpaceModel.fromMap(Map<String, dynamic> map) {
    return StationSpaceModel(
      stationSpaceId:
          map['stationSpaceId'] != null ? map['stationSpaceId'] as int : null,
      stationId: map['stationId'] != null ? map['stationId'] as int : null,
      spaceId: map['spaceId'] != null ? map['spaceId'] as int : null,
      spaceCode: map['spaceCode'] != null ? map['spaceCode'] as String : null,
      spaceName: map['spaceName'] != null ? map['spaceName'] as String : null,
      capacity: map['capacity'] != null ? map['capacity'] as int : null,
      statusCode:
          map['statusCode'] != null ? map['statusCode'] as String : null,
      statusName:
          map['statusName'] != null ? map['statusName'] as String : null,
      metadata: map['metadata'] != null
          ? SpaceMetaDataModel.fromMap(map['metadata'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory StationSpaceModel.fromJson(Map<String, dynamic> source) =>
      StationSpaceModel.fromMap(source);

  StationSpaceModel copyWith({
    int? stationSpaceId,
    int? stationId,
    int? spaceId,
    String? spaceCode,
    String? spaceName,
    int? capacity,
    String? statusCode,
    String? statusName,
    PlatformSpaceModel? space,
    SpaceMetaDataModel? metadata,
  }) {
    return StationSpaceModel(
      stationSpaceId: stationSpaceId ?? this.stationSpaceId,
      stationId: stationId ?? this.stationId,
      spaceId: spaceId ?? this.spaceId,
      spaceCode: spaceCode ?? this.spaceCode,
      spaceName: spaceName ?? this.spaceName,
      capacity: capacity ?? this.capacity,
      statusCode: statusCode ?? this.statusCode,
      statusName: statusName ?? this.statusName,
      space: space ?? this.space,
      metadata: metadata ?? this.metadata,
    );
  }
}

class PlatformSpaceModel {
  int? spaceId;
  String? typeCode;
  String? typeName;
  String? statusCode;
  String? statusName;
  String? description;
  SpaceMetaDataModel? metadata;

  PlatformSpaceModel({
    this.spaceId,
    this.typeCode,
    this.typeName,
    this.statusCode,
    this.statusName,
    this.description,
    this.metadata,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'spaceId': spaceId,
      'typeCode': typeCode,
      'typeName': typeName,
      'statusCode': statusCode,
      'statusName': statusName,
      'description': description,
      'metadata': metadata?.toMap(),
    };
  }

  factory PlatformSpaceModel.fromMap(Map<String, dynamic> map) {
    return PlatformSpaceModel(
      spaceId: map['spaceId'] != null ? map['spaceId'] as int : null,
      typeCode: map['typeCode'] != null ? map['typeCode'] as String : null,
      typeName: map['typeName'] != null ? map['typeName'] as String : null,
      statusCode:
          map['statusCode'] != null ? map['statusCode'] as String : null,
      statusName:
          map['statusName'] != null ? map['statusName'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      metadata: map['metadata'] != null
          ? SpaceMetaDataModel.fromMap(map['metadata'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PlatformSpaceModel.fromJson(Map<String, dynamic> source) =>
      PlatformSpaceModel.fromMap(source);

  // Clone method để copy object
  PlatformSpaceModel copyWith({
    int? spaceId,
    String? typeCode,
    String? typeName,
    String? statusCode,
    String? statusName,
    String? description,
    SpaceMetaDataModel? metadata,
  }) {
    return PlatformSpaceModel(
      spaceId: spaceId ?? this.spaceId,
      typeCode: typeCode ?? this.typeCode,
      typeName: typeName ?? this.typeName,
      statusCode: statusCode ?? this.statusCode,
      statusName: statusName ?? this.statusName,
      description: description ?? this.description,
      metadata: metadata ?? this.metadata,
    );
  }
}

class SpaceMetaDataModel {
  String? icon;
  String? bgColor;
  SpaceMetaDataModel({
    this.icon,
    this.bgColor,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'icon': icon,
      'bgColor': bgColor,
    };
  }

  factory SpaceMetaDataModel.fromMap(Map<String, dynamic> map) {
    return SpaceMetaDataModel(
      icon: map['icon'] != null ? map['icon'] as String : null,
      bgColor: map['bgColor'] != null ? map['bgColor'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SpaceMetaDataModel.fromJson(Map<String, dynamic> source) =>
      SpaceMetaDataModel.fromMap(source);
}

class MatchMakingJoinModel {
  int? matchJoiningRegistrationId;
  int? matchMakingId;
  String? message;
  String? statusCode;
  String? statusName;
  MatchAccount? account;

  MatchMakingJoinModel({
    this.matchJoiningRegistrationId,
    this.matchMakingId,
    this.message,
    this.statusCode,
    this.statusName,
    this.account,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'matchJoiningRegistrationId': matchJoiningRegistrationId,
      'matchMakingId': matchMakingId,
      'message': message,
      'statusCode': statusCode,
      'statusName': statusName,
      'account': account?.toMap(),
    };
  }

  factory MatchMakingJoinModel.fromMap(Map<String, dynamic> map) {
    return MatchMakingJoinModel(
      matchJoiningRegistrationId: map['matchJoiningRegistrationId'] != null
          ? map['matchJoiningRegistrationId'] as int
          : null,
      matchMakingId:
          map['matchMakingId'] != null ? map['matchMakingId'] as int : null,
      message: map['message'] != null ? map['message'] as String : null,
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

  factory MatchMakingJoinModel.fromJson(Map<String, dynamic> source) =>
      MatchMakingJoinModel.fromMap(source);
}
