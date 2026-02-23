import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_sficon/flutter_sficon.dart';

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
        color: const Color(0xFF16161C),
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
                  ),
                  child: Text(
                    tourType.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
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
  final String tournamentName;
  final String leaderName;
  final String leaderScore;
  final String thru;
  final String currentRound;
  final String? leaderImage;
  final String tourType;
  final String? purse;
  final String? p2Name;
  final String? p2Score;
  final String? p2Thru;
  final String? p3Name;
  final String? p3Score;
  final String? p3Thru;

  const GolfLiveCard({
    super.key,
    required this.tournamentName,
    required this.leaderName,
    required this.leaderScore,
    required this.thru,
    required this.currentRound,
    this.leaderImage,
    required this.tourType,
    this.purse,
    this.p2Name,
    this.p2Score,
    this.p2Thru,
    this.p3Name,
    this.p3Score,
    this.p3Thru,
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
                      tournamentName.toUpperCase(),
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
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
          _buildLeaderSection(),
          if (p2Name != null) _buildLiveRow(2, p2Name!, p2Score!, p2Thru!),
          if (p3Name != null) _buildLiveRow(3, p3Name!, p3Score!, p3Thru!),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildLiveRow(int rank, String name, String score, String thru) {
    return Container(
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
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                score,
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                thru,
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
    );
  }

  Widget _buildLeaderSection() {
    return Container(
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
                  leaderName,
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
                    _buildStat('SCORE', leaderScore, isHighlight: true),
                    const SizedBox(width: 24),
                    _buildStat('THRU', thru),
                    if (purse != null) ...[
                      const SizedBox(width: 24),
                      _buildStat('PURSE', purse!),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (leaderImage != null)
            Positioned(
              right: 0,
              bottom: 0,
              child: SizedBox(
                height: 120,
                width: 140,
                child: Image.network(
                  leaderImage!,
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
        color: const Color(0xFF16161C),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tournamentName.toUpperCase(),
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
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
              ],
            ),
          ),
          _buildWinnerSection(),
          if (p2Name != null) _buildRunnerUpRow(2, p2Name!, p2Score!),
          if (p3Name != null) _buildRunnerUpRow(3, p3Name!, p3Score!),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildWinnerSection() {
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
                  winnerName,
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
              child: SizedBox(
                height: 130,
                width: 150,
                child: Image.network(
                  winnerImage!,
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

  Widget _buildRunnerUpRow(int rank, String name, String score) {
    return Container(
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
              name,
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
    );
  }
}
