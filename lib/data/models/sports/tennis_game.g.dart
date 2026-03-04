// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tennis_game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TennisGame _$TennisGameFromJson(Map<String, dynamic> json) => TennisGame(
  id: json['id'] as String,
  sport: json['sport'] as String,
  startTime: DateTime.parse(json['startTime'] as String),
  status: json['status'] as String,
  isLive: json['isLive'] as bool? ?? false,
  broadcastChannel: json['broadcastChannel'] as String?,
  leagueType: json['leagueType'] as String?,
  stadium: json['stadium'] as String?,
  player1Name: json['player1Name'] as String,
  player2Name: json['player2Name'] as String,
  player1Image: json['player1Image'] as String?,
  player2Image: json['player2Image'] as String?,
  player1Country: json['player1Country'] as String?,
  player2Country: json['player2Country'] as String?,
  tournamentName: json['tournamentName'] as String?,
  round: json['round'] as String?,
  surface: json['surface'] as String?,
  score: json['score'] as String?,
  player1SetScores: (json['player1SetScores'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  player2SetScores: (json['player2SetScores'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  player1CurrentPoints: json['player1CurrentPoints'] as String?,
  player2CurrentPoints: json['player2CurrentPoints'] as String?,
  player1HasService: json['player1HasService'] as bool?,
  currentSet: json['currentSet'] as String?,
);

Map<String, dynamic> _$TennisGameToJson(TennisGame instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sport': instance.sport,
      'startTime': instance.startTime.toIso8601String(),
      'status': instance.status,
      'isLive': instance.isLive,
      'broadcastChannel': instance.broadcastChannel,
      'leagueType': instance.leagueType,
      'stadium': instance.stadium,
      'player1Name': instance.player1Name,
      'player2Name': instance.player2Name,
      'player1Image': instance.player1Image,
      'player2Image': instance.player2Image,
      'player1Country': instance.player1Country,
      'player2Country': instance.player2Country,
      'tournamentName': instance.tournamentName,
      'round': instance.round,
      'surface': instance.surface,
      'score': instance.score,
      'player1SetScores': instance.player1SetScores,
      'player2SetScores': instance.player2SetScores,
      'player1CurrentPoints': instance.player1CurrentPoints,
      'player2CurrentPoints': instance.player2CurrentPoints,
      'player1HasService': instance.player1HasService,
      'currentSet': instance.currentSet,
    };
