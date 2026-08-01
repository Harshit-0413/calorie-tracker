import 'meal_log.dart';

class MealTimelineItem {
  final String mealType;
  final double calories;
  final DateTime loggedAt;
  final int foodCount;
  final MealLog mealLog;

  const MealTimelineItem({
    required this.mealType,
    required this.loggedAt,
    required this.foodCount,
    required this.calories,
    required this.mealLog,
  });
}
