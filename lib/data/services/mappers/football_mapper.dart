import '../../models/game.dart';
import '../../models/sports/football_game.dart';
import 'sport_mapper.dart';

class FootballMapper extends SportMapper {
  @override
  Game? map(Map<String, dynamic> json) {
    final participants = json['event_participants'] as List<dynamic>? ?? [];
    final teams = findHomeAwayTeams(participants, json['name']);
    if (teams == null) return null;

    final home = teams['home'];
    final away = teams['away'];

    return FootballGame(
      id: json['id'].toString(),
      sport: 'Football',
      startTime: DateTime.parse(json['start_time']),
      status: mapStatus(json['status_state'], json['status_type']),
      isLive: isLive(json['is_live'], json['status_state']),
      stadium: json['venue_name'],
      clock: json['clock'],
      period: (json['period'] is int) ? json['period'] as int : int.tryParse(json['period']?.toString() ?? ''),
      statusType: json['status_type'],
      homeTeamName: home?['name'] ?? 'TBD',
      awayTeamName: away?['name'] ?? 'TBD',
      homeTeamAbbr: home?['abbreviation'] ?? _getAbbreviation(home?['name'] ?? 'TBD'),
      awayTeamAbbr: away?['abbreviation'] ?? _getAbbreviation(away?['name'] ?? 'TBD'),
      homeTeamLogo: home?['logo'],
      awayTeamLogo: away?['logo'],
      score: getScore(json['status_state'], teams['homeData']['score'], teams['awayData']['score']),
      leagueType: 'Premier League', // leagues table removed
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
