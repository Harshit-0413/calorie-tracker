import '../models/daily_nutrition_summary.dart';
import '../models/meal_log.dart';
import '../models/weekly_summary.dart';

class AnalyticsService {
  const AnalyticsService._();

  static const int _defaultPeriodDays = 7;

  static Map<DateTime, List<MealLog>> _groupMealsByDay(List<MealLog> meals) {
    final grouped = <DateTime, List<MealLog>>{};

    for (final meal in meals) {
      final day = DateTime(
        meal.loggedAt.year,
        meal.loggedAt.month,
        meal.loggedAt.day,
      );

      grouped.putIfAbsent(day, () => []);
      grouped[day]!.add(meal);
    }

    return grouped;
  }

  static List<DailyNutritionSummary> _createDailySummaries(
    Map<DateTime, List<MealLog>> groupedMeals,
  ) {
    final summaries = <DailyNutritionSummary>[];

    for (final entry in groupedMeals.entries) {
      final meals = entry.value;

      double calories = 0;
      double protein = 0;
      double carbs = 0;
      double fat = 0;

      for (final meal in meals) {
        calories += meal.totalCalories;
        protein += meal.totalProtein;
        carbs += meal.totalCarbs;
        fat += meal.totalFat;
      }

      summaries.add(
        DailyNutritionSummary(
          date: entry.key,
          calories: calories,
          protein: protein,
          carbs: carbs,
          fat: fat,
          mealsLogged: meals.length,
        ),
      );
    }

    summaries.sort((a, b) => a.date.compareTo(b.date));

    return summaries;
  }

  static WeeklySummary generateSummary(
    List<MealLog> meals, {
    int periodDays = _defaultPeriodDays,
  }) {
    if (meals.isEmpty) {
      return WeeklySummary(
        averageCalories: 0,
        averageProtein: 0,
        averageCarbs: 0,
        averageFat: 0,
        totalCalories: 0,
        totalMeals: 0,
        activeDays: 0,
        bestDay: null,
        weakestDay: null,
        consistency: 0,
        dailySummaries: const [],
        periodDays: periodDays,
      );
    }

    final groupedMeals = _groupMealsByDay(meals);
    final dailySummaries = _createDailySummaries(groupedMeals);

    double totalCalories = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFat = 0;

    for (final day in dailySummaries) {
      totalCalories += day.calories;
      totalProtein += day.protein;
      totalCarbs += day.carbs;
      totalFat += day.fat;
    }

    final activeDays = dailySummaries.length;

    final averageCalories = activeDays == 0.0
        ? 0.0
        : totalCalories / activeDays;

    final averageProtein = activeDays == 0.0 ? 0.0 : totalProtein / activeDays;

    final averageCarbs = activeDays == 0.0 ? 0.0 : totalCarbs / activeDays;

    final averageFat = activeDays == 0.0 ? 0.0 : totalFat / activeDays;

    final bestDay = dailySummaries.reduce(
      (a, b) => a.calories >= b.calories ? a : b,
    );

    final weakestDay = dailySummaries.reduce(
      (a, b) => a.calories <= b.calories ? a : b,
    );

    final consistency = activeDays / periodDays;

    return WeeklySummary(
      averageCalories: averageCalories,
      averageProtein: averageProtein,
      averageCarbs: averageCarbs,
      averageFat: averageFat,
      totalCalories: totalCalories,
      totalMeals: meals.length,
      activeDays: activeDays,
      bestDay: bestDay.date,
      weakestDay: weakestDay.date,
      consistency: consistency.clamp(0.0, 1.0),
      dailySummaries: dailySummaries,
      periodDays: periodDays,
    );
  }
}
