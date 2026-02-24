import 'package:json_annotation/json_annotation.dart';
import '../game.dart';

part 'football_game.g.dart';

@JsonSerializable()
class FootballGame extends Game {
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

  final String homeTeamName;
  final String awayTeamName;
  final String homeTeamAbbr;
  final String awayTeamAbbr;
  final String? homeTeamLogo;
  final String? awayTeamLogo;
  final String? score;

  FootballGame({
    required this.id,
    required this.sport,
    required this.startTime,
    required this.status,
    this.isLive = false,
    this.broadcastChannel,
    this.leagueType,
    this.stadium,
    required this.homeTeamName,
    required this.awayTeamName,
    required this.homeTeamAbbr,
    required this.awayTeamAbbr,
    this.homeTeamLogo,
    this.awayTeamLogo,
    this.score,
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

  factory FootballGame.fromJson(Map<String, dynamic> json) => _$FootballGameFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$FootballGameToJson(this);
}
