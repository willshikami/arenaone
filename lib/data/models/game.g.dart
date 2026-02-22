// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Game _$GameFromJson(Map<String, dynamic> json) => Game(
  id: json['id'] as String,
  sport: json['sport'] as String,
  startTime: DateTime.parse(json['startTime'] as String),
  isLive: json['isLive'] as bool? ?? false,
  status: json['status'] as String,
  leagueType: json['leagueType'] as String?,
  stadium: json['stadium'] as String?,
  broadcastChannel: json['broadcastChannel'] as String?,
);

Map<String, dynamic> _$GameToJson(Game instance) => <String, dynamic>{
  'id': instance.id,
  'sport': instance.sport,
  'startTime': instance.startTime.toIso8601String(),
  'isLive': instance.isLive,
  'status': instance.status,
  'leagueType': instance.leagueType,
  'stadium': instance.stadium,
  'broadcastChannel': instance.broadcastChannel,
};
