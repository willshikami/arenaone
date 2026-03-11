import 'package:arenaone/core/data/game.dart';
import 'package:arenaone/core/data/sports/tennis_game.dart';
import 'package:arenaone/core/data/mappers/sport_mapper.dart';

class TennisMapper extends SportMapper {
  @override
  Game? map(Map<String, dynamic> json) {
    final startTimeStr = json['startTime'] as String?;
    if (startTimeStr == null) return null; 
    
    final statusMap = json['status'] as Map<String, dynamic>?;
    final startTime = DateTime.parse(startTimeStr);
    var status = mapStatus(statusMap);
    final tournamentName = json['name'] ?? 'ATP Tour';

    // FIX: Many tournament headers are marked 'post' erroneously.
    // If it's within 7 days of today (past or future), let's keep it visible in Upcoming or Live
    final now = DateTime.now();
    final oneWeekAgo = now.subtract(const Duration(days: 7));
    final oneWeekFromNow = now.add(const Duration(days: 7));

    if (startTime.isAfter(oneWeekAgo) && startTime.isBefore(oneWeekFromNow)) {
      if (status == 'Final') {
        // Only force to Upcoming if players are TBD (likely a tournament header)
        final teams = findHomeAwayTeams(json);
        if (teams == null || teams['home'] == null) {
          status = 'Upcoming';
        }
      }
    }

    final teams = findHomeAwayTeams(json);
    
    final home = teams?['home'];
    final away = teams?['away'];

    // REMOVED the "return null" check. We want to show the tournaments even if players aren't set yet.
    
    return TennisGame(
      id: json['id'].toString(),
      sport: 'Tennis',
      startTime: startTime,
      status: status,
      isLive: isLive(statusMap),
      stadium: json['venue'] ?? tournamentName,
      player1Name: home?['name'] ?? 'TBD',
      player2Name: away?['name'] ?? 'TBD',
      player1Image: home?['logo'],
      player2Image: away?['logo'],
      score: getScore(statusMap, teams?['homeData']?['score'], teams?['awayData']?['score']),
      leagueType: json['leagues']?['name'] ?? 'Tennis',
      tournamentName: tournamentName,
    );
  }
}
