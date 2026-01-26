import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class GameModel {
  int? gameId;
  int? stationSpaceId;
  String? gameCode;
  String gameName;
  String? genreCode;
  String? genreName;
  String statusCode;
  String? statusName;
  String? image;
  GameModel({
    this.gameId,
    this.stationSpaceId,
    this.gameCode,
    required this.gameName,
    this.genreCode,
    this.genreName,
    required this.statusCode,
    this.statusName,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'gameId': gameId,
      'stationSpaceId': stationSpaceId,
      'gameCode': gameCode,
      'gameName': gameName,
      'genreCode': genreCode,
      'genreName': genreName,
      'statusCode': statusCode,
      'statusName': statusName,
      'image': image,
    };
  }

  factory GameModel.fromMap(Map<String, dynamic> map) {
    return GameModel(
      gameId: map['gameId'] != null ? map['gameId'] as int : null,
      stationSpaceId:
          map['stationSpaceId'] != null ? map['stationSpaceId'] as int : null,
      gameCode: map['gameCode'] != null ? map['gameCode'] as String : null,
      gameName: map['gameName'] as String,
      genreCode: map['genreCode'] != null ? map['genreCode'] as String : null,
      genreName: map['genreName'] != null ? map['genreName'] as String : null,
      statusCode: map['statusCode'] as String,
      statusName:
          map['statusName'] != null ? map['statusName'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory GameModel.fromJson(Map<String, dynamic> source) =>
      GameModel.fromMap(source);

  bool get isActive => statusCode == 'ENABLE' || statusCode == 'ACTIVE';
}
