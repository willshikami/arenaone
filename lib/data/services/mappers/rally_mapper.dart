import '../../models/game.dart';
import '../../models/sports/rally_game.dart';
import 'sport_mapper.dart';

class RallyMapper extends SportMapper {
  @override
  Game? map(Map<String, dynamic> json) {
    final participants = json['event_participants'] as List<dynamic>? ?? [];
    
    final leaders = participants.map((p) {
      final pInfo = getParticipantMap(p['participants']);
      return RallyLeader(
        position: p['position'] ?? 0,
        name: pInfo?['name'] ?? 'Unknown',
        team: pInfo?['team'] ?? '',
        image: pInfo?['logo'],
        time: p['score']?.toString(),
      );
    }).toList();

    return RallyGame(
      id: json['id'].toString(),
      sport: 'Rally',
      startTime: DateTime.parse(json['start_time']),
      status: mapStatus(json['status']),
      isLive: isLive(json['status']),
      stadium: json['venue'],
      eventName: json['name'],
      leaderboard: leaders,
    );
  }
}
