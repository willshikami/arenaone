import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:arenaone/core/data/game.dart';
import 'package:arenaone/core/data/supabase_config.dart';
import 'package:arenaone/core/data/mappers/sport_mapper.dart';
import 'package:arenaone/core/data/mappers/basketball_mapper.dart';
import 'package:arenaone/core/data/mappers/football_mapper.dart';
import 'package:arenaone/core/data/mappers/f1_mapper.dart';
import 'package:arenaone/core/data/mappers/golf_mapper.dart';
import 'package:arenaone/core/data/mappers/tennis_mapper.dart';
import 'package:arenaone/core/data/mappers/rally_mapper.dart';

class SupabaseService {
  final SupabaseClient _client = SupabaseConfig.client;

  Future<List<Game>> fetchNBAGames() async {
    return _fetchGamesBySportSlug('basketball', BasketballMapper());
  }

  Future<List<Game>> fetchFootballGames() async {
    return _fetchGamesBySportSlug('soccer', FootballMapper());
  }

  Future<List<Game>> fetchF1Games() async {
    final games = await _fetchGamesBySportSlug('racing', F1Mapper());
    
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
    return _fetchGamesBySportSlug('golf', GolfMapper());
  }

  Future<List<Game>> fetchTennisGames() async {
    return _fetchGamesBySportSlug('tennis', TennisMapper());
  }

  Future<List<Game>> fetchRallyGames() async {
    return _fetchGamesBySportSlug('rally', RallyMapper());
  }

  Future<List<Game>> _fetchGamesBySportSlug(String sportSlug, SportMapper mapper) async {
    try {
      // 1. Get the Sport ID from the slug
      final sportResponse = await _client
          .from('sports')
          .select('id')
          .eq('slug', sportSlug)
          .maybeSingle();

      if (sportResponse == null) {
        debugPrint('--- SUPABASE FETCH: $sportSlug --- SPORT NOT FOUND');
        return [];
      }

      final sportId = sportResponse['id'];

      // 2. Get all Leagues for this Sport
      final leaguesResponse = await _client
          .from('leagues')
          .select('id, name, abbreviation')
          .eq('sport_id', sportId);

      if (leaguesResponse.isEmpty) {
        debugPrint('--- SUPABASE FETCH: $sportSlug --- NO LEAGUES FOUND');
        return [];
      }

      final List<Game> allGames = [];
      
      // 3. For each league, fetch events separately to avoid deep join collisions
      for (var league in leaguesResponse) {
        final leagueId = league['id'];
        final leagueName = league['name'];

    final eventsResponse = await _client
        .from('events')
        .select('''
          id,
          name,
          short_name,
          event_date,
          status,
          venue,
          competitions(
            id,
            neutral_site,
            competition_teams(
              id,
              score,
              home_away,
              statistics,
              records,
              order_in_competition,
              teams(
                id,
                name,
                logo,
                abbreviation,
                display_name,
                short_display_name,
                color,
                alternate_color
              )
            )
          )
        ''')
        .eq('league_id', leagueId)
        .gte('event_date', DateTime.now().subtract(const Duration(days: 1)).toUtc().toIso8601String())
        .order('event_date', ascending: true);

        if (eventsResponse.isNotEmpty) {
          final mapped = eventsResponse.map((eventJson) {
            final Map<String, dynamic> doc = Map<String, dynamic>.from(eventJson as Map);
            
            // Root Aliases
            doc['shortName'] = doc['short_name'];
            doc['startTime'] = doc['event_date'];
            doc['leagues'] = {'name': leagueName, 'id': leagueId.toString()};

            // Nested Aliases
            final competitions = doc['competitions'] as List<dynamic>?;
            if (competitions != null && competitions.isNotEmpty) {
              for (var comp in competitions) {
                final compMap = comp as Map<String, dynamic>;
                compMap['neutralSite'] = compMap['neutral_site'];
                
                final competitionTeams = compMap['competition_teams'];
                if (competitionTeams != null) {
                  compMap['competitionTeams'] = (competitionTeams as List).map((ct) {
                    final ctMap = ct as Map<String, dynamic>;
                    ctMap['homeAway'] = ctMap['home_away'];
                    ctMap['orderInCompetition'] = ctMap['order_in_competition'];
                    
                    final team = ctMap['teams'] as Map<String, dynamic>?;
                    if (team != null) {
                      team['id'] = team['id'].toString();
                      team['displayName'] = team['display_name'];
                      team['shortDisplayName'] = team['short_display_name'];
                      team['alternateColor'] = team['alternate_color'];
                    }
                    return ctMap;
                  }).toList();
                }
              }
            }
            
            final mappedGame = mapper.map(doc);
            if (mappedGame != null) {
              return mappedGame;
            }
            return null;
          }).whereType<Game>().toList();
          
          allGames.addAll(mapped);
        }
      }

      debugPrint('SUCCESS: Mapped ${allGames.length} games for $sportSlug');
      return allGames;
    } catch (e, stackTrace) {
      debugPrint('DEBUG: SupabaseService fetch failed for $sportSlug: $e');
      debugPrint('STACKTRACE: $stackTrace');
      return [];
    }
  }
}
