import 'package:async_redux/async_redux.dart';
import '../app_state.dart';
import '../../data/services/database_helper.dart';
import '../../data/models/team.dart';
import '../../data/models/sports/basketball_game.dart';
import '../../data/models/sports/f1_game.dart';
import '../../data/models/sports/golf_game.dart';
import '../../data/models/sports/tennis_game.dart';
import '../../data/models/sports/rally_game.dart';
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
      BasketballGame(
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
      F1Game(
        id: 'y2',
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
        broadcastChannel: 'Sky Sports',
        trackLength: '5.281 km',
        circuitLayoutUrl: TrackAssets.yasMarina,
      ),
      // Today's Games
      BasketballGame(
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
      BasketballGame(
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
      F1Game(
        id: 'tm2',
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
      F1Game(
        id: 'tm3',
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
      F1Game(
        id: 'tm4',
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
      // Golf Mock Data
      GolfGame(
        id: 'g1',
        sport: 'Golf',
        tournamentName: 'The Genesis Invitational',
        stadium: 'Riviera Country Club',
        startTime: yesterday.subtract(const Duration(days: 2)),
        status: 'Final',
        tourType: 'PGA Tour',
        winnerPurse: '\$4.0M',
        leaderboard: [
          GolfLeader(
            position: 1,
            name: 'Hideki Matsuyama',
            team: 'Japan',
            score: '-17',
            thru: 'F',
            image: 'https://pga-tour-res.cloudinary.com/image/upload/c_fill,d_headshots_default.png,f_auto,g_face:center,h_350,q_auto,w_280/headshots_28486.png',
          ),
          GolfLeader(
            position: 2,
            name: 'Luke List',
            team: 'USA',
            score: '-14',
            thru: 'F',
            image: 'https://pga-tour-res.cloudinary.com/image/upload/c_fill,d_headshots_default.png,f_auto,g_face:center,h_350,q_auto,w_280/headshots_27129.png',
          ),
          GolfLeader(
            position: 3,
            name: 'Adam Hadwin',
            team: 'Canada',
            score: '-14',
            thru: 'F',
            image: 'https://pga-tour-res.cloudinary.com/image/upload/c_fill,d_headshots_default.png,f_auto,g_face:center,h_350,q_auto,w_280/headshots_33410.png',
          ),
        ],
      ),
      GolfGame(
        id: 'g2',
        sport: 'Golf',
        tournamentName: 'WM Phoenix Open',
        stadium: 'TPC Scottsdale',
        startTime: today,
        status: 'Live',
        isLive: true,
        tourType: 'PGA Tour',
        purse: '\$8.8M',
        leaderboard: [
          GolfLeader(
            position: 1,
            name: 'Nick Taylor',
            team: 'Canada',
            score: '-21',
            thru: 'Hole 18',
            image: 'https://pga-tour-res.cloudinary.com/image/upload/c_fill,d_headshots_default.png,f_auto,g_face:center,h_350,q_auto,w_280/headshots_35450.png',
          ),
          GolfLeader(
            position: 2,
            name: 'Charley Hoffman',
            team: 'USA',
            score: '-21',
            thru: 'F',
            image: 'https://pga-tour-res.cloudinary.com/image/upload/c_fill,d_headshots_default.png,f_auto,g_face:center,h_350,q_auto,w_280/headshots_25686.png',
          ),
          GolfLeader(
            position: 3,
            name: 'Sam Burns',
            team: 'USA',
            score: '-18',
            thru: 'F',
            image: 'https://pga-tour-res.cloudinary.com/image/upload/c_fill,d_headshots_default.png,f_auto,g_face:center,h_350,q_auto,w_280/headshots_47484.png',
          ),
        ],
      ),
      GolfGame(
        id: 'g3',
        sport: 'Golf',
        tournamentName: 'The Masters Tournament',
        stadium: 'Augusta National Golf Club',
        startTime: tomorrow.add(const Duration(days: 45)),
        status: 'Upcoming',
        par: '72',
        tourType: 'PGA Tour',
        purse: '\$20M',
        broadcastChannel: 'CBS / ESPN',
      ),
      // Tennis Mock Data
      TennisGame(
        id: 't1',
        sport: 'Tennis',
        tournamentName: 'Australian Open',
        round: 'Final',
        startTime: yesterday,
        status: 'Final',
        surface: 'Hard',
        stadium: 'Rod Laver Arena',
        player1Name: 'Jannik Sinner',
        player1Country: 'ITA',
        player1Image: 'https://www.atptour.com/-/media/alias/player-headshot/s0ag',
        player2Name: 'Daniil Medvedev',
        player2Country: 'RUS',
        player2Image: 'https://www.atptour.com/-/media/alias/player-headshot/mc65',
        player1SetScores: ['3', '3', '6', '6', '6'],
        player2SetScores: ['6', '6', '4', '4', '3'],
      ),
      TennisGame(
        id: 't2',
        sport: 'Tennis',
        tournamentName: 'ATP Rotterdam',
        round: 'Quarter-Final',
        startTime: today,
        status: 'Live',
        isLive: true,
        surface: 'Indoor Hard',
        player1Name: 'Holger Rune',
        player1Country: 'DEN',
        player1HasService: true,
        player1SetScores: ['6', '2'],
        player2SetScores: ['4', '1'],
        player1CurrentPoints: '30',
        player2CurrentPoints: '15',
        player2Name: 'Alexander Shevchenko',
        player2Country: 'KAZ',
      ),
      TennisGame(
        id: 't3',
        sport: 'Tennis',
        tournamentName: 'Indian Wells Open',
        round: 'Round 1',
        startTime: tomorrow.add(const Duration(days: 2)),
        status: 'Upcoming',
        surface: 'Hard',
        stadium: 'Stadium 1',
        player1Name: 'Carlos Alcaraz',
        player1Country: 'ESP',
        player2Name: 'Novak Djokovic',
        player2Country: 'SRB',
      ),
      // Rally Mock Data
      RallyGame(
        id: 'r1',
        sport: 'Rally',
        leagueType: 'WRC',
        eventName: 'Rallye Monte-Carlo',
        location: 'Monaco',
        surface: 'Tarmac/Ice',
        startTime: yesterday.subtract(const Duration(days: 3)),
        status: 'Final',
        totalStages: 18,
        totalDistance: '324.44 km',
        eventImageUrl: 'https://cdn-7.motorsport.com/images/mgl/6OEqXp40/s8/thierry-neuville-martijn-wyda-1.jpg',
        leaderboard: [
          RallyLeader(
            position: 1,
            name: 'Thierry Neuville',
            team: 'Hyundai Shell Mobis WRT',
            time: '3:09:30.9',
            car: 'Hyundai i20 N Rally1',
            image: 'https://wrc.com/a/p/thierry-neuville.jpg',
          ),
          RallyLeader(
            position: 2,
            name: 'Sébastien Ogier',
            team: 'Toyota Gazoo Racing WRT',
            gap: '+16.1s',
            car: 'Toyota GR Yaris Rally1',
          ),
          RallyLeader(
            position: 3,
            name: 'Elfyn Evans',
            team: 'Toyota Gazoo Racing WRT',
            gap: '+45.2s',
            car: 'Toyota GR Yaris Rally1',
          ),
        ],
      ),
      RallyGame(
        id: 'r2',
        sport: 'Rally',
        leagueType: 'Dakar',
        eventName: 'Dakar Rally',
        location: 'Saudi Arabia',
        surface: 'Sand/Dunes',
        startTime: today,
        status: 'Live',
        isLive: true,
        currentStage: 'Stage 11',
        totalStages: 12,
        totalDistance: '7,891 km',
        eventImageUrl: 'https://img.redbull.com/images/c_fill,g_auto,w_1000,h_667/q_auto,f_auto/redbullcom/2024/1/15/s1j7v7v7v7v7v7v7v7v7/dakar-rally-2024-action',
        leaderboard: [
          RallyLeader(
            position: 1,
            name: 'Carlos Sainz',
            team: 'Team Audi Sport',
            time: '46:23:47',
            car: 'Audi RS Q e-tron',
            image: 'https://redbull-content-pool.s3.amazonaws.com/carlos-sainz.png',
          ),
          RallyLeader(
            position: 2,
            name: 'Guillaume de Mevius',
            team: 'Overdrive Racing',
            gap: '+1:27:06',
            car: 'Toyota Hilux Overdrive',
          ),
          RallyLeader(
            position: 3,
            name: 'Sébastien Loeb',
            team: 'Bahrain Raid Xtreme',
            gap: '+1:35:02',
            car: 'Prodrive Hunter',
          ),
        ],
      ),
      RallyGame(
        id: 'r3',
        sport: 'Rally',
        leagueType: 'WRC',
        eventName: 'Rally Sweden',
        location: 'Umeå, Sweden',
        surface: 'Snow/Ice',
        startTime: tomorrow.add(const Duration(days: 10)),
        status: 'Upcoming',
        totalStages: 18,
        totalDistance: '300.10 km',
        eventImageUrl: 'https://wrc.com/a/p/rally-sweden-image.jpg',
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
