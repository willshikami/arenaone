import 'package:arenaone/core/data/game.dart';

abstract class SportMapper {
  Game? map(Map<String, dynamic> json);

  String mapStatus(Map<String, dynamic>? status) {
    if (status == null) return 'Upcoming';
    
    final type = status['type'] as Map<String, dynamic>?;
    final state = type?['state']?.toString().toLowerCase();
    
    if (state == 'pre') return 'Upcoming';
    if (state == 'in') return 'Live';
    if (state == 'post') return 'Final';
    
    final typeName = type?['name']?.toString().toLowerCase();
    if (typeName == 'final' || typeName == 'finished' || typeName == 'complete') return 'Final';
    if (typeName != null && (typeName.contains('live') || typeName.contains('progress'))) {
      return 'Live';
    }
    return 'Upcoming';
  }

  bool isLive(Map<String, dynamic>? status) {
    if (status == null) return false;
    final type = status['type'] as Map<String, dynamic>?;
    final state = type?['state']?.toString().toLowerCase();
    return state == 'in';
  }

  String? getScore(Map<String, dynamic>? status, dynamic homeScore, dynamic awayScore) {
    final state = status?['type']?['state']?.toString().toLowerCase();
    if (state == 'pre') return null;
    return "${homeScore ?? '0'}-${awayScore ?? '0'}";
  }

  Map<String, dynamic>? findHomeAwayTeams(Map<String, dynamic> json) {
    final competitions = json['competitions'] as List<dynamic>?;
    if (competitions == null || competitions.isEmpty) return null;
    
    final competition = competitions[0] as Map<String, dynamic>;
    final teams = (competition['competitionTeams'] as List<dynamic>?)
            ?.map((e) => e as Map<String, dynamic>)
            .toList() ??
        [];
    if (teams.isEmpty) return null;

    Map<String, dynamic> homeData = <String, dynamic>{};
    Map<String, dynamic> awayData = <String, dynamic>{};

    // 1. Try to find by explicit homeAway field
    homeData = teams.firstWhere(
      (p) => p['homeAway'] == 'home',
      orElse: () => <String, dynamic>{},
    );
    awayData = teams.firstWhere(
      (p) => p['homeAway'] == 'away',
      orElse: () => <String, dynamic>{},
    );

    // 2. Fallback to order in competition
    if (homeData.isEmpty || awayData.isEmpty) {
      homeData = teams.firstWhere(
        (p) => p['orderInCompetition'] == 0,
        orElse: () => <String, dynamic>{},
      );
      if (teams.length > 1) {
        awayData = teams.firstWhere(
          (p) => p['orderInCompetition'] == 1,
          orElse: () => <String, dynamic>{},
        );
      }
    }

    // 3. Last resort fallback
    if (homeData.isEmpty && teams.isNotEmpty) {
      homeData = teams[0];
    }
    if (awayData.isEmpty && teams.length > 1) {
      awayData = teams[1];
    }

    if (homeData.isEmpty && awayData.isEmpty) {
      print('DEBUG: findHomeAwayTeams failed to find ANY team data');
      return null;
    }

    return {
      'home': homeData['teams'],
      'away': awayData['teams'],
      'homeData': homeData,
      'awayData': awayData,
    };
  }

  static String getShortName(String? name) {
    if (name == null || name.isEmpty) return 'TBD';
    final parts = name.trim().split(' ');
    if (parts.length > 1) {
      return parts.last;
    }
    return name;
  }

  static String getInitialName(String? name) {
    if (name == null || name.isEmpty) return 'TBD';
    final parts = name.trim().split(' ');
    if (parts.length > 1) {
      final firstName = parts[0];
      final lastName = parts.last;
      if (firstName.isNotEmpty) {
        return "${firstName[0]}.$lastName";
      }
    }
    return name;
  }
}
