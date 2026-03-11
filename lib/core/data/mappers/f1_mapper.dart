import 'package:arenaone/core/data/game.dart';
import 'package:arenaone/core/data/sports/f1_game.dart';
import 'package:arenaone/core/data/mappers/sport_mapper.dart';

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
    if (name.contains('qatar') || name.contains('lusail')) return 'assets/tracks/qatar.webp';

    return null;
  }

  @override
  Game? map(Map<String, dynamic> json) {
    final competitions = json['competitions'] as List<dynamic>? ?? [];
    if (competitions.isEmpty) return null;
    
    final competition = competitions[0] as Map<String, dynamic>;
    final participants = competition['competitionTeams'] as List<dynamic>? ?? [];
    
    final drivers = participants.map((p) {
      final teamsData = p['teams'] as Map<String, dynamic>?;
      
      final pName = teamsData?['name'] ?? 'Unknown';
      final pLogo = teamsData?['logo'] ?? 'https://a.espncdn.com/i/teamlogos/f1/500/f1.png';
      
      // Map driver names to their respective F1 teams for 2026 season
      String teamName = 'TBD';
      String driverImage = pLogo; // Default from API
      int wins = 0;
      int podiums = 0;
      int totalRaces = 0;

      if (pName.contains('Verstappen')) {
        teamName = 'Red Bull Racing';
        driverImage = 'https://media.formula1.com/d_driver_fallback_image.png/content/dam/fom-website/drivers/M/MAXVER01_Max_Verstappen/maxver01.png';
        wins = 61; podiums = 107; totalRaces = 206;
      } else if (pName.contains('Hadjar')) {
        teamName = 'Red Bull Racing';
        driverImage = 'https://media.formula1.com/d_driver_fallback_image.png/content/dam/fom-website/drivers/I/ISAHAD01_Isack_Hadjar/isahad01.png';
        wins = 0; podiums = 0; totalRaces = 0;
      } else if (pName.contains('Russell')) {
        teamName = 'Mercedes';
        driverImage = 'https://media.formula1.com/d_driver_fallback_image.png/content/dam/fom-website/drivers/G/GEORUS01_George_Russell/georus01.png';
        wins = 2; podiums = 14; totalRaces = 125;
      } else if (pName.contains('Antonelli')) {
        teamName = 'Mercedes';
        driverImage = 'https://media.formula1.com/d_driver_fallback_image.png/content/dam/fom-website/drivers/K/KIMANT01_Kimi_Antonelli/kimant01.png';
        wins = 0; podiums = 0; totalRaces = 0;
      } else if (pName.contains('Leclerc')) {
        teamName = 'Ferrari';
        driverImage = 'https://media.formula1.com/d_driver_fallback_image.png/content/dam/fom-website/drivers/C/CHALEC01_Charles_Leclerc/chalec01.png';
        wins = 7; podiums = 39; totalRaces = 144;
      } else if (pName.contains('Hamilton')) {
        teamName = 'Ferrari';
        driverImage = 'https://media.formula1.com/d_driver_fallback_image.png/content/dam/fom-website/drivers/L/LEWHAM01_Lewis_Hamilton/lewham01.png';
        wins = 105; podiums = 201; totalRaces = 353;
      } else if (pName.contains('Norris')) {
        teamName = 'McLaren';
        driverImage = 'https://media.formula1.com/d_driver_fallback_image.png/content/dam/fom-website/drivers/L/LANNOR01_Lando_Norris/lannor01.png';
        wins = 3; podiums = 25; totalRaces = 125;
      } else if (pName.contains('Piastri')) {
        teamName = 'McLaren';
        driverImage = 'https://media.formula1.com/d_driver_fallback_image.png/content/dam/fom-website/drivers/O/OSCPIA01_Oscar_Piastri/oscpia01.png';
        wins = 2; podiums = 9; totalRaces = 43;
      } else if (pName.contains('Alonso')) {
        teamName = 'Aston Martin';
        driverImage = 'https://media.formula1.com/d_driver_fallback_image.png/content/dam/fom-website/drivers/F/FERALO01_Fernando_Alonso/feralo01.png';
        wins = 32; podiums = 106; totalRaces = 398;
      } else if (pName.contains('Stroll')) {
        teamName = 'Aston Martin';
        driverImage = 'https://media.formula1.com/d_driver_fallback_image.png/content/dam/fom-website/drivers/LANSTR01_Lance_Stroll/lanstr01.png';
        wins = 0; podiums = 3; totalRaces = 163;
      } else if (pName.contains('Sainz')) {
        teamName = 'Williams';
        driverImage = 'https://media.formula1.com/d_driver_fallback_image.png/content/dam/fom-website/drivers/C/CARSAI01_Carlos_Sainz/carsai01.png';
        wins = 4; podiums = 25; totalRaces = 203;
      } else if (pName.contains('Albon')) {
        teamName = 'Williams';
        driverImage = 'https://media.formula1.com/d_driver_fallback_image.png/content/dam/fom-website/drivers/A/ALEALB01_Alexander_Albon/alealb01.png';
        wins = 0; podiums = 2; totalRaces = 101;
      } else if (pName.contains('Ocon')) {
        teamName = 'Haas';
        driverImage = 'https://media.formula1.com/d_driver_fallback_image.png/content/dam/fom-website/drivers/E/ESTOCO01_Esteban_Ocon/estoco01.png';
        wins = 1; podiums = 4; totalRaces = 154;
      } else if (pName.contains('Bearman')) {
        teamName = 'Haas';
        driverImage = 'https://media.formula1.com/d_driver_fallback_image.png/content/dam/fom-website/drivers/O/OLIBEA01_Oliver_Bearman/olibea01.png';
        wins = 0; podiums = 0; totalRaces = 3;
      } else if (pName.contains('Gasly')) {
        teamName = 'Alpine';
        driverImage = 'https://media.formula1.com/d_driver_fallback_image.png/content/dam/fom-website/drivers/P/PIEGAS01_Pierre_Gasly/piegas01.png';
        wins = 1; podiums = 5; totalRaces = 150;
      } else if (pName.contains('Doohan')) {
        teamName = 'Alpine';
        driverImage = 'https://media.formula1.com/d_driver_fallback_image.png/content/dam/fom-website/drivers/J/JACDOO01_Jack_Doohan/jacdoo01.png';
        wins = 0; podiums = 0; totalRaces = 0;
      } else if (pName.contains('Tsunoda')) {
        teamName = 'RB';
        driverImage = 'https://media.formula1.com/d_driver_fallback_image.png/content/dam/fom-website/drivers/Y/YUKTSU01_Yuki_Tsunoda/yuktsu01.png';
        wins = 0; podiums = 0; totalRaces = 87;
      } else if (pName.contains('Lawson')) {
        teamName = 'RB';
        driverImage = 'https://media.formula1.com/d_driver_fallback_image.png/content/dam/fom-website/drivers/L/LIALAW01_Liam_Lawson/lialaw01.png';
        wins = 0; podiums = 0; totalRaces = 11;
      } else if (pName.contains('Hülkenberg')) {
        teamName = 'Kick Sauber';
        driverImage = 'https://media.formula1.com/d_driver_fallback_image.png/content/dam/fom-website/drivers/N/NICHUL01_Nico_Hulkenberg/nichul01.png';
        wins = 0; podiums = 0; totalRaces = 224;
      } else if (pName.contains('Bortoleto')) {
        teamName = 'Kick Sauber';
        driverImage = 'https://media.formula1.com/d_driver_fallback_image.png/content/dam/fom-website/drivers/G/GABBOR01_Gabriel_Bortoleto/gabbor01.png';
        wins = 0; podiums = 0; totalRaces = 0;
      }

      return F1Driver(
        position: p['orderInCompetition'] ?? 0,
        name: pName,
        team: teamName,
        image: driverImage,
        points: p['score']?.toString() ?? '0',
        gap: p['records']?.toString(), // Sometimes gap is in record
        wins: wins,
        podiums: podiums,
        totalRaces: totalRaces,
      );
    }).toList();

    drivers.sort((a, b) => a.position.compareTo(b.position));

    final winner = drivers.isNotEmpty ? drivers[0] : null;
    final p2 = drivers.length > 1 ? drivers[1] : null;
    final p3 = drivers.length > 2 ? drivers[2] : null;
    final p4 = drivers.length > 3 ? drivers[3] : null;

    final eventName = json['name'];
    final venue = json['venue']?.toString();
    final trackAsset = _getTrackAsset(venue, eventName, null);

    // Detection of session type from status or name
    final statusMap = json['status'] as Map<String, dynamic>?;
    final typeMap = statusMap?['type'] as Map<String, dynamic>?;
    final statusType = typeMap?['name']?.toString().toLowerCase() ?? '';
    final name = eventName?.toString().toLowerCase() ?? '';
    
    String? sessionType = 'race';
    if (statusType.contains('qualifying') || name.contains('qualifying')) {
      sessionType = 'qualifying';
    } else if (statusType.contains('practice') || name.contains('practice')) {
      sessionType = 'practice';
    } else if (statusType.contains('sprint') || name.contains('sprint')) {
      sessionType = 'sprint';
    }

    return F1Game(
      id: json['id'].toString(),
      sport: 'F1',
      startTime: DateTime.parse(json['startTime']),
      status: mapStatus(statusMap),
      isLive: isLive(statusMap),
      stadium: venue ?? eventName,
      leagueType: json['leagues']?['name'] ?? 'Formula 1',
      sessionType: sessionType,
      winnerName: winner?.name,
      winnerTeam: winner?.team ?? 'TBD',
      winnerImage: winner?.image,
      winnerPoints: winner?.points,
      p2Name: p2?.name,
      p2Team: p2?.team,
      p2Image: p2?.image,
      p2Points: p2?.points,
      p2Gap: p2?.gap,
      p3Name: p3?.name,
      p3Team: p3?.team,
      p3Image: p3?.image,
      p3Points: p3?.points,
      p3Gap: p3?.gap,
      p4Name: p4?.name,
      p4Team: p4?.team,
      p4Image: p4?.image,
      p4Points: p4?.points,
      p4Gap: p4?.gap,
      raceNumber: 1,
      eventImageUrl: trackAsset,
      drivers: drivers,
    );
  }
}
