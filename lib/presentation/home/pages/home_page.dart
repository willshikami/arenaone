import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import '../../../redux/app_state.dart';
import '../../../redux/actions/team_actions.dart';
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
      builder: (context, vm) => Column(
        children: [
          const HomeTopBar(), // Moved from appBar to body's top
          SportSelector(),
          Expanded(
            child: vm.games.isEmpty
                ? _buildEmptyState()
                : _buildGamesList(vm.games),
          ),
        ],
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
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: games.length,
      itemBuilder: (context, index) {
        final game = games[index];
        return Card(
          elevation: 0,
          color: Colors.grey.shade50,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTeamInfo(game.homeTeamName),
                Column(
                  children: [
                    if (game.isLive)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'LIVE',
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      game.score ?? DateFormat('HH:mm').format(game.startTime),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      game.status,
                      style: TextStyle(fontSize: 12, color: game.isLive ? Colors.red : Colors.grey),
                    ),
                  ],
                ),
                _buildTeamInfo(game.awayTeamName),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTeamInfo(String name) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.grey.shade200,
          child: Text(name[0], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        ),
        const SizedBox(height: 8),
        Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _Factory extends VmFactory<AppState, HomeScreen, _ViewModel> {
  _Factory(super.widget);

  @override
  _ViewModel fromStore() => _ViewModel(
        games: state.games,
      );
}

class _ViewModel extends Vm {
  final List<Game> games;

  _ViewModel({required this.games}) : super(equals: [games]);
}
