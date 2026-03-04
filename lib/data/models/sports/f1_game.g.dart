// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'f1_game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

F1Game _$F1GameFromJson(Map<String, dynamic> json) => F1Game(
  id: json['id'] as String,
  sport: json['sport'] as String,
  startTime: DateTime.parse(json['startTime'] as String),
  status: json['status'] as String,
  isLive: json['isLive'] as bool? ?? false,
  broadcastChannel: json['broadcastChannel'] as String?,
  leagueType: json['leagueType'] as String?,
  stadium: json['stadium'] as String?,
  winnerName: json['winnerName'] as String?,
  winnerTeam: json['winnerTeam'] as String?,
  winnerImage: json['winnerImage'] as String?,
  winnerPoints: json['winnerPoints'] as String?,
  winningTime: json['winningTime'] as String?,
  p2Name: json['p2Name'] as String?,
  p2Team: json['p2Team'] as String?,
  p2Image: json['p2Image'] as String?,
  p2Points: json['p2Points'] as String?,
  p2Gap: json['p2Gap'] as String?,
  p3Name: json['p3Name'] as String?,
  p3Team: json['p3Team'] as String?,
  p3Image: json['p3Image'] as String?,
  p3Points: json['p3Points'] as String?,
  p3Gap: json['p3Gap'] as String?,
  eventImageUrl: json['eventImageUrl'] as String?,
  raceNumber: (json['raceNumber'] as num?)?.toInt(),
  laps: (json['laps'] as num?)?.toInt(),
  circuitLayoutUrl: json['circuitLayoutUrl'] as String?,
  trackLength: json['trackLength'] as String?,
  winnerTotalPoints: json['winnerTotalPoints'] as String?,
  p2TotalPoints: json['p2TotalPoints'] as String?,
  p3TotalPoints: json['p3TotalPoints'] as String?,
  practice1Time: json['practice1Time'] == null
      ? null
      : DateTime.parse(json['practice1Time'] as String),
  practice2Time: json['practice2Time'] == null
      ? null
      : DateTime.parse(json['practice2Time'] as String),
  practice3Time: json['practice3Time'] == null
      ? null
      : DateTime.parse(json['practice3Time'] as String),
  qualifyingTime: json['qualifyingTime'] == null
      ? null
      : DateTime.parse(json['qualifyingTime'] as String),
  sprintTime: json['sprintTime'] == null
      ? null
      : DateTime.parse(json['sprintTime'] as String),
);

Map<String, dynamic> _$F1GameToJson(F1Game instance) => <String, dynamic>{
  'id': instance.id,
  'sport': instance.sport,
  'startTime': instance.startTime.toIso8601String(),
  'status': instance.status,
  'isLive': instance.isLive,
  'broadcastChannel': instance.broadcastChannel,
  'leagueType': instance.leagueType,
  'stadium': instance.stadium,
  'winnerName': instance.winnerName,
  'winnerTeam': instance.winnerTeam,
  'winnerImage': instance.winnerImage,
  'winnerPoints': instance.winnerPoints,
  'winningTime': instance.winningTime,
  'p2Name': instance.p2Name,
  'p2Team': instance.p2Team,
  'p2Image': instance.p2Image,
  'p2Points': instance.p2Points,
  'p2Gap': instance.p2Gap,
  'p3Name': instance.p3Name,
  'p3Team': instance.p3Team,
  'p3Image': instance.p3Image,
  'p3Points': instance.p3Points,
  'p3Gap': instance.p3Gap,
  'eventImageUrl': instance.eventImageUrl,
  'raceNumber': instance.raceNumber,
  'laps': instance.laps,
  'circuitLayoutUrl': instance.circuitLayoutUrl,
  'trackLength': instance.trackLength,
  'winnerTotalPoints': instance.winnerTotalPoints,
  'p2TotalPoints': instance.p2TotalPoints,
  'p3TotalPoints': instance.p3TotalPoints,
  'practice1Time': instance.practice1Time?.toIso8601String(),
  'practice2Time': instance.practice2Time?.toIso8601String(),
  'practice3Time': instance.practice3Time?.toIso8601String(),
  'qualifyingTime': instance.qualifyingTime?.toIso8601String(),
  'sprintTime': instance.sprintTime?.toIso8601String(),
};
