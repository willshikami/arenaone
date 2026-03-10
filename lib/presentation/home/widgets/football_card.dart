import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:arenaone/data/models/game.dart';
import 'package:arenaone/data/models/sports/football_game.dart';
import 'package:arenaone/data/services/mappers/sport_mapper.dart';
import 'package:arenaone/presentation/widgets/live_clock_text.dart';

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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Home Logo & Name & Score
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    SportMapper.getShortName(footGame?.homeTeamName),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.instrumentSans(
                                      color: game.status == 'Final'
                                          ? (homeIsWinner ? Colors.white : Colors.grey.shade600)
                                          : Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  _buildTeamLogo(footGame?.homeTeamLogo, homeIsWinner),
                                ],
                              ),
                              const SizedBox(width: 16),
                              Padding(
                                padding: const EdgeInsets.only(top: 22),
                                child: Text(
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
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // Match Info Center
                      Padding(
                        padding: const EdgeInsets.only(top: 22, left: 12, right: 12),
                        child: _buildMatchCenter(game),
                      ),

                      // Away Logo & Name & Score
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 22),
                                child: Text(
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
                              ),
                              const SizedBox(width: 16),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    SportMapper.getShortName(footGame?.awayTeamName),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.instrumentSans(
                                      color: game.status == 'Final'
                                          ? (awayIsWinner ? Colors.white : Colors.grey.shade600)
                                          : Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  _buildTeamLogo(footGame?.awayTeamLogo, awayIsWinner),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
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
                      Text(
                        (game.stadium ?? 'VENUE TBD').toUpperCase(),
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      if (game.isLive)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: game.statusType?.toUpperCase() == 'HALFTIME'
                                ? const Color(0xFFFF6A1A).withValues(alpha: 0.1)
                                : Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: game.statusType?.toUpperCase() == 'HALFTIME'
                                    ? const Color(0xFFFF6A1A).withValues(alpha: 0.2)
                                    : Colors.white.withValues(alpha: 0.2)),
                          ),
                          child: Text(
                            _getLiveStatusText(game).toUpperCase(),
                            style: TextStyle(
                              color: game.statusType?.toUpperCase() == 'HALFTIME'
                                  ? const Color(0xFFFF6A1A)
                                  : Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
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
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                        )
                      else
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              DateFormat('EEE, MMM d').format(game.startTime.toLocal()).toUpperCase(),
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
                                DateFormat('h:mm a').format(game.startTime.toLocal()),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTeamLogo(String? logoUrl, bool isWinner) {
    return Container(
      height: 50,
      width: 50,
      padding: const EdgeInsets.all(4),
      child: logoUrl != null
          ? (logoUrl.endsWith('.svg')
              ? SvgPicture.network(
                  logoUrl,
                  fit: BoxFit.contain,
                  placeholderBuilder: (context) => const Center(child: SizedBox.shrink()),
                )
              : Image.network(
                  logoUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => 
                      const Center(
                        child: SFIcon(SFIcons.sf_sportscourt, color: Colors.white24, fontSize: 30),
                      ),
                ))
          : const Center(
              child: SFIcon(SFIcons.sf_sportscourt, color: Colors.white24, fontSize: 30),
            ),
    );
  }

  Widget _buildMatchCenter(Game game) {
    if (game.isLive) {
      final isHalftime = game.statusType == 'STATUS_HALFTIME' ||
          game.status.toUpperCase().contains('HALFTIME') ||
          game.status.toUpperCase().contains('HALF TIME');

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isHalftime)
            Text(
              'HALFTIME',
              style: GoogleFonts.instrumentSans(
                color: const Color(0xFFFF6600),
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: 1,
              ),
            )
          else ...[
            LiveClockText(
              initialClock: game.clock,
              isLive: game.isLive,
              isCountdown: false, // Football clocks count UP
              style: GoogleFonts.instrumentSans(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'LIVE',
              style: TextStyle(
                color: Colors.red,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
          ],
        ],
      );
    }

    Color textColor = game.status == 'Final' ? Colors.grey.shade500 : Colors.white;

    return Text(
      'VS',
      style: GoogleFonts.instrumentSans(
        color: textColor,
        fontSize: 18,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  String _getLiveStatusText(Game game) {
    // Check for Halftime status
    if (game.statusType?.toUpperCase() == 'HALFTIME') return 'Half Time';
    
    // Check period
    if (game.period == 1) return 'First Half';
    if (game.period == 2) return 'Second Half';
    
    // Fallback to basic capitalization for anything else
    if (game.statusType != null && game.statusType!.isNotEmpty) {
      return game.statusType![0].toUpperCase() + game.statusType!.substring(1).toLowerCase();
    }
    
    return 'Live';
  }
}
