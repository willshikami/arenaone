import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../data/models/game.dart';
import '../../../data/models/sports/basketball_game.dart';
import '../../../data/models/sports/football_game.dart';
import '../../../data/models/sports/golf_game.dart';
import '../../../data/services/mappers/sport_mapper.dart';
import '../../widgets/score_flip_text.dart';

class GameCard extends StatelessWidget {
  final Game game;

  const GameCard({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    // Determine winner and scores based on sport type
    bool homeIsWinner = false;
    bool awayIsWinner = false;
    String homeScoreValue = '0';
    String awayScoreValue = '0';
    String? homeTeamName;
    String? awayTeamName;
    String? homeLogo;
    String? awayLogo;

    if (game is BasketballGame) {
      final baskGame = game as BasketballGame;
      homeTeamName = baskGame.homeTeamName;
      awayTeamName = baskGame.awayTeamName;
      homeLogo = baskGame.homeTeamLogo;
      awayLogo = baskGame.awayTeamLogo;
      
      final scores = (baskGame.score ?? '0-0').split('-');
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
    } else if (game is FootballGame) {
      final footGame = game as FootballGame;
      homeTeamName = footGame.homeTeamName;
      awayTeamName = footGame.awayTeamName;
      homeLogo = footGame.homeTeamLogo;
      awayLogo = footGame.awayTeamLogo;
      
      final scores = (footGame.score ?? '0-0').split('-');
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
    } else if (game is GolfGame) {
      final golfGame = game as GolfGame;
      return _buildGolfCard(context, golfGame);
    }

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
                          Container(
                            width: 2,
                            height: 12,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF6A1A),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${game.sport} ${game.leagueType ?? ''}'.toUpperCase().trim(),
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1,
                            ),
                          ),
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

                  const SizedBox(height: 16),
                  Row(
                    children: [
                      // Home Logo
                      _buildTeamLogo(homeLogo, homeIsWinner, game.sport),
                      const SizedBox(width: 16),
                      // Home Stats
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            SportMapper.getShortName(homeTeamName),
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
                          ScoreFlipText(
                            score: homeScoreValue,
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
                      
                      // Match Info Center
                      _buildMatchCenter(game),

                      const Spacer(),

                      // Away Stats
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            SportMapper.getShortName(awayTeamName),
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
                          ScoreFlipText(
                            score: awayScoreValue,
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
                      // Away Logo
                      _buildTeamLogo(awayLogo, awayIsWinner, game.sport),
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

  Widget _buildGolfCard(BuildContext context, GolfGame golf) {
    // Basic implementation for Golf, can be expanded
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1C1C26), Color(0xFF16161C)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  golf.tournamentName?.toUpperCase() ?? 'GOLF',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1),
                ),
                if (golf.isLive)
                  const Row(
                    children: [
                      Icon(Icons.circle, color: Colors.red, size: 8),
                      SizedBox(width: 6),
                      Text('LIVE', style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.w900)),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (golf.leaderboard != null && golf.leaderboard!.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(golf.leaderboard![0].name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                      Text('POSITION ${golf.leaderboard![0].position}', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                    ],
                  ),
                  ScoreFlipText(
                    score: golf.leaderboard![0].score,
                    style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
          ],
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

  Widget _buildTeamLogo(String? logoUrl, bool isWinner, String sport) {
    IconData defaultIcon = sport == 'Football' ? SFIcons.sf_sportscourt : SFIcons.sf_basketball;
    
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
                      placeholderBuilder: (context) => const Center(child: SizedBox.shrink()),
                    )
                  : Image.network(
                      logoUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => 
                          Center(
                            child: SFIcon(defaultIcon, color: Colors.white24, fontSize: 30),
                          ),
                    ),
            )
          : Center(
              child: SFIcon(defaultIcon, color: Colors.white24, fontSize: 30),
            ),
    );
  }

  Widget _buildMatchCenter(Game game) {
    String centerText = 'VS';
    Color textColor = Colors.white;

    if (game.isLive) {
      centerText = 'LIVE'; // Use generic LIVE instead of hardcoded clock
    } else if (game.status == 'Final') {
      centerText = 'VS';
      textColor = Colors.grey.shade500;
    } else {
      centerText = 'VS';
      textColor = Colors.grey.shade500;
    }

    return Text(
      centerText,
      style: GoogleFonts.instrumentSans(
        color: textColor,
        fontSize: 20,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

