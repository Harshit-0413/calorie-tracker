import 'package:flutter/material.dart';

import '../models/chart_point.dart';
import '../models/daily_nutrition_summary.dart';

class ChartMath {
  const ChartMath._();

  static const double _minPadding = 100;

  static List<ChartPoint> calculatePoints({
    required Size size,
    required List<DailyNutritionSummary> data,
  }) {
    if (data.isEmpty) return [];

    final maxCalories = data
        .map((e) => e.calories)
        .reduce((a, b) => a > b ? a : b);

    final minCalories = data
        .map((e) => e.calories)
        .reduce((a, b) => a < b ? a : b);

    final chartMin = _chartMin(minCalories, maxCalories);
    final chartMax = _chartMax(minCalories, maxCalories);

    final spacing = data.length == 1 ? 0.0 : size.width / (data.length - 1);

    final points = <ChartPoint>[];

    for (int i = 0; i < data.length; i++) {
      final meal = data[i];

      final x = data.length == 1 ? size.width / 2 : spacing * i;

      final y = calculateYPosition(
        size: size,
        value: meal.calories,
        minValue: chartMin,
        maxValue: chartMax,
      );

      points.add(
        ChartPoint(
          offset: Offset(x, y),
          value: meal.calories,
          label: _weekday(meal.date),
        ),
      );
    }

    return points;
  }

  /// Converts any calorie value to its Y-coordinate on the chart.
  static double calculateYPosition({
    required Size size,
    required double value,
    required double minValue,
    required double maxValue,
  }) {
    final range = (maxValue - minValue).clamp(1.0, double.infinity);

    final normalized = (value - minValue) / range;

    return size.height - (normalized * size.height);
  }

  static double _chartMin(double min, double max) {
    final range = max - min;
    final padding = (range * 0.15).clamp(_minPadding, double.infinity);

    return min - padding;
  }

  static double _chartMax(double min, double max) {
    final range = max - min;
    final padding = (range * 0.15).clamp(_minPadding, double.infinity);

    return max + padding;
  }

  static String _weekday(DateTime date) {
    const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

    return days[date.weekday - 1];
  }
}
