import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class F1UpcomingCard extends StatelessWidget {
  final String raceName;
  final String location;
  final DateTime raceDate;
  final String? circuitImage;
  final String? broadcastChannel;
  final int raceNumber;
  final int laps;
  final String circuitLayoutUrl;
  final String trackLength;

  const F1UpcomingCard({
    super.key,
    required this.raceName,
    required this.location,
    required this.raceDate,
    this.circuitImage,
    this.broadcastChannel,
    required this.raceNumber,
    required this.laps,
    required this.circuitLayoutUrl,
    required this.trackLength,
  });


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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF16161C),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2D7DFF).withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: const Color(0xFF2D7DFF).withValues(alpha: 0.15),
                          ),
                        ),
                        child: Text(
                          'ROUND $raceNumber',
                          style: const TextStyle(
                            color: Color(0xFF2D7DFF),
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            DateFormat('EEE, MMM d').format(raceDate).toUpperCase(),
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
                              color: const Color(0xFFFFFFFF).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: const Color(0xFFFFFFFF).withValues(alpha: 0.2),
                              ),
                            ),
                            child: Text(
                              DateFormat('h:mm a').format(raceDate),
                              style: const TextStyle(
                                color: Color(0xFFFFFFFF),
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              raceName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              location,
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                _buildTechLabel('LAPS', '$laps'),
                                const SizedBox(width: 24),
                                _buildTechLabel('LENGTH', trackLength.toUpperCase()),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 90,
                        width: 90,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white.withValues(alpha: 0.03),
                        ),
                        child: Image.asset(
                          circuitLayoutUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.map, color: Colors.white24, size: 32),
                        ),
                      ),
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
}

class F1CompletedCard extends StatelessWidget {
  final String raceName;
  final DateTime raceDate;
  final int raceNumber;
  final String winnerName;
  final String winnerTeam;
  final String winnerLogo;
  final String points;
  final String? winnerTotalPoints;
  final String? time;
  final String? p2Name;
  final String? p2Team;
  final String? p2Image;
  final String? p2Points;
  final String? p2TotalPoints;
  final String? p2Gap;
  final String? p3Name;
  final String? p3Team;
  final String? p3Image;
  final String? p3Points;
  final String? p3TotalPoints;
  final String? p3Gap;

  const F1CompletedCard({
    super.key,
    required this.raceName,
    required this.raceDate,
    required this.raceNumber,
    required this.winnerName,
    required this.winnerTeam,
    required this.winnerLogo,
    required this.points,
    this.winnerTotalPoints,
    this.time,
    this.p2Name,
    this.p2Team,
    this.p2Image,
    this.p2Points,
    this.p2TotalPoints,
    this.p2Gap,
    this.p3Name,
    this.p3Team,
    this.p3Image,
    this.p3Points,
    this.p3TotalPoints,
    this.p3Gap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF16161C),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ROUND $raceNumber',
                      style: TextStyle(
                        color: Color(0xFF2D7DFF),
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      raceName.toUpperCase(),
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'FINAL',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('MMM d, yyyy • h:mm a').format(raceDate),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _buildWinnerSection(winnerName, winnerTeam, winnerLogo, time ?? '1:41.223', points, winnerTotalPoints),
          if (p2Name != null)
            _buildDriverRow(2, p2Name!, p2Team!, p2Image!, p2Gap ?? '+0.222s', p2Points ?? '18', p2TotalPoints),
          if (p3Name != null)
            _buildDriverRow(3, p3Name!, p3Team!, p3Image!, p3Gap ?? '+0.254s', p3Points ?? '15', p3TotalPoints),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildWinnerSection(String name, String team, String imageUrl, String time, String points, String? totalPoints) {
    return Container(
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
                  'WINNER',
                  style: TextStyle(
                    color: Color(0xFFFFD100),
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                ),
                Text(
                  team.toUpperCase(),
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildWinnerStat('TIME', time),
                    const SizedBox(width: 20),
                    _buildWinnerStat('PTS', '+$points'),
                    if (totalPoints != null) ...[
                      const SizedBox(width: 20),
                      _buildWinnerStat('TOTAL', totalPoints),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: SizedBox(
              height: 130,
              width: 150,
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                alignment: Alignment.bottomCenter,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.person, color: Colors.white24, size: 60),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWinnerStat(String label, String value) {
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
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _buildDriverRow(int rank, String name, String team, String imageUrl, String timeOrGap, String pointsPerRace, String? totalPoints) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 18,
            child: Text(
              '$rank',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 13,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.05),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  team.toUpperCase(),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (totalPoints != null) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'TOTAL',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 7,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  totalPoints,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
          ],
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                timeOrGap,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '+$pointsPerRace pts',
                style: const TextStyle(
                  color: Color(0xFF00FF00),
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

