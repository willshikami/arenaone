import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:async_redux/async_redux.dart';
import 'package:arenaone/redux/app_state.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dayName = DateFormat('EEEE').format(now);
    final monthDate = DateFormat('d MMMM').format(now).toUpperCase();

    return StoreConnector<AppState, _ViewModel>(
      vm: () => _Factory(this),
      builder: (context, vm) => Container(
        decoration: const BoxDecoration(
          color: Colors.transparent, // Background handled by parent HomeScreen
        ),
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 72.0, bottom: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  dayName.toUpperCase(),
                  style: GoogleFonts.instrumentSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFFFF6A1A),
                    letterSpacing: 1.5,
                  ),
                ),
                Text(
                  monthDate,
                  style: GoogleFonts.instrumentSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
              ],
            ),
            if (vm.liveCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                ),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(Icons.circle, color: Colors.red.withValues(alpha: 0.2), size: 14),
                        const Icon(Icons.circle, color: Colors.red, size: 6),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${vm.liveCount} LIVE',
                      style: GoogleFonts.instrumentSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: SFIcon(
                    SFIcons.sf_bell,
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Factory extends VmFactory<AppState, HomeTopBar, _ViewModel> {
  _Factory(super.widget);

  @override
  _ViewModel fromStore() {
    final liveGames = state.games.where((g) {
      final isLive = g.isLive || g.status == 'Live';
      if (!isLive) return false;

      // Filter by followed sports if the user has selected any preferred sports
      if (state.selectedSports.isNotEmpty) {
        return state.selectedSports.contains(g.sport);
      }
      
      return true;
    }).length;

    return _ViewModel(liveCount: liveGames);
  }
}

class _ViewModel extends Vm {
  final int liveCount;
  _ViewModel({required this.liveCount}) : super(equals: [liveCount]);
}
