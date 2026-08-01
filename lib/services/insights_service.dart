import 'package:calorie_tracker/models/meal_timeline_item.dart';
import 'package:calorie_tracker/models/user_profile.dart';

import '../models/insights_data.dart';
import '../models/meal_log.dart';

class InsightsService {
  static InsightsData generateInsights({
    required List<MealLog> meals,
    required UserProfile user,
  }) {
    double caloriesConsumed = 0;
    double proteinConsumed = 0;
    double carbsConsumed = 0;
    double fatConsumed = 0;

    for (final meal in meals) {
      caloriesConsumed += meal.totalCalories;
      proteinConsumed += meal.totalProtein;
      carbsConsumed += meal.totalCarbs;
      fatConsumed += meal.totalFat;
    }

    final timeline = _buildTimeline(meals);

    final nutritionScore = _calculateNutritionScore(
      calories: caloriesConsumed,
      calorieGoal: user.dailyCalorieGoal,
      protein: proteinConsumed,
      proteinGoal: user.dailyProteinGoal,
      carbs: carbsConsumed,
      carbsGoal: user.dailyCarbsGoal,
      fat: fatConsumed,
      fatGoal: user.dailyFatGoal,
    );

    final nutritionMessage = _generateNutritionMessage(nutritionScore);

    final latestInsight = _latestInsight(meals) ?? "Log your first meal today!";

    return InsightsData(
      caloriesConsumed: caloriesConsumed,
      calorieGoal: user.dailyCalorieGoal,

      proteinConsumed: proteinConsumed,
      proteinGoal: user.dailyProteinGoal,

      carbsConsumed: carbsConsumed,
      carbsGoal: user.dailyCarbsGoal,

      fatConsumed: fatConsumed,
      fatGoal: user.dailyFatGoal,

      nutritionScore: nutritionScore,
      nutritionMessage: nutritionMessage,

      mealTimeline: timeline,

      latestAIInsight: latestInsight,
    );
  }

  static List<MealTimelineItem> _buildTimeline(List<MealLog> meals) {
    final timeline = meals
        .map(
          (meal) => MealTimelineItem(
            mealType: meal.mealType.name,
            loggedAt: meal.loggedAt,
            calories: meal.totalCalories,
            foodCount: meal.foodEntries.length,
            mealLog: meal,
          ),
        )
        .toList();

    timeline.sort((a, b) => b.loggedAt.compareTo(a.loggedAt));

    return timeline;
  }

  static String? _latestInsight(List<MealLog> meals) {
    final sortedMeals = [...meals]
      ..sort((a, b) => b.loggedAt.compareTo(a.loggedAt));

    for (final meal in sortedMeals) {
      if (meal.aiInsight.trim().isNotEmpty) {
        return meal.aiInsight;
      }
    }

    return null;
  }

  static int _calculateNutritionScore({
    required double calories,
    required double calorieGoal,
    required double protein,
    required double proteinGoal,
    required double carbs,
    required double carbsGoal,
    required double fat,
    required double fatGoal,
  }) {
    double score = 0;

    score += _goalScore(calories, calorieGoal) * 40;
    score += _goalScore(protein, proteinGoal) * 30;
    score += _goalScore(carbs, carbsGoal) * 15;
    score += _goalScore(fat, fatGoal) * 15;

    return score.round().clamp(0, 100);
  }

  static double _goalScore(double value, double goal) {
    if (goal <= 0) return 0;

    final ratio = value / goal;

    if (ratio <= 1) {
      return ratio;
    }

    final penalty = 1 - ((ratio - 1) * 0.5);

    return penalty.clamp(0.0, 1.0);
  }

  static String _generateNutritionMessage(int score) {
    if (score >= 90) {
      return "Excellent! You're meeting your nutrition goals.";
    }

    if (score >= 75) {
      return "Great job! Just a few improvements needed.";
    }

    if (score >= 60) {
      return "You're on the right track. Keep balancing your meals.";
    }

    if (score >= 40) {
      return "Try increasing protein and balancing your macros.";
    }

    return "Let's improve today's nutrition by logging balanced meals.";
  }
}
