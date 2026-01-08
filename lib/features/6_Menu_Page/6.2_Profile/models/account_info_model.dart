import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class AccountInfoModel {
  int? accountId;
  int? roleId;
  String? password;

  String? avatar;
  String? username;
  String? identification;
  String? phone;
  String? email;
  String? statusCode;
  String? statusName;
  String? roleCode;
  String? accessToken;
  String? accessExpiredAt;
  String? refreshToken;
  String? refreshExpiredAt;
  AccountInfoModel({
    this.accountId,
    this.roleId,
    this.avatar,
    this.username,
    this.identification,
    this.phone,
    this.email,
    this.statusCode,
    this.statusName,
    this.roleCode,
    this.accessToken,
    this.accessExpiredAt,
    this.refreshToken,
    this.refreshExpiredAt,
    this.password,
  });

  factory AccountInfoModel.fromMap(Map<String, dynamic> map) {
    return AccountInfoModel(
      accountId: map['accountId'] != null ? map['accountId'] as int : null,
      roleId: map['roleId'] != null ? map['roleId'] as int : null,
      avatar: map['avatar'] != null ? map['avatar'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
      identification: map['identification'] != null
          ? map['identification'] as String
          : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      statusCode:
          map['statusCode'] != null ? map['statusCode'] as String : null,
      statusName:
          map['statusName'] != null ? map['statusName'] as String : null,
      roleCode: map['roleCode'] != null ? map['roleCode'] as String : null,
      accessToken:
          map['accessToken'] != null ? map['accessToken'] as String : null,
      accessExpiredAt: map['accessExpiredAt'] != null
          ? map['accessExpiredAt'] as String
          : null,
      refreshToken:
          map['refreshToken'] != null ? map['refreshToken'] as String : null,
      refreshExpiredAt: map['refreshExpiredAt'] != null
          ? map['refreshExpiredAt'] as String
          : null,
    );
  }

  factory AccountInfoModel.fromJson(Map<String, dynamic> source) =>
      AccountInfoModel.fromMap(source);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "avatar": avatar,
      "username": username,
      "password": password,
      "identification": identification,
      "phone": phone,
      "email": email,
    };
  }

  String toJson() => json.encode(toMap());

  AccountInfoModel copyWith({
    String? username,
    String? phone,
    String? avatar,
    String? identification,
    String? email,
    String? password,
  }) {
    return AccountInfoModel(
      accountId: accountId,
      roleId: roleId,
      avatar: avatar ?? this.avatar,
      username: username ?? this.username,
      identification: identification ?? this.identification,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      statusCode: statusCode,
      statusName: statusName,
      roleCode: roleCode,
      accessToken: accessToken,
      accessExpiredAt: accessExpiredAt,
      refreshToken: refreshToken,
      refreshExpiredAt: refreshExpiredAt,
      password: password ?? this.password,
    );
  }
}
