import 'package:json_annotation/json_annotation.dart';
import 'sports/basketball_game.dart';
import 'sports/f1_game.dart';
import 'sports/golf_game.dart';
import 'sports/tennis_game.dart';
import 'sports/rally_game.dart';
import 'sports/football_game.dart';

part 'game.g.dart';

@JsonSerializable()
class Game {
  final String id;
  final String sport;
  final DateTime startTime;
  final bool isLive;
  final String status; // e.g., "Upcoming", "Live", "Final"
  final String? leagueType; // e.g., "Regular Season"
  final String? stadium; // e.g., "Gillette Stadium"
  final String? broadcastChannel; // e.g., "Apple TV"

  Game({
    required this.id,
    required this.sport,
    required this.startTime,
    this.isLive = false,
    required this.status,
    this.leagueType,
    this.stadium,
    this.broadcastChannel,
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

  Map<String, dynamic> toJson() {
    if (this is F1Game) return (this as F1Game).toJson();
    if (this is GolfGame) return (this as GolfGame).toJson();
    if (this is TennisGame) return (this as TennisGame).toJson();
    if (this is RallyGame) return (this as RallyGame).toJson();
    if (this is FootballGame) return (this as FootballGame).toJson();
    if (this is BasketballGame) return (this as BasketballGame).toJson();
    return _$GameToJson(this);
  }

  Game copyWith({
    String? id,
    String? sport,
    DateTime? startTime,
    bool? isLive,
    String? status,
    String? leagueType,
    String? stadium,
    String? broadcastChannel,
  }) {
    return Game(
      id: id ?? this.id,
      sport: sport ?? this.sport,
      startTime: startTime ?? this.startTime,
      isLive: isLive ?? this.isLive,
      status: status ?? this.status,
      leagueType: leagueType ?? this.leagueType,
      stadium: stadium ?? this.stadium,
      broadcastChannel: broadcastChannel ?? this.broadcastChannel,
    );
  }
}
