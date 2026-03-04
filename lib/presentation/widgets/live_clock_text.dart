import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:ui';

class LiveClockText extends StatefulWidget {
  final String? initialClock;
  final TextStyle style;
  final bool isLive;
  final bool isCountdown;

  const LiveClockText({
    super.key,
    required this.initialClock,
    required this.style,
    this.isLive = true,
    this.isCountdown = true,
  });

  @override
  State<LiveClockText> createState() => _LiveClockTextState();
}

class _LiveClockTextState extends State<LiveClockText> {
  Timer? _timer;
  late int _currentSeconds;

  @override
  void initState() {
    super.initState();
    _parseAndStart();
  }

  @override
  void didUpdateWidget(LiveClockText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialClock != widget.initialClock) {
      _parseAndStart();
    }
  }

  void _parseAndStart() {
    _timer?.cancel();
    if (widget.initialClock == null || !widget.isLive) {
      _currentSeconds = 0;
      return;
    }

    // Handle Football format (e.g., "45 +1'")
    if (widget.initialClock!.contains("'")) {
      final cleanClock = widget.initialClock!.replaceAll("'", "");
      
      if (cleanClock.contains('+')) {
        final parts = cleanClock.split('+');
        final baseMins = int.tryParse(parts[0].trim()) ?? 0;
        final extraMins = int.tryParse(parts[1].trim()) ?? 0;
        _currentSeconds = (baseMins + extraMins) * 60;
      } else {
        final minutes = int.tryParse(cleanClock.trim()) ?? 0;
        _currentSeconds = minutes * 60;
      }
      _startTimer();
      return;
    }

    // Parse MM:SS or M:SS
    final parts = widget.initialClock!.split(':');
    if (parts.length == 2) {
      final minutes = int.tryParse(parts[0]) ?? 0;
      final seconds = int.tryParse(parts[1]) ?? 0;
      _currentSeconds = (minutes * 60) + seconds;
      
      // Start ticker
      _startTimer();
    } else {
      // If it's just a number or something else, handle it safely
      _currentSeconds = int.tryParse(widget.initialClock!) ?? 0;
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (widget.isCountdown) {
          if (_currentSeconds > 0) {
            _currentSeconds--;
          } else {
            timer.cancel();
          }
        } else {
          // Count UP for football
          _currentSeconds++;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;

    // Special logic for Football Stoppage Time parsing from API
    if (!widget.isCountdown && widget.initialClock != null && widget.initialClock!.contains('+')) {
      final cleanClock = widget.initialClock!.replaceAll("'", "");
      final baseMinsStr = cleanClock.split('+')[0].trim();
      final baseMins = int.tryParse(baseMinsStr) ?? (minutes < 90 ? 45 : 90);
      
      final extraSeconds = totalSeconds - (baseMins * 60);
      if (extraSeconds >= 0) {
        final extraMins = extraSeconds ~/ 60;
        final extraSecs = extraSeconds % 60;
        return "$baseMins +$extraMins:${extraSecs.toString().padLeft(2, '0')}";
      }
    }

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.initialClock == null) return Text('-', style: widget.style);
    
    return Text(
      _formatDuration(_currentSeconds),
      style: widget.style.copyWith(
        fontFeatures: [const FontFeature.tabularFigures()],
      ),
    );
  }
}
