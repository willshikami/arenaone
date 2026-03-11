import 'package:arenaone/core/data/game.dart';
import 'package:arenaone/core/data/sports/rally_game.dart';
import 'package:arenaone/core/data/mappers/sport_mapper.dart';

class RallyMapper extends SportMapper {
  @override
  Game? map(Map<String, dynamic> json) {
    final statusMap = json['status'] as Map<String, dynamic>?;
    final competitions = json['competitions'] as List<dynamic>? ?? [];
    if (competitions.isEmpty) return null;
    
    final competition = competitions[0] as Map<String, dynamic>;
    final teams = competition['competitionTeams'] as List<dynamic>? ?? [];
    
    final leaders = teams.map((p) {
      final teamsData = p['teams'] as Map<String, dynamic>?;
      return RallyLeader(
        position: p['orderInCompetition'] ?? 0,
        name: teamsData?['name'] ?? 'Unknown',
        team: teamsData?['shortDisplayName'] ?? '',
        image: teamsData?['logo'],
        time: p['score']?.toString(),
      );
    }).toList();

    return RallyGame(
      id: json['id'].toString(),
      sport: 'Rally',
      startTime: DateTime.parse(json['startTime']),
      status: mapStatus(statusMap),
      isLive: isLive(statusMap),
      stadium: json['venue'],
      leagueType: json['leagues']?['name'] ?? 'Rally',
      eventName: json['name'],
      leaderboard: leaders,
    );
  }
}
