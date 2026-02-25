import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/game.dart';
import '../models/sports/basketball_game.dart';
import 'supabase_config.dart';

class SupabaseService {
  final SupabaseClient _client = SupabaseConfig.client;

  Future<List<Game>> fetchNBAGames() async {
    try {
      print('DEBUG: Fetching NBA games from Supabase...');
      // Fetch NBA games by filtering the 'events' table joined with 'sports' (slug = 'nba')
      final List<dynamic> response = await _client
          .from('events')
          .select('''
            id,
            name,
            start_time,
            status,
            venue,
            sports!inner(slug),
            event_participants(
              score,
              position,
              winner,
              participants(
                name,
                logo
              )
            )
          ''')
          .eq('sports.slug', 'nba')
          .order('start_time', ascending: true);

      print('DEBUG: Supabase response received: ${response.length} events');
      return response.map((eventJson) {
        final participants = eventJson['event_participants'] as List<dynamic>;
        
        // Find Home and Away teams based on position (usually 1=home, 2=away)
        // If not explicit, try to find based on list order
        final homeData = participants.firstWhere((p) => p['position'] == 1, orElse: () => participants.isNotEmpty ? participants[0] : null);
        final awayData = participants.firstWhere((p) => p['position'] == 2, orElse: () => participants.length > 1 ? participants[1] : (participants.isNotEmpty ? participants[0] : null));

        if (homeData == null || awayData == null) {
           // Skip if we don't have enough teams (unlikely for NBA but defensive code)
           return null;
        }

        final homeParticipant = homeData['participants'];
        final awayParticipant = awayData['participants'];

        return BasketballGame(
          id: eventJson['id'].toString(),
          sport: 'NBA',
          startTime: DateTime.parse(eventJson['start_time']),
          status: _mapStatus(eventJson['status']),
          isLive: (eventJson['status'] as String?)?.toLowerCase() == 'live' || (eventJson['status'] as String?)?.toLowerCase() == 'in_progress',
          stadium: eventJson['venue'],
          homeTeamName: homeParticipant['name'] ?? 'TBD',
          awayTeamName: awayParticipant['name'] ?? 'TBD',
          homeTeamAbbr: _getAbbreviation(homeParticipant['name'] ?? 'TBD'),
          awayTeamAbbr: _getAbbreviation(awayParticipant['name'] ?? 'TBD'),
          homeTeamLogo: homeParticipant['logo'],
          awayTeamLogo: awayParticipant['logo'],
          score: (eventJson['status']?.toString().toLowerCase() == 'finished' || eventJson['status']?.toString().toLowerCase() == 'live') 
              ? "${homeData['score'] ?? '0'}-${awayData['score'] ?? '0'}" 
              : null,
          leagueType: 'Regular Season', // Placeholder or can be fetched from leagues table
        );
      }).whereType<Game>().toList();
    } catch (e) {
      print('DEBUG: SupabaseService check failed: $e');
      return [];
    }
  }

  String _mapStatus(String? status) {
    if (status == null) return 'Upcoming';
    final s = status.toLowerCase();
    if (s.contains('final') || s.contains('finished') || s.contains('complete')) return 'Final';
    if (s.contains('live') || s.contains('progress') || s.contains('playing')) return 'Live';
    return 'Upcoming';
  }

  String _getAbbreviation(String name) {
    final words = name.trim().split(' ');
    if (words.length >= 2) {
      // e.g. "Los Angeles Lakers" -> "LAL"
      if (words[0].toLowerCase() == 'los' && words.length >= 3) {
        return (words[0][0] + words[1][0] + words[2][0]).toUpperCase();
      }
      // e.g. "Boston Celtics" -> "BOS" (take first word's first letter and last word's first two letters, or similar)
      // Actually simple rule: first letter of each of the last two words or similar.
      // Standard sports abbrs are usually 3 letters.
      if (words.length == 2) {
        return name.substring(0, 3).toUpperCase();
      }
       return (words[0][0] + words[1][0] + (words.length > 2 ? words[2][0] : '')).toUpperCase().padRight(3, 'S');
    }
    return name.length >= 3 ? name.substring(0, 3).toUpperCase() : name.toUpperCase().padRight(3, ' ');
  }
}
