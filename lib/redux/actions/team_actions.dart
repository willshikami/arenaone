import 'package:async_redux/async_redux.dart';
import '../app_state.dart';
import '../../data/services/database_helper.dart';
import '../../data/models/team.dart';
import '../../data/models/game.dart';

class LoadMockGamesAction extends ReduxAction<AppState> {
  @override
  AppState? reduce() {
    final mockGames = [
      Game(
        id: '1',
        homeTeamName: 'Lakers',
        awayTeamName: 'Warriors',
        sport: 'NBA',
        startTime: DateTime.now().add(const Duration(hours: 2)),
        isLive: true,
        score: '84 - 79',
        status: 'Live',
      ),
      Game(
        id: '2',
        homeTeamName: 'Celtics',
        awayTeamName: 'Nets',
        sport: 'NBA',
        startTime: DateTime.now().add(const Duration(hours: 5)),
        status: 'Upcoming',
      ),
    ];
    return state.copyWith(games: mockGames);
  }
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
