import 'package:flutter/material.dart';

import 'package:calorie_tracker/models/chart_point.dart';
import 'package:calorie_tracker/models/daily_nutrition_summary.dart';
import 'package:calorie_tracker/services/chart_math.dart';
import 'package:calorie_tracker/theme/app_theme.dart';

class CalorieChartPainter extends CustomPainter {
  final List<DailyNutritionSummary> data;
  final double progress;
  static const double _pointRadius = 5.0;
  static const int _gridRows = 4;

  const CalorieChartPainter(this.data, {required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final points = ChartMath.calculatePoints(size: size, data: data);

    if (points.isEmpty) return;

    _drawGrid(canvas, size);

    final fullPath = _createSmoothPath(points);

    // Keep the gradient static for a cleaner look.
    _drawGradient(canvas, size, fullPath);

    // Animate only the line.
    final animatedPath = _createAnimatedPath(fullPath);

    _drawCurve(canvas, animatedPath);

    _drawPoints(canvas, points);

    _drawLabels(canvas, size, points);
  }

  void _drawGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withValues(alpha: .15)
      ..strokeWidth = 1;

    final spacing = size.height / _gridRows;

    for (int i = 0; i <= _gridRows; i++) {
      final y = spacing * i;

      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  void _drawGradient(Canvas canvas, Size size, Path linePath) {
    final path = Path.from(linePath);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppTheme.primary.withValues(alpha: .25),
          AppTheme.primary.withValues(alpha: .02),
        ],
      ).createShader(Offset.zero & size);

    canvas.drawPath(path, paint);
  }

  void _drawCurve(Canvas canvas, Path path) {
    final paint = Paint()
      ..color = AppTheme.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, paint);
  }

  void _drawPoints(Canvas canvas, List<ChartPoint> points) {
    final fillPaint = Paint()..color = AppTheme.primary;

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i < points.length; i++) {
      final point = points[i];

      final pointStart = i / points.length;
      const pointAnimationDuration = 0.12;

      final pointProgress = ((progress - pointStart) / pointAnimationDuration)
          .clamp(0.0, 1.0);

      if (pointProgress <= 0) continue;

      // Ease-out scale animation
      final scale = Curves.easeOutBack.transform(pointProgress);

      final radius = _pointRadius * scale;

      canvas.drawCircle(point.offset, radius, fillPaint);

      canvas.drawCircle(point.offset, radius, borderPaint);
    }
  }

  void _drawLabels(Canvas canvas, Size size, List<ChartPoint> points) {
    for (final point in points) {
      final painter = TextPainter(
        text: TextSpan(
          text: point.label,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
        textDirection: TextDirection.ltr,
      );

      painter.layout();

      painter.paint(
        canvas,
        Offset(point.offset.dx - painter.width / 2, size.height + 8),
      );
    }
  }

  Path _createSmoothPath(List<ChartPoint> points) {
    final path = Path();

    path.moveTo(points.first.offset.dx, points.first.offset.dy);

    for (int i = 0; i < points.length - 1; i++) {
      final current = points[i];
      final next = points[i + 1];

      final controlX = (current.offset.dx + next.offset.dx) / 2;

      path.cubicTo(
        controlX,
        current.offset.dy,
        controlX,
        next.offset.dy,
        next.offset.dx,
        next.offset.dy,
      );
    }

    return path;
  }

  Path _createAnimatedPath(Path originalPath) {
    if (progress >= 1) {
      return originalPath;
    }

    final animatedPath = Path();

    for (final metric in originalPath.computeMetrics()) {
      animatedPath.addPath(
        metric.extractPath(0, metric.length * progress),
        Offset.zero,
      );
    }

    return animatedPath;
  }

  @override
  bool shouldRepaint(covariant CalorieChartPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.data != data;
  }
}
