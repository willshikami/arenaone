import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import '../data/models/team.dart';
import '../data/models/game.dart';

part 'app_state.g.dart';

@JsonSerializable()
class AppState {
  final bool isLoading;
  final String? error;
  final int currentTabIndex;
  final List<Team> followedTeams;
  final List<Game> games;
  final DateTime selectedDate;

  AppState({
    required this.isLoading,
    this.error,
    required this.currentTabIndex,
    required this.followedTeams,
    required this.games,
    required this.selectedDate,
  });

  AppState copyWith({
    bool? isLoading,
    String? error,
    int? currentTabIndex,
    List<Team>? followedTeams,
    List<Game>? games,
    DateTime? selectedDate,
  }) {
    return AppState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
      followedTeams: followedTeams ?? this.followedTeams,
      games: games ?? this.games,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }

  static AppState initialState() => AppState(
        isLoading: false,
        currentTabIndex: 0,
        followedTeams: [],
        games: [],
        selectedDate: DateTime.now(),
      );

  factory AppState.fromJson(Map<String, dynamic> json) => _$AppStateFromJson(json);
  Map<String, dynamic> toJson() => _$AppStateToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          error == other.error &&
          currentTabIndex == other.currentTabIndex &&
          selectedDate == other.selectedDate &&
          listEquals(followedTeams, other.followedTeams) &&
          listEquals(games, other.games);

  @override
  int get hashCode =>
      isLoading.hashCode ^ 
      error.hashCode ^ 
      currentTabIndex.hashCode ^ 
      followedTeams.hashCode ^
      games.hashCode ^
      selectedDate.hashCode;
}
