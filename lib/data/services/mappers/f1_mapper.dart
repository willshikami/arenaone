import '../../models/game.dart';
import '../../models/sports/f1_game.dart';
import 'sport_mapper.dart';

class F1Mapper extends SportMapper {
  @override
  Game? map(Map<String, dynamic> json) {
    final participants = json['event_participants'] as List<dynamic>? ?? [];
    
    final winner = participants.isNotEmpty ? participants[0] : null;
    final p2 = participants.length > 1 ? participants[1] : null;
    final p3 = participants.length > 2 ? participants[2] : null;

    final winnerInfo = getParticipantMap(winner?['participants']);
    final p2Info = getParticipantMap(p2?['participants']);
    final p3Info = getParticipantMap(p3?['participants']);

    return F1Game(
      id: json['id'].toString(),
      sport: 'F1',
      startTime: DateTime.parse(json['start_time']),
      status: mapStatus(json['status']),
      isLive: isLive(json['status']),
      stadium: json['venue'] ?? json['name'],
      leagueType: json['leagues']?['name'] ?? 'Formula 1',
      winnerName: winnerInfo?['name'],
      winnerTeam: winnerInfo?['team'] ?? 'TBD',
      winnerImage: winnerInfo?['logo'],
      winnerPoints: winner?['score']?.toString(),
      p2Name: p2Info?['name'],
      p2Team: p2Info?['team'],
      p2Image: p2Info?['logo'],
      p3Name: p3Info?['name'],
      p3Team: p3Info?['team'],
      p3Image: p3Info?['logo'],
      raceNumber: 1,
    );
  }
}
