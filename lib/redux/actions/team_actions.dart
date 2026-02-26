import 'package:async_redux/async_redux.dart';
import 'package:flutter/foundation.dart';
import '../app_state.dart';
import '../../data/services/database_helper.dart';
import '../../data/services/supabase_service.dart';
import '../../data/models/team.dart';
import '../../data/models/sports/basketball_game.dart';
import '../../data/models/sports/f1_game.dart';
import '../../data/models/sports/golf_game.dart';
import '../../data/models/sports/tennis_game.dart';
import '../../data/models/sports/rally_game.dart';
import '../../data/models/sports/football_game.dart';
import '../../data/assets/track_assets.dart';

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
  @override
  Future<AppState?> reduce() async {
    dispatch(UpdateLoadingAction(true));
    try {
      // Run sequentially to avoid race conditions where one sport wipes out another
      await dispatchAndWait(LoadNBAGamesAction());
      await dispatchAndWait(LoadFootballGamesAction());
      await dispatchAndWait(LoadF1GamesAction());
      await dispatchAndWait(LoadGolfGamesAction());
      await dispatchAndWait(LoadTennisGamesAction());
      await dispatchAndWait(LoadRallyGamesAction());
    } finally {
      dispatch(UpdateLoadingAction(false));
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

class LoadMockGamesAction extends ReduxAction<AppState> {
  @override
  AppState? reduce() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final tomorrow = today.add(const Duration(days: 1));

    final mockGames = [
      // NBA
      // Results
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
      BasketballGame(
        id: 'y1_2',
        homeTeamName: 'Lakers',
        awayTeamName: 'Warriors',
        homeTeamAbbr: 'LAL',
        awayTeamAbbr: 'GSW',
        homeTeamLogo: 'https://a.espncdn.com/i/teamlogos/nba/500/lal.png',
        awayTeamLogo: 'https://a.espncdn.com/i/teamlogos/nba/500/gsw.png',
        sport: 'NBA',
        leagueType: 'Regular Season',
        stadium: 'Crypto.com Arena',
        startTime: yesterday.add(const Duration(hours: 21)),
        status: 'Final',
        score: '108-115',
        broadcastChannel: 'ESPN',
      ),
      // Live
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
      BasketballGame(
        id: 't1_2',
        homeTeamName: 'Bucks',
        awayTeamName: 'Heat',
        homeTeamAbbr: 'MIL',
        awayTeamAbbr: 'MIA',
        homeTeamLogo: 'https://a.espncdn.com/i/teamlogos/nba/500/mil.png',
        awayTeamLogo: 'https://a.espncdn.com/i/teamlogos/nba/500/mia.png',
        sport: 'NBA',
        leagueType: 'Regular Season',
        stadium: 'Fiserv Forum',
        startTime: today.add(const Duration(hours: 21)),
        status: 'Live',
        isLive: true,
        score: '45-42',
        broadcastChannel: 'TNT',
      ),
      // Upcoming
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
      BasketballGame(
        id: 'tm1_2',
        homeTeamName: 'Suns',
        awayTeamName: 'Mavericks',
        homeTeamAbbr: 'PHX',
        awayTeamAbbr: 'DAL',
        homeTeamLogo: 'https://a.espncdn.com/i/teamlogos/nba/500/phx.png',
        awayTeamLogo: 'https://a.espncdn.com/i/teamlogos/nba/500/dal.png',
        sport: 'NBA',
        leagueType: 'Regular Season',
        stadium: 'Footprint Center',
        startTime: tomorrow.add(const Duration(hours: 22)),
        status: 'Upcoming',
        broadcastChannel: 'TNT',
      ),

      // Football (Premier League)
      // Results
      FootballGame(
        id: 'f1',
        homeTeamName: 'Arsenal',
        awayTeamName: 'Liverpool',
        homeTeamAbbr: 'ARS',
        awayTeamAbbr: 'LIV',
        homeTeamLogo: 'https://upload.wikimedia.org/wikipedia/en/5/53/Arsenal_FC.svg',
        awayTeamLogo: 'https://upload.wikimedia.org/wikipedia/en/0/0c/Liverpool_FC.svg',
        sport: 'Football',
        leagueType: 'Premier League',
        stadium: 'Emirates Stadium',
        startTime: yesterday.add(const Duration(hours: 15)),
        status: 'Final',
        score: '2-1',
        broadcastChannel: 'Sky Sports',
      ),
      // Live
      FootballGame(
        id: 'f2',
        homeTeamName: 'Man City',
        awayTeamName: 'Chelsea',
        homeTeamAbbr: 'MCI',
        awayTeamAbbr: 'CHE',
        homeTeamLogo: 'https://upload.wikimedia.org/wikipedia/en/e/eb/Manchester_City_FC_badge.svg',
        awayTeamLogo: 'https://upload.wikimedia.org/wikipedia/en/c/cc/Chelsea_FC.svg',
        sport: 'Football',
        leagueType: 'Premier League',
        stadium: 'Etihad Stadium',
        startTime: today.add(const Duration(hours: 14)),
        status: 'Live',
        isLive: true,
        score: '1-1',
        broadcastChannel: 'NBC Sports',
      ),
      // Upcoming
      FootballGame(
        id: 'f3',
        homeTeamName: 'Tottenham',
        awayTeamName: 'Man Utd',
        homeTeamAbbr: 'TOT',
        awayTeamAbbr: 'MUN',
        homeTeamLogo: 'https://upload.wikimedia.org/wikipedia/en/b/b4/Tottenham_Hotspur.svg',
        awayTeamLogo: 'https://upload.wikimedia.org/wikipedia/en/7/7a/Manchester_United_FC_crest.svg',
        sport: 'Football',
        leagueType: 'Premier League',
        stadium: 'Tottenham Hotspur Stadium',
        startTime: tomorrow.add(const Duration(hours: 16, minutes: 30)),
        status: 'Upcoming',
        broadcastChannel: 'USA Network',
      ),

      // F1
      // Results
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
      F1Game(
        id: 'y2_2',
        sport: 'F1',
        leagueType: 'Las Vegas, USA',
        stadium: 'Las Vegas Strip Circuit',
        startTime: yesterday.subtract(const Duration(days: 7)),
        status: 'Final',
        raceNumber: 21,
        winnerName: 'George Russell',
        winnerTeam: 'Mercedes',
        winnerImage: 'https://media.formula1.com/content/dam/fom-website/drivers/G/GEORUS01_George_Russell/georus01.png.transform/2col/image.png',
        winnerPoints: '25',
        winnerTotalPoints: '245',
        winningTime: '1:33.433',
        p2Name: 'Lewis Hamilton',
        p2Team: 'Mercedes',
        p2Image: 'https://media.formula1.com/content/dam/fom-website/drivers/L/LEWHAM01_Lewis_Hamilton/lewham01.png.transform/2col/image.png',
        p2Points: '18',
        p2TotalPoints: '190',
        p2Gap: '+0.435s',
        p3Name: 'Carlos Sainz',
        p3Team: 'Ferrari',
        p3Image: 'https://media.formula1.com/content/dam/fom-website/drivers/C/CARSAI01_Carlos_Sainz/carsai01.png.transform/2col/image.png',
        p3Points: '15',
        p3TotalPoints: '184',
        p3Gap: '+1.234s',
        broadcastChannel: 'Sky Sports',
      ),
      // Live
      F1Game(
        id: 't2',
        sport: 'F1',
        leagueType: 'Monaco, Monte Carlo',
        stadium: 'Circuit de Monaco',
        startTime: today.subtract(const Duration(hours: 1)),
        status: 'Live',
        isLive: true,
        raceNumber: 8,
        laps: 78,
        broadcastChannel: 'ABC',
        winnerName: 'Charles Leclerc',
        winnerTeam: 'Ferrari',
        winnerImage: 'https://media.formula1.com/content/dam/fom-website/drivers/C/CHALEC01_Charles_Leclerc/chalec01.png.transform/2col/image.png',
        winnerPoints: '25',
        winningTime: 'LAP 45/78',
        winnerTotalPoints: '138',
        p2Name: 'Oscar Piastri',
        p2Team: 'McLaren',
        p2Image: 'https://media.formula1.com/content/dam/fom-website/drivers/O/OSCPIA01_Oscar_Piastri/oscpia01.png.transform/2col/image.png',
        p2Gap: '+1.2s',
        p2Points: '18',
        p2TotalPoints: '112',
        p3Name: 'Carlos Sainz',
        p3Team: 'Ferrari',
        p3Image: 'https://media.formula1.com/content/dam/fom-website/drivers/C/CARSAI01_Carlos_Sainz/carsai01.png.transform/2col/image.png',
        p3Gap: '+2.5s',
        p3Points: '15',
        p3TotalPoints: '108',
      ),
      F1Game(
        id: 't2_2',
        sport: 'F1',
        leagueType: 'Barcelona, Spain',
        stadium: 'Circuit de Barcelona-Catalunya',
        startTime: today.subtract(const Duration(hours: 3)),
        status: 'Live',
        isLive: true,
        raceNumber: 9,
        laps: 66,
        broadcastChannel: 'ESPN',
        winnerName: 'Max Verstappen',
        winnerTeam: 'Red Bull Racing',
        winnerImage: 'https://media.formula1.com/content/dam/fom-website/drivers/M/MAXVER01_Max_Verstappen/maxver01.png.transform/2col/image.png',
        winnerPoints: '25',
        winningTime: 'LAP 22/66',
        winnerTotalPoints: '219',
        p2Name: 'Lando Norris',
        p2Team: 'McLaren',
        p2Image: 'https://media.formula1.com/content/dam/fom-website/drivers/L/LANNOR01_Lando_Norris/lannor01.png.transform/2col/image.png',
        p2Gap: '+0.8s',
        p2Points: '18',
        p2TotalPoints: '150',
        p3Name: 'Lewis Hamilton',
        p3Team: 'Mercedes',
        p3Image: 'https://media.formula1.com/content/dam/fom-website/drivers/L/LEWHAM01_Lewis_Hamilton/lewham01.png.transform/2col/image.png',
        p3Gap: '+4.2s',
        p3Points: '15',
        p3TotalPoints: '70',
      ),
      // Upcoming
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

      // Golf
      // Results
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
            name: 'Will Zalatoris',
            team: 'USA',
            score: '-14',
            thru: 'F',
            image: 'https://pga-tour-res.cloudinary.com/image/upload/c_fill,d_headshots_default.png,f_auto,g_face:center,h_350,q_auto,w_280/headshots_47487.png',
          ),
          GolfLeader(
            position: 3,
            name: 'Luke List',
            team: 'USA',
            score: '-14',
            thru: 'F',
            image: 'https://pga-tour-res.cloudinary.com/image/upload/c_fill,d_headshots_default.png,f_auto,g_face:center,h_350,q_auto,w_280/headshots_27141.png',
          ),
        ],
      ),
      GolfGame(
        id: 'g1_2',
        sport: 'Golf',
        tournamentName: 'AT&T Pebble Beach',
        stadium: 'Pebble Beach GL',
        startTime: yesterday.subtract(const Duration(days: 9)),
        status: 'Final',
        tourType: 'PGA Tour',
        winnerPurse: '\$3.6M',
        leaderboard: [
          GolfLeader(
            position: 1,
            name: 'Wyndham Clark',
            team: 'USA',
            score: '-17',
            thru: 'F',
            image: 'https://pga-tour-res.cloudinary.com/image/upload/c_fill,d_headshots_default.png,f_auto,g_face:center,h_350,q_auto,w_280/headshots_49964.png',
          ),
          GolfLeader(
            position: 2,
            name: 'Ludvig Åberg',
            team: 'Sweden',
            score: '-16',
            thru: 'F',
            image: 'https://pga-tour-res.cloudinary.com/image/upload/c_fill,d_headshots_default.png,f_auto,g_face:center,h_350,q_auto,w_280/headshots_64332.png',
          ),
          GolfLeader(
            position: 3,
            name: 'Matthieu Pavon',
            team: 'France',
            score: '-15',
            thru: 'F',
            image: 'https://pga-tour-res.cloudinary.com/image/upload/c_fill,d_headshots_default.png,f_auto,g_face:center,h_350,q_auto,w_280/headshots_47190.png',
          ),
        ],
      ),
      // Live
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
            thru: 'Hole 18',
            image: 'https://pga-tour-res.cloudinary.com/image/upload/c_fill,d_headshots_default.png,f_auto,g_face:center,h_350,q_auto,w_280/headshots_27129.png',
          ),
          GolfLeader(
            position: 3,
            name: 'Scottie Scheffler',
            team: 'USA',
            score: '-18',
            thru: 'Hole 18',
            image: 'https://pga-tour-res.cloudinary.com/image/upload/c_fill,d_headshots_default.png,f_auto,g_face:center,h_350,q_auto,w_280/headshots_46046.png',
          ),
        ],
      ),
      GolfGame(
        id: 't3_golf',
        sport: 'Golf',
        tournamentName: 'Arnold Palmer Invitational',
        stadium: 'Bay Hill Club',
        startTime: today,
        status: 'Live',
        isLive: true,
        tourType: 'PGA Tour',
        purse: '\$20M',
        leaderboard: [
          GolfLeader(
            position: 1,
            name: 'Scottie Scheffler',
            team: 'USA',
            score: '-15',
            thru: 'Hole 14',
            image: 'https://pga-tour-res.cloudinary.com/image/upload/c_fill,d_headshots_default.png,f_auto,g_face:center,h_350,q_auto,w_280/headshots_46046.png',
          ),
          GolfLeader(
            position: 2,
            name: 'Wyndham Clark',
            team: 'USA',
            score: '-10',
            thru: 'Hole 14',
            image: 'https://pga-tour-res.cloudinary.com/image/upload/c_fill,d_headshots_default.png,f_auto,g_face:center,h_350,q_auto,w_280/headshots_49964.png',
          ),
          GolfLeader(
            position: 3,
            name: 'Shane Lowry',
            team: 'Ireland',
            score: '-9',
            thru: 'Hole 15',
            image: 'https://pga-tour-res.cloudinary.com/image/upload/c_fill,d_headshots_default.png,f_auto,g_face:center,h_350,q_auto,w_280/headshots_33448.png',
          ),
        ],
      ),
      // Upcoming
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
      GolfGame(
        id: 'g3_2',
        sport: 'Golf',
        tournamentName: 'U.S. Open',
        stadium: 'Pinehurst No. 2',
        startTime: tomorrow.add(const Duration(days: 100)),
        status: 'Upcoming',
        par: '70',
        tourType: 'PGA Tour',
        purse: '\$20M',
        broadcastChannel: 'NBC',
      ),

      // Tennis
      // Results
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
        id: 't1_2',
        sport: 'Tennis',
        tournamentName: 'Wimbledon',
        round: 'Final',
        startTime: yesterday.subtract(const Duration(days: 200)),
        status: 'Final',
        surface: 'Grass',
        stadium: 'Centre Court',
        player1Name: 'Carlos Alcaraz',
        player1Country: 'ESP',
        player1Image: 'https://www.atptour.com/-/media/alias/player-headshot/a0e2',
        player2Name: 'Novak Djokovic',
        player2Country: 'SRB',
        player2Image: 'https://www.atptour.com/-/media/alias/player-headshot/d643',
        player1SetScores: ['1', '7', '6', '6', '6'],
        player2SetScores: ['6', '6', '1', '3', '4'],
      ),
      // Live
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
        player1Image: 'https://www.atptour.com/-/media/alias/player-headshot/r0dg',
        player1HasService: true,
        player1SetScores: ['6', '2'],
        player2SetScores: ['4', '1'],
        player1CurrentPoints: '30',
        player2CurrentPoints: '15',
        player2Name: 'Alexander Shevchenko',
        player2Country: 'KAZ',
        player2Image: 'https://www.atptour.com/-/media/alias/player-headshot/sh96',
      ),
      TennisGame(
        id: 't2_2',
        sport: 'Tennis',
        tournamentName: 'Dubai Championships',
        round: 'Round 1',
        startTime: today,
        status: 'Live',
        isLive: true,
        surface: 'Hard',
        player1Name: 'Andrey Rublev',
        player1Country: 'RUS',
        player1Image: 'https://www.atptour.com/-/media/alias/player-headshot/re44',
        player1HasService: false,
        player1SetScores: ['5'],
        player2SetScores: ['6'],
        player1CurrentPoints: '15',
        player2CurrentPoints: '40',
        player2Name: 'Alex de Minaur',
        player2Country: 'AUS',
        player2Image: 'https://www.atptour.com/-/media/alias/player-headshot/di60',
      ),
      // Upcoming
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
        player1Image: 'https://www.atptour.com/-/media/alias/player-headshot/a0e2',
        player2Name: 'Novak Djokovic',
        player2Country: 'SRB',
        player2Image: 'https://www.atptour.com/-/media/alias/player-headshot/d643',
      ),
      TennisGame(
        id: 't3_2',
        sport: 'Tennis',
        tournamentName: 'Miami Open',
        round: 'Round 1',
        startTime: tomorrow.add(const Duration(days: 14)),
        status: 'Upcoming',
        surface: 'Hard',
        player1Name: 'Taylor Fritz',
        player1Country: 'USA',
        player1Image: 'https://www.atptour.com/-/media/alias/player-headshot/fb98',
        player2Name: 'Casper Ruud',
        player2Country: 'NOR',
        player2Image: 'https://www.atptour.com/-/media/alias/player-headshot/rh16',
      ),

      // Rally
      // Results
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
            image: 'https://cdn-wrc.idios.be/ea430df4-6e8a-44e2-8b6a-938b81db06a3/drivers/22/neuville_thierry_2024.png',
          ),
          RallyLeader(
            position: 2,
            name: 'Sébastien Ogier',
            team: 'Toyota Gazoo Racing WRT',
            time: '+16.1',
            car: 'Toyota GR Yaris Rally1',
            image: 'https://cdn-wrc.idios.be/ea430df4-6e8a-44e2-8b6a-938b81db06a3/drivers/22/ogier_sebastien_2024.png',
          ),
          RallyLeader(
            position: 3,
            name: 'Elfyn Evans',
            team: 'Toyota Gazoo Racing WRT',
            time: '+45.2',
            car: 'Toyota GR Yaris Rally1',
            image: 'https://cdn-wrc.idios.be/ea430df4-6e8a-44e2-8b6a-938b81db06a3/drivers/22/evans_elfyn_2024.png',
          ),
        ],
      ),
      RallyGame(
        id: 'r1_2',
        sport: 'Rally',
        leagueType: 'WRC',
        eventName: 'Rally Japan',
        location: 'Japan',
        surface: 'Tarmac',
        startTime: yesterday.subtract(const Duration(days: 90)),
        status: 'Final',
        totalStages: 22,
        leaderboard: [
          RallyLeader(
            position: 1,
            name: 'Elfyn Evans',
            team: 'Toyota Gazoo Racing WRT',
            time: '3:32:08.8',
            image: 'https://cdn-wrc.idios.be/ea430df4-6e8a-44e2-8b6a-938b81db06a3/drivers/22/evans_elfyn_2024.png',
          ),
          RallyLeader(
            position: 2,
            name: 'Sébastien Ogier',
            team: 'Toyota Gazoo Racing WRT',
            time: '+1:17.7',
            image: 'https://cdn-wrc.idios.be/ea430df4-6e8a-44e2-8b6a-938b81db06a3/drivers/22/ogier_sebastien_2024.png',
          ),
          RallyLeader(
            position: 3,
            name: 'Kalle Rovanperä',
            team: 'Toyota Gazoo Racing WRT',
            time: '+1:46.5',
            image: 'https://cdn-wrc.idios.be/ea430df4-6e8a-44e2-8b6a-938b81db06a3/drivers/22/rovanpera_kalle_2024.png',
          ),
        ],
      ),
      // Live
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
          ),
          RallyLeader(
            position: 2,
            name: 'Guillaume de Mevius',
            team: 'Overdrive Racing',
            time: '+1:20:12',
            car: 'Toyota Hilux Overdrive',
          ),
          RallyLeader(
            position: 3,
            name: 'Sébastien Loeb',
            team: 'Bahrain Raid Xtreme',
            time: '+1:25:22',
            car: 'Hunter',
          ),
        ],
      ),
      RallyGame(
        id: 'r2_2',
        sport: 'Rally',
        leagueType: 'WRC',
        eventName: 'Rally Kenya',
        location: 'Naivasha, Kenya',
        surface: 'Gravel',
        startTime: today,
        status: 'Live',
        isLive: true,
        currentStage: 'SS4',
        leaderboard: [
          RallyLeader(
            position: 1,
            name: 'Kalle Rovanperä',
            team: 'Toyota Gazoo Racing WRT',
            time: '35:21.0',
            car: 'Toyota GR Yaris Rally1',
          ),
          RallyLeader(
            position: 2,
            name: 'Elfyn Evans',
            team: 'Toyota Gazoo Racing WRT',
            time: '+15.5',
            car: 'Toyota GR Yaris Rally1',
          ),
          RallyLeader(
            position: 3,
            name: 'Ott Tänak',
            team: 'Hyundai Shell Mobis WRT',
            time: '+16.8',
            car: 'Hyundai i20 N Rally1',
          ),
        ],
      ),
      // Upcoming
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
      RallyGame(
        id: 'r3_2',
        sport: 'Rally',
        leagueType: 'WRC',
        eventName: 'Rally Croatia',
        location: 'Zagreb, Croatia',
        surface: 'Tarmac',
        startTime: tomorrow.add(const Duration(days: 60)),
        status: 'Upcoming',
        totalStages: 20,
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
