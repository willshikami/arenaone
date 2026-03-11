import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:arenaone/core/data/sports/f1_game.dart';

class F1DetailPage extends StatelessWidget {
  final F1Game game;

  const F1DetailPage({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final drivers = game.drivers ?? [];
    
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
                        DateFormat('MMMM d, yyyy').format(game.startTime).toUpperCase(),
                        style: GoogleFonts.spaceMono(
                          color: const Color(0xFFE10600),
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE10600).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          game.status.toUpperCase(),
                          style: GoogleFonts.spaceMono(
                            color: const Color(0xFFE10600),
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
                    (game.stadium ?? 'Grand Prix').toUpperCase(),
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
                    game.leagueType ?? 'Formula 1',
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
                            'DRIVER',
                            style: GoogleFonts.spaceMono(
                              color: Colors.grey.shade600,
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'TEAM',
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
                            'PTS',
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
                if (drivers.isEmpty) {
                  // Fallback
                  if (index == 0 && game.winnerName != null) return _buildDriverRow(1, game.winnerName!, game.winnerTeam ?? 'TBD', game.winnerPoints ?? '0');
                  return null;
                }
                final driver = drivers[index];
                return _buildDriverRow(
                  driver.position, 
                  driver.name, 
                  driver.team, 
                  driver.points,
                );
              },
              childCount: drivers.isNotEmpty ? drivers.length : (game.winnerName != null ? 1 : 0),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
        ],
      ),
    );
  }

  Widget _buildDriverRow(int pos, String name, String team, String pts) {
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
              pos.toString(),
              textAlign: TextAlign.center,
              style: GoogleFonts.instrumentSans(
                color: pos == 1 ? const Color(0xFFE10600) : Colors.grey.shade400,
                fontSize: 13,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              name,
              style: GoogleFonts.instrumentSans(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              team.toUpperCase(),
              textAlign: TextAlign.center,
              style: GoogleFonts.instrumentSans(
                color: Colors.grey.shade500,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              pts,
              textAlign: TextAlign.center,
              style: GoogleFonts.instrumentSans(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
