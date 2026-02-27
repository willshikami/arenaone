import 'dart:async';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:google_fonts/google_fonts.dart';
import 'sport_category_page.dart';
import 'f1_detail_page.dart';
import 'golf_detail_page.dart';
import '../../../redux/app_state.dart';
import '../../../redux/actions/team_actions.dart';
import '../../../data/models/game.dart';
import '../../../data/models/sports/f1_game.dart';
import '../../../data/models/sports/golf_game.dart';
import '../../../data/models/sports/tennis_game.dart';
import '../../../data/models/sports/rally_game.dart';
import '../../../data/models/sports/football_game.dart';
import '../widgets/home_top_bar.dart';
import '../widgets/game_card.dart';
import '../widgets/f1_race_card.dart';
import '../widgets/golf_card.dart';
import '../widgets/tennis_card.dart';
import '../widgets/rally_card.dart';
import '../widgets/football_card.dart';
import '../../widgets/shimmer_loading.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _startRefreshTimer();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _startRefreshTimer() {
    // Refresh every 3 minutes
    _refreshTimer = Timer.periodic(const Duration(minutes: 3), (timer) {
      if (mounted) {
        StoreProvider.dispatch<AppState>(context, LoadAllGamesAction(showLoading: false));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      onInit: (store) {
        store.dispatch(LoadAllGamesAction());
      },
      vm: () => _Factory(widget),
      builder: (context, vm) {
        return DefaultTabController(
          length: 3,
          initialIndex: 1,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0D0D10),
              gradient: RadialGradient(
                center: const Alignment(0, -1.8),
                radius: 2.2,
                colors: [
                  const Color(0xFFFF6A1A).withValues(alpha: 0.12),
                  const Color(0xFF0D0D10),
                ],
                stops: const [0.0, 0.5],
              ),
            ),
            child: Column(
              children: [
                const HomeTopBar(),
                TabBar(
                  dividerColor: Colors.transparent,
                  indicatorColor: const Color(
                    0xFFFF6A1A,
                  ), // Modern bold orange indicator
                  indicatorWeight: 3,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: GoogleFonts.instrumentSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  unselectedLabelStyle: GoogleFonts.instrumentSans(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  tabs: const [
                    Tab(text: 'Upcoming'),
                    Tab(text: 'Live'),
                    Tab(text: 'Results'),
                  ],
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await vm.refreshGames();
                    },
                    color: const Color(0xFFFF6A1A),
                    backgroundColor: const Color(0xFF1A1A1E),
                    child: TabBarView(
                      children: [
                        _buildTabContent(context, vm, vm.upcomingGames),
                        _buildTabContent(context, vm, vm.liveGames),
                        _buildTabContent(context, vm, vm.resultsGames),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabContent(BuildContext context, _ViewModel vm, List<Game> games) {
    if (vm.isLoading && games.isEmpty) {
      return _buildShimmerList();
    }
    return _buildGamesList(context, games);
  }

  Widget _buildShimmerList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        F1CardShimmer(),
        NBAFootballCardShimmer(),
        GolfCardShimmer(),
        TennisCardShimmer(),
        RallyCardShimmer(),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SFIcon(SFIcons.sf_sportscourt, fontSize: 100, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No matches available at this time',
              textAlign: TextAlign.center,
              style: GoogleFonts.instrumentSans(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGamesList(BuildContext context, List<Game> games) {
    if (games.isEmpty) return _buildEmptyState();

    // Sort games: descending for results (status 'Final'), ascending for others
    final sortedGames = List<Game>.from(games)
      ..sort((a, b) {
        // Special safety for Tennis: if player names include 'TBD', put them at the end of the day's group
        if (a is TennisGame && b is TennisGame) {
          final aIsTBD = a.player1Name == 'TBD' || a.player2Name == 'TBD';
          final bIsTBD = b.player1Name == 'TBD' || b.player2Name == 'TBD';
          if (aIsTBD != bIsTBD) return aIsTBD ? 1 : -1;
        }

        if (a.status == 'Final') {
          return b.startTime.compareTo(a.startTime);
        }
        return a.startTime.compareTo(b.startTime);
      });

    // Debugging print
    if (games.any((g) => g.sport == 'Tennis')) {
      debugPrint('HOME_PAGE: Processing ${games.where((g) => g.sport == 'Tennis').length} Tennis matches');
      for (var g in games.where((g) => g.sport == 'Tennis')) {
        debugPrint('  - Event: ${g.stadium ?? "Unknown"} | Status: ${g.status} | Time: ${g.startTime}');
      }
    } else if (games.isNotEmpty) {
       debugPrint('HOME_PAGE: No Tennis games among ${games.length} games. Sports present: ${games.map((g) => g.sport).toSet().toList()}');
    }

    // Group by sport
    final groupedGames = <String, List<Game>>{};
    final fullSportGames = <String, List<Game>>{};
    
    for (var game in sortedGames) {
      final sport = game.sport;
      if (!fullSportGames.containsKey(sport)) {
        fullSportGames[sport] = [];
        groupedGames[sport] = [];
      }
      
      fullSportGames[sport]!.add(game);
      
      if (groupedGames[sport]!.length < 5) {
        groupedGames[sport]!.add(game);
      }
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: groupedGames.entries.map((entry) {
        final sport = entry.key;
        final sportDisplayGames = entry.value;
        final allSportGames = fullSportGames[sport]!;

        IconData getSportIcon(String sport) {
          switch (sport.toUpperCase()) {
            case 'F1':
              return SFIcons.sf_flag_2_crossed_fill;
            case 'GOLF':
              return SFIcons.sf_figure_golf;
            case 'TENNIS':
              return SFIcons.sf_tennisball_fill;
            case 'NBA':
              return SFIcons.sf_basketball_fill;
            case 'RALLY':
              return SFIcons.sf_car_fill;
            case 'FOOTBALL':
              return SFIcons.sf_sportscourt;
            default:
              return SFIcons.sf_sportscourt;
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                String category = "Upcoming";
                if (allSportGames.isNotEmpty) {
                  final status = allSportGames.first.status;
                  if (status == 'Live') {
                    category = "Live games";
                  } else if (status == 'Final') {
                    category = "Results";
                  } else {
                    category = "Upcoming race";
                  }
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SportCategoryPage(
                      sport: sport,
                      categoryTitle: category,
                      games: allSportGames,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12.0, top: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SFIcon(
                          getSportIcon(sport),
                          fontSize: 14,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          sport.toUpperCase(),
                          style: GoogleFonts.spaceMono(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 14,
                    ),
                  ],
                ),
              ),
            ),
            ...sportDisplayGames.map((game) => _buildGameCard(game)),
            const SizedBox(height: 16),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildGameCard(Game game) {
    if (game is F1Game) {
      if (game.status == 'Upcoming') {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => F1DetailPage(game: game),
              ),
            );
          },
          child: F1UpcomingCard(
            raceName: game.stadium ?? 'TBD Grand Prix',
            location: game.leagueType ?? 'TBD',
            raceDate: game.startTime.toLocal(),
            circuitImage: game.eventImageUrl,
            broadcastChannel: game.broadcastChannel,
            raceNumber: game.raceNumber ?? 0,
            laps: game.laps ?? 0,
            circuitLayoutUrl: game.circuitLayoutUrl ??
                'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2b/Circuit_Red_Bull_Ring.svg/1024px-Circuit_Red_Bull_Ring.svg.png',
            trackLength: game.trackLength ?? '---',
          ),
        );
      } else if (game.status == 'Live') {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => F1DetailPage(game: game),
              ),
            );
          },
          child: F1LiveCard(
            raceName: game.stadium ?? 'Grand Prix',
            raceNumber: game.raceNumber ?? 0,
            circuitImage: game.eventImageUrl,
            leaderName: game.winnerName ?? 'Unknown',
            leaderTeam: game.winnerTeam ?? 'TBD',
            leaderImage: game.winnerImage ??
                'https://a.espncdn.com/i/teamlogos/f1/500/f1.png',
            lapInfo: game.winningTime ?? 'LAP --/--',
            p2Name: game.p2Name,
            p2Team: game.p2Team,
            p2Image: game.p2Image,
            p2Gap: game.p2Gap,
            p3Name: game.p3Name,
            p3Team: game.p3Team,
            p3Image: game.p3Image,
            p3Gap: game.p3Gap,
          ),
        );
      } else {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => F1DetailPage(game: game),
              ),
            );
          },
          child: F1CompletedCard(
            raceName: game.stadium ?? 'Grand Prix',
            raceDate: game.startTime.toLocal(),
            raceNumber: game.raceNumber ?? 0,
            circuitImage: game.eventImageUrl,
            winnerName: game.winnerName ?? 'Unknown',
            winnerTeam: game.winnerTeam ?? 'TBD',
            winnerLogo: game.winnerImage ??
                'https://a.espncdn.com/i/teamlogos/f1/500/f1.png',
            points: game.winnerPoints ?? '0',
            winnerTotalPoints: game.winnerTotalPoints,
            time: game.winningTime,
            p2Name: game.p2Name,
            p2Team: game.p2Team,
            p2Image: game.p2Image,
            p2Points: game.p2Points,
            p2TotalPoints: game.p2TotalPoints,
            p2Gap: game.p2Gap,
            p3Name: game.p3Name,
            p3Team: game.p3Team,
            p3Image: game.p3Image,
            p3Points: game.p3Points,
            p3TotalPoints: game.p3TotalPoints,
            p3Gap: game.p3Gap,
          ),
        );
      }
    }

    if (game is GolfGame) {
      final leaders = game.leaderboard ?? [];
      if (game.status == 'Upcoming') {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GolfDetailPage(game: game),
              ),
            );
          },
          child: GolfUpcomingCard(
            tournamentName: game.tournamentName ?? 'TBD Tournament',
            location: game.stadium ?? 'TBD Course',
            startDate: game.startTime.toLocal(),
            par: game.par ?? '72',
            tourType: game.tourType ?? 'PGA Tour',
            broadcastChannel: game.broadcastChannel,
            purse: game.purse,
          ),
        );
      } else if (game.status == 'Live') {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GolfDetailPage(game: game),
              ),
            );
          },
          child: GolfLiveCard(game: game),
        );
      } else {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GolfDetailPage(game: game),
              ),
            );
          },
          child: GolfCompletedCard(
            tournamentName: game.tournamentName ?? 'TBD Tournament',
            winnerName: leaders.isNotEmpty ? leaders[0].name : 'Unknown',
            winnerScore: leaders.isNotEmpty ? leaders[0].score : 'E',
            winnerImage: leaders.isNotEmpty ? leaders[0].image : null,
            tourType: game.tourType ?? 'PGA Tour',
            winnerPurse: game.winnerPurse ?? game.purse,
            p2Name: leaders.length > 1 ? leaders[1].name : null,
            p2Score: leaders.length > 1 ? leaders[1].score : null,
            p3Name: leaders.length > 2 ? leaders[2].name : null,
            p3Score: leaders.length > 2 ? leaders[2].score : null,
          ),
        );
      }
    }

    if (game is TennisGame) {
      if (game.status == 'Upcoming') {
        return TennisUpcomingCard(game: game);
      } else if (game.status == 'Live') {
        return TennisLiveCard(game: game);
      } else {
        return TennisCompletedCard(game: game);
      }
    }

    if (game is RallyGame) {
      if (game.status == 'Upcoming') {
        return RallyUpcomingCard(game: game);
      } else if (game.status == 'Live') {
        return RallyLiveCard(game: game);
      } else {
        return RallyCompletedCard(game: game);
      }
    }

    if (game is FootballGame) {
      return FootballCard(game: game);
    }

    return GameCard(game: game);
  }
}

