import 'package:calorie_tracker/models/daily_nutrition_summary.dart';

class WeeklySummary {
  final double averageCalories;
  final double averageProtein;
  final double averageCarbs;
  final double averageFat;

  final double totalCalories;

  final int totalMeals;
  final int activeDays;
  final int periodDays;

  final DateTime? bestDay;
  final DateTime? weakestDay;

  final double consistency;

  final List<DailyNutritionSummary> dailySummaries;

  int get roundedAverageCalories => averageCalories.round();

  int get consistencyPercentage => (consistency * 100).round();

  bool get hasData => totalMeals > 0;

  const WeeklySummary({
    required this.averageCalories,
    required this.averageProtein,
    required this.averageCarbs,
    required this.averageFat,
    required this.totalCalories,
    required this.totalMeals,
    required this.activeDays,
    required this.periodDays,
    required this.bestDay,
    required this.weakestDay,
    required this.consistency,
    required this.dailySummaries,
  });
}
