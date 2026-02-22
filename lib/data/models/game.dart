import 'package:json_annotation/json_annotation.dart';

part 'game.g.dart';

@JsonSerializable()
class Game {
  final String id;
  final String homeTeamName;
  final String awayTeamName;
  final String homeTeamAbbr;
  final String awayTeamAbbr;
  final String? homeTeamLogo;
  final String? awayTeamLogo;
  final String sport;
  final DateTime startTime;
  final String? score;
  final bool isLive;
  final String status; // e.g., "Upcoming", "Live", "Final"
  final String? leagueType; // e.g., "Regular Season"
  final String? stadium; // e.g., "Gillette Stadium"
  final String? broadcastChannel; // e.g., "Apple TV"

  Game({
    required this.id,
    required this.homeTeamName,
    required this.awayTeamName,
    required this.homeTeamAbbr,
    required this.awayTeamAbbr,
    this.homeTeamLogo,
    this.awayTeamLogo,
    required this.sport,
    required this.startTime,
    this.score,
    this.isLive = false,
    required this.status,
    this.leagueType,
    this.stadium,
    this.broadcastChannel,
  });

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);
  Map<String, dynamic> toJson() => _$GameToJson(this);

  Game copyWith({
    String? id,
    String? homeTeamName,
    String? awayTeamName,
    String? homeTeamAbbr,
    String? awayTeamAbbr,
    String? homeTeamLogo,
    String? awayTeamLogo,
    String? sport,
    DateTime? startTime,
    String? score,
    bool? isLive,
    String? status,
    String? leagueType,
    String? stadium,
    String? broadcastChannel,
  }) {
    return Game(
      id: id ?? this.id,
      homeTeamName: homeTeamName ?? this.homeTeamName,
      awayTeamName: awayTeamName ?? this.awayTeamName,
      homeTeamAbbr: homeTeamAbbr ?? this.homeTeamAbbr,
      awayTeamAbbr: awayTeamAbbr ?? this.awayTeamAbbr,
      homeTeamLogo: homeTeamLogo ?? this.homeTeamLogo,
      awayTeamLogo: awayTeamLogo ?? this.awayTeamLogo,
      sport: sport ?? this.sport,
      startTime: startTime ?? this.startTime,
      score: score ?? this.score,
      isLive: isLive ?? this.isLive,
      status: status ?? this.status,
      leagueType: leagueType ?? this.leagueType,
      stadium: stadium ?? this.stadium,
      broadcastChannel: broadcastChannel ?? this.broadcastChannel,
    );
  }
}
