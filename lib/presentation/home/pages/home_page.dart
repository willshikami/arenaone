import 'dart:ui';
import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../redux/app_state.dart';
import '../../../redux/actions/team_actions.dart';
import '../../../redux/actions/navigation_actions.dart';
import '../../../data/models/game.dart';
import '../widgets/home_top_bar.dart';
import 'package:intl/intl.dart';

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
            Icon(Icons.sports_rounded, size: 100, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'There are no upcoming matches in this league',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
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
        return _GameCard(game: game);
      },
    );
  }
}

class _GameCard extends StatelessWidget {
  final Game game;

  const _GameCard({required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16161C), // Unified dark surface
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                game.leagueType ?? 'Regular Season',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (game.isLive)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.red, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'LIVE',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    game.status == 'Final' 
                        ? 'FINAL' 
                        : DateFormat('h:mm a').format(game.startTime),
                    style: TextStyle(
                      color: game.status == 'Final' ? Colors.white : Colors.grey.shade400,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _TeamSection(
                name: game.homeTeamName,
                abbr: game.homeTeamAbbr,
                logoUrl: game.homeTeamLogo,
                isHome: true,
              )),
              _MatchInfo(game: game),
              Expanded(child: _TeamSection(
                name: game.awayTeamName,
                abbr: game.awayTeamAbbr,
                logoUrl: game.awayTeamLogo,
                isHome: false,
              )),
            ],
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: Colors.white.withOpacity(0.08)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    game.stadium ?? 'TBD',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.tv_outlined, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    game.broadcastChannel ?? 'Check Local',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TeamSection extends StatelessWidget {
  final String name;
  final String abbr;
  final String? logoUrl;
  final bool isHome;

  const _TeamSection({
    required this.name,
    required this.abbr,
    this.logoUrl,
    required this.isHome,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (logoUrl != null && logoUrl!.endsWith('.svg'))
          SvgPicture.network(
            logoUrl!,
            height: 48,
            width: 48,
            placeholderBuilder: (context) => const CircleAvatar(radius: 24, backgroundColor: Colors.transparent),
          )
        else if (logoUrl != null)
          Image.network(
            logoUrl!,
            height: 48,
            width: 48,
            errorBuilder: (context, error, stackTrace) => const CircleAvatar(radius: 24, backgroundColor: Colors.transparent),
          )
        else
          const CircleAvatar(radius: 24, backgroundColor: Colors.transparent),
        const SizedBox(height: 8),
        Text(
          abbr.isNotEmpty ? abbr : name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        Text(
          isHome ? 'Home' : 'Away',
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ],
    );
  }
}

class _MatchInfo extends StatelessWidget {
  final Game game;

  const _MatchInfo({required this.game});

  @override
  Widget build(BuildContext context) {
    if (game.status == 'Final' || game.isLive) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              game.score ?? '0-0',
              style: const TextStyle(
                fontSize: 28, 
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
            if (game.status == 'Final')
              Text(
                'FINAL',
                style: TextStyle(
                  fontSize: 10, 
                  color: Colors.grey.shade600, 
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Text(
            'VS',
            style: TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.w900, 
              color: Colors.grey.shade300,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 4),
          // We don't need the time here anymore as it's in the top right badge
          // But we can show "Tonight" or "Tomorrow" or something similar if needed
        ],
      ),
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
