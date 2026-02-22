import 'package:async_redux/async_redux.dart';
import '../app_state.dart';
import '../../data/services/database_helper.dart';
import '../../data/models/team.dart';
import '../../data/models/game.dart';
import '../../data/assets/track_assets.dart';

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
      Game(
        id: 'y2',
        homeTeamName: '',
        awayTeamName: '',
        homeTeamAbbr: '',
        awayTeamAbbr: '',
        sport: 'F1',
        leagueType: 'Abu Dhabi, UAE',
        stadium: 'Yas Marina Circuit',
        startTime: yesterday.subtract(const Duration(hours: 4)),
        status: 'Final',
        raceNumber: 22,
        winnerName: 'Lando Norris',
        winnerTeam: 'McLaren',
        winnerImage: 'https://media.formula1.com/content/dam/fom-website/drivers/L/LANNOR01_Lando_Norris/lannor01.png.transform/2col/image.png',
        winnerPoints: '19',
        winnerTotalPoints: '331',
        winningTime: '1:41.223',
        p2Name: 'Max Verstappen',
        p2Team: 'Red Bull Racing',
        p2Image: 'https://media.formula1.com/content/dam/fom-website/drivers/M/MAXVER01_Max_Verstappen/maxver01.png.transform/2col/image.png',
        p2Points: '19',
        p2TotalPoints: '393',
        p2Gap: '+0.222s',
        p3Name: 'Oscar Piastri',
        p3Team: 'McLaren',
        p3Image: 'https://media.formula1.com/content/dam/fom-website/drivers/O/OSCPIA01_Oscar_Piastri/oscpia01.png.transform/2col/image.png',
        p3Points: '21',
        p3TotalPoints: '262',
        p3Gap: '+0.254s',
        homeTeamLogo: 'https://a.espncdn.com/i/teamlogos/f1/500/f1.png',
        broadcastChannel: 'Sky Sports',
        trackLength: '5.281 km',
        circuitLayoutUrl: TrackAssets.yasMarina,
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
      Game(
        id: 'tm2',
        homeTeamName: '',
        awayTeamName: '',
        homeTeamAbbr: '',
        awayTeamAbbr: '',
        sport: 'F1',
        leagueType: 'Sakhir, Bahrain',
        stadium: 'Bahrain International Circuit',
        startTime: tomorrow.add(const Duration(hours: 15)),
        status: 'Upcoming',
        broadcastChannel: 'Sky Sports',
        eventImageUrl: 'https://www.formula1.com/content/dam/fom-website/2018-redesign-assets/circuit-maps-16-9/Bahrain_Circuit.png.transform/7col/image.png',
        raceNumber: 1,
        laps: 57,
        circuitLayoutUrl: TrackAssets.bahrain,
        trackLength: '5.412 km',
      ),
      Game(
        id: 'tm3',
        homeTeamName: '',
        awayTeamName: '',
        homeTeamAbbr: '',
        awayTeamAbbr: '',
        sport: 'F1',
        leagueType: 'Jeddah, Saudi Arabia',
        stadium: 'Jeddah Corniche Circuit',
        startTime: tomorrow.add(const Duration(days: 7, hours: 18)),
        status: 'Upcoming',
        broadcastChannel: 'Sky Sports',
        raceNumber: 2,
        laps: 50,
        circuitLayoutUrl: TrackAssets.jeddah,
        trackLength: '6.174 km',
      ),
      Game(
        id: 'tm4',
        homeTeamName: '',
        awayTeamName: '',
        homeTeamAbbr: '',
        awayTeamAbbr: '',
        sport: 'F1',
        leagueType: 'Melbourne, Australia',
        stadium: 'Albert Park Circuit',
        startTime: tomorrow.add(const Duration(days: 21, hours: 14)),
        status: 'Upcoming',
        broadcastChannel: 'Sky Sports',
        raceNumber: 3,
        laps: 58,
        circuitLayoutUrl: TrackAssets.albertPark,
        trackLength: '5.278 km',
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
