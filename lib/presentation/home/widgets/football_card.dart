import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../data/models/game.dart';
import '../../../data/models/sports/football_game.dart';

class FootballCard extends StatelessWidget {
  final Game game;

  const FootballCard({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final footGame = game is FootballGame ? (game as FootballGame) : null;
    
    // Determine winner for Results view
    bool homeIsWinner = false;
    bool awayIsWinner = false;
    String homeScoreValue = '0';
    String awayScoreValue = '0';

    if (footGame?.score != null) {
      final scores = footGame!.score!.split('-');
      if (scores.length >= 2) {
        homeScoreValue = scores[0];
        awayScoreValue = scores[1];
        
        if (game.status == 'Final') {
          final hScore = int.tryParse(homeScoreValue) ?? 0;
          final aScore = int.tryParse(awayScoreValue) ?? 0;
          homeIsWinner = hScore > aScore;
          awayIsWinner = aScore > hScore;
        }
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1C1C26),
            Color(0xFF16161C),
          ],
        ),
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
            onTap: () {},
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          if (game.leagueType != null) ...[
                            Container(
                              width: 2,
                              height: 12,
                              decoration: BoxDecoration(
                                color: const Color(0xFF3A66A7), // Premier League blue-ish color
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              game.leagueType!.toUpperCase(),
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ],
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
                      else if (game.status == 'Final')
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF34C759).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'FINAL',
                            style: TextStyle(
                              color: Color(0xFF34C759),
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
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

                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildTeamLogo(footGame?.homeTeamLogo, homeIsWinner),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            footGame?.homeTeamAbbr ?? '',
                            style: GoogleFonts.instrumentSans(
                              color: game.status == 'Final' 
                                ? (homeIsWinner ? Colors.white : Colors.grey.shade600)
                                : Colors.white,
                              fontSize: 16,
                              fontWeight: game.status == 'Final' && homeIsWinner 
                                ? FontWeight.w900 
                                : FontWeight.w700,
                            ),
                          ),
                          Text(
                            homeScoreValue,
                            style: TextStyle(
                              color: game.status == 'Final' 
                                ? (homeIsWinner ? Colors.white : Colors.grey.shade700)
                                : Colors.white,
                              fontSize: 36,
                              fontWeight: game.status == 'Final' && homeIsWinner 
                                ? FontWeight.w600 
                                : FontWeight.w400,
                              fontFeatures: const [FontFeature.tabularFigures()],
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),
                      
                      _buildMatchCenter(game),

                      const Spacer(),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            footGame?.awayTeamAbbr ?? '',
                            style: GoogleFonts.instrumentSans(
                              color: game.status == 'Final' 
                                ? (awayIsWinner ? Colors.white : Colors.grey.shade600)
                                : Colors.white,
                              fontSize: 16,
                              fontWeight: game.status == 'Final' && awayIsWinner 
                                ? FontWeight.w900 
                                : FontWeight.w700,
                            ),
                          ),
                          Text(
                            awayScoreValue,
                            style: TextStyle(
                              color: game.status == 'Final' 
                                ? (awayIsWinner ? Colors.white : Colors.grey.shade700)
                                : Colors.white,
                              fontSize: 36,
                              fontWeight: game.status == 'Final' && awayIsWinner 
                                ? FontWeight.w600 
                                : FontWeight.w400,
                              fontFeatures: const [FontFeature.tabularFigures()],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      _buildTeamLogo(footGame?.awayTeamLogo, awayIsWinner),
                    ],
                  ),
                  const SizedBox(height: 20),
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

  Widget _buildTeamLogo(String? logoUrl, bool isWinner) {
    return Container(
      height: 54,
      width: 54,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        shape: BoxShape.circle,
        border: isWinner ? Border.all(color: const Color(0xFFFF6A1A).withValues(alpha: 0.3), width: 1.5) : null,
      ),
      child: logoUrl != null
          ? ClipOval(
              child: logoUrl.endsWith('.svg')
                  ? SvgPicture.network(
                      logoUrl,
                      placeholderBuilder: (context) => const SizedBox.shrink(),
                    )
                  : Image.network(
                      logoUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => 
                          const SFIcon(SFIcons.sf_sportscourt, color: Colors.white24, fontSize: 30),
                    ),
            )
          : const SFIcon(SFIcons.sf_sportscourt, color: Colors.white24, fontSize: 30),
    );
  }

  Widget _buildMatchCenter(Game game) {
    String centerText = 'VS';
    Color textColor = Colors.white;

    if (game.isLive) {
      centerText = "64'"; // Football match minute
    } else if (game.status == 'Final') {
      textColor = Colors.grey.shade500;
    } else {
      textColor = Colors.grey.shade500;
    }

    return Text(
      centerText,
      style: GoogleFonts.instrumentSans(
        color: textColor,
        fontSize: 18,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
