import '../../models/game.dart';
import '../../models/sports/tennis_game.dart';
import 'sport_mapper.dart';

class TennisMapper extends SportMapper {
  @override
  Game? map(Map<String, dynamic> json) {
    final participants = json['event_participants'] as List<dynamic>? ?? [];
    final teams = findHomeAwayTeams(participants, json['name']);
    
    // If it's a result (Final) and we still have no participants, 
    // it's likely a tournament entry in the DB, not a match.
    // We might want to filter these out of the "Results" tab if they are TBD vs TBD.
    final status = mapStatus(json['status']);
    final home = teams?['home'];
    final away = teams?['away'];

    if (status == 'Final' && home == null && away == null) {
      return null; // Skip empty tournament results
    }

    return TennisGame(
      id: json['id'].toString(),
      sport: 'Tennis',
      startTime: DateTime.parse(json['start_time']),
      status: status,
      isLive: isLive(json['status']),
      stadium: json['venue'] ?? json['name'],
      player1Name: home?['name'] ?? 'TBD',
      player2Name: away?['name'] ?? 'TBD',
      player1Image: home?['logo'],
      player2Image: away?['logo'],
      score: getScore(json['status'], teams?['homeData']?['score'], teams?['awayData']?['score']),
      tournamentName: json['leagues']?['name'] ?? json['name'] ?? 'ATP Tour',
    );
  }
}
