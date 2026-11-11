import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:live_activities/live_activities.dart';
import 'package:arenaone/core/data/game.dart';
import 'package:arenaone/core/data/sports/football_game.dart';
import 'package:arenaone/core/data/sports/basketball_game.dart';
import 'package:arenaone/core/data/sports/f1_game.dart';
import 'package:arenaone/core/data/sports/golf_game.dart';
import 'package:arenaone/core/data/sports/rally_game.dart';
import 'package:arenaone/core/data/sports/tennis_game.dart';

class LiveActivityService {
  static final LiveActivityService _instance = LiveActivityService._internal();
  factory LiveActivityService() => _instance;
  LiveActivityService._internal();

  static const String appGroupId = 'group.com.opus.arenaone';
  static const String _activityIdPrefix = 'arenaone-live-game';
  static const Duration _staleAfter = Duration(minutes: 5);

  final LiveActivities _liveActivitiesPlugin = LiveActivities();
  StreamSubscription? _activitySubscription;

  bool _isInitialized = false;
  bool _canUseLiveActivities = false;
  String? _latestActivityId;
  String? _trackedGameId;

  Future<void> init() async {
    if (_isInitialized) return;
    _isInitialized = true;

    if (kIsWeb || defaultTargetPlatform != TargetPlatform.iOS) {
      return;
    }

    try {
      await _liveActivitiesPlugin.init(appGroupId: appGroupId);

      final supported = await _liveActivitiesPlugin.areActivitiesSupported();
      final enabled =
          supported && await _liveActivitiesPlugin.areActivitiesEnabled();
      _canUseLiveActivities = enabled;

      if (!_canUseLiveActivities) return;

      final existingIds = await _liveActivitiesPlugin.getAllActivitiesIds();
      if (existingIds.isNotEmpty) {
        _latestActivityId = existingIds.first;
      }

      _activitySubscription ??= _liveActivitiesPlugin.activityUpdateStream
          .listen((event) {
            event.mapOrNull(
              ended: (ended) => _clearActivityIfCurrent(ended.activityId),
              stale: (stale) => _clearActivityIfCurrent(stale.activityId),
            );
          });
    } catch (e) {
      _canUseLiveActivities = false;
      debugPrint('LiveActivityService.init failed: $e');
    }
  }

  Future<void> startActivity(Game game) async {
    if (!game.isLive && game.status != 'Live') return;
    await updateActivity(game);
  }

  Future<void> updateActivity(Game game) async {
    if (!_canUseLiveActivities) return;

    if (!game.isLive && game.status != 'Live') {
      await stopActivity();
      return;
    }

    try {
      if (_trackedGameId != null && _trackedGameId != game.id) {
        await _endCurrentActivity();
      }

      final activityKey = _activityKeyForGame(game.id);
      final activityData = _formatGameData(game);

      final activityId = await _liveActivitiesPlugin.createOrUpdateActivity(
        activityKey,
        activityData,
        iOSEnableRemoteUpdates: false,
        staleIn: _staleAfter,
      );

      if (activityId is String && activityId.isNotEmpty) {
        _latestActivityId = activityId;
      }
      _trackedGameId = game.id;
    } catch (e) {
      _latestActivityId = null;
      debugPrint('LiveActivityService.updateActivity failed: $e');
    }
  }

  Future<void> stopActivity() async {
    if (!_canUseLiveActivities) return;

    try {
      await _endCurrentActivity();
    } catch (e) {
      debugPrint('LiveActivityService.stopActivity failed: $e');
    } finally {
      _latestActivityId = null;
      _trackedGameId = null;
    }
  }

  Future<void> endAllActivities() async {
    if (!_canUseLiveActivities) return;

    try {
      await _liveActivitiesPlugin.endAllActivities();
    } catch (e) {
      debugPrint('LiveActivityService.endAllActivities failed: $e');
    } finally {
      _latestActivityId = null;
      _trackedGameId = null;
    }
  }

