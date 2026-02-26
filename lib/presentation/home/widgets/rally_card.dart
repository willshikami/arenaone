import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import '../../../data/models/sports/rally_game.dart';

class RallyUpcomingCard extends StatelessWidget {
  final RallyGame game;

  const RallyUpcomingCard({super.key, required this.game});

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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          children: [
            if (game.eventImageUrl != null)
              Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(game.eventImageUrl!),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        const Color(0xFF16161C).withValues(alpha: 0.4),
                        const Color(0xFF16161C).withValues(alpha: 0.9),
                      ],
                    ),
                  ),
                ),
              ),
            Padding(
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
                              color: const Color(0xFFFFD100),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            (game.leagueType ?? 'WRC').toUpperCase(),
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
                            DateFormat('EEE, MMM d').format(game.startTime).toUpperCase(),
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
                              DateFormat('h:mm a').format(game.startTime),
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
                  const SizedBox(height: 20),
                  Text(
                    game.eventName ?? 'TBD Rally',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(SFIcons.sf_mappin_and_ellipse, color: Colors.grey, size: 12),
                      const SizedBox(width: 6),
                      Text(
                        game.location ?? 'TBD',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTechLabel('SURFACE', game.surface?.toUpperCase() ?? 'GRAVEL'),
                      _buildTechLabel('STAGES', '${game.totalStages ?? 0} STAGES'),
                      _buildTechLabel('DISTANCE', game.totalDistance ?? '--- KM'),
                    ],
                  ),
                ],
              ),
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
          style: TextStyle(color: Colors.grey.shade600, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 0.5),
        ),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class RallyLiveCard extends StatelessWidget {
  final RallyGame game;

  const RallyLiveCard({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final leader = game.leaderboard?.first;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF16161C),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${game.leagueType} • ${game.eventName}'.toUpperCase(),
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      game.currentStage?.toUpperCase() ?? 'LIVE',
                      style: const TextStyle(color: Color(0xFFFFD100), fontSize: 12, fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                  child: const Row(
                    children: [
                      Icon(Icons.circle, color: Colors.red, size: 8),
                      SizedBox(width: 6),
                      Text('LIVE', style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.w900)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (leader != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: leader.image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                leader.image!, 
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const Center(
                                  child: Icon(Icons.person, color: Colors.white24, size: 24),
                                ),
                              ),
                            )
                          : const Center(
                              child: Text('1',
                                  style: TextStyle(
                                      color: Color(0xFFFFD100),
                                      fontWeight: FontWeight.w900,
                                      fontSize: 18)),
                            ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(leader.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
                          Text(leader.team.toUpperCase(), style: TextStyle(color: Colors.grey.shade600, fontSize: 10, fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                    Text(leader.time ?? '--:--:--', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 12),
          if (game.leaderboard != null && game.leaderboard!.length > 1)
            ...game.leaderboard!.skip(1).take(2).map((l) => _buildMiniLeaderRow(l)),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildMiniLeaderRow(RallyLeader leader) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 16,
            child: Text('${leader.position}',
                style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w900,
                    fontSize: 12)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(leader.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14)),
                Text(leader.team.toUpperCase(),
                    style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(leader.time ?? leader.gap ?? '',
                  style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w700,
                      fontSize: 13)),
              if (leader.car != null)
                Text(leader.car!,
                    style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 9,
                        fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}

class RallyCompletedCard extends StatelessWidget {
  final RallyGame game;

  const RallyCompletedCard({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final winner = game.leaderboard?.isNotEmpty == true ? game.leaderboard!.first : null;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
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
                            color: const Color(0xFFFFD100),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          game.leagueType?.toUpperCase() ?? 'WRC',
                          style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      game.eventName?.toUpperCase() ?? 'FINAL',
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
          if (winner != null)
            _buildWinnerHero(winner, game.totalDistance ?? '--- KM'),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(height: 1, color: Colors.white12),
          ),
          if (game.leaderboard != null && game.leaderboard!.length > 1)
             ...game.leaderboard!.skip(1).take(2).map((l) => _buildResultRow(l)),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildWinnerHero(RallyLeader winner, String distance) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: winner.image != null 
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(16), 
                  child: Image.network(
                    winner.image!, 
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(SFIcons.sf_person_fill, color: Colors.white24, size: 30),
                    ),
                  ),
                )
              : const Center(
                  child: Icon(SFIcons.sf_person_fill, color: Colors.white24, size: 30),
                ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(winner.name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
                    const SizedBox(width: 8),
                    const SFIcon(SFIcons.sf_trophy_fill, color: Color(0xFFFFD100), fontSize: 14),
                  ],
                ),
                Text(winner.team.toUpperCase(), style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(winner.time ?? '', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900)),
              Text(distance, style: TextStyle(color: Colors.grey.shade600, fontSize: 10, fontWeight: FontWeight.w800)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow(RallyLeader leader) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text('${leader.position}', style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w900, fontSize: 13)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(leader.name, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
                Text(leader.team.toUpperCase(), style: TextStyle(color: Colors.grey.shade600, fontSize: 9, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          Text(leader.gap ?? '', style: TextStyle(color: Colors.grey.shade400, fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
