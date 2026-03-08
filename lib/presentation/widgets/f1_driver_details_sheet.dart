import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import '../../data/models/sports/f1_game.dart';

class F1DriverDetailsSheet extends StatelessWidget {
  final String name;
  final String team;
  final String image;
  final String position;
  final String? points;
  final String? gap;
  final String? totalPoints;
  final String? sessionType;
  final int? wins;
  final int? podiums;
  final int? totalRaces;

  const F1DriverDetailsSheet({
    super.key,
    required this.name,
    required this.team,
    required this.image,
    required this.position,
    this.points,
    this.gap,
    this.totalPoints,
    this.sessionType,
    this.wins,
    this.podiums,
    this.totalRaces,
  });

  static void show(
    BuildContext context, {
    required String name,
    required String team,
    required String image,
    required String position,
    String? points,
    String? gap,
    String? totalPoints,
    String? sessionType,
    int? wins,
    int? podiums,
    int? totalRaces,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => F1DriverDetailsSheet(
        name: name,
        team: team,
        image: image,
        position: position,
        points: points,
        gap: gap,
        totalPoints: totalPoints,
        sessionType: sessionType,
        wins: wins,
        podiums: podiums,
        totalRaces: totalRaces,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isQualifying = sessionType?.toLowerCase() == 'qualifying';
    final Color accentColor = isQualifying ? const Color(0xFF00D2FF) : const Color(0xFFE10600);

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
                // Large Driver Image
                Hero(
                  tag: 'driver_$name',
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Colors.white.withOpacity(0.05),
                      image: image.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(image),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: image.isEmpty
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
                          color: accentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'P$position',
                          style: TextStyle(
                            color: accentColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        team.toUpperCase(),
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
                    _buildStatItem(isQualifying ? 'BEST LAP' : 'POINTS', points ?? '-', color: accentColor),
                    _buildStatItem('GAP', gap ?? 'Laps', color: Colors.grey.shade400),
                    if (totalPoints != null)
                      _buildStatItem('SEASON PTS', totalPoints!),
                  ],
                ),
                if (wins != null || podiums != null || totalRaces != null) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Divider(color: Colors.white10, height: 1),
                  ),
                  Row(
                    children: [
                      if (wins != null)
                        _buildStatItem('WINS', wins.toString(), color: const Color(0xFFFFD700)),
                      if (podiums != null)
                        _buildStatItem('PODIUMS', podiums.toString()),
                      if (totalRaces != null)
                        _buildStatItem('RACES', totalRaces.toString()),
                    ],
                  ),
                ],
              ],
            ),
          ),
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
