import 'package:calorie_tracker/models/meal_timeline_item.dart';

class InsightsData {
  final double caloriesConsumed;
  final double calorieGoal;

  final double proteinConsumed;
  final double proteinGoal;

  final double carbsConsumed;
  final double carbsGoal;

  final double fatConsumed;
  final double fatGoal;

  final int nutritionScore;
  final String nutritionMessage;

  final List<MealTimelineItem> mealTimeline;

  final String? latestAIInsight;

  const InsightsData({
    required this.caloriesConsumed,
    required this.calorieGoal,

    required this.proteinConsumed,
    required this.proteinGoal,

    required this.carbsConsumed,
    required this.carbsGoal,

    required this.fatConsumed,
    required this.fatGoal,

    required this.nutritionScore,
    required this.nutritionMessage,

    required this.mealTimeline,

    required this.latestAIInsight,
  });
}
