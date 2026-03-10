import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:arenaone/core/data/mappers/sport_mapper.dart';
import 'package:arenaone/core/widgets/f1_driver_details_sheet.dart';

class F1UpcomingCard extends StatelessWidget {
  final String raceName;
  final String location;
  final DateTime raceDate;
  final String? circuitImage;
  final String? broadcastChannel;
  final int raceNumber;
  final String circuitLayoutUrl;
  final DateTime? practice1Time;
  final DateTime? practice2Time;
  final DateTime? practice3Time;
  final DateTime? qualifyingTime;
  final DateTime? sprintTime;
  final String? sessionType;

  const F1UpcomingCard({
    super.key,
    required this.raceName,
    required this.location,
    required this.raceDate,
    this.circuitImage,
    this.broadcastChannel,
    required this.raceNumber,
    required this.circuitLayoutUrl,
    this.practice1Time,
    this.practice2Time,
    this.practice3Time,
    this.qualifyingTime,
    this.sprintTime,
    this.sessionType,
  });

  Widget _buildSessionRow(String session, DateTime time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: session == 'RACE DAY' ? const Color(0xFFFF2D2D) : const Color(0xFF2D7DFF),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                session,
                style: GoogleFonts.instrumentSans(
                  color: session == 'RACE DAY' ? Colors.white : Colors.grey.shade400,
                  fontSize: 12,
                  fontWeight: session == 'RACE DAY' ? FontWeight.w800 : FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          Text(
            DateFormat('EEEE, MMM d').format(time.toLocal()).toUpperCase(),
            style: GoogleFonts.instrumentSans(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1C1C26),
            const Color(0xFF16161C),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (circuitImage != null)
              Container(
                height: 160,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.03),
                ),
                child: Image(
                  image: circuitImage!.startsWith('assets/') ? AssetImage(circuitImage!) : NetworkImage(circuitImage!) as ImageProvider,
                  fit: BoxFit.contain,
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 2,
                            height: 12,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2D7DFF),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'ROUND $raceNumber',
                            style: GoogleFonts.instrumentSans(
                              color: Colors.grey.shade400,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            DateFormat('EEE, MMM d').format(raceDate.toLocal()).toUpperCase(),
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFFFFF).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: const Color(0xFFFFFFFF).withValues(alpha: 0.2),
                              ),
                            ),
                            child: Text(
                              DateFormat('h:mm a').format(raceDate.toLocal()),
                              style: const TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              raceName,
                              style: GoogleFonts.instrumentSans(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.location_on_rounded, size: 14, color: Colors.grey.shade500),
                                const SizedBox(width: 4),
                                Text(
                                  location,
                                  style: GoogleFonts.instrumentSans(
                                    color: Colors.grey.shade400,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            if (sessionType == 'qualifying') ...[
                              _buildQualifyingHeader(),
                              const SizedBox(height: 12),
                            ],
                            _buildSessionRow('PRACTICE 1 & 2', practice1Time ?? _getFriday(raceDate)),
                            _buildSessionRow('PRACTICE 3 & QUALIFYING', qualifyingTime ?? _getSaturday(raceDate)),
                            _buildSessionRow('RACE DAY', raceDate),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQualifyingHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF2D7DFF).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF2D7DFF).withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.timer_outlined, color: Color(0xFF2D7DFF), size: 14),
          const SizedBox(width: 6),
          Text(
            'QUALIFYING SESSION',
            style: GoogleFonts.instrumentSans(
              color: const Color(0xFF2D7DFF),
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  DateTime _getFriday(DateTime date) {
    return date.add(Duration(days: 5 - date.weekday));
  }

  DateTime _getSaturday(DateTime date) {
    return date.add(Duration(days: 6 - date.weekday));
  }
}

class F1CompletedCard extends StatelessWidget {
  final String? sessionType;
  final String raceName;
  final DateTime raceDate;
  final int raceNumber;
  final String? circuitImage;
  final String winnerName;
  final String winnerTeam;
  final String winnerLogo;
  final String points;
  final String? winnerTotalPoints;
  final String? time;
  final String? p2Name;
  final String? p2Team;
  final String? p2Image;
  final String? p2Points;
  final String? p2TotalPoints;
  final String? p2Gap;
  final String? p3Name;
  final String? p3Team;
  final String? p3Image;
  final String? p3Points;
  final String? p3TotalPoints;
  final String? p3Gap;

  const F1CompletedCard({
    super.key,
    this.sessionType,
    required this.raceName,
    required this.raceDate,
    required this.raceNumber,
    this.circuitImage,
    required this.winnerName,
    required this.winnerTeam,
    required this.winnerLogo,
    required this.points,
    this.winnerTotalPoints,
    this.time,
    this.p2Name,
    this.p2Team,
    this.p2Image,
    this.p2Points,
    this.p2TotalPoints,
    this.p2Gap,
    this.p3Name,
    this.p3Team,
    this.p3Image,
    this.p3Points,
    this.p3TotalPoints,
    this.p3Gap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1C1C26),
            const Color(0xFF16161C),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (circuitImage != null)
              Container(
                height: 160,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.03),
                ),
                child: Image(
                  image: circuitImage!.startsWith('assets/') ? AssetImage(circuitImage!) : NetworkImage(circuitImage!) as ImageProvider,
                  fit: BoxFit.contain,
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 2,
                            height: 10,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2D7DFF),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'ROUND $raceNumber',
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        raceName.toUpperCase(),
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: (sessionType == 'qualifying') 
                            ? const Color(0xFF2D7DFF).withValues(alpha: 0.15)
                            : const Color(0xFF34C759).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          (sessionType == 'qualifying') ? 'QUALIFYING' : 'FINAL',
                          style: TextStyle(
                            color: (sessionType == 'qualifying') 
                              ? const Color(0xFF2D7DFF) 
                              : const Color(0xFF34C759),
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('MMM d, yyyy • h:mm a').format(raceDate.toLocal()),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _buildWinnerSection(context, winnerName, winnerTeam, winnerLogo, time ?? '1:41.223', points, winnerTotalPoints),
            if (p2Name != null)
              _buildDriverRow(context, 2, p2Name!, p2Team!, p2Image!, p2Gap ?? '+0.222s', p2Points ?? '18', p2TotalPoints),
            if (p3Name != null)
              _buildDriverRow(context, 3, p3Name!, p3Team!, p3Image!, p3Gap ?? '+0.254s', p3Points ?? '15', p3TotalPoints),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildWinnerSection(BuildContext context, String name, String team, String imageUrl, String time, String points, String? totalPoints) {
    return InkWell(
      onTap: () => F1DriverDetailsSheet.show(
        context,
        name: name,
        team: team,
        image: imageUrl,
        position: '1',
        points: points,
        totalPoints: totalPoints,
        sessionType: sessionType,
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFFFD100).withValues(alpha: 0.03),
          border: Border.symmetric(
            horizontal: BorderSide(color: Colors.white.withValues(alpha: 0.05), width: 0.5),
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 110, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (sessionType == 'qualifying') ? 'LEADER' : 'WINNER',
                    style: TextStyle(
                      color: (sessionType == 'qualifying') ? const Color(0xFF2D7DFF) : const Color(0xFFFFD100),
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    SportMapper.getShortName(name),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                    ),
                  ),
                  Text(
                    team.toUpperCase(),
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildWinnerStat('TIME', time),
                      const SizedBox(width: 20),
                      _buildWinnerStat('PTS', '+$points'),
                      if (totalPoints != null) ...[
                        const SizedBox(width: 20),
                        _buildWinnerStat('TOTAL', totalPoints),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Hero(
                tag: 'driver_$name',
                child: SizedBox(
                  height: 130,
                  width: 150,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    alignment: Alignment.bottomCenter,
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(
                          child: Icon(Icons.person, color: Colors.white24, size: 60),
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWinnerStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 8,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _buildDriverRow(BuildContext context, int rank, String name, String team, String imageUrl, String timeOrGap, String pointsPerRace, String? totalPoints) {
    return InkWell(
      onTap: () => F1DriverDetailsSheet.show(
        context,
        name: name,
        team: team,
        image: imageUrl,
        position: rank.toString(),
        points: pointsPerRace,
        gap: timeOrGap,
        totalPoints: totalPoints,
        sessionType: sessionType,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          children: [
            SizedBox(
              width: 18,
              child: Text(
                '$rank',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Hero(
              tag: 'driver_$name',
              child: Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
                child: ClipOval(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(Icons.person, color: Colors.white24, size: 20),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    SportMapper.getShortName(name),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    team.toUpperCase(),
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (totalPoints != null) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'TOTAL',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 7,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    totalPoints,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
            ],
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  timeOrGap,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '+$pointsPerRace pts',
                  style: const TextStyle(
                    color: Color(0xFF00FF00),
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class F1LiveCard extends StatelessWidget {
  final String? sessionType;
  final String raceName;
  final int raceNumber;
  final String? circuitImage;
  final String leaderName;
  final String leaderTeam;
  final String leaderImage;
  final String lapInfo;
  final String? p2Name;
  final String? p2Team;
  final String? p2Image;
  final String? p2Gap;
  final String? p2Points;
  final String? p3Name;
  final String? p3Team;
  final String? p3Image;
  final String? p3Gap;
  final String? p3Points;
  final String? p4Name;
  final String? p4Team;
  final String? p4Image;
  final String? p4Gap;
  final String? p4Points;

  const F1LiveCard({
    super.key,
    this.sessionType,
    required this.raceName,
    required this.raceNumber,
    this.circuitImage,
    required this.leaderName,
    required this.leaderTeam,
    required this.leaderImage,
    required this.lapInfo,
    this.p2Name,
    this.p2Team,
    this.p2Image,
    this.p2Gap,
    this.p2Points,
    this.p3Name,
    this.p3Team,
    this.p3Image,
    this.p3Gap,
    this.p3Points,
    this.p4Name,
    this.p4Team,
    this.p4Image,
    this.p4Gap,
    this.p4Points,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1C1C26),
            const Color(0xFF16161C),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08), width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (circuitImage != null)
              Container(
                height: 160,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.03),
                ),
                child: Image(
                  image: circuitImage!.startsWith('assets/') ? AssetImage(circuitImage!) : NetworkImage(circuitImage!) as ImageProvider,
                  fit: BoxFit.contain,
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 2,
                            height: 10,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2D7DFF),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'ROUND $raceNumber',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        raceName.toUpperCase(),
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: (sessionType == 'qualifying') 
                        ? const Color(0xFF2D7DFF).withValues(alpha: 0.1)
                        : Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.circle, 
                          color: (sessionType == 'qualifying') ? const Color(0xFF2D7DFF) : Colors.red, 
                          size: 8
                        ),
                        const SizedBox(width: 6),
                        Text(
                          (sessionType == 'qualifying') ? 'QUALIFYING' : 'LIVE',
                          style: TextStyle(
                            color: (sessionType == 'qualifying') ? const Color(0xFF2D7DFF) : Colors.red,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _buildLeaderSection(context),
            if (p2Name != null)
              _buildLiveDriverRow(context, 2, p2Name!, p2Team!, p2Image!, p2Gap ?? (p2Points != null ? '$p2Points PTS' : '---')),
            if (p3Name != null)
              _buildLiveDriverRow(context, 3, p3Name!, p3Team!, p3Image!, p3Gap ?? (p3Points != null ? '$p3Points PTS' : '---')),
            if (p4Name != null)
              _buildLiveDriverRow(context, 4, p4Name!, p4Team!, p4Image!, p4Gap ?? (p4Points != null ? '$p4Points PTS' : '---')),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderSection(BuildContext context) {
    return InkWell(
      onTap: () => F1DriverDetailsSheet.show(
        context,
        name: leaderName,
        team: leaderTeam,
        image: leaderImage,
        position: '1',
        points: lapInfo,
        sessionType: sessionType,
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.03),
          border: Border.symmetric(
            horizontal: BorderSide(color: Colors.white.withValues(alpha: 0.05), width: 0.5),
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 110, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (sessionType == 'qualifying') ? 'LEADER' : 'LEADER',
                    style: TextStyle(
                      color: (sessionType == 'qualifying') ? const Color(0xFF2D7DFF) : Colors.red,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    leaderName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                    ),
                  ),
                  Text(
                    leaderTeam.toUpperCase(),
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildStat('LAP INFO', lapInfo),
                ],
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Hero(
                tag: 'driver_$leaderName',
                child: SizedBox(
                  height: 130,
                  width: 150,
                  child: Image.network(
                    leaderImage,
                    fit: BoxFit.contain,
                    alignment: Alignment.bottomCenter,
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(
                          child: Icon(Icons.person, color: Colors.white24, size: 60),
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 8,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _buildLiveDriverRow(BuildContext context, int rank, String name, String team, String imageUrl, String gap) {
    return InkWell(
      onTap: () => F1DriverDetailsSheet.show(
        context,
        name: name,
        team: team,
        image: imageUrl,
        position: rank.toString(),
        gap: gap,
        sessionType: sessionType,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          children: [
            SizedBox(
              width: 18,
              child: Text(
                '$rank',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Hero(
              tag: 'driver_$name',
              child: Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
                child: ClipOval(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(Icons.person, color: Colors.white24, size: 20),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    team.toUpperCase(),
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  gap,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

