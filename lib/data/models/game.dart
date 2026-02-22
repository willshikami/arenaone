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
  final String? winnerName;
  final String? winnerTeam;
  final String? winnerImage;
  final String? winnerPoints;
  final String? winningTime;
  final String? p2Name;
  final String? p2Team;
  final String? p2Image;
  final String? p2Points;
  final String? p2Gap;
  final String? p3Name;
  final String? p3Team;
  final String? p3Image;
  final String? p3Points;
  final String? p3Gap;
  final String? eventImageUrl;
  final int? raceNumber;
  final int? laps;
  final String? circuitLayoutUrl;
  final String? trackLength;
  final String? winnerTotalPoints;
  final String? p2TotalPoints;
  final String? p3TotalPoints;

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
    this.winnerName,
    this.winnerTeam,
    this.winnerImage,
    this.winnerPoints,
    this.winningTime,
    this.p2Name,
    this.p2Team,
    this.p2Image,
    this.p2Points,
    this.p2Gap,
    this.p3Name,
    this.p3Team,
    this.p3Image,
    this.p3Points,
    this.p3Gap,
    this.eventImageUrl,
    this.raceNumber,
    this.laps,
    this.circuitLayoutUrl,
    this.trackLength,
    this.winnerTotalPoints,
    this.p2TotalPoints,
    this.p3TotalPoints,
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
    String? winnerName,
    String? winnerTeam,
    String? winnerImage,
    String? winnerPoints,
    String? winningTime,
    String? p2Name,
    String? p2Team,
    String? p2Image,
    String? p2Points,
    String? p2Gap,
    String? p3Name,
    String? p3Team,
    String? p3Image,
    String? p3Points,
    String? p3Gap,
    String? eventImageUrl,
    int? raceNumber,
    int? laps,
    String? circuitLayoutUrl,
    String? trackLength,
    String? winnerTotalPoints,
    String? p2TotalPoints,
    String? p3TotalPoints,
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
      winnerName: winnerName ?? this.winnerName,
      winnerTeam: winnerTeam ?? this.winnerTeam,
      winnerImage: winnerImage ?? this.winnerImage,
      winnerPoints: winnerPoints ?? this.winnerPoints,
      winningTime: winningTime ?? this.winningTime,
      p2Name: p2Name ?? this.p2Name,
      p2Team: p2Team ?? this.p2Team,
      p2Image: p2Image ?? this.p2Image,
      p2Points: p2Points ?? this.p2Points,
      p2Gap: p2Gap ?? this.p2Gap,
      p3Name: p3Name ?? this.p3Name,
      p3Team: p3Team ?? this.p3Team,
      p3Image: p3Image ?? this.p3Image,
      p3Points: p3Points ?? this.p3Points,
      p3Gap: p3Gap ?? this.p3Gap,
      eventImageUrl: eventImageUrl ?? this.eventImageUrl,
      raceNumber: raceNumber ?? this.raceNumber,
      laps: laps ?? this.laps,
      circuitLayoutUrl: circuitLayoutUrl ?? this.circuitLayoutUrl,
      trackLength: trackLength ?? this.trackLength,
      winnerTotalPoints: winnerTotalPoints ?? this.winnerTotalPoints,
      p2TotalPoints: p2TotalPoints ?? this.p2TotalPoints,
      p3TotalPoints: p3TotalPoints ?? this.p3TotalPoints,
    );
  }
}