class _Factory extends VmFactory<AppState, HomeScreen, _ViewModel> {
  _Factory(super.widget);

  @override
  _ViewModel fromStore() {
    final selectedSports = state.selectedSports;
    
    // DEBUG: Check what's in the state
    if (state.games.isNotEmpty) {
      final sportsInState = state.games.map((g) => g.sport).toSet().toList();
      debugPrint('REDUX_STATE: Total games: ${state.games.length}, Sports: $sportsInState');
      final tennisGames = state.games.where((g) => g.sport == 'Tennis').toList();
      if (tennisGames.isNotEmpty) {
        debugPrint('REDUX_STATE: Found ${tennisGames.length} Tennis games');
        for (var tg in tennisGames) {
          debugPrint('  - ${tg.id}: ${tg.status} (isLive: ${tg.isLive})');
        }
      }
    }

    // If no sports selected, show all games
    final filteredGames = selectedSports.isEmpty 
      ? state.games 
      : state.games.where((g) => selectedSports.contains(g.sport)).toList();

    return _ViewModel(
      currentTabIndex: state.currentTabIndex,
      liveGames: filteredGames.where((g) => g.isLive || g.status == 'Live').toList(),
      upcomingGames: filteredGames.where((g) => g.status == 'Upcoming' && !g.isLive).toList(),
      resultsGames: filteredGames.where((g) => g.status == 'Final').toList(),
      isLoading: state.isLoading,
      refreshGames: () => dispatch(LoadAllGamesAction()),
    );
  }
}

class _ViewModel extends Vm {
  final int currentTabIndex;
  final List<Game> liveGames;
  final List<Game> upcomingGames;
  final List<Game> resultsGames;
  final bool isLoading;
  final Function() refreshGames;

  _ViewModel({
    required this.currentTabIndex,
    required this.liveGames,
    required this.upcomingGames,
    required this.resultsGames,
    required this.isLoading,
    required this.refreshGames,
  }) : super(
          equals: [
            currentTabIndex,
            liveGames,
            upcomingGames,
            resultsGames,
            isLoading,
          ],
        );
}
