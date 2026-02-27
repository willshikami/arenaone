import 'package:live_activities/live_activities.dart';
import '../../data/models/game.dart';
import '../../data/models/sports/football_game.dart';
import '../../data/models/sports/basketball_game.dart';
import '../../data/models/sports/golf_game.dart';

class LiveActivityService {
  static final LiveActivityService _instance = LiveActivityService._internal();
  factory LiveActivityService() => _instance;
  LiveActivityService._internal();

  final LiveActivities _liveActivitiesPlugin = LiveActivities();
  String? _latestActivityId;

  Future<void> init() async {
    await _liveActivitiesPlugin.init(appGroupId: 'group.com.opus.arenaone');
  }

  Future<void> startActivity(Game game) async {
    if (game.isLive == false) return;

    // For now, we only support one active live activity for simplicity
    // but the plugin supports multiple.
    if (_latestActivityId != null) {
      await updateActivity(game);
    } else {
      Map<String, dynamic> activityData = _formatGameData(game);
      _latestActivityId = await _liveActivitiesPlugin.createActivity(game.id, activityData);
    }
  }

  Future<void> updateActivity(Game game) async {
    if (_latestActivityId == null) {
      await startActivity(game);
      return;
    }

    Map<String, dynamic> activityData = _formatGameData(game);
    await _liveActivitiesPlugin.updateActivity(_latestActivityId!, activityData);
  }

  Future<void> stopActivity() async {
    if (_latestActivityId != null) {
      await _liveActivitiesPlugin.endActivity(_latestActivityId!);
      _latestActivityId = null;
    }
  }

  Future<void> endAllActivities() async {
    await _liveActivitiesPlugin.endAllActivities();
    _latestActivityId = null;
  }

  Map<String, dynamic> _formatGameData(Game game) {
    String title = game.sport;
    String status = game.status;
    String score = 'N/A';
    String teamA = '';
    String teamB = '';

    if (game is FootballGame) {
      teamA = game.homeTeamAbbr;
      teamB = game.awayTeamAbbr;
      score = game.score ?? '0 - 0';
      title = '${game.homeTeamName} vs ${game.awayTeamName}';
    } else if (game is BasketballGame) {
      teamA = game.homeTeamAbbr;
      teamB = game.awayTeamAbbr;
      score = game.score ?? '0 - 0';
      title = '${game.homeTeamName} vs ${game.awayTeamName}';
    } else if (game is GolfGame) {
      title = game.tournamentName ?? 'Golf Tournament';
      if (game.leaderboard != null && game.leaderboard!.isNotEmpty) {
        final leader = game.leaderboard![0];
        teamA = leader.name;
        teamB = 'Round ${game.round ?? '1'}';
        score = leader.score;
        status = 'Thru ${leader.thru}';
      }
    }

    return {
      'game_id': game.id,
      'title': title,
      'status': status,
      'score': score,
      'team_a': teamA,
      'team_b': teamB,
      'sport': game.sport,
    };
  }
}
