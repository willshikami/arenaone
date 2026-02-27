import '../../models/game.dart';
import '../../models/sports/f1_game.dart';
import 'sport_mapper.dart';

class F1Mapper extends SportMapper {
  static String? _getTrackAsset(String? venueName, String? eventName, String? venueCity) {
    if (venueName == null && eventName == null && venueCity == null) return null;
    
    final name = '${venueName ?? ''} ${eventName ?? ''} ${venueCity ?? ''}'.toLowerCase();
    
    if (name.contains('bahrain')) return 'assets/tracks/bahrain.webp';
    if (name.contains('jeddah') || name.contains('saudi')) return 'assets/tracks/jeddah.webp';
    if (name.contains('albert park') || name.contains('melbourne') || name.contains('australia')) return 'assets/tracks/albert_park.webp';
    if (name.contains('suzuka') || name.contains('japan')) return 'assets/tracks/suzuka.webp';
    if (name.contains('shanghai') || name.contains('china')) return 'assets/tracks/shanghai.webp';
    if (name.contains('miami')) return 'assets/tracks/miami.webp';
    if (name.contains('monaco') || name.contains('monte carlo')) return 'assets/tracks/monaco.webp';
    if (name.contains('gilles villeneuve') || name.contains('montreal') || name.contains('canada')) return 'assets/tracks/villeneuve.webp';
    if (name.contains('catalunya') || name.contains('barcelona') || name.contains('spain')) return 'assets/tracks/catalunya.webp';
    if (name.contains('red bull ring') || name.contains('spielberg') || name.contains('austria')) return 'assets/tracks/red_bull_ring.webp';
    if (name.contains('silverstone') || name.contains('british') || name.contains('great britain')) return 'assets/tracks/silverstone.webp';
    if (name.contains('hungaroring') || name.contains('budapest') || name.contains('hungary')) return 'assets/tracks/hungaroring.webp';
    if (name.contains('spa-francorchamps') || name.contains('spa') || name.contains('belgium')) return 'assets/tracks/spa.webp';
    if (name.contains('zandvoort') || name.contains('dutch') || name.contains('netherlands')) return 'assets/tracks/zandvoort.webp';
    if (name.contains('monza') || name.contains('italy') || name.contains('italian')) return 'assets/tracks/monza.webp';
    if (name.contains('baku') || name.contains('azerbaijan')) return 'assets/tracks/baku.webp';
    if (name.contains('marina bay') || name.contains('singapore')) return 'assets/tracks/marina_bay.webp';
    if (name.contains('americas') || name.contains('austin') || name.contains('united states')) return 'assets/tracks/americas.webp';
    if (name.contains('hermanos rodriguez') || name.contains('mexico')) return 'assets/tracks/rodriguez.webp';
    if (name.contains('interlagos') || name.contains('sao paulo') || name.contains('brazil')) return 'assets/tracks/interlagos.webp';
    if (name.contains('las vegas') || name.contains('vegas')) return 'assets/tracks/vegas.webp';
    if (name.contains('yas marina') || name.contains('abu dhabi')) return 'assets/tracks/yas_marina.webp';
    if (name.contains('madrid')) return 'assets/tracks/madrid.webp';
    
    return null;
  }

  @override
  Game? map(Map<String, dynamic> json) {
    final participants = json['event_participants'] as List<dynamic>? ?? [];
    
    final drivers = participants.map((p) {
      final pInfo = getParticipantMap(p['participants']);
      return F1Driver(
        position: p['position'] ?? 0,
        name: pInfo?['name'] ?? 'Unknown',
        team: pInfo?['team'] ?? 'TBD',
        image: pInfo?['logo'] ?? 'https://a.espncdn.com/i/teamlogos/f1/500/f1.png',
        points: p['score']?.toString() ?? '0',
        gap: p['record']?.toString(), // Sometimes gap is in record
      );
    }).toList();

    drivers.sort((a, b) => a.position.compareTo(b.position));

    final winner = drivers.isNotEmpty ? drivers[0] : null;
    final p2 = drivers.length > 1 ? drivers[1] : null;
    final p3 = drivers.length > 2 ? drivers[2] : null;

    final venueName = json['venue_name'];
    final eventName = json['name'];
    final venueCity = json['venue_city'];
    final trackAsset = _getTrackAsset(venueName, eventName, venueCity);

    return F1Game(
      id: json['id'].toString(),
      sport: 'F1',
      startTime: DateTime.parse(json['start_time']),
      status: mapStatus(json['status_state'], json['status_type']),
      isLive: isLive(json['is_live'], json['status_state']),
      stadium: venueName ?? eventName,
      leagueType: 'Formula 1',
      winnerName: winner?.name,
      winnerTeam: winner?.team ?? 'TBD',
      winnerImage: winner?.image,
      winnerPoints: winner?.points,
      p2Name: p2?.name,
      p2Team: p2?.team,
      p2Image: p2?.image,
      p3Name: p3?.name,
      p3Team: p3?.team,
      p3Image: p3?.image,
      raceNumber: 1,
      eventImageUrl: trackAsset,
      drivers: drivers,
    );
  }
}
