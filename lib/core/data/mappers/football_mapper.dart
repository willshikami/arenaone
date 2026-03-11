import 'package:arenaone/core/data/game.dart';
import 'package:arenaone/core/data/sports/football_game.dart';
import 'package:arenaone/core/data/mappers/sport_mapper.dart';

class FootballMapper extends SportMapper {
  @override
  Game? map(Map<String, dynamic> json) {
    final teams = findHomeAwayTeams(json);
    if (teams == null) return null;

    final home = teams['home'];
    final away = teams['away'];
    
    final statusMap = json['status'] as Map<String, dynamic>?;

    return FootballGame(
      id: json['id'].toString(),
      sport: 'Football',
      startTime: DateTime.parse(json['startTime']),
      status: mapStatus(statusMap),
      isLive: isLive(statusMap),
      stadium: json['venue'],
      clock: statusMap?['displayClock']?.toString(),
      period: statusMap?['period'] as int?,
      statusType: statusMap?['type']?['name']?.toString(),
      homeTeamName: home?['name'] ?? 'TBD',
      awayTeamName: away?['name'] ?? 'TBD',
      homeTeamAbbr: home?['abbreviation'] ?? _getAbbreviation(home?['name'] ?? 'TBD'),
      awayTeamAbbr: away?['abbreviation'] ?? _getAbbreviation(away?['name'] ?? 'TBD'),
      homeTeamLogo: home?['logo'],
      awayTeamLogo: away?['logo'],
      score: getScore(statusMap, teams['homeData']['score'], teams['awayData']['score']),
      leagueType: json['leagues']?['name'] ?? 'Football',
    );
  }

  String _getAbbreviation(String name) {
    final words = name.trim().split(' ');
    if (words.length >= 2) {
      return (words[0][0] + words[1][0] + (words.length > 2 ? words[2][0] : '')).toUpperCase().padRight(3, ' ');
    }
    return name.length >= 3 ? name.substring(0, 3).toUpperCase() : name.toUpperCase().padRight(3, ' ');
  }
}
