// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'basketball_game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BasketballGame _$BasketballGameFromJson(Map<String, dynamic> json) =>
    BasketballGame(
      id: json['id'] as String,
      sport: json['sport'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      status: json['status'] as String,
      isLive: json['isLive'] as bool? ?? false,
      broadcastChannel: json['broadcastChannel'] as String?,
      leagueType: json['leagueType'] as String?,
      stadium: json['stadium'] as String?,
      homeTeamName: json['homeTeamName'] as String,
      awayTeamName: json['awayTeamName'] as String,
      homeTeamAbbr: json['homeTeamAbbr'] as String,
      awayTeamAbbr: json['awayTeamAbbr'] as String,
      homeTeamLogo: json['homeTeamLogo'] as String?,
      awayTeamLogo: json['awayTeamLogo'] as String?,
      score: json['score'] as String?,
      clock: json['clock'] as String?,
      period: (json['period'] as num?)?.toInt(),
      statusType: json['statusType'] as String?,
    );

Map<String, dynamic> _$BasketballGameToJson(BasketballGame instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sport': instance.sport,
      'startTime': instance.startTime.toIso8601String(),
      'status': instance.status,
      'isLive': instance.isLive,
      'broadcastChannel': instance.broadcastChannel,
      'leagueType': instance.leagueType,
      'stadium': instance.stadium,
      'homeTeamName': instance.homeTeamName,
      'awayTeamName': instance.awayTeamName,
      'homeTeamAbbr': instance.homeTeamAbbr,
      'awayTeamAbbr': instance.awayTeamAbbr,
      'homeTeamLogo': instance.homeTeamLogo,
      'awayTeamLogo': instance.awayTeamLogo,
      'score': instance.score,
      'clock': instance.clock,
      'period': instance.period,
      'statusType': instance.statusType,
    };
