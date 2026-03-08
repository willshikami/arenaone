import 'package:json_annotation/json_annotation.dart';
import '../game.dart';

part 'f1_game.g.dart';

class F1Driver {
  final int position;
  final String name;
  final String team;
  final String image;
  final String points;
  final String? gap;

  F1Driver({
    required this.position,
    required this.name,
    required this.team,
    required this.image,
    required this.points,
    this.gap,
  });
}

@JsonSerializable()
class F1Game extends Game {
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
  final String? p4Name;
  final String? p4Team;
  final String? p4Image;
  final String? p4Points;
  final String? p4Gap;
  final String? eventImageUrl;
  final int? raceNumber;
  final int? laps;
  final String? circuitLayoutUrl;
  final String? trackLength;
  final String? winnerTotalPoints;
  final String? p2TotalPoints;
  final String? p3TotalPoints;
  final DateTime? practice1Time;
  final DateTime? practice2Time;
  final DateTime? practice3Time;
  final DateTime? qualifyingTime;
  final DateTime? sprintTime;
  final String? sessionType; // 'race', 'qualifying', 'practice', 'sprint'
  
  @JsonKey(includeFromJson: false, includeToJson: false)
  final List<F1Driver>? drivers;

  F1Game({
    required this.id,
    required this.sport,
    required this.startTime,
    required this.status,
    this.isLive = false,
    this.broadcastChannel,
    this.leagueType,
    this.stadium,
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
    this.p4Name,
    this.p4Team,
    this.p4Image,
    this.p4Points,
    this.p4Gap,
    this.eventImageUrl,
    this.raceNumber,
    this.laps,
    this.circuitLayoutUrl,
    this.trackLength,
    this.winnerTotalPoints,
    this.p2TotalPoints,
    this.p3TotalPoints,
    this.practice1Time,
    this.practice2Time,
    this.practice3Time,
    this.qualifyingTime,
    this.sprintTime,
    this.sessionType,
    this.drivers,
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

  factory F1Game.fromJson(Map<String, dynamic> json) => _$F1GameFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$F1GameToJson(this);
}
