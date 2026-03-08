import 'package:json_annotation/json_annotation.dart';
import '../game.dart';

part 'golf_game.g.dart';

@JsonSerializable()
class GolfGame extends Game {
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

  final List<GolfLeader>? leaderboard;
  final String? round;
  final String? purse;
  final String? par;
  final String? yards;
  final String? winnerPurse;
  final String? tournamentName;
  final String? tourType;

  GolfGame({
    required this.id,
    required this.sport,
    required this.startTime,
    required this.status,
    this.isLive = false,
    this.broadcastChannel,
    this.leagueType,
    this.stadium,
    this.leaderboard,
    this.round,
    this.purse,
    this.par,
    this.yards,
    this.winnerPurse,
    this.tournamentName,
    this.tourType,
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

  factory GolfGame.fromJson(Map<String, dynamic> json) => _$GolfGameFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$GolfGameToJson(this);
}

@JsonSerializable()
class GolfLeader {
  final int position;
  final String name;
  final String team;
  final String score;
  final String thru;
  final String image;
  final String? currentRound;
  final String? careerPoints;
  final String? totalPoints;
  final String? purse;
  final int? totalWins;
  final int? championships;

  GolfLeader({
    required this.position,
    required this.name,
    required this.team,
    required this.score,
    required this.thru,
    required this.image,
    this.currentRound,
    this.careerPoints,
    this.totalPoints,
    this.purse,
    this.totalWins,
    this.championships,
  });

  factory GolfLeader.fromJson(Map<String, dynamic> json) => _$GolfLeaderFromJson(json);
  Map<String, dynamic> toJson() => _$GolfLeaderToJson(this);
}
