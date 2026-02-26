import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/game.dart';
import 'supabase_config.dart';
import 'mappers/sport_mapper.dart';
import 'mappers/basketball_mapper.dart';
import 'mappers/football_mapper.dart';
import 'mappers/f1_mapper.dart';
import 'mappers/golf_mapper.dart';
import 'mappers/tennis_mapper.dart';
import 'mappers/rally_mapper.dart';

class SupabaseService {
  final SupabaseClient _client = SupabaseConfig.client;

  Future<List<Game>> fetchNBAGames() async {
    return _fetchGamesBySlug('nba', BasketballMapper());
  }

  Future<List<Game>> fetchFootballGames() async {
    return _fetchGamesBySlug('football', FootballMapper());
  }

  Future<List<Game>> fetchF1Games() async {
    return _fetchGamesBySlug('f1', F1Mapper());
  }

  Future<List<Game>> fetchGolfGames() async {
    return _fetchGamesBySlug('golf', GolfMapper());
  }

  Future<List<Game>> fetchTennisGames() async {
    return _fetchGamesBySlug('tennis', TennisMapper());
  }

  Future<List<Game>> fetchRallyGames() async {
    return _fetchGamesBySlug('rally', RallyMapper());
  }

  Future<List<Game>> _fetchGamesBySlug(String slug, SportMapper mapper) async {
    try {
      final List<dynamic> response = await _client
          .from('events')
          .select('''
            id,
            name,
            short_name,
            start_time,
            status_type,
            status_state,
            completed,
            is_live,
            clock,
            period,
            venue_name,
            venue_city,
            venue_country,
            sports!inner(slug),
            event_participants(
              score,
              winner,
              home_away,
              record,
              seed,
              position,
              linescores,
              participants(
                name,
                logo,
                abbreviation,
                type
              )
            )
          ''')
          .eq('sports.slug', slug)
          .order('start_time', ascending: true);

      // CRITICAL DEBUG LOGS
      debugPrint('--- SUPABASE FETCH: $slug ---');
      debugPrint('Status: ${response.isNotEmpty ? "SUCCESS" : "EMPTY"}');
      debugPrint('Count: ${response.length}');
      if (response.isNotEmpty) {
        debugPrint('First Event: ${response[0]['name']}');
        debugPrint('First Event ID: ${response[0]['id']}');
      }
      debugPrint('-----------------------------');

      return response
          .map((eventJson) => mapper.map(eventJson as Map<String, dynamic>))
          .whereType<Game>()
          .toList();
    } catch (e) {
      print('DEBUG: SupabaseService fetch failed for $slug: $e');
      return [];
    }
  }
}
