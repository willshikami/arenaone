import 'package:arenaone/data/models/game.dart';
import 'package:arenaone/data/models/sports/tennis_game.dart';
import 'package:arenaone/data/services/mappers/sport_mapper.dart';

class TennisMapper extends SportMapper {
  @override
  Game? map(Map<String, dynamic> json) {
    final startTimeStr = json['start_time'] as String?;
    if (startTimeStr == null) return null; 
    
    final startTime = DateTime.parse(startTimeStr);
    var status = mapStatus(json['status_state'], json['status_type']);
    final tournamentName = json['name'] ?? 'ATP Tour';

    // FIX: Many tournament headers are marked 'post' erroneously.
    // If it's within 7 days of today (past or future), let's keep it visible in Upcoming or Live
    final now = DateTime.now();
    final oneWeekAgo = now.subtract(const Duration(days: 7));
    final oneWeekFromNow = now.add(const Duration(days: 7));

    if (startTime.isAfter(oneWeekAgo) && startTime.isBefore(oneWeekFromNow)) {
      if (status == 'Final') {
        // Only force to Upcoming if players are TBD (likely a tournament header)
        final participants = json['event_participants'] as List<dynamic>? ?? [];
        if (participants.isEmpty) {
          status = 'Upcoming';
        }
      }
    }

    final participants = json['event_participants'] as List<dynamic>? ?? [];
    final teams = findHomeAwayTeams(participants, json['name']);
    
    final home = teams?['home'];
    final away = teams?['away'];

    // REMOVED the "return null" check. We want to show the tournaments even if players aren't set yet.
    
    return TennisGame(
      id: json['id'].toString(),
      sport: 'Tennis',
      startTime: startTime,
      status: status,
      isLive: isLive(json['is_live'], json['status_state']),
      stadium: json['venue_name'] ?? tournamentName,
      player1Name: home?['name'] ?? 'TBD',
      player2Name: away?['name'] ?? 'TBD',
      player1Image: home?['logo'],
      player2Image: away?['logo'],
      score: getScore(json['status_state'], teams?['homeData']?['score'], teams?['awayData']?['score']),
      tournamentName: tournamentName,
    );
  }
}
