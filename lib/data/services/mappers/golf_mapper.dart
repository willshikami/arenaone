import '../../models/game.dart';
import '../../models/sports/golf_game.dart';
import 'sport_mapper.dart';

class GolfMapper extends SportMapper {
  @override
  Game? map(Map<String, dynamic> json) {
    final participants = json['event_participants'] as List<dynamic>? ?? [];
    
    final leaders = participants.map((p) {
      final pInfo = getParticipantMap(p['participants']);
      final pLinescores = p['linescores'] as List<dynamic>? ?? [];
      
      String playerRound = json['period']?.toString() ?? 'R1';
      String playerThru = p['record']?.toString() ?? 'F';

      if (pLinescores.isNotEmpty) {
        // Find the most recent linescore with statistics (this is usually the current round)
        final currentRoundData = pLinescores.lastWhere(
          (ls) => ls['statistics'] != null,
          orElse: () => pLinescores.first,
        );
        
        if (currentRoundData != null) {
          if (currentRoundData['period'] != null) {
            playerRound = 'R${currentRoundData['period']}';
          }
          
          try {
            final stats = currentRoundData['statistics']?['categories']?[0]?['stats'] as List<dynamic>?;
            if (stats != null && stats.length >= 6) {
              final thruValue = stats[5]?['displayValue']?.toString();
              if (thruValue != null && thruValue.isNotEmpty) {
                playerThru = thruValue;
              }
            }
          } catch (e) {
            // Fallback to record if statistics parsing fails
          }
        }
      }

      return GolfLeader(
        position: p['position'] ?? 0,
        name: pInfo?['name'] ?? 'Unknown',
        team: pInfo?['team'] ?? '',
        score: p['score']?.toString() ?? 'E',
        thru: playerThru,
        image: pInfo?['logo'] ?? '',
        currentRound: playerRound,
      );
    }).toList();

    // Sort leaderboard by position
    leaders.sort((a, b) => a.position.compareTo(b.position));

    return GolfGame(
      id: json['id'].toString(),
      sport: 'Golf',
      startTime: DateTime.parse(json['start_time']),
      status: mapStatus(json['status_state'], json['status_type']),
      isLive: isLive(json['is_live'], json['status_state']),
      stadium: json['venue_name'] ?? json['name'],
      leagueType: 'PGA Tour',
      tournamentName: json['name'],
      round: json['period']?.toString() ?? 'R1',
      leaderboard: leaders,
    );
  }
}
