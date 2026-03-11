import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:arenaone/core/redux/app_state.dart';
import 'package:arenaone/core/redux/actions/navigation_actions.dart';

class FollowingPage extends StatelessWidget {
  const FollowingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sports = [
      {'name': 'NBA', 'icon': SFIcons.sf_basketball_fill},
      {'name': 'F1', 'icon': SFIcons.sf_flag_2_crossed_fill},
      {'name': 'Football', 'icon': SFIcons.sf_sportscourt},
      {'name': 'Tennis', 'icon': SFIcons.sf_tennisball_fill},
      {'name': 'Golf', 'icon': SFIcons.sf_figure_golf},
      {'name': 'Rally', 'icon': SFIcons.sf_car_fill},
    ];

    return StoreConnector<AppState, _ViewModel>(
      vm: () => _Factory(this),
      builder: (context, vm) => Scaffold(
        backgroundColor: const Color(0xFF0D0D10),
        body: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0, -1.2),
              radius: 1.5,
              colors: [
                const Color(0xFFFF6A1A).withValues(alpha: 0.1),
                const Color(0xFF0D0D10),
              ],
              stops: const [0.0, 0.6],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'FOLLOWING',
                          style: GoogleFonts.spaceMono(
                            color: const Color(0xFFFF6A1A),
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your Sports',
                          style: GoogleFonts.instrumentSans(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Customize your feed by selecting the sports you want to track.',
                          style: GoogleFonts.instrumentSans(
                            color: Colors.grey.shade500,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.1,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final sport = sports[index];
                        final isSelected = vm.selectedSports.contains(sport['name']);
                        
                        return GestureDetector(
                          onTap: () => vm.onToggleSport(sport['name'] as String),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: isSelected 
                                  ? const Color(0xFFFF6A1A).withValues(alpha: 0.1) 
                                  : const Color(0xFF1C1C26),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: isSelected 
                                    ? const Color(0xFFFF6A1A) 
                                    : Colors.white.withValues(alpha: 0.06),
                                width: 2,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SFIcon(
                                  sport['icon'] as IconData,
                                  fontSize: 32,
                                  color: isSelected ? const Color(0xFFFF6A1A) : Colors.white,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  (sport['name'] as String).toUpperCase(),
                                  style: GoogleFonts.spaceMono(
                                    color: isSelected ? const Color(0xFFFF6A1A) : Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: sports.length,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Factory extends VmFactory<AppState, FollowingPage, _ViewModel> {
  _Factory(super.widget);

  @override
  _ViewModel fromStore() => _ViewModel(
        selectedSports: state.selectedSports,
        onToggleSport: (sport) => dispatch(ToggleSportSelectionAction(sport)),
      );
}

class _ViewModel extends Vm {
  final List<String> selectedSports;
  final ValueChanged<String> onToggleSport;

  _ViewModel({
    required this.selectedSports,
    required this.onToggleSport,
  }) : super(equals: [selectedSports]);
}
