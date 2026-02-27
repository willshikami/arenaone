import 'package:flutter/material.dart';

class ScoreFlipText extends StatelessWidget {
  final String score;
  final TextStyle style;
  final TextAlign textAlign;

  const ScoreFlipText({
    super.key,
    required this.score,
    required this.style,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return AnimatedBuilder(
          animation: animation,
          child: child,
          builder: (context, child) {
            final isEntering = child!.key == ValueKey(score);
            final rotationValue = isEntering ? (1 - animation.value) * 1.5 : animation.value * 1.5;
            
            return Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(isEntering ? -rotationValue : rotationValue),
              alignment: Alignment.center,
              child: Opacity(
                opacity: animation.value,
                child: child,
              ),
            );
          },
        );
      },
      child: Text(
        score,
        key: ValueKey(score),
        style: style,
        textAlign: textAlign,
      ),
    );
  }
}
