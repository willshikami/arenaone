import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:arenaone/core/data/sports/golf_game.dart';
import 'package:arenaone/core/data/mappers/sport_mapper.dart';
import 'package:arenaone/core/widgets/score_flip_text.dart';
import 'package:arenaone/core/widgets/golf_player_details_sheet.dart';

class GolfUpcomingCard extends StatelessWidget {
  final String tournamentName;
  final String location;
  final DateTime startDate;
  final String par;
  final String? broadcastChannel;
  final String tourType;
  final String? purse;

  const GolfUpcomingCard({
    super.key,
    required this.tournamentName,
    required this.location,
    required this.startDate,
    required this.par,
    this.broadcastChannel,
    required this.tourType,
    this.purse,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1C1C26),
            const Color(0xFF16161C),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 2,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      tourType.toUpperCase(),
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      DateFormat('EEE, MMM d').format(startDate).toUpperCase(),
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Text(
                        DateFormat('h:mm a').format(startDate),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              tournamentName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const SFIcon(SFIcons.sf_mappin_and_ellipse, color: Colors.grey, fontSize: 14),
                const SizedBox(width: 4),
                Text(
                  location,
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _buildTechLabel('PAR', par),
                const SizedBox(width: 32),
                if (purse != null) ...[
                  _buildTechLabel('PURSE', purse!),
                  const SizedBox(width: 32),
                ],
                if (broadcastChannel != null) _buildTechLabel('TV', broadcastChannel!),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechLabel(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class GolfLiveCard extends StatelessWidget {
  final GolfGame game;
  final bool showFullLeaderboard;

  const GolfLiveCard({
    super.key,
    required this.game,
    this.showFullLeaderboard = false,
  });

  @override
  Widget build(BuildContext context) {
    final tournamentName = game.tournamentName ?? 'TBD Tournament';
    final currentRound = game.round ?? 'Round 1';
    final leaders = game.leaderboard ?? [];
    
    // Determine how many players to show
    final displayLeaders = showFullLeaderboard 
        ? (leaders.isNotEmpty ? leaders.sublist(1) : <GolfLeader>[])
        : (leaders.length > 1 ? leaders.sublist(1, leaders.length > 10 ? 10 : leaders.length) : <GolfLeader>[]);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1C1C26),
            const Color(0xFF16161C),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 2,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          tournamentName.toUpperCase(),
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      currentRound.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.circle, color: Colors.red, size: 8),
                      SizedBox(width: 6),
                      Text(
                        'LIVE',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildLeaderSection(context, leaders.isNotEmpty ? leaders[0] : null),
          
          // Header Row for the list - placed AFTER the leader
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                const SizedBox(width: 24), // Space for rank
                const Expanded(
                  child: Text(
                    'PLAYER',
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                _buildTableHeader('SCORE'),
                const SizedBox(width: 12),
                _buildTableHeader('ROUND'),
                const SizedBox(width: 12),
                _buildTableHeader('THRU'),
              ],
            ),
          ),

          ...displayLeaders.map((player) => _buildLiveRow(context, player)),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildTableHeader(String label) {
    return SizedBox(
      width: 40,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white38,
          fontSize: 8,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildLiveRow(BuildContext context, GolfLeader player) {
    final currentRound = game.round ?? 'R1';
    return InkWell(
      onTap: () => GoffPlayerDetailsSheet.show(
        context, 
        player,
        tournamentName: game.tournamentName,
        round: currentRound,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              child: Text(
                '${player.position}',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Hero(
                    tag: 'player_${player.name}',
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.white10,
                      backgroundImage: player.image.isNotEmpty ? NetworkImage(player.image) : null,
                      child: player.image.isEmpty ? const Icon(Icons.person, size: 10, color: Colors.white24) : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    SportMapper.getInitialName(player.name),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            // Score Column
            SizedBox(
              width: 40,
              child: ScoreFlipText(
                score: player.score,
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Round Column
            SizedBox(
              width: 40,
              child: Text(
                (player.currentRound ?? currentRound).length > 2 
                    ? (player.currentRound ?? currentRound).substring(0, 2) 
                    : (player.currentRound ?? currentRound),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Thru Column
            SizedBox(
              width: 40,
              child: Text(
                player.thru,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderSection(BuildContext context, GolfLeader? leader) {
    if (leader == null) return const SizedBox.shrink();
    final currentRound = game.round ?? 'R1';

    return InkWell(
      onTap: () => GoffPlayerDetailsSheet.show(
        context, 
        leader,
        tournamentName: game.tournamentName,
        round: currentRound,
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.03),
          border: Border.symmetric(
            horizontal: BorderSide(color: Colors.white.withValues(alpha: 0.05), width: 0.5),
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 110, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'LEADER',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    SportMapper.getInitialName(leader.name),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildStat('SCORE', leader.score, isHighlight: true),
                      const SizedBox(width: 24),
                      _buildStat('ROUND', (leader.currentRound ?? currentRound).length > 2 
                          ? (leader.currentRound ?? currentRound).substring(0, 2) 
                          : (leader.currentRound ?? currentRound)),
                      const SizedBox(width: 24),
                      _buildStat('THRU', leader.thru),
                    ],
                  ),
                ],
              ),
            ),
            if (leader.image.isNotEmpty)
              Positioned(
                right: 0,
                bottom: 0,
                child: Hero(
                  tag: 'player_${leader.name}',
                  child: SizedBox(
                    height: 120,
                    width: 140,
                    child: Image.network(
                      leader.image,
                      fit: BoxFit.contain,
                      alignment: Alignment.bottomCenter,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(
                            child: Icon(Icons.person, color: Colors.white24, size: 60),
                          ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value, {bool isHighlight = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 8,
            fontWeight: FontWeight.w900,
          ),
        ),
        if (label == 'SCORE')
          ScoreFlipText(
            score: value,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: isHighlight ? Colors.green : Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          )
        else
          Text(
            value,
            style: TextStyle(
              color: isHighlight ? Colors.green : Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
      ],
    );
  }
}

class GolfCompletedCard extends StatelessWidget {
  final String tournamentName;
  final String winnerName;
  final String winnerScore;
  final String? winnerImage;
  final String tourType;
  final String? winnerPurse;
  final String? p2Name;
  final String? p2Score;
  final String? p3Name;
  final String? p3Score;

  const GolfCompletedCard({
    super.key,
    required this.tournamentName,
    required this.winnerName,
    required this.winnerScore,
    this.winnerImage,
    required this.tourType,
    this.winnerPurse,
    this.p2Name,
    this.p2Score,
    this.p3Name,
    this.p3Score,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1C1C26),
            const Color(0xFF16161C),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 2,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      tournamentName.toUpperCase(),
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF34C759).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'FINAL',
                    style: TextStyle(
                      color: Color(0xFF34C759),
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildWinnerSection(context),
          if (p2Name != null) _buildRunnerUpRow(context, 2, p2Name!, p2Score!),
          if (p3Name != null) _buildRunnerUpRow(context, 3, p3Name!, p3Score!),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildWinnerSection(BuildContext context) {
    return InkWell(
      onTap: () {
        if (winnerImage != null) {
          GoffPlayerDetailsSheet.show(
            context,
            GolfLeader(
              position: 1,
              name: winnerName,
              team: tourType,
              score: winnerScore,
              thru: 'FINAL',
              image: winnerImage!,
              purse: winnerPurse,
            ),
            tournamentName: tournamentName,
          );
        }
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFFFD100).withValues(alpha: 0.03),
          border: Border.symmetric(
            horizontal: BorderSide(color: Colors.white.withValues(alpha: 0.05), width: 0.5),
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 110, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CHAMPION',
                    style: TextStyle(
                      color: Color(0xFFFFD100),
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    SportMapper.getInitialName(winnerName),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TOTAL SCORE',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 8,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            winnerScore,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      if (winnerPurse != null) ...[
                        const SizedBox(width: 32),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PURSE',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 8,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              winnerPurse!,
                              style: const TextStyle(
                                color: Color(0xFFFFD100),
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            if (winnerImage != null)
              Positioned(
                right: 0,
                bottom: 0,
                child: Hero(
                  tag: 'player_$winnerName',
                  child: SizedBox(
                    height: 130,
                    width: 150,
                    child: Image.network(
                      winnerImage!,
                      fit: BoxFit.contain,
                      alignment: Alignment.bottomCenter,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(
                            child: Icon(Icons.person, color: Colors.white24, size: 60),
                          ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRunnerUpRow(BuildContext context, int rank, String name, String score) {
    return InkWell(
      onTap: () {
        GoffPlayerDetailsSheet.show(
          context,
          GolfLeader(
            position: rank,
            name: name,
            team: tourType,
            score: score,
            thru: 'FINAL',
            image: '', // No image for runners up in completed card currently
          ),
          tournamentName: tournamentName,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              child: Text(
                '$rank',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Expanded(
              child: Text(
                SportMapper.getInitialName(name),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              score,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
