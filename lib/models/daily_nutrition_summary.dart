class DailyNutritionSummary {
  final DateTime date;

  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  final int mealsLogged;

  const DailyNutritionSummary({
    required this.date,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.mealsLogged,
  });
}
