import 'package:flutter/material.dart';
import 'package:async_redux/async_redux.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import '../../../redux/app_state.dart';
import '../../../redux/actions/navigation_actions.dart';

class SportSelector extends StatelessWidget {
  final List<Map<String, dynamic>> sports = [
    {'name': 'F1', 'icon': SFIcons.sf_flag_2_crossed_fill},
    {'name': 'Golf', 'icon': SFIcons.sf_figure_golf},
    {'name': 'Tennis', 'icon': SFIcons.sf_tennisball_fill},
    {'name': 'NBA', 'icon': SFIcons.sf_basketball_fill},
    {'name': 'Rally', 'icon': SFIcons.sf_car_fill},
  ];

  SportSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      vm: () => _Factory(this),
      builder: (context, vm) => Container(
        height: 36,
        margin: const EdgeInsets.symmetric(vertical: 16),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          itemCount: sports.length,
          separatorBuilder: (context, index) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final sportData = sports[index];
            final sport = sportData['name'] as String;
            final icon = sportData['icon'] as IconData;
            final isSelected = sport == vm.selectedSport;

            return GestureDetector(
              onTap: () => vm.onSportSelected(sport),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFFF6A1A) : const Color(0xFF16161C),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? Colors.transparent : Colors.white.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SFIcon(
                      icon,
                      color: isSelected ? Colors.black : Colors.white,
                      fontSize: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      sport,
                      style: TextStyle(
                        color: isSelected ? Colors.black : Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Factory extends VmFactory<AppState, SportSelector, _ViewModel> {
  _Factory(super.widget);

  @override
  _ViewModel fromStore() => _ViewModel(
        selectedSport: state.selectedSport,
        onSportSelected: (sport) => dispatch(SetSelectedSportAction(sport)),
      );
}

class _ViewModel extends Vm {
  final String selectedSport;
  final Function(String) onSportSelected;

  _ViewModel({
    required this.selectedSport,
    required this.onSportSelected,
  }) : super(equals: [selectedSport]);
}
