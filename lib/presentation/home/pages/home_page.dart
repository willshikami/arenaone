import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
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
      decoration: BoxDecoration(
        color: const Color(0xFF16161C),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.06), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {}, // Enhanced with interaction surface
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 3,
                            height: 10,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF6A1A),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            (game.leagueType ?? 'Regular Season').toUpperCase(),
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                      if (game.isLive)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.red.withOpacity(0.5), width: 1),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 5,
                                height: 5,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                'LIVE',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            game.status == 'Final' 
                                ? 'FINAL' 
                                : DateFormat('h:mm a').format(game.startTime),
                            style: TextStyle(
                              color: game.status == 'Final' ? Colors.white : Colors.grey.shade300,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
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
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: Colors.white.withOpacity(0.06),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildFooterInfo(game.stadium ?? 'TBD'),
                      _buildFooterInfo(game.broadcastChannel ?? 'Check Local'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooterInfo(String label) {
    return Text(
      label,
      style: TextStyle(
        color: Colors.grey.shade500,
        fontSize: 12,
        fontWeight: FontWeight.w600,
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
        Container(
          height: 44,
          width: 44,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            shape: BoxShape.circle,
          ),
          child: logoUrl != null
              ? (logoUrl!.endsWith('.svg')
                  ? SvgPicture.network(
                      logoUrl!,
                      placeholderBuilder: (context) => const SizedBox.shrink(),
                    )
                  : Image.network(
                      logoUrl!,
                      errorBuilder: (context, error, stackTrace) => 
                          const SFIcon(SFIcons.sf_basketball, color: Colors.grey, fontSize: 20),
                    ))
              : const SFIcon(SFIcons.sf_basketball, color: Colors.grey, fontSize: 20),
        ),
        const SizedBox(height: 8),
        Text(
          abbr.isNotEmpty ? abbr : name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(
          isHome ? 'HOME' : 'AWAY',
          style: TextStyle(
            fontSize: 8, 
            color: Colors.grey.shade500, 
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
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
                color: Colors.white,
                letterSpacing: -1.5,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(height: 2),
            Text(
              game.isLive ? 'LIVE' : 'FINAL',
              style: TextStyle(
                fontSize: 9, 
                color: game.isLive ? Colors.red : Colors.grey.shade600, 
                fontWeight: FontWeight.w900,
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'VS',
              style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.w900, 
                color: Colors.white24,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            DateFormat('h:mm a').format(game.startTime),
            style: TextStyle(
              fontSize: 10, 
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w800,
            ),
          ),
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
