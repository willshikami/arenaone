import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import '../../../redux/app_state.dart';
import '../../../redux/actions/team_actions.dart';
import '../../../redux/actions/navigation_actions.dart';
import '../../../data/models/game.dart';
import '../widgets/home_top_bar.dart';
import '../widgets/game_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      onInit: (store) => store.dispatch(LoadMockGamesAction()),
      vm: () => _Factory(this),
      builder: (context, vm) => DefaultTabController(
        length: 3,
        initialIndex: 1, // Today
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0D0D10),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFFFF6A1A).withOpacity(0.12), // Bold orange tint
                const Color(0xFF0D0D10),
              ],
              stops: const [0.0, 0.3],
            ),
          ),
          child: Column(
            children: [
              const HomeTopBar(),
              SportSelector(),
              const TabBar(
                dividerColor: Colors.transparent,
                indicatorColor: Color(0xFFFF6A1A), // Modern bold orange indicator
                indicatorWeight: 3,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                tabs: [
                  Tab(text: 'Yesterday'),
                  Tab(text: 'Today'),
                  Tab(text: 'Tomorrow'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildGamesList(vm.yesterdayGames),
                    _buildGamesList(vm.todayGames),
                    _buildGamesList(vm.tomorrowGames),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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

    return _ViewModel(
      yesterdayGames: state.games.where((g) => isSameDay(g.startTime, yesterdayDate)).toList(),
      todayGames: state.games.where((g) => isSameDay(g.startTime, todayDate)).toList(),
      tomorrowGames: state.games.where((g) => isSameDay(g.startTime, tomorrowDate)).toList(),
      selectedDate: state.selectedDate,
      onDateSelected: (date) => dispatch(SetSelectedDateAction(date)),
    );
  }
}

class _ViewModel extends Vm {
  final List<Game> yesterdayGames;
  final List<Game> todayGames;
  final List<Game> tomorrowGames;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  _ViewModel({
    required this.yesterdayGames,
    required this.todayGames,
    required this.tomorrowGames,
    required this.selectedDate,
    required this.onDateSelected,
  }) : super(equals: [yesterdayGames, todayGames, tomorrowGames, selectedDate]);
}
