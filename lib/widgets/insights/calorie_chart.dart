import 'package:flutter/material.dart';

import '../../models/daily_nutrition_summary.dart';
import '../../theme/app_theme.dart';
import 'calorie_chart_painter.dart';

class CalorieChart extends StatefulWidget {
  final List<DailyNutritionSummary> dailySummaries;
  final Duration animationDuration;
  static const _chartHeight = 220.0;

  const CalorieChart({
    super.key,
    required this.dailySummaries,
    this.animationDuration = const Duration(milliseconds: 900),
  });

  @override
  State<CalorieChart> createState() => _CalorieChartState();
}

class _CalorieChartState extends State<CalorieChart>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant CalorieChart oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.dailySummaries != widget.dailySummaries) {
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.lg),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Weekly Calories",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppTheme.lg),
          SizedBox(
            height: CalorieChart._chartHeight,
            width: double.infinity,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  painter: CalorieChartPainter(
                    widget.dailySummaries,
                    progress: _animation.value,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
