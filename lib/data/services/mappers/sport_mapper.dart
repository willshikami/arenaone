import '../../models/game.dart';

abstract class SportMapper {
  Game? map(Map<String, dynamic> json);

  String mapStatus(String? state, String? type) {
    if (state == 'pre') return 'Upcoming';
    if (state == 'in') return 'Live';
    if (state == 'post') return 'Final';
    
    if (type == null) return 'Upcoming';
    final s = type.toLowerCase();
    if (s == 'final' || s == 'status_final' || s == 'finished' || s == 'complete') return 'Final';
    if (s.contains('live') || s.contains('progress') || s.contains('playing') || s.contains('quarter') || s.contains('half')) {
      return 'Live';
    }
    return 'Upcoming';
  }

  bool isLive(bool? is_live, String? state) {
    if (is_live == true) return true;
    final s = state?.toLowerCase() ?? '';
    return s == 'in' || s == 'live' || s == 'inprogress';
  }

  String? getScore(String? state, dynamic homeScore, dynamic awayScore) {
    if (state == 'pre') return null;
    return "${homeScore ?? '0'}-${awayScore ?? '0'}";
  }

  Map<String, dynamic>? getParticipantMap(dynamic participantsField) {
    if (participantsField == null) return null;
    if (participantsField is Map<String, dynamic>) return participantsField;
    if (participantsField is List && participantsField.isNotEmpty) {
      return participantsField[0] as Map<String, dynamic>;
    }
    return null;
  }

  Map<String, dynamic>? findHomeAwayTeams(List<dynamic> eventParticipants, String? eventName) {
    // REMOVED early return: process even if participants are empty
    // if (eventParticipants.isEmpty) return null;

    dynamic homeData;
    dynamic awayData;

    // 1. Try to find by explicit home_away field (new schema)
    homeData = eventParticipants.firstWhere(
      (p) => p['home_away'] == 'home',
      orElse: () => null,
    );
    awayData = eventParticipants.firstWhere(
      (p) => p['home_away'] == 'away',
      orElse: () => null,
    );

    // 2. Try to find by explicit position (1=Home, 2=Away)
    if (homeData == null || awayData == null) {
      homeData = eventParticipants.firstWhere(
        (p) => p['position'] == 1,
        orElse: () => null,
      );
      awayData = eventParticipants.firstWhere(
        (p) => p['position'] == 2,
        orElse: () => null,
      );
    }

    // 2. If positions are missing OR no participants, try to infer from event name
    if (homeData == null || awayData == null) {
      final name = eventName ?? '';
      String? separator;
      if (name.contains(' at ')) separator = ' at ';
      else if (name.contains(' vs ')) separator = ' vs ';
      else if (name.contains(' - ')) separator = ' - ';

      if (separator != null) {
        final parts = name.split(separator);
        final awayNameFromEvent = parts[0].trim();
        final homeNameFromEvent = parts.length > 1 ? parts[1].trim() : '';

        if (eventParticipants.length >= 2) {
          for (int i = 0; i < eventParticipants.length; i++) {
            final p = eventParticipants[i];
            final pMap = getParticipantMap(p['participants']);
            final pName = pMap?['name']?.toLowerCase() ?? '';
            
            if (awayNameFromEvent.toLowerCase().contains(pName) || 
                (pName.isNotEmpty && awayNameFromEvent.toLowerCase().startsWith(pName))) {
              awayData = p;
            } else if (homeNameFromEvent.toLowerCase().contains(pName) || 
                       (pName.isNotEmpty && homeNameFromEvent.toLowerCase().startsWith(pName))) {
              homeData = p;
            }
          }
        } else if (eventParticipants.isNotEmpty) {
          final p = eventParticipants[0];
          final pMap = getParticipantMap(p['participants']);
          final pName = pMap?['name']?.toLowerCase() ?? '';
          if (awayNameFromEvent.toLowerCase().contains(pName)) {
            awayData = p;
          } else {
            homeData = p;
          }
        } else if (homeNameFromEvent.isNotEmpty && awayNameFromEvent.isNotEmpty) {
          homeData = {
            'participants': {'name': homeNameFromEvent, 'logo': null},
            'score': 0,
            'position': 1
          };
          awayData = {
            'participants': {'name': awayNameFromEvent, 'logo': null},
            'score': 0,
            'position': 2
          };
        }
      }
    }

    // 3. Fallback to index order
    if (homeData == null && eventParticipants.isNotEmpty) {
      homeData = eventParticipants[0];
    }
    if (awayData == null && eventParticipants.isNotEmpty) {
      awayData = eventParticipants.length > 1 ? eventParticipants[1] : (eventParticipants.isNotEmpty ? eventParticipants[0] : null);
    }

    // REMOVED: If we have no participants, we return a shell with TBDs instead of null
    // so the event actually appears in the UI.
    return {
      'home': homeData != null ? getParticipantMap(homeData['participants']) : null,
      'away': awayData != null ? getParticipantMap(awayData['participants']) : null,
      'homeData': homeData ?? {},
      'awayData': awayData ?? {},
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
