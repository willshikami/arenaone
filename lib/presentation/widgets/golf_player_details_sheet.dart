import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:arenaone/data/models/sports/golf_game.dart';

class GoffPlayerDetailsSheet extends StatelessWidget {
  final GolfLeader player;
  final String? tournamentName;
  final String? round;

  const GoffPlayerDetailsSheet({
    super.key,
    required this.player,
    this.tournamentName,
    this.round,
  });

  static void show(BuildContext context, GolfLeader player, {String? tournamentName, String? round}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => GoffPlayerDetailsSheet(
        player: player,
        tournamentName: tournamentName,
        round: round,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF16161C),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Large Player Image
                Hero(
                  tag: 'player_${player.name}',
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Colors.white.withOpacity(0.05),
                      image: player.image.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(player.image),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: player.image.isEmpty
                        ? const Icon(Icons.person, size: 60, color: Colors.white24)
                        : null,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'POS ${player.position}',
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        player.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        player.team.toUpperCase(),
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Stats Grid
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildStatItem('SCORE', player.score, color: Colors.green),
                    _buildStatItem('THRU', player.thru),
                    _buildStatItem('ROUND', player.currentRound ?? round ?? '-'),
                  ],
                ),
                if (player.totalPoints != null || player.careerPoints != null || player.totalWins != null || player.championships != null) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Divider(color: Colors.white10, height: 1),
                  ),
                  Row(
                    children: [
                      if (player.totalWins != null)
                        _buildStatItem('TOTAL WINS', player.totalWins!.toString(), color: const Color(0xFFFFD700)),
                      if (player.championships != null)
                        _buildStatItem('MAJORS', player.championships!.toString(), color: Colors.green),
                      if (player.purse != null)
                        _buildStatItem('EARNINGS', player.purse!),
                    ],
                  ),
                  if (player.totalPoints != null || player.careerPoints != null) ...[
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        if (player.totalPoints != null)
                          _buildStatItem('TOTAL POINTS', player.totalPoints!),
                        if (player.careerPoints != null)
                          _buildStatItem('CAREER POINTS', player.careerPoints!),
                      ],
                    ),
                  ],
                ],
              ],
            ),
          ),
          if (tournamentName != null) ...[
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  const SFIcon(SFIcons.sf_trophy_fill, color: Colors.green, fontSize: 16),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      tournamentName!,
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, {Color? color}) {
    return Expanded(
      child: Column(
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
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color ?? Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
