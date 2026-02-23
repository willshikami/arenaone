import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:intl/intl.dart';
import '../../../data/models/game.dart';
import '../../../data/models/sports/basketball_game.dart';

class GameCard extends StatelessWidget {
  final Game game;

  const GameCard({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    // If it's a basketball game, we use its fields. 
    // Otherwise we provide defaults to avoid crashes if used generically.
    final baskGame = game is BasketballGame ? (game as BasketballGame) : null;
    
    // Determine winner for Results view
    bool homeIsWinner = false;
    bool awayIsWinner = false;
    if (game.status == 'Final' && baskGame?.score != null) {
      final scores = baskGame!.score!.split('-');
      if (scores.length == 2) {
        final homeScore = int.tryParse(scores[0]) ?? 0;
        final awayScore = int.tryParse(scores[1]) ?? 0;
        homeIsWinner = homeScore > awayScore;
        awayIsWinner = awayScore > homeScore;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF16161C),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
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
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6A1A).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFFF6A1A).withValues(alpha: 0.2)),
                        ),
                        child: Text(
                          (game.leagueType ?? 'NBA').toUpperCase(),
                          style: const TextStyle(
                            color: Color(0xFFFF6A1A),
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      if (game.isLive)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
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
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
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
                  Row(
                    children: [
                      Expanded(child: TeamSection(
                        name: baskGame?.homeTeamName ?? '',
                        abbr: baskGame?.homeTeamAbbr ?? '',
                        logoUrl: baskGame?.homeTeamLogo,
                        isHome: true,
                        isWinner: homeIsWinner,
                      )),
                      MatchInfo(game: game),
                      Expanded(child: TeamSection(
                        name: baskGame?.awayTeamName ?? '',
                        abbr: baskGame?.awayTeamAbbr ?? '',
                        logoUrl: baskGame?.awayTeamLogo,
                        isHome: false,
                        isWinner: awayIsWinner,
                      )),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: Colors.white.withValues(alpha: 0.06),
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

class TeamSection extends StatelessWidget {
  final String name;
  final String abbr;
  final String? logoUrl;
  final bool isHome;
  final bool isWinner;

  const TeamSection({
    super.key,
    required this.name,
    required this.abbr,
    this.logoUrl,
    required this.isHome,
    this.isWinner = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              height: 44,
              width: 44,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.04),
                shape: BoxShape.circle,
                border: isWinner ? Border.all(color: const Color(0xFFFF6A1A).withValues(alpha: 0.3), width: 1.5) : null,
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
            if (isWinner)
              Transform.translate(
                offset: const Offset(4, -4),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF6A1A),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 10, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          abbr.isNotEmpty ? abbr : name,
          style: TextStyle(
            fontSize: 18, 
            fontWeight: FontWeight.w900, 
            color: isWinner ? Colors.white : Colors.white.withValues(alpha: 0.6),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(
          isHome ? 'HOME' : 'AWAY',
          style: TextStyle(
            fontSize: 8, 
            color: isWinner ? Colors.grey.shade400 : Colors.grey.shade600, 
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}

class MatchInfo extends StatelessWidget {
  final Game game;

  const MatchInfo({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    // If it's a basketball game, we use its score.
    String? score;
    if (game is BasketballGame) {
      score = (game as BasketballGame).score;
    }

    if (game.status == 'Final' || game.isLive) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              score ?? '0-0',
              style: const TextStyle(
                fontSize: 28, 
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: -1.5,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
            if (!game.isLive) ...[
              const SizedBox(height: 2),
              Text(
                'FINAL',
                style: TextStyle(
                  fontSize: 9, 
                  color: Colors.grey.shade600, 
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
            ],
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
              color: Colors.white.withValues(alpha: 0.04),
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
        ],
      ),
    );
  }
}