  Map<String, dynamic> _formatGameData(Game game) {
    String title = game.leagueType ?? game.sport;
    String status = game.status;
    String score = 'LIVE';
    String teamA = game.sport;
    String teamB = 'Arena One';
    String teamADetail = '';
    String teamBDetail = '';
    String footer = game.stadium ?? '';

    if (game is FootballGame) {
      teamA = game.homeTeamAbbr;
      teamB = game.awayTeamAbbr;
      score = _formatScore(game.score);
      title = '${game.homeTeamName} vs ${game.awayTeamName}';
      footer = _liveClockLabel(game);
    } else if (game is BasketballGame) {
      teamA = game.homeTeamAbbr;
      teamB = game.awayTeamAbbr;
      score = _formatScore(game.score);
      title = '${game.homeTeamName} vs ${game.awayTeamName}';
      footer = _liveClockLabel(game);
    } else if (game is F1Game) {
      title = game.stadium ?? 'Formula 1';
      teamA = game.winnerName ?? 'Leader';
      teamB = game.sessionType?.toUpperCase() ?? 'F1';
      teamADetail = game.winnerTeam ?? '';
      teamBDetail = game.leagueType ?? 'Formula 1';
      score = game.winningTime ?? game.winnerPoints ?? 'LIVE';
      footer = game.p2Name != null ? 'P2 ${game.p2Name}' : game.status;
    } else if (game is GolfGame) {
      title = game.tournamentName ?? 'Golf Tournament';
      if (game.leaderboard != null && game.leaderboard!.isNotEmpty) {
        final leader = game.leaderboard![0];
        teamA = leader.name;
        teamB = 'Round ${game.round ?? '1'}';
        score = leader.score;
        status = 'Thru ${leader.thru}';
        teamADetail = leader.team;
      }
      footer = game.stadium ?? game.tourType ?? 'Golf';
    } else if (game is TennisGame) {
      title = game.tournamentName ?? 'Tennis';
      teamA = game.player1Name;
      teamB = game.player2Name;
      score =
          game.score ??
          '${game.player1CurrentPoints ?? '0'} - ${game.player2CurrentPoints ?? '0'}';
      teamADetail = game.player1Country ?? '';
      teamBDetail = game.player2Country ?? '';
      footer = game.round ?? game.stadium ?? 'Tennis';
    } else if (game is RallyGame) {
      title = game.eventName ?? 'Rally';
      final leaders = game.leaderboard ?? [];
      if (leaders.isNotEmpty) {
        final leader = leaders[0];
        teamA = leader.name;
        teamB = leader.car ?? leader.team;
        score = leader.time ?? 'P${leader.position}';
        teamADetail = leader.team;
      }
      footer = game.currentStage ?? game.location ?? game.stadium ?? 'Rally';
    }

    return {
      'game_id': game.id,
      'title': title,
      'status': status,
      'score': score,
      'team_a': teamA,
      'team_b': teamB,
      'team_a_detail': teamADetail,
      'team_b_detail': teamBDetail,
      'sport': game.sport,
      'footer': footer,
    };
  }

  String _activityKeyForGame(String gameId) => '$_activityIdPrefix-$gameId';

  Future<void> _endCurrentActivity() async {
    if (_latestActivityId != null) {
      await _liveActivitiesPlugin.endActivity(_latestActivityId!);
    } else if (_trackedGameId != null) {
      await _liveActivitiesPlugin.endActivity(
        _activityKeyForGame(_trackedGameId!),
      );
    } else {
      await _liveActivitiesPlugin.endAllActivities();
    }
  }

  String _formatScore(String? score) {
    if (score == null || score.trim().isEmpty) return '0 - 0';
    return score.replaceAll('-', ' - ');
  }

  String _liveClockLabel(Game game) {
    final period = game.period == null ? null : 'P${game.period}';
    final clock = game.clock;
    return [
      period,
      clock,
      game.statusType,
    ].whereType<String>().where((value) => value.trim().isNotEmpty).join(' • ');
  }

  void _clearActivityIfCurrent(String activityId) {
    if (_latestActivityId == null || _latestActivityId == activityId) {
      _latestActivityId = null;
      _trackedGameId = null;
    }
  }
}
