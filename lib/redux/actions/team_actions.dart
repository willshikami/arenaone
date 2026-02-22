import 'package:async_redux/async_redux.dart';
import '../app_state.dart';
import '../../data/services/database_helper.dart';
import '../../data/models/team.dart';
import '../../data/models/game.dart';

class LoadMockGamesAction extends ReduxAction<AppState> {
  @override
  AppState? reduce() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final tomorrow = today.add(const Duration(days: 1));

    final mockGames = [
      // Yesterday's Games
      Game(
        id: 'y1',
        homeTeamName: 'Celtics',
        awayTeamName: 'Nets',
        homeTeamAbbr: 'BOS',
        awayTeamAbbr: 'BKN',
        homeTeamLogo: 'https://a.espncdn.com/i/teamlogos/nba/500/bos.png',
        awayTeamLogo: 'https://a.espncdn.com/i/teamlogos/nba/500/bkn.png',
        sport: 'NBA',
        leagueType: 'Regular Season',
        stadium: 'TD Garden',
        startTime: yesterday.add(const Duration(hours: 19)),
        status: 'Final',
        score: '112-105',
        broadcastChannel: 'TNT',
      ),
      // Today's Games
      Game(
        id: 't1',
        homeTeamName: 'Knicks',
        awayTeamName: '76ers',
        homeTeamAbbr: 'NYK',
        awayTeamAbbr: 'PHI',
        homeTeamLogo: 'https://a.espncdn.com/i/teamlogos/nba/500/nyk.png',
        awayTeamLogo: 'https://a.espncdn.com/i/teamlogos/nba/500/phi.png',
        sport: 'NBA',
        leagueType: 'Regular Season',
        stadium: 'Madison Square Garden',
        startTime: today.add(const Duration(hours: 20)),
        status: 'Live',
        isLive: true,
        score: '84-79',
        broadcastChannel: 'ESPN',
      ),
      Game(
        id: 't2',
        homeTeamName: 'Lakers',
        awayTeamName: 'Warriors',
        homeTeamAbbr: 'LAL',
        awayTeamAbbr: 'GSW',
        homeTeamLogo: 'https://a.espncdn.com/i/teamlogos/nba/500/lal.png',
        awayTeamLogo: 'https://a.espncdn.com/i/teamlogos/nba/500/gs.png',
        sport: 'NBA',
        leagueType: 'Regular Season',
        stadium: 'Crypto.com Arena',
        startTime: today.add(const Duration(hours: 22, minutes: 30)),
        status: 'Upcoming',
        broadcastChannel: 'ABC',
      ),
      // Tomorrow's Games
      Game(
        id: 'tm1',
        homeTeamName: 'Bulls',
        awayTeamName: 'Cavaliers',
        homeTeamAbbr: 'CHI',
        awayTeamAbbr: 'CLE',
        homeTeamLogo: 'https://a.espncdn.com/i/teamlogos/nba/500/chi.png',
        awayTeamLogo: 'https://a.espncdn.com/i/teamlogos/nba/500/cle.png',
        sport: 'NBA',
        leagueType: 'Regular Season',
        stadium: 'United Center',
        startTime: tomorrow.add(const Duration(hours: 19, minutes: 30)),
        status: 'Upcoming',
        broadcastChannel: 'NBA TV',
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
