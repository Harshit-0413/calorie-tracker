import 'dart:math';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class CalorieRing extends StatefulWidget {
  const CalorieRing({super.key, required this.consumed, required this.goal});

  final int consumed;
  final int goal;

  @override
  State<CalorieRing> createState() => _CalorieRingState();
}

class _CalorieRingState extends State<CalorieRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    final progress = (widget.consumed / widget.goal).clamp(0.0, 1.0);

    _controller = AnimationController(
      vsync: this,
      duration: AppTheme.slowAnimation,
    );

    _animation = Tween<double>(
      begin: 0,
      end: progress,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final remaining = widget.goal - widget.consumed;

    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) {
        return SizedBox(
          width: 220,
          height: 220,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(220, 220),
                painter: RingPainter(progress: _animation.value),
              ),

              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("🔥", style: TextStyle(fontSize: 28)),

                  const SizedBox(height: 8),

                  Text(
                    remaining.toString(),
                    style: Theme.of(
                      context,
                    ).textTheme.displayLarge?.copyWith(fontSize: 42),
                  ),

                  Text(
                    "kcal left",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "${widget.consumed} / ${widget.goal}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class RingPainter extends CustomPainter {
  final double progress;

  RingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 14.0;

    final center = Offset(size.width / 2, size.height / 2);

    final radius = size.width / 2 - stroke;

    final backgroundPaint = Paint()
      ..color = AppTheme.divider
      ..strokeWidth = stroke
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final foregroundPaint = Paint()
      ..shader = const LinearGradient(
        colors: [AppTheme.primaryLight, AppTheme.primary],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = stroke
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(covariant RingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
