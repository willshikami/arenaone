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
            start_time,
            status,
            venue,
            sports!inner(slug),
            leagues(name),
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
          .eq('sports.slug', slug)
          .order('start_time', ascending: true);

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
