import 'package:json_annotation/json_annotation.dart';

part 'game.g.dart';

@JsonSerializable()
class Game {
  final String id;
  final String homeTeamName;
  final String awayTeamName;
  final String? homeTeamLogo;
  final String? awayTeamLogo;
  final String sport;
  final DateTime startTime;
  final String? score;
  final bool isLive;
  final String status; // e.g., "Upcoming", "Live", "Final"

  Game({
    required this.id,
    required this.homeTeamName,
    required this.awayTeamName,
    this.homeTeamLogo,
    this.awayTeamLogo,
    required this.sport,
    required this.startTime,
    this.score,
    this.isLive = false,
    required this.status,
  });

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);
  Map<String, dynamic> toJson() => _$GameToJson(this);

  Game copyWith({
    String? id,
    String? homeTeamName,
    String? awayTeamName,
    String? homeTeamLogo,
    String? awayTeamLogo,
    String? sport,
    DateTime? startTime,
    String? score,
    bool? isLive,
    String? status,
  }) {
    return Game(
      id: id ?? this.id,
      homeTeamName: homeTeamName ?? this.homeTeamName,
      awayTeamName: awayTeamName ?? this.awayTeamName,
      homeTeamLogo: homeTeamLogo ?? this.homeTeamLogo,
      awayTeamLogo: awayTeamLogo ?? this.awayTeamLogo,
      sport: sport ?? this.sport,
      startTime: startTime ?? this.startTime,
      score: score ?? this.score,
      isLive: isLive ?? this.isLive,
      status: status ?? this.status,
    );
  }
}
