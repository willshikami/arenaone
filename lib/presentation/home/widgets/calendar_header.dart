import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:async_redux/async_redux.dart';
import '../../../redux/app_state.dart';
import '../../../redux/actions/navigation_actions.dart';

class CalendarHeader extends StatelessWidget {
  const CalendarHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      vm: () => _Factory(this),
      builder: (context, vm) => Column(
        children: [
          _buildMonthSelector(vm),
          _buildCalendarRow(vm),
        ],
      ),
    );
  }

  Widget _buildMonthSelector(_ViewModel vm) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 64, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                DateFormat('MMM yyyy').format(vm.selectedDate),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 24),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(4),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C24),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                _buildToggleButton(SFIcons.sf_line_3_horizontal, true),
                _buildToggleButton(SFIcons.sf_calendar, false),
              ],
            ),
          ),
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
    );
  }

  Widget _buildToggleButton(IconData icon, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF2C2C34) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SFIcon(
        icon,
        color: isSelected ? const Color(0xFFFF6A1A) : Colors.grey.shade600,
        fontSize: 16,
      ),
    );
  }

  Widget _buildCalendarRow(_ViewModel vm) {
    return _WeeklyCalendar(vm: vm);
  }
}

class _WeeklyCalendar extends StatefulWidget {
  final _ViewModel vm;
  const _WeeklyCalendar({required this.vm});

  @override
  State<_WeeklyCalendar> createState() => _WeeklyCalendarState();
}

class _WeeklyCalendarState extends State<_WeeklyCalendar> {
  late PageController _pageController;
  final int _initialPage = 500; // Arbitrary large number to allow swiping "back"

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _initialPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: PageView.builder(
        controller: _pageController,
        itemBuilder: (context, pageIndex) {
          return _buildWeekPage(widget.vm, pageIndex - _initialPage);
        },
      ),
    );
  }

  Widget _buildWeekPage(_ViewModel vm, int weekOffset) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // Find the start of the current week (Monday)
    final monday = today.subtract(Duration(days: today.weekday - 1));
    final weekStart = monday.add(Duration(days: weekOffset * 7));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(7, (index) {
        final date = weekStart.add(Duration(days: index));
        final isSelected = _isSameDay(date, vm.selectedDate);
        final isToday = _isSameDay(date, today);
        final primaryColor = const Color(0xFFFF6A1A);

        return GestureDetector(
          onTap: () => vm.onDateSelected(date),
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            width: 50,
            child: Column(
              children: [
                Text(
                  DateFormat('E').format(date),
                  style: TextStyle(
                    color: isSelected || isToday ? Colors.white : Colors.grey.shade600,
                    fontSize: 13,
                    fontWeight: isSelected || isToday ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: 42,
                  height: 42,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected || isToday ? primaryColor : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    date.day.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: isSelected || isToday ? FontWeight.w900 : FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 3,
                  height: 3,
                  decoration: BoxDecoration(
                    color: isSelected || isToday ? Colors.transparent : Colors.grey.shade800,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class _Factory extends VmFactory<AppState, CalendarHeader, _ViewModel> {
  _Factory(super.widget);

  @override
  _ViewModel fromStore() => _ViewModel(
        selectedDate: state.selectedDate,
        onDateSelected: (date) => dispatch(SetSelectedDateAction(date)),
        onNavigateToProfile: () => dispatch(SetCurrentTabIndexAction(4)),
      );
}

class _ViewModel extends Vm {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final VoidCallback onNavigateToProfile;

  _ViewModel({
    required this.selectedDate,
    required this.onDateSelected,
    required this.onNavigateToProfile,
  }) : super(equals: [selectedDate]);
}
