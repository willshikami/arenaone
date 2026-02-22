import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import '../../../data/models/sports/tennis_game.dart';

class TennisUpcomingCard extends StatelessWidget {
  final TennisGame game;

  const TennisUpcomingCard({super.key, required this.game});

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
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
                  ),
                  child: Text(
                    (game.tournamentName ?? 'ATP TOUR').toUpperCase(),
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                Text(
                  DateFormat('EEE, MMM d • HH:mm').format(game.startTime).toUpperCase(),
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _buildPlayerPortrait(game.player1Name, game.player1Image, game.player1Country)),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('VS', style: TextStyle(color: Colors.white24, fontWeight: FontWeight.w900, fontSize: 16)),
                ),
                Expanded(child: _buildPlayerPortrait(game.player2Name, game.player2Image, game.player2Country)),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTechLabel('ROUND', game.round ?? 'TBD'),
                _buildTechLabel('SURFACE', game.surface ?? 'Hard'),
                _buildTechLabel('COURT', game.stadium ?? 'Main Court'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerPortrait(String name, String? image, String? country) {
    return Column(
      children: [
        CircleAvatar(
          radius: 32,
          backgroundColor: Colors.white.withValues(alpha: 0.04),
          backgroundImage: image != null ? NetworkImage(image) : null,
          child: image == null ? const Icon(Icons.person, color: Colors.white24, size: 30) : null,
        ),
        const SizedBox(height: 12),
        Text(
          name,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w900),
        ),
        if (country != null)
          Text(
            country.toUpperCase(),
            style: TextStyle(color: Colors.grey.shade600, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 0.5),
          ),
      ],
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
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class TennisLiveCard extends StatelessWidget {
  final TennisGame game;

  const TennisLiveCard({super.key, required this.game});

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
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${game.tournamentName} • ${game.round}'.toUpperCase(),
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1),
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
          _buildScoreRow(game.player1Name, game.player1Country, game.player1SetScores, game.player1CurrentPoints, game.player1HasService ?? false),
          const Divider(height: 1, color: Colors.white12),
          _buildScoreRow(game.player2Name, game.player2Country, game.player2SetScores, game.player2CurrentPoints, !(game.player1HasService ?? false)),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildScoreRow(String name, String? country, List<String>? sets, String? points, bool hasService) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Container(width: 4, height: 4, decoration: BoxDecoration(color: hasService ? Colors.yellow : Colors.transparent, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900)),
                if (country != null) Text(country.toUpperCase(), style: TextStyle(color: Colors.grey.shade600, fontSize: 9, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          if (sets != null)
            Row(
              children: sets.map((s) => Container(
                width: 30,
                alignment: Alignment.center,
                child: Text(s, style: TextStyle(color: Colors.grey.shade400, fontSize: 16, fontWeight: FontWeight.w700)),
              )).toList(),
            ),
          const SizedBox(width: 12),
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(8)),
            child: Text(points ?? '0', style: const TextStyle(color: Colors.yellow, fontSize: 18, fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }
}

class TennisCompletedCard extends StatelessWidget {
  final TennisGame game;

  const TennisCompletedCard({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final bool p1Won = _didPlayerWin(game.player1SetScores, game.player2SetScores);
    
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
                  '${game.tournamentName} • FINAL'.toUpperCase(),
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1),
                ),
                const Icon(SFIcons.sf_checkmark_circle_fill, color: Colors.green, size: 16),
              ],
            ),
          ),
          _buildResultRow(game.player1Name, game.player1Image, game.player1Country, game.player1SetScores, p1Won),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(height: 1, color: Colors.white12),
          ),
          _buildResultRow(game.player2Name, game.player2Image, game.player2Country, game.player2SetScores, !p1Won),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  bool _didPlayerWin(List<String>? s1, List<String>? s2) {
    if (s1 == null || s2 == null) return false;
    int sets1 = 0;
    int sets2 = 0;
    for (int i = 0; i < s1.length; i++) {
      if (int.parse(s1[i]) > int.parse(s2[i])) sets1++;
      else sets2++;
    }
    return sets1 > sets2;
  }

  Widget _buildResultRow(String name, String? image, String? country, List<String>? sets, bool isWinner) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white10,
            backgroundImage: image != null ? NetworkImage(image) : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(name, style: TextStyle(color: isWinner ? Colors.white : Colors.grey.shade500, fontSize: 15, fontWeight: isWinner ? FontWeight.w900 : FontWeight.w600)),
                    if (isWinner) ...[
                      const SizedBox(width: 6),
                      const SFIcon(SFIcons.sf_trophy_fill, color: Color(0xFFFFD100), fontSize: 12),
                    ],
                  ],
                ),
                if (country != null) Text(country.toUpperCase(), style: TextStyle(color: Colors.grey.shade600, fontSize: 9, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
          if (sets != null)
            Row(
              children: sets.map((s) => Container(
                width: 25,
                alignment: Alignment.center,
                child: Text(s, style: TextStyle(color: isWinner ? Colors.white : Colors.grey.shade600, fontSize: 15, fontWeight: isWinner ? FontWeight.w900 : FontWeight.w600)),
              )).toList(),
            ),
        ],
      ),
    );
  }
}
