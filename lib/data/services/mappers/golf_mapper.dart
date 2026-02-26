import '../../models/game.dart';
import '../../models/sports/golf_game.dart';
import 'sport_mapper.dart';

class GolfMapper extends SportMapper {
  @override
  Game? map(Map<String, dynamic> json) {
    final participants = json['event_participants'] as List<dynamic>? ?? [];
    
    final leaders = participants.map((p) {
      final pInfo = getParticipantMap(p['participants']);
      return GolfLeader(
        position: p['position'] ?? 0,
        name: pInfo?['name'] ?? 'Unknown',
        team: pInfo?['team'] ?? '',
        score: p['score']?.toString() ?? 'E',
        thru: 'F',
        image: pInfo?['logo'] ?? '',
      );
    }).toList();

    return GolfGame(
      id: json['id'].toString(),
      sport: 'Golf',
      startTime: DateTime.parse(json['start_time']),
      status: mapStatus(json['status_state'], json['status_type']),
      isLive: isLive(json['is_live'], json['status_state']),
      stadium: json['venue_name'] ?? json['name'],
      leagueType: 'PGA Tour',
      tournamentName: json['name'],
      leaderboard: leaders,
    );
  }
}
