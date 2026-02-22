// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rally_game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RallyGame _$RallyGameFromJson(Map<String, dynamic> json) => RallyGame(
  id: json['id'] as String,
  sport: json['sport'] as String,
  startTime: DateTime.parse(json['startTime'] as String),
  status: json['status'] as String,
  isLive: json['isLive'] as bool? ?? false,
  broadcastChannel: json['broadcastChannel'] as String?,
  leagueType: json['leagueType'] as String?,
  stadium: json['stadium'] as String?,
  eventName: json['eventName'] as String?,
  location: json['location'] as String?,
  surface: json['surface'] as String?,
  currentStage: json['currentStage'] as String?,
  totalStages: (json['totalStages'] as num?)?.toInt(),
  totalDistance: json['totalDistance'] as String?,
  eventImageUrl: json['eventImageUrl'] as String?,
  mapImageUrl: json['mapImageUrl'] as String?,
  leaderboard: (json['leaderboard'] as List<dynamic>?)
      ?.map((e) => RallyLeader.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$RallyGameToJson(RallyGame instance) => <String, dynamic>{
  'id': instance.id,
  'sport': instance.sport,
  'startTime': instance.startTime.toIso8601String(),
  'status': instance.status,
  'isLive': instance.isLive,
  'broadcastChannel': instance.broadcastChannel,
  'leagueType': instance.leagueType,
  'stadium': instance.stadium,
  'eventName': instance.eventName,
  'location': instance.location,
  'surface': instance.surface,
  'currentStage': instance.currentStage,
  'totalStages': instance.totalStages,
  'totalDistance': instance.totalDistance,
  'eventImageUrl': instance.eventImageUrl,
  'mapImageUrl': instance.mapImageUrl,
  'leaderboard': instance.leaderboard,
};

RallyLeader _$RallyLeaderFromJson(Map<String, dynamic> json) => RallyLeader(
  position: (json['position'] as num).toInt(),
  name: json['name'] as String,
  team: json['team'] as String,
  image: json['image'] as String?,
  time: json['time'] as String?,
  gap: json['gap'] as String?,
  car: json['car'] as String?,
);

Map<String, dynamic> _$RallyLeaderToJson(RallyLeader instance) =>
    <String, dynamic>{
      'position': instance.position,
      'name': instance.name,
      'team': instance.team,
      'image': instance.image,
      'time': instance.time,
      'gap': instance.gap,
      'car': instance.car,
    };
