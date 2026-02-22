// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppState _$AppStateFromJson(Map<String, dynamic> json) => AppState(
  isLoading: json['isLoading'] as bool,
  error: json['error'] as String?,
  currentTabIndex: (json['currentTabIndex'] as num).toInt(),
  followedTeams: (json['followedTeams'] as List<dynamic>)
      .map((e) => Team.fromJson(e as Map<String, dynamic>))
      .toList(),
  games: (json['games'] as List<dynamic>)
      .map((e) => Game.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$AppStateToJson(AppState instance) => <String, dynamic>{
  'isLoading': instance.isLoading,
  'error': instance.error,
  'currentTabIndex': instance.currentTabIndex,
  'followedTeams': instance.followedTeams,
  'games': instance.games,
};
