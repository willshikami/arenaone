// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'golf_game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GolfGame _$GolfGameFromJson(Map<String, dynamic> json) => GolfGame(
  id: json['id'] as String,
  sport: json['sport'] as String,
  startTime: DateTime.parse(json['startTime'] as String),
  status: json['status'] as String,
  isLive: json['isLive'] as bool? ?? false,
  broadcastChannel: json['broadcastChannel'] as String?,
  leagueType: json['leagueType'] as String?,
  stadium: json['stadium'] as String?,
  leaderboard: (json['leaderboard'] as List<dynamic>?)
      ?.map((e) => GolfLeader.fromJson(e as Map<String, dynamic>))
      .toList(),
  round: json['round'] as String?,
  purse: json['purse'] as String?,
  par: json['par'] as String?,
  yards: json['yards'] as String?,
  winnerPurse: json['winnerPurse'] as String?,
  tournamentName: json['tournamentName'] as String?,
  tourType: json['tourType'] as String?,
);

Map<String, dynamic> _$GolfGameToJson(GolfGame instance) => <String, dynamic>{
  'id': instance.id,
  'sport': instance.sport,
  'startTime': instance.startTime.toIso8601String(),
  'status': instance.status,
  'isLive': instance.isLive,
  'broadcastChannel': instance.broadcastChannel,
  'leagueType': instance.leagueType,
  'stadium': instance.stadium,
  'leaderboard': instance.leaderboard,
  'round': instance.round,
  'purse': instance.purse,
  'par': instance.par,
  'yards': instance.yards,
  'winnerPurse': instance.winnerPurse,
  'tournamentName': instance.tournamentName,
  'tourType': instance.tourType,
};

GolfLeader _$GolfLeaderFromJson(Map<String, dynamic> json) => GolfLeader(
  position: (json['position'] as num).toInt(),
  name: json['name'] as String,
  team: json['team'] as String,
  score: json['score'] as String,
  thru: json['thru'] as String,
  image: json['image'] as String,
  currentRound: json['currentRound'] as String?,
  careerPoints: json['careerPoints'] as String?,
  totalPoints: json['totalPoints'] as String?,
  purse: json['purse'] as String?,
  totalWins: (json['totalWins'] as num?)?.toInt(),
  championships: (json['championships'] as num?)?.toInt(),
);

Map<String, dynamic> _$GolfLeaderToJson(GolfLeader instance) =>
    <String, dynamic>{
      'position': instance.position,
      'name': instance.name,
      'team': instance.team,
      'score': instance.score,
      'thru': instance.thru,
      'image': instance.image,
      'currentRound': instance.currentRound,
      'careerPoints': instance.careerPoints,
      'totalPoints': instance.totalPoints,
      'purse': instance.purse,
      'totalWins': instance.totalWins,
      'championships': instance.championships,
    };
