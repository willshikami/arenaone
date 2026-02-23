import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../data/models/game.dart';
import '../../../data/models/sports/f1_game.dart';
import '../../../data/models/sports/golf_game.dart';
import '../../../data/models/sports/tennis_game.dart';
import '../../../data/models/sports/rally_game.dart';
import '../widgets/game_card.dart';
import '../widgets/f1_race_card.dart';
import '../widgets/golf_card.dart';
import '../widgets/tennis_card.dart';
import '../widgets/rally_card.dart';

class SportCategoryPage extends StatelessWidget {
  final String sport;
  final String categoryTitle; // "Upcoming race", "Live games", "Results"
  final List<Game> games;

  const SportCategoryPage({
    super.key,
    required this.sport,
    required this.categoryTitle,
    required this.games,
  });

  @override
  Widget build(BuildContext context) {
    // Group games by date
    final groupedGames = <String, List<Game>>{};
    
    // Sort games descending by date for results, ascending for upcoming
    final sortedGames = List<Game>.from(games)..sort((a, b) {
      if (categoryTitle.toLowerCase().contains('results')) {
        return b.startTime.compareTo(a.startTime);
      }
      return a.startTime.compareTo(b.startTime);
    });

    for (var game in sortedGames) {
      final dateKey = _getDateKey(game.startTime);
      if (!groupedGames.containsKey(dateKey)) {
        groupedGames[dateKey] = [];
      }
      groupedGames[dateKey]!.add(game);
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D10),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '$sport - $categoryTitle',
          style: GoogleFonts.instrumentSans(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFFF6A1A).withValues(alpha: 0.08),
              const Color(0xFF0D0D10),
            ],
            stops: const [0.0, 0.2],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: groupedGames.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0, top: 4.0),
                  child: Text(
                    entry.key.toUpperCase(),
                    style: GoogleFonts.spaceMono(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                ...entry.value.map((game) => _buildGameCard(game)),
                const SizedBox(height: 16),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  String _getDateKey(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final tomorrow = today.add(const Duration(days: 1));
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (date == today) return 'Today';
    if (date == yesterday) return 'Yesterday';
    if (date == tomorrow) return 'Tomorrow';
    
    return DateFormat('EEEE, MMM d').format(date);
  }

  Widget _buildGameCard(Game game) {
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
          circuitLayoutUrl: game.circuitLayoutUrl ??
              'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2b/Circuit_Red_Bull_Ring.svg/1024px-Circuit_Red_Bull_Ring.svg.png',
          trackLength: game.trackLength ?? '---',
        );
      } else if (game.status == 'Live') {
        return F1LiveCard(
          raceName: game.stadium ?? 'Grand Prix',
          raceNumber: game.raceNumber ?? 0,
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
        );
      } else {
        return F1CompletedCard(
          raceName: game.stadium ?? 'Grand Prix',
          raceDate: game.startTime,
          raceNumber: game.raceNumber ?? 0,
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

    return GameCard(game: game);
  }
}
