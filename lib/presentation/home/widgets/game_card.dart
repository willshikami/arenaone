import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:intl/intl.dart';
import '../../../data/models/game.dart';

class GameCard extends StatelessWidget {
  final Game game;

  const GameCard({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
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
                  Center(
                    child: Text(
                      (game.leagueType ?? 'Regular Season').toUpperCase(),
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: TeamSection(
                        name: game.homeTeamName,
                        abbr: game.homeTeamAbbr,
                        logoUrl: game.homeTeamLogo,
                        isHome: true,
                      )),
                      MatchInfo(game: game),
                      Expanded(child: TeamSection(
                        name: game.awayTeamName,
                        abbr: game.awayTeamAbbr,
                        logoUrl: game.awayTeamLogo,
                        isHome: false,
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

  const TeamSection({
    super.key,
    required this.name,
    required this.abbr,
    this.logoUrl,
    required this.isHome,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 44,
          width: 44,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.04),
            shape: BoxShape.circle,
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
        const SizedBox(height: 8),
        Text(
          abbr.isNotEmpty ? abbr : name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(
          isHome ? 'HOME' : 'AWAY',
          style: TextStyle(
            fontSize: 8, 
            color: Colors.grey.shade500, 
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
    if (game.status == 'Final' || game.isLive) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              game.score ?? '0-0',
              style: const TextStyle(
                fontSize: 28, 
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: -1.5,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(height: 2),
            Text(
              game.isLive ? 'LIVE' : 'FINAL',
              style: TextStyle(
                fontSize: 9, 
                color: game.isLive ? Colors.red : Colors.grey.shade600, 
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
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
          const SizedBox(height: 8),
          Text(
            DateFormat('h:mm a').format(game.startTime),
            style: TextStyle(
              fontSize: 10, 
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
