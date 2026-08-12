import 'package:calorie_tracker/core/enums/meal_type.dart';

import '../models/meal_log.dart';
import '../services/claude_service.dart';
import '../services/database_service.dart';

class MealRepository {
  final DatabaseService database;
  final ClaudeService claude;

  MealRepository({required this.database, required this.claude});

  Future<List<MealLog>> getMealsForDate(String userId, DateTime date) {
    return database.getMealsForDate(userId, date);
  }

  Future<void> saveMeal(MealLog meal) {
    return database.saveMeal(meal);
  }

  Future<MealLog?> getMealForType({
    required String userId,
    required MealType mealType,
    required DateTime date,
  }) {
    return database.getMealForType(
      userId: userId,
      mealType: mealType,
      date: date,
    );
  }

  Future<void> deleteMeal(String id) {
    return database.deleteMeal(id);
  }

  Future<void> updateMeal(MealLog meal) {
    return database.updateMeal(meal);
  }

  Future<List<MealFoodEntry>> parseFoodInput(String prompt) {
    return claude.parseFoodInput(prompt);
  }

  Future<String> generateHealthAnalysis(List<MealLog> meals) {
    return claude.getHealthAnalysis(meals);
  }
}
