import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import '../../../redux/app_state.dart';
import '../../../redux/actions/navigation_actions.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dayName = DateFormat('EEEE').format(now);
    final monthDate = DateFormat('MMMM d').format(now);

    return StoreConnector<AppState, _ViewModel>(
      vm: () => _Factory(this),
      builder: (context, vm) => Container(
        decoration: const BoxDecoration(
          color: Colors.transparent, // Background handled by parent HomeScreen
        ),
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 64.0, bottom: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  dayName.toUpperCase(),
                  style: GoogleFonts.instrumentSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Colors.grey.shade500,
                    letterSpacing: 1.5,
                  ),
                ),
                Text(
                  monthDate,
                  style: GoogleFonts.instrumentSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.white, // White text for dark mode
                    height: 1.1,
                  ),
                ),
              ],
            ),
            const Spacer(),
            GestureDetector(
              onTap: vm.onNavigateToProfile,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 2),
                ),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white.withValues(alpha: 0.05),
                  child: const SFIcon(
                    SFIcons.sf_person_fill,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Factory extends VmFactory<AppState, StatelessWidget, _ViewModel> {
  _Factory(super.widget);

  @override
  _ViewModel fromStore() => _ViewModel(
        onNavigateToProfile: () => dispatch(SetCurrentTabIndexAction(4)),
      );
}

class _ViewModel extends Vm {
  final VoidCallback onNavigateToProfile;

  _ViewModel({
    required this.onNavigateToProfile,
  }) : super(equals: []);
}
