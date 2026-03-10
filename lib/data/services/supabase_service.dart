import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:arenaone/data/models/game.dart';
import 'package:arenaone/data/services/supabase_config.dart';
import 'package:arenaone/data/services/mappers/sport_mapper.dart';
import 'package:arenaone/data/services/mappers/basketball_mapper.dart';
import 'package:arenaone/data/services/mappers/football_mapper.dart';
import 'package:arenaone/data/services/mappers/f1_mapper.dart';
import 'package:arenaone/data/services/mappers/golf_mapper.dart';
import 'package:arenaone/data/services/mappers/tennis_mapper.dart';
import 'package:arenaone/data/services/mappers/rally_mapper.dart';

class SupabaseService {
  final SupabaseClient _client = SupabaseConfig.client;

  Future<List<Game>> fetchNBAGames() async {
    return _fetchGamesBySlug('nba', BasketballMapper());
  }

  Future<List<Game>> fetchFootballGames() async {
    return _fetchGamesBySlug('football', FootballMapper());
  }

  Future<List<Game>> fetchF1Games() async {
    final games = await _fetchGamesBySlug('f1', F1Mapper());
    
    // Group games by their base name (e.g., "Australian Grand Prix")
    // and only keep the one with the latest start time or most advanced session.
    final groupedGames = <String, Game>{};
    for (var game in games) {
      final baseName = game.stadium ?? game.id;
      if (!groupedGames.containsKey(baseName)) {
        groupedGames[baseName] = game;
      } else {
        // If we find another session for the same GP, pick the one with the later start time
        // (usually Race > Qualifying > Practice)
        if (game.startTime.isAfter(groupedGames[baseName]!.startTime)) {
          groupedGames[baseName] = game;
        }
      }
    }
    
    return groupedGames.values.toList();
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

      final mappedGames = response
          .map((eventJson) => mapper.map(eventJson as Map<String, dynamic>))
          .whereType<Game>()
          .toList();

      debugPrint('SUCCESS: Mapped ${mappedGames.length} games for $slug');
      return mappedGames;
    } catch (e) {
      debugPrint('DEBUG: SupabaseService fetch failed for $slug: $e');
      return [];
    }
  }
}
