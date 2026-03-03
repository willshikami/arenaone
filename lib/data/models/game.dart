import 'sports/basketball_game.dart';
import 'sports/f1_game.dart';
import 'sports/golf_game.dart';
import 'sports/tennis_game.dart';
import 'sports/rally_game.dart';
import 'sports/football_game.dart';

abstract class Game {
  final String id;
  final String sport;
  final DateTime startTime;
  final bool isLive;
  final String status; // e.g., "Upcoming", "Live", "Final"
  final String? leagueType; // e.g., "Regular Season"
  final String? stadium; // e.g., "Gillette Stadium"
  final String? broadcastChannel; // e.g., "Apple TV"
  final String? clock;
  final int? period;
  final String? statusType;

  Game({
    required this.id,
    required this.sport,
    required this.startTime,
    this.isLive = false,
    required this.status,
    this.leagueType,
    this.stadium,
    this.broadcastChannel,
    this.clock,
    this.period,
    this.statusType,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    final sport = json['sport'] as String?;
    switch (sport) {
      case 'F1':
        return F1Game.fromJson(json);
      case 'Golf':
        return GolfGame.fromJson(json);
      case 'Tennis':
        return TennisGame.fromJson(json);
      case 'Rally':
        return RallyGame.fromJson(json);
      case 'Football':
        return FootballGame.fromJson(json);
      default:
        return BasketballGame.fromJson(json);
    }
  }

  Map<String, dynamic> toJson();
}
