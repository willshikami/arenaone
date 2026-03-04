import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:async_redux/async_redux.dart';
import '../../../redux/app_state.dart';

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
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 72.0, bottom: 8.0),
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
          ],
        ),
      ),
    );
  }
}

class _Factory extends VmFactory<AppState, HomeTopBar, _ViewModel> {
  _Factory(super.widget);

  @override
  _ViewModel fromStore() => _ViewModel();
}

class _ViewModel extends Vm {
  _ViewModel() : super(equals: []);
}
