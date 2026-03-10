import 'package:json_annotation/json_annotation.dart';
import 'package:arenaone/core/data/game.dart';

part 'rally_game.g.dart';

@JsonSerializable()
class RallyGame extends Game {
  @override
  final String id;
  @override
  final String sport;
  @override
  final DateTime startTime;
  @override
  final String status;
  @override
  final bool isLive;
  @override
  final String? broadcastChannel;
  @override
  final String? leagueType;
  @override
  final String? stadium;

  // Rally specific fields
  final String? eventName;
  final String? location;
  final String? surface;
  final String? currentStage;
  final int? totalStages;
  final String? totalDistance;
  final String? eventImageUrl;
  final String? mapImageUrl;
  
  // Results / Leaderboard
  final List<RallyLeader>? leaderboard;

  RallyGame({
    required this.id,
    required this.sport,
    required this.startTime,
    required this.status,
    this.isLive = false,
    this.broadcastChannel,
    this.leagueType,
    this.stadium,
    this.eventName,
    this.location,
    this.surface,
    this.currentStage,
    this.totalStages,
    this.totalDistance,
    this.eventImageUrl,
    this.mapImageUrl,
    this.leaderboard,
  }) : super(
          id: id,
          sport: sport,
          startTime: startTime,
          status: status,
          isLive: isLive,
          broadcastChannel: broadcastChannel,
          leagueType: leagueType,
          stadium: stadium,
        );

  factory RallyGame.fromJson(Map<String, dynamic> json) => _$RallyGameFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$RallyGameToJson(this);
}

@JsonSerializable()
class RallyLeader {
  final int position;
  final String name;
  final String team;
  final String? image;
  final String? time;
  final String? gap;
  final String? car;

  RallyLeader({
    required this.position,
    required this.name,
    required this.team,
    this.image,
    this.time,
    this.gap,
    this.car,
  });

  factory RallyLeader.fromJson(Map<String, dynamic> json) => _$RallyLeaderFromJson(json);
  Map<String, dynamic> toJson() => _$RallyLeaderToJson(this);
}
