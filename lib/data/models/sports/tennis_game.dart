import 'package:json_annotation/json_annotation.dart';
import '../game.dart';

part 'tennis_game.g.dart';

@JsonSerializable()
class TennisGame extends Game {
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

  // Tennis specific fields
  final String player1Name;
  final String player2Name;
  final String? player1Image;
  final String? player2Image;
  final String? player1Country;
  final String? player2Country;
  final String? tournamentName;
  final String? round;
  final String? surface;
  final String? score;
  
  // Live score fields
  final List<String>? player1SetScores;
  final List<String>? player2SetScores;
  final String? player1CurrentPoints;
  final String? player2CurrentPoints;
  final bool? player1HasService;
  final String? currentSet;

  TennisGame({
    required this.id,
    required this.sport,
    required this.startTime,
    required this.status,
    this.isLive = false,
    this.broadcastChannel,
    this.leagueType,
    this.stadium,
    required this.player1Name,
    required this.player2Name,
    this.player1Image,
    this.player2Image,
    this.player1Country,
    this.player2Country,
    this.tournamentName,
    this.round,
    this.surface,
    this.score,
    this.player1SetScores,
    this.player2SetScores,
    this.player1CurrentPoints,
    this.player2CurrentPoints,
    this.player1HasService,
    this.currentSet,
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

  factory TennisGame.fromJson(Map<String, dynamic> json) => _$TennisGameFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$TennisGameToJson(this);
}
