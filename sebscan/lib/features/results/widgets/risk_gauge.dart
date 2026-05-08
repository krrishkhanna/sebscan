import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class RiskGauge extends StatefulWidget {
  const RiskGauge({
    required this.score,
    super.key,
  });

  final int score;

  @override
  State<RiskGauge> createState() => _RiskGaugeState();
}

class _RiskGaugeState extends State<RiskGauge> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get gaugeColor {
    if (widget.score <= 30) return AppTheme.kColorSafe;
    if (widget.score <= 60) return AppTheme.kColorWarning;
    return AppTheme.kColorDanger;
  }

  String get label {
    if (widget.score <= 30) return 'CLEAN';
    if (widget.score <= 60) return 'MODERATE RISK';
    return 'HIGH RISK';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 240,
      height: 160,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: _RiskGaugePainter(
              progress: _animation.value * (widget.score / 100),
              color: gaugeColor,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${widget.score}',
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontSize: 36,
                        color: gaugeColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      label,
                      style: theme.textTheme.labelMedium,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RiskGaugePainter extends CustomPainter {
  const _RiskGaugePainter({
    required this.progress,
    required this.color,
  });

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 14.0;
    final rect = Rect.fromLTWH(
      strokeWidth,
      strokeWidth,
      size.width - (strokeWidth * 2),
      size.width - (strokeWidth * 2),
    );

    final backgroundPaint = Paint()
      ..color = AppTheme.kColorBorder
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    final foregroundPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    canvas.drawArc(rect, math.pi, math.pi, false, backgroundPaint);
    canvas.drawArc(rect, math.pi, math.pi * progress, false, foregroundPaint);
  }

  @override
  bool shouldRepaint(covariant _RiskGaugePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
