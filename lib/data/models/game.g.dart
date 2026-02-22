// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Game _$GameFromJson(Map<String, dynamic> json) => Game(
  id: json['id'] as String,
  homeTeamName: json['homeTeamName'] as String,
  awayTeamName: json['awayTeamName'] as String,
  homeTeamAbbr: json['homeTeamAbbr'] as String,
  awayTeamAbbr: json['awayTeamAbbr'] as String,
  homeTeamLogo: json['homeTeamLogo'] as String?,
  awayTeamLogo: json['awayTeamLogo'] as String?,
  sport: json['sport'] as String,
  startTime: DateTime.parse(json['startTime'] as String),
  score: json['score'] as String?,
  isLive: json['isLive'] as bool? ?? false,
  status: json['status'] as String,
  leagueType: json['leagueType'] as String?,
  stadium: json['stadium'] as String?,
  broadcastChannel: json['broadcastChannel'] as String?,
);

Map<String, dynamic> _$GameToJson(Game instance) => <String, dynamic>{
  'id': instance.id,
  'homeTeamName': instance.homeTeamName,
  'awayTeamName': instance.awayTeamName,
  'homeTeamAbbr': instance.homeTeamAbbr,
  'awayTeamAbbr': instance.awayTeamAbbr,
  'homeTeamLogo': instance.homeTeamLogo,
  'awayTeamLogo': instance.awayTeamLogo,
  'sport': instance.sport,
  'startTime': instance.startTime.toIso8601String(),
  'score': instance.score,
  'isLive': instance.isLive,
  'status': instance.status,
  'leagueType': instance.leagueType,
  'stadium': instance.stadium,
  'broadcastChannel': instance.broadcastChannel,
};
