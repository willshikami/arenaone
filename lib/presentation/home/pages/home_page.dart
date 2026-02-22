import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import '../../../redux/app_state.dart';
import '../../../redux/actions/team_actions.dart';
import '../../../redux/actions/navigation_actions.dart';
import '../../../data/models/game.dart';
import '../../../data/models/sports/f1_game.dart';
import '../../../data/models/sports/golf_game.dart';
import '../widgets/home_top_bar.dart';
import '../widgets/game_card.dart';
import '../widgets/f1_race_card.dart';
import '../widgets/golf_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      onInit: (store) => store.dispatch(LoadMockGamesAction()),
      vm: () => _Factory(this),
      builder: (context, vm) {
        final isF1 = vm.selectedSport == 'F1';
        final isGolf = vm.selectedSport == 'Golf';
        return DefaultTabController(
          key: ValueKey(vm.selectedSport),
          length: (isF1 || isGolf) ? 2 : 3,
          initialIndex: 0,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0D0D10),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFFFF6A1A).withValues(alpha: 0.12), // Bold orange tint
                  const Color(0xFF0D0D10),
                ],
                stops: const [0.0, 0.3],
              ),
            ),
            child: Column(
              children: [
                const HomeTopBar(),
                SportSelector(),
                TabBar(
                  dividerColor: Colors.transparent,
                  indicatorColor: const Color(
                    0xFFFF6A1A,
                  ), // Modern bold orange indicator
                  indicatorWeight: 3,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                  tabs: (isF1 || isGolf)
                      ? const [Tab(text: 'Previous'), Tab(text: 'Upcoming')]
                      : const [
                          Tab(text: 'Yesterday'),
                          Tab(text: 'Today'),
                          Tab(text: 'Tomorrow'),
                        ],
                ),
                Expanded(
                  child: TabBarView(
                    children: (isF1 || isGolf)
                        ? [
                            _buildGamesList(vm.yesterdayGames), // Previous
                            _buildGamesList(vm.todayGames), // Upcoming
                          ]
                        : [
                            _buildGamesList(vm.yesterdayGames),
                            _buildGamesList(vm.todayGames),
                            _buildGamesList(vm.tomorrowGames),
                          ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SFIcon(SFIcons.sf_sportscourt, fontSize: 100, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'There are no upcoming matches in this league',
              textAlign: TextAlign.center,
              style: TextStyle(
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

  Widget _buildGamesList(List<Game> games) {
    if (games.isEmpty) return _buildEmptyState();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: games.length,
      itemBuilder: (context, index) {
        final game = games[index];

        if (game is F1Game) {
          if (game.status == 'Upcoming') {
            return F1UpcomingCard(
              raceName: game.stadium ?? 'TBD Grand Prix',
              location: game.leagueType ?? 'TBD',
              raceDate: game.startTime,
              circuitImage: game.eventImageUrl,
              broadcastChannel: game.broadcastChannel,
              raceNumber: game.raceNumber ?? 0,
              laps: game.laps ?? 0,
              circuitLayoutUrl: game.circuitLayoutUrl ?? 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2b/Circuit_Red_Bull_Ring.svg/1024px-Circuit_Red_Bull_Ring.svg.png',
              trackLength: game.trackLength ?? '---',
            );
          } else {
            return F1CompletedCard(
              raceName: game.stadium ?? 'Grand Prix',
              raceDate: game.startTime,
              raceNumber: game.raceNumber ?? 0,
              winnerName: game.winnerName ?? 'Unknown',
              winnerTeam: game.winnerTeam ?? 'TBD',
              winnerLogo: game.winnerImage ?? 'https://a.espncdn.com/i/teamlogos/f1/500/f1.png',
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
            );
          }
        }

        if (game is GolfGame) {
          final leaders = game.leaderboard ?? [];
          if (game.status == 'Upcoming') {
            return GolfUpcomingCard(
              tournamentName: game.tournamentName ?? 'TBD Tournament',
              location: game.stadium ?? 'TBD Course',
              startDate: game.startTime,
              par: game.par ?? '72',
              tourType: game.tourType ?? 'PGA Tour',
              broadcastChannel: game.broadcastChannel,
              purse: game.purse,
            );
          } else if (game.status == 'Live') {
            return GolfLiveCard(
              tournamentName: game.tournamentName ?? 'TBD Tournament',
              leaderName: leaders.isNotEmpty ? leaders[0].name : 'TBD',
              leaderScore: leaders.isNotEmpty ? leaders[0].score : 'E',
              thru: leaders.isNotEmpty ? leaders[0].thru : '-',
              currentRound: game.round ?? 'Round 1',
              tourType: game.tourType ?? 'PGA Tour',
              leaderImage: leaders.isNotEmpty ? leaders[0].image : null,
              purse: game.purse,
              p2Name: leaders.length > 1 ? leaders[1].name : null,
              p2Score: leaders.length > 1 ? leaders[1].score : null,
              p2Thru: leaders.length > 1 ? leaders[1].thru : null,
              p3Name: leaders.length > 2 ? leaders[2].name : null,
              p3Score: leaders.length > 2 ? leaders[2].score : null,
              p3Thru: leaders.length > 2 ? leaders[2].thru : null,
            );
          } else {
            return GolfCompletedCard(
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
            );
          }
        }

        return GameCard(game: game);
      },
    );
  }
}

class _Factory extends VmFactory<AppState, HomeScreen, _ViewModel> {
  _Factory(super.widget);

  @override
  _ViewModel fromStore() {
    final now = DateTime.now();
    final todayDate = DateTime(now.year, now.month, now.day);
    final yesterdayDate = todayDate.subtract(const Duration(days: 1));
    final tomorrowDate = todayDate.add(const Duration(days: 1));

    bool isSameDay(DateTime a, DateTime b) {
      return a.year == b.year && a.month == b.month && a.day == b.day;
    }

    if (state.selectedSport == 'F1') {
      return _ViewModel(
        yesterdayGames: state.games
            .where((g) => g.sport == 'F1' && g.status == 'Final')
            .toList(),
        todayGames: state.games
            .where((g) => g.sport == 'F1' && g.status == 'Upcoming')
            .toList(),
        tomorrowGames: [],
        selectedDate: state.selectedDate,
        selectedSport: state.selectedSport,
        onDateSelected: (date) => dispatch(SetSelectedDateAction(date)),
      );
    }

    if (state.selectedSport == 'Golf') {
      return _ViewModel(
        yesterdayGames: state.games
            .where((g) => g.sport == 'Golf' && g.status == 'Final')
            .toList(),
        todayGames: state.games
            .where((g) => g.sport == 'Golf' && (g.status == 'Upcoming' || g.status == 'Live'))
            .toList(),
        tomorrowGames: [],
        selectedDate: state.selectedDate,
        selectedSport: state.selectedSport,
        onDateSelected: (date) => dispatch(SetSelectedDateAction(date)),
      );
    }

    return _ViewModel(
      yesterdayGames: state.games
          .where(
            (g) =>
                isSameDay(g.startTime, yesterdayDate) &&
                g.sport == state.selectedSport,
          )
          .toList(),
      todayGames: state.games
          .where(
            (g) =>
                isSameDay(g.startTime, todayDate) &&
                g.sport == state.selectedSport,
          )
          .toList(),
      tomorrowGames: state.games
          .where(
            (g) =>
                isSameDay(g.startTime, tomorrowDate) &&
                g.sport == state.selectedSport,
          )
          .toList(),
      selectedDate: state.selectedDate,
      selectedSport: state.selectedSport,
      onDateSelected: (date) => dispatch(SetSelectedDateAction(date)),
    );
  }
}

class _ViewModel extends Vm {
  final List<Game> yesterdayGames;
  final List<Game> todayGames;
  final List<Game> tomorrowGames;
  final DateTime selectedDate;
  final String selectedSport;
  final Function(DateTime) onDateSelected;

  _ViewModel({
    required this.yesterdayGames,
    required this.todayGames,
    required this.tomorrowGames,
    required this.selectedDate,
    required this.selectedSport,
    required this.onDateSelected,
  }) : super(
         equals: [
           yesterdayGames,
           todayGames,
           tomorrowGames,
           selectedDate,
           selectedSport,
         ],
       );
}
