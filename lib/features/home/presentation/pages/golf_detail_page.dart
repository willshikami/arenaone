import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:arenaone/core/data/sports/golf_game.dart';
import 'package:arenaone/core/data/mappers/sport_mapper.dart';

class GolfDetailPage extends StatelessWidget {
  final GolfGame game;

  const GolfDetailPage({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final tournamentName = game.tournamentName ?? 'TBD Tournament';
    final leaders = game.leaderboard ?? [];
    
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D10),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            elevation: 0,
            backgroundColor: const Color(0xFF1C1C26),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              titlePadding: const EdgeInsets.only(top:16, left: 48, bottom: 20, right: 24),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Row(
                    children: [
                      Text(
                        game.round?.toUpperCase() ?? 'ROUND 1',
                        style: GoogleFonts.spaceMono(
                          color: Colors.green,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: game.status == 'Live' 
                              ? Colors.red.withValues(alpha: 0.15) 
                              : Colors.grey.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          game.status.toUpperCase(),
                          style: TextStyle(
                            color: game.status == 'Live' ? Colors.red : Colors.grey,
                            fontSize: 7,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tournamentName.toUpperCase(),
                    style: GoogleFonts.instrumentSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    game.stadium ?? 'TBD Course',
                    style: GoogleFonts.instrumentSans(
                      color: Colors.grey.shade400,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1C1C26),
                      Color(0xFF16161C),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Table Headers
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const SizedBox(width: 40), 
                        Expanded(
                          flex: 4,
                          child: Text(
                            'PLAYER',
                            style: GoogleFonts.spaceMono(
                              color: Colors.grey.shade600,
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'SCORE',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.spaceMono(
                              color: Colors.grey.shade600,
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'ROUND',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.spaceMono(
                              color: Colors.grey.shade600,
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'THRU',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.spaceMono(
                              color: Colors.grey.shade600,
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final player = leaders[index];
                return _buildLeaderboardRow(player);
              },
              childCount: leaders.length,
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
        ],
      ),
    );
  }

  Widget _buildLeaderboardRow(GolfLeader player) {
    final scoreColor = player.score.startsWith('-') ? Colors.green : (player.score == 'E' ? Colors.white : Colors.red);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C26).withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(
              player.position.toString(),
              textAlign: TextAlign.center,
              style: GoogleFonts.instrumentSans(
                color: Colors.grey.shade400,
                fontSize: 13,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Row(
              children: [
                if (player.image.isNotEmpty)
                  CircleAvatar(
                    radius: 12,
                    backgroundImage: NetworkImage(player.image),
                  )
                else
                  const CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.white10,
                    child: Icon(Icons.person, size: 14, color: Colors.white38),
                  ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    SportMapper.getInitialName(player.name),
                    style: GoogleFonts.instrumentSans(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              player.score,
              textAlign: TextAlign.center,
              style: GoogleFonts.instrumentSans(
                color: scoreColor,
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              player.currentRound ?? 'R1',
              textAlign: TextAlign.center,
              style: GoogleFonts.instrumentSans(
                color: Colors.grey.shade400,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              player.thru,
              textAlign: TextAlign.center,
              style: GoogleFonts.instrumentSans(
                color: Colors.grey.shade400,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
