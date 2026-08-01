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

  Future<void> deleteMeal(String id) {
    return database.deleteMeal(id);
  }

  Future<List<MealFoodEntry>> parseFoodInput(String prompt) {
    return claude.parseFoodInput(prompt);
  }

  Future<String> generateHealthAnalysis(List<MealLog> meals) {
    return claude.getHealthAnalysis(meals);
  }
}
