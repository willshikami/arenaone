import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:async_redux/async_redux.dart';
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
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 48.0, bottom: 8.0),
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
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
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
                  border: Border.all(color: Colors.white.withOpacity(0.1), width: 2),
                ),
                child: const CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=arenaone_user'),
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
  _ViewModel fromStore() => _ViewModel(
        onNavigateToProfile: () => dispatch(SetCurrentTabIndexAction(4)),
      );
}

class _ViewModel extends Vm {
  final VoidCallback onNavigateToProfile;

  _ViewModel({required this.onNavigateToProfile});
}

class SportSelector extends StatelessWidget {
  final List<Map<String, dynamic>> sports = [
    {'name': 'NBA', 'icon': Icons.sports_basketball},
    {'name': 'MLB', 'icon': Icons.sports_baseball},
    {'name': 'NHL', 'icon': Icons.sports_hockey},
    {'name': 'NFL', 'icon': Icons.sports_football},
    {'name': 'EPL', 'icon': Icons.sports_soccer},
    {'name': 'Tennis', 'icon': Icons.sports_tennis},
  ];

  SportSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(top: 8),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: sports.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final sport = sports[index]['name'] as String;
          final icon = sports[index]['icon'] as IconData;
          final isSelected = sport == 'NBA';

          return FilterChip(
            avatar: Icon(icon, color: isSelected ? Colors.black : Colors.white, size: 16),
            label: Text(sport),
            selected: isSelected,
            onSelected: (selected) {},
            backgroundColor: const Color(0xFF16161C),
            selectedColor: const Color(0xFFFF6A1A), // Using modern bold orange
            showCheckmark: false,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            labelStyle: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: isSelected ? Colors.transparent : Colors.white.withOpacity(0.1)),
            ),
          );
        },
      ),
    );
  }
}
