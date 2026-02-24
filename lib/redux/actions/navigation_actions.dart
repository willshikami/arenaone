import 'package:async_redux/async_redux.dart';
import 'dart:convert';
import '../app_state.dart';
import '../../data/services/database_helper.dart';

class SetCurrentTabIndexAction extends ReduxAction<AppState> {
  final int index;

  SetCurrentTabIndexAction(this.index);

  @override
  AppState? reduce() {
    return state.copyWith(currentTabIndex: index);
  }
}

class SetSelectedDateAction extends ReduxAction<AppState> {
  final DateTime date;

  SetSelectedDateAction(this.date);

  @override
  AppState? reduce() {
    return state.copyWith(selectedDate: date);
  }
}

class SetSelectedSportAction extends ReduxAction<AppState> {
  final String sport;

  SetSelectedSportAction(this.sport);

  @override
  AppState? reduce() {
    return state.copyWith(selectedSport: sport);
  }
}

class ToggleSportSelectionAction extends ReduxAction<AppState> {
  final String sport;
  ToggleSportSelectionAction(this.sport);

  @override
  Future<AppState?> reduce() async {
    final currentSelected = List<String>.from(state.selectedSports);
    if (currentSelected.contains(sport)) {
      currentSelected.remove(sport);
    } else {
      currentSelected.add(sport);
    }
    
    // Persist change
    await DatabaseHelper().setPreference('selected_sports', jsonEncode(currentSelected));
    
    return state.copyWith(selectedSports: currentSelected);
  }
}

class SetLiveActivitiesAction extends ReduxAction<AppState> {
  final bool enabled;
  SetLiveActivitiesAction(this.enabled);

  @override
  Future<AppState?> reduce() async {
    await DatabaseHelper().setPreference('live_activities_enabled', enabled.toString());
    return state.copyWith(liveActivitiesEnabled: enabled);
  }
}

class CompleteOnboardingAction extends ReduxAction<AppState> {
  @override
  Future<AppState?> reduce() async {
    // Persist change
    await DatabaseHelper().setPreference('onboarding_completed', 'true');
    
    return state.copyWith(isOnboardingCompleted: true);
  }
}

class LoadUserPreferencesAction extends ReduxAction<AppState> {
  @override
  Future<AppState?> reduce() async {
    final db = DatabaseHelper();
    final onboardingCompleted = await db.getPreference('onboarding_completed') == 'true';
    final liveActivities = await db.getPreference('live_activities_enabled') != 'false'; // Default to true
    final selectedSportsJson = await db.getPreference('selected_sports');
    
    List<String> selectedSports = [];
    if (selectedSportsJson != null) {
      selectedSports = List<String>.from(jsonDecode(selectedSportsJson));
    }
    
    return state.copyWith(
      isOnboardingCompleted: onboardingCompleted,
      liveActivitiesEnabled: liveActivities,
      selectedSports: selectedSports,
    );
  }
}
