import 'package:async_redux/async_redux.dart';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';
import '../app_state.dart';
import '../../data/services/database_helper.dart';
import '../../data/services/supabase_service.dart';
import '../../data/models/team.dart';
import '../../data/services/live_activity_service.dart';

class LoadNBAGamesAction extends ReduxAction<AppState> {
  @override
  Future<AppState?> reduce() async {
    try {
      final nbaGames = await SupabaseService().fetchNBAGames();
      
      // We clear current NBA games and replace them with whatever Supabase returned.
      // This ensures mock data is removed once the app connects to the real backend,
      // even if the database is currently empty.
      final filteredGames = state.games.where((g) => g.sport != 'NBA').toList();
      return state.copyWith(games: [...filteredGames, ...nbaGames], error: null);
    } catch (e) {
      return state.copyWith(error: 'Failed to fetch NBA games: $e');
    }
  }
}

class LoadFootballGamesAction extends ReduxAction<AppState> {
  @override
  Future<AppState?> reduce() async {
    try {
      final footballGames = await SupabaseService().fetchFootballGames();
      
      final filteredGames = state.games.where((g) => g.sport != 'Football').toList();
      return state.copyWith(games: [...filteredGames, ...footballGames], error: null);
    } catch (e) {
      return state.copyWith(error: 'Failed to fetch Football games: $e');
    }
  }
}

class LoadF1GamesAction extends ReduxAction<AppState> {
  @override
  Future<AppState?> reduce() async {
    try {
      final games = await SupabaseService().fetchF1Games();

      final filteredGames = state.games.where((g) => g.sport != 'F1').toList();
      
      return state.copyWith(games: [...filteredGames, ...games], error: null);
    } catch (e) {
      return state.copyWith(error: 'Failed to fetch F1 games: $e');
    }
  }
}

class LoadGolfGamesAction extends ReduxAction<AppState> {
  @override
  Future<AppState?> reduce() async {
    try {
      final games = await SupabaseService().fetchGolfGames();
      final filteredGames = state.games.where((g) => g.sport != 'Golf').toList();
      return state.copyWith(games: [...filteredGames, ...games], error: null);
    } catch (e) {
      return state.copyWith(error: 'Failed to fetch Golf games: $e');
    }
  }
}

class LoadTennisGamesAction extends ReduxAction<AppState> {
  @override
  Future<AppState?> reduce() async {
    try {
      final games = await SupabaseService().fetchTennisGames();
      debugPrint('REDUX: Loaded ${games.length} Tennis games into state');
      final filteredGames = state.games.where((g) => g.sport != 'Tennis').toList();
      return state.copyWith(games: [...filteredGames, ...games], error: null);
    } catch (e) {
      return state.copyWith(error: 'Failed to fetch Tennis games: $e');
    }
  }
}

class LoadRallyGamesAction extends ReduxAction<AppState> {
  @override
  Future<AppState?> reduce() async {
    try {
      final games = await SupabaseService().fetchRallyGames();
      final filteredGames = state.games.where((g) => g.sport != 'Rally').toList();
      return state.copyWith(games: [...filteredGames, ...games], error: null);
    } catch (e) {
      return state.copyWith(error: 'Failed to fetch Rally games: $e');
    }
  }
}

class LoadAllGamesAction extends ReduxAction<AppState> {
  final bool showLoading;
  LoadAllGamesAction({this.showLoading = true});

  @override
  Future<AppState?> reduce() async {
    try {
      // Run all sport fetches in parallel for maximum speed
      final fetches = [
        dispatchAndWait(LoadNBAGamesAction()),
        dispatchAndWait(LoadFootballGamesAction()),
        dispatchAndWait(LoadF1GamesAction()),
        dispatchAndWait(LoadGolfGamesAction()),
        dispatchAndWait(LoadTennisGamesAction()),
        dispatchAndWait(LoadRallyGamesAction()),
      ];

      // Wait for at least half of the sports to load or a reasonable baseline
      // before clearing the global loading state for a faster "perceived" load
      await Future.wait(fetches);
    } finally {
      if (showLoading) {
        dispatch(UpdateLoadingAction(false));
      }
    }

    // Handle Live Activities logic
    if (state.liveActivitiesEnabled) {
      final liveGame = state.games.firstWhereOrNull((g) => g.isLive);
      if (liveGame != null) {
        await LiveActivityService().updateActivity(liveGame);
      } else {
        await LiveActivityService().stopActivity();
      }
    }

    return null;
  }
}

class UpdateLoadingAction extends ReduxAction<AppState> {
  final bool isLoading;
  UpdateLoadingAction(this.isLoading);
  @override
  AppState? reduce() => state.copyWith(isLoading: isLoading);
}

class LoadFollowedTeamsAction extends ReduxAction<AppState> {
  @override
  Future<AppState?> reduce() async {
    final dbHelper = DatabaseHelper();
    final teams = await dbHelper.getFollowedTeams();
    
    return state.copyWith(followedTeams: teams);
  }
}

class ToggleFollowTeamAction extends ReduxAction<AppState> {
  final Team team;

  ToggleFollowTeamAction(this.team);

  @override
  Future<AppState?> reduce() async {
    final dbHelper = DatabaseHelper();
    final updatedTeam = team.copyWith(isFollowing: !team.isFollowing);
    
    // Persist change to SQLite
    await dbHelper.saveTeam(updatedTeam);
    
    // Update state
    final newTeams = List<Team>.from(state.followedTeams);
    final index = newTeams.indexWhere((t) => t.id == team.id);
    
    if (index != -1) {
      newTeams[index] = updatedTeam;
    } else {
      newTeams.add(updatedTeam);
    }
    
    return state.copyWith(followedTeams: newTeams);
  }
}
