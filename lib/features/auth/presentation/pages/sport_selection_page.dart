import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:arenaone/core/redux/app_state.dart';
import 'package:arenaone/core/redux/actions/navigation_actions.dart';

class SportSelectionPage extends StatelessWidget {
  const SportSelectionPage({super.key});

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
              center: const Alignment(0, -1.8),
              radius: 2.2,
              colors: [
                const Color(0xFFFF6A1A).withValues(alpha: 0.15),
                const Color(0xFF0D0D10),
              ],
              stops: const [0.0, 0.5],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    'Welcome to\nArenaOne',
                    style: GoogleFonts.instrumentSans(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Select the sports you want to follow to customize your feed.',
                    style: GoogleFonts.instrumentSans(
                      color: Colors.grey.shade400,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 48),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.1,
                      ),
                      itemCount: sports.length,
                      itemBuilder: (context, index) {
                        final sport = sports[index];
                        final isSelected = vm.selectedSports.contains(sport['name']);
                        
                        return GestureDetector(
                          onTap: () => vm.toggleSport(sport['name'] as String),
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
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: vm.selectedSports.isNotEmpty ? vm.onContinue : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6A1A),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey.shade800,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'CONTINUE',
                        style: GoogleFonts.instrumentSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Factory extends VmFactory<AppState, SportSelectionPage, _ViewModel> {
  _Factory(super.widget);

  @override
  _ViewModel fromStore() => _ViewModel(
        selectedSports: state.selectedSports,
        toggleSport: (sport) => dispatch(ToggleSportSelectionAction(sport)),
        onContinue: () => dispatch(CompleteOnboardingAction()),
      );
}

class _ViewModel extends Vm {
  final List<String> selectedSports;
  final ValueChanged<String> toggleSport;
  final VoidCallback onContinue;

  _ViewModel({
    required this.selectedSports,
    required this.toggleSport,
    required this.onContinue,
  }) : super(equals: [selectedSports]);
}
