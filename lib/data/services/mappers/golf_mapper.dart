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

      final pName = pInfo?['name'] ?? 'Unknown';
      
      // Map golfer names to their respective Headshots
      String playerImage = pInfo?['logo'] ?? '';
      int totalWins = 0;
      int championships = 0;

      if (pName.contains('Scheffler')) {
        playerImage = 'https://pga-tour-res.cloudinary.com/image/upload/c_thumb,g_face,z_0.7,q_auto,f_auto,dpr_2.0,w_120,h_120,b_rgb:F2F2F2,d_stub:default_avatar_light.webp/headshots_46046';
        totalWins = 13; championships = 2;
      } else if (pName.contains('McIlroy')) {
        playerImage = 'https://pga-tour-res.cloudinary.com/image/upload/c_thumb,g_face,z_0.7,q_auto,f_auto,dpr_2.0,w_120,h_120,b_rgb:F2F2F2,d_stub:default_avatar_light.webp/headshots_28237';
        totalWins = 26; championships = 4;
      } else if (pName.contains('Rahm')) {
        playerImage = 'https://pga-tour-res.cloudinary.com/image/upload/c_thumb,g_face,z_0.7,q_auto,f_auto,dpr_2.0,w_120,h_120,b_rgb:F2F2F2,d_stub:default_avatar_light.webp/headshots_46970';
        totalWins = 11; championships = 2;
      } else if (pName.contains('Hovland')) {
        playerImage = 'https://pga-tour-res.cloudinary.com/image/upload/c_thumb,g_face,z_0.7,q_auto,f_auto,dpr_2.0,w_120,h_120,b_rgb:F2F2F2,d_stub:default_avatar_light.webp/headshots_46717';
        totalWins = 6; championships = 0;
      } else if (pName.contains('Åberg')) {
        playerImage = 'https://pga-tour-res.cloudinary.com/image/upload/c_thumb,g_face,z_0.7,q_auto,f_auto,dpr_2.0,w_120,h_120,b_rgb:F2F2F2,d_stub:default_avatar_light.webp/headshots_52955';
        totalWins = 1; championships = 0;
      } else if (pName.contains('Clark') && (pName.contains('Wyndham') || pName.contains('W.'))) {
        playerImage = 'https://pga-tour-res.cloudinary.com/image/upload/c_thumb,g_face,z_0.7,q_auto,f_auto,dpr_2.0,w_120,h_120,b_rgb:F2F2F2,d_stub:default_avatar_light.webp/headshots_51506';
        totalWins = 3; championships = 1;
      } else if (pName.contains('Schauffele')) {
        playerImage = 'https://pga-tour-res.cloudinary.com/image/upload/c_thumb,g_face,z_0.7,q_auto,f_auto,dpr_2.0,w_120,h_120,b_rgb:F2F2F2,d_stub:default_avatar_light.webp/headshots_48041';
        totalWins = 7; championships = 0;
      } else if (pName.contains('Cantlay')) {
        playerImage = 'https://pga-tour-res.cloudinary.com/image/upload/c_thumb,g_face,z_0.7,q_auto,f_auto,dpr_2.0,w_120,h_120,b_rgb:F2F2F2,d_stub:default_avatar_light.webp/headshots_35450';
        totalWins = 8; championships = 0;
      } else if (pName.contains('Homa')) {
        playerImage = 'https://pga-tour-res.cloudinary.com/image/upload/c_thumb,g_face,z_0.7,q_auto,f_auto,dpr_2.0,w_120,h_120,b_rgb:F2F2F2,d_stub:default_avatar_light.webp/headshots_35549';
        totalWins = 6; championships = 0;
      } else if (pName.contains('Fitzpatrick')) {
        playerImage = 'https://pga-tour-res.cloudinary.com/image/upload/c_thumb,g_face,z_0.7,q_auto,f_auto,dpr_2.0,w_120,h_120,b_rgb:F2F2F2,d_stub:default_avatar_light.webp/headshots_40098';
        totalWins = 2; championships = 1;
      } else if (pName.contains('Harman')) {
        playerImage = 'https://pga-tour-res.cloudinary.com/image/upload/c_thumb,g_face,z_0.7,q_auto,f_auto,dpr_2.0,w_120,h_120,b_rgb:F2F2F2,d_stub:default_avatar_light.webp/headshots_32139';
        totalWins = 3; championships = 1;
      } else if (pName.contains('Fleetwood')) {
        playerImage = 'https://pga-tour-res.cloudinary.com/image/upload/c_thumb,g_face,z_0.7,q_auto,f_auto,dpr_2.0,w_120,h_120,b_rgb:F2F2F2,d_stub:default_avatar_light.webp/headshots_34360';
        totalWins = 0; championships = 0;
      } else if (pName.contains('Hatton')) {
        playerImage = 'https://pga-tour-res.cloudinary.com/image/upload/c_thumb,g_face,z_0.7,q_auto,f_auto,dpr_2.0,w_120,h_120,b_rgb:F2F2F2,d_stub:default_avatar_light.webp/headshots_34099';
        totalWins = 1; championships = 0;
      } else if (pName.contains('Bradley')) {
        playerImage = 'https://pga-tour-res.cloudinary.com/image/upload/c_thumb,g_face,z_0.7,q_auto,f_auto,dpr_2.0,w_120,h_120,b_rgb:F2F2F2,d_stub:default_avatar_light.webp/headshots_33141';
        totalWins = 6; championships = 1;
      } else if (pName.contains('Morikawa')) {
        playerImage = 'https://pga-tour-res.cloudinary.com/image/upload/c_thumb,g_face,z_0.7,q_auto,f_auto,dpr_2.0,w_120,h_120,b_rgb:F2F2F2,d_stub:default_avatar_light.webp/headshots_50525';
        totalWins = 6; championships = 2;
      } else if (pName.contains('Day') && pName.contains('Jason')) {
        playerImage = 'https://pga-tour-res.cloudinary.com/image/upload/c_thumb,g_face,z_0.7,q_auto,f_auto,dpr_2.0,w_120,h_120,b_rgb:F2F2F2,d_stub:default_avatar_light.webp/headshots_28089';
        totalWins = 13; championships = 1;
      } else if (pName.contains('Theegala')) {
        playerImage = 'https://pga-tour-res.cloudinary.com/image/upload/c_thumb,g_face,z_0.7,q_auto,f_auto,dpr_2.0,w_120,h_120,b_rgb:F2F2F2,d_stub:default_avatar_light.webp/headshots_51634';
        totalWins = 1; championships = 0;
      } else if (pName.contains('Spieth')) {
        playerImage = 'https://pga-tour-res.cloudinary.com/image/upload/c_thumb,g_face,z_0.7,q_auto,f_auto,dpr_2.0,w_120,h_120,b_rgb:F2F2F2,d_stub:default_avatar_light.webp/headshots_34046';
        totalWins = 13; championships = 3;
      } else if (pName.contains('Thomas') && pName.contains('Justin')) {
        playerImage = 'https://pga-tour-res.cloudinary.com/image/upload/c_thumb,g_face,z_0.7,q_auto,f_auto,dpr_2.0,w_120,h_120,b_rgb:F2F2F2,d_stub:default_avatar_light.webp/headshots_33448';
        totalWins = 15; championships = 2;
      } else if (pName.contains('Fowler')) {
        playerImage = 'https://pga-tour-res.cloudinary.com/image/upload/c_thumb,g_face,z_0.7,q_auto,f_auto,dpr_2.0,w_120,h_120,b_rgb:F2F2F2,d_stub:default_avatar_light.webp/headshots_32102';
        totalWins = 6; championships = 0;
      } else if (pName.contains('Matsuyama')) {
        playerImage = 'https://pga-tour-res.cloudinary.com/image/upload/c_thumb,g_face,z_0.7,q_auto,f_auto,dpr_2.0,w_120,h_120,b_rgb:F2F2F2,d_stub:default_avatar_light.webp/headshots_32839';
        totalWins = 9; championships = 1;
      } else if (pName.contains('Lowry')) {
        playerImage = 'https://pga-tour-res.cloudinary.com/image/upload/c_thumb,g_face,z_0.7,q_auto,f_auto,dpr_2.0,w_120,h_120,b_rgb:F2F2F2,d_stub:default_avatar_light.webp/headshots_33204';
        totalWins = 3; championships = 1;
      } else if (pName.contains('Burns') && pName.contains('Sam')) {
        playerImage = 'https://pga-tour-res.cloudinary.com/image/upload/c_thumb,g_face,z_0.7,q_auto,f_auto,dpr_2.0,w_120,h_120,b_rgb:F2F2F2,d_stub:default_avatar_light.webp/headshots_47506';
        totalWins = 5; championships = 0;
      } else if (pName.contains('Kim') && (pName.contains('Tom') || pName.contains('Joo-hyung'))) {
        playerImage = 'https://pga-tour-res.cloudinary.com/image/upload/c_thumb,g_face,z_0.7,q_auto,f_auto,dpr_2.0,w_120,h_120,b_rgb:F2F2F2,d_stub:default_avatar_light.webp/headshots_55182';
        totalWins = 3; championships = 0;
      } else if (pName.contains('Finau')) {
        playerImage = 'https://pga-tour-res.cloudinary.com/image/upload/c_thumb,g_face,z_0.7,q_auto,f_auto,dpr_2.0,w_120,h_120,b_rgb:F2F2F2,d_stub:default_avatar_light.webp/headshots_29725';
        totalWins = 6; championships = 0;
      } else if (pName.contains('Koepka')) {
        playerImage = 'https://pga-tour-res.cloudinary.com/image/upload/c_thumb,g_face,z_0.7,q_auto,f_auto,dpr_2.0,w_120,h_120,b_rgb:F2F2F2,d_stub:default_avatar_light.webp/headshots_35451';
        totalWins = 9; championships = 5;
      } else if (pName.contains('DeChambeau')) {
        playerImage = 'https://pga-tour-res.cloudinary.com/image/upload/c_thumb,g_face,z_0.7,q_auto,f_auto,dpr_2.0,w_120,h_120,b_rgb:F2F2F2,d_stub:default_avatar_light.webp/headshots_47959';
        totalWins = 8; championships = 2;
      } else if (pName.contains('Smith') && pName.contains('Cameron')) {
        playerImage = 'https://pga-tour-res.cloudinary.com/image/upload/c_thumb,g_face,z_0.7,q_auto,f_auto,dpr_2.0,w_120,h_120,b_rgb:F2F2F2,d_stub:default_avatar_light.webp/headshots_35891';
        totalWins = 6; championships = 1;
      } else if (pName.contains('Johnson') && pName.contains('Dustin')) {
        playerImage = 'https://pga-tour-res.cloudinary.com/image/upload/c_thumb,g_face,z_0.7,q_auto,f_auto,dpr_2.0,w_120,h_120,b_rgb:F2F2F2,d_stub:default_avatar_light.webp/headshots_33067';
        totalWins = 24; championships = 2;
      } else if (pName.contains('Mickelson')) {
        playerImage = 'https://pga-tour-res.cloudinary.com/image/upload/c_thumb,g_face,z_0.7,q_auto,f_auto,dpr_2.0,w_120,h_120,b_rgb:F2F2F2,d_stub:default_avatar_light.webp/headshots_01810';
        totalWins = 45; championships = 6;
      } else if (pName.contains('Bhatia')) {
        playerImage = 'https://pga-tour-res.cloudinary.com/image/upload/c_thumb,g_face,z_0.7,q_auto,f_auto,dpr_2.0,w_120,h_120,b_rgb:F2F2F2,d_stub:default_avatar_light.webp/headshots_56630';
        totalWins = 2; championships = 0;
      } else if (pName.contains('Gotterup')) {
        playerImage = 'https://pga-tour-res.cloudinary.com/image/upload/c_thumb,g_face,z_0.7,q_auto,f_auto,dpr_2.0,w_120,h_120,b_rgb:F2F2F2,d_stub:default_avatar_light.webp/headshots_59095';
        totalWins = 1; championships = 0;
      } else if (pName.contains('Young') && pName.contains('Cameron')) {
        playerImage = 'https://pga-tour-res.cloudinary.com/image/upload/c_thumb,g_face,z_0.7,q_auto,f_auto,dpr_2.0,w_120,h_120,b_rgb:F2F2F2,d_stub:default_avatar_light.webp/headshots_57366';
        totalWins = 0; championships = 0;
      } else if (pName.contains('Straka')) {
        playerImage = 'https://pga-tour-res.cloudinary.com/image/upload/c_thumb,g_face,z_0.7,q_auto,f_auto,dpr_2.0,w_120,h_120,b_rgb:F2F2F2,d_stub:default_avatar_light.webp/headshots_49960';
        totalWins = 2; championships = 0;
      } else if (pName.contains('Berger')) {
        playerImage = 'https://pga-tour-res.cloudinary.com/image/upload/c_thumb,g_face,z_0.7,q_auto,f_auto,dpr_2.0,w_120,h_120,b_rgb:F2F2F2,d_stub:default_avatar_light.webp/headshots_40026';
        totalWins = 4; championships = 0;
      } else if (pName.contains('Henley')) {
        playerImage = 'https://pga-tour-res.cloudinary.com/image/upload/c_thumb,g_face,z_0.7,q_auto,f_auto,dpr_2.0,w_120,h_120,b_rgb:F2F2F2,d_stub:default_avatar_light.webp/headshots_34098';
        totalWins = 4; championships = 0;
      } else if (pName.contains('Hall') && pName.contains('Harry')) {
        playerImage = 'https://pga-tour-res.cloudinary.com/image/upload/c_thumb,g_face,z_0.7,q_auto,f_auto,dpr_2.0,w_120,h_120,b_rgb:F2F2F2,d_stub:default_avatar_light.webp/headshots_57975';
        totalWins = 1; championships = 0;
      } else if (pName.contains('Cauley')) {
        playerImage = 'https://pga-tour-res.cloudinary.com/image/upload/c_thumb,g_face,z_0.7,q_auto,f_auto,dpr_2.0,w_120,h_120,b_rgb:F2F2F2,d_stub:default_avatar_light.webp/headshots_34021';
        totalWins = 0; championships = 0;
      } else if (pName.contains('Lee') && pName.contains('Min Woo')) {
        playerImage = 'https://pga-tour-res.cloudinary.com/image/upload/c_thumb,g_face,z_0.7,q_auto,f_auto,dpr_2.0,w_120,h_120,b_rgb:F2F2F2,d_stub:default_avatar_light.webp/headshots_37378';
        totalWins = 0; championships = 0;
      }

      return GolfLeader(
        position: p['position'] ?? 0,
        name: pName,
        team: pInfo?['team'] ?? '',
        score: p['score']?.toString() ?? 'E',
        thru: playerThru,
        image: playerImage,
        currentRound: playerRound,
        totalWins: totalWins,
        championships: championships,
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
