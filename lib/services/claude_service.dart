import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/food_item.dart';
import '../models/meal_log.dart';
import 'database_service.dart';

class ClaudeService {
  static const bool useMockData = true;

  /// AI service for future Claude integration.
  /// Currently uses mock data until API integration is enabled.
  static const String _apiKey = 'CLAUDE_API_KEY';
  static const String _baseUrl = 'https://api.anthropic.com/v1/messages';
  static const String _model = 'claude-haiku-4-5-20251001';

  final DatabaseService _db = DatabaseService();

  // ─── Parse natural language food input ───────────────────
  Future<List<MealFoodEntry>> parseFoodInput(String userInput) async {
    if (useMockData) {
      return _mockParseFoodInput(userInput);
    }
    final prompt =
        '''
You are a nutrition assistant for an Indian calorie tracking app.
The user has typed what they ate. Parse it into structured food items.

User input: "$userInput"

Respond ONLY with a JSON array. No explanation, no markdown, no backticks.
Each item must have exactly these fields:
- "name": food name in English (string)
- "quantity": numeric quantity (number)
- "unit": unit of measurement (string, e.g. "piece", "katori", "tbsp", "g", "ml", "plate")

Example output:
[
  {"name": "roti", "quantity": 2, "unit": "piece"},
  {"name": "dal", "quantity": 1, "unit": "katori"}
]

Rules:
- If quantity is not mentioned, assume 1
- Convert Hindi food names to English
- Split combined items (e.g. "2 roti sabzi" = roti + sabzi separately)
- Use realistic Indian serving units
''';

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': _apiKey,
          'anthropic-version': '2023-06-01',
        },
        body: jsonEncode({
          'model': _model,
          'max_tokens': 1000,
          'messages': [
            {'role': 'user', 'content': prompt},
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['content'][0]['text'] as String;
        final parsed = jsonDecode(text) as List;

        List<MealFoodEntry> entries = [];

        for (final item in parsed) {
          final name = item['name'] as String;
          final quantity = (item['quantity'] as num).toDouble();
          final unit = item['unit'] as String;

          // Look up food in local database
          FoodItem? food = await _db.getFoodByName(name);

          // If not found, create estimated entry
          food ??= _createEstimatedFood(name, unit);

          // Scale the food by quantity
          final scaled = food.scaleBy(quantity);

          entries.add(
            MealFoodEntry(
              scaledFood: scaled,
              quantity: quantity,
              quantityUnit: unit,
            ),
          );
        }

        return entries;
      } else {
        throw Exception('Claude API error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to parse food input: $e');
    }
  }

  // ─── Generate health analysis for a meal ─────────────────
  Future<String> generateHealthAnalysis({
    required List<MealFoodEntry> entries,
    required double totalCalories,
    required double totalProtein,
    required double totalCarbs,
    required double totalFat,
    required double dailyCalorieGoal,
  }) async {
    final foodList = entries
        .map((e) => '${e.scaledFood.name} (${e.quantity} ${e.quantityUnit})')
        .join(', ');

    final prompt =
        '''
You are a friendly nutrition coach for an Indian fitness app.
Analyze this meal and give a brief, practical health insight in 3-4 sentences.

Meal: $foodList
Total: ${totalCalories.toInt()} calories, ${totalProtein.toInt()}g protein, ${totalCarbs.toInt()}g carbs, ${totalFat.toInt()}g fat
Daily calorie goal: ${dailyCalorieGoal.toInt()} calories

Be specific about the foods mentioned. Mention what's good and what to watch out for.
Keep it conversational and encouraging. Do not use bullet points.
''';

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': _apiKey,
          'anthropic-version': '2023-06-01',
        },
        body: jsonEncode({
          'model': _model,
          'max_tokens': 1000,
          'messages': [
            {'role': 'user', 'content': prompt},
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['content'][0]['text'] as String;
      } else {
        throw Exception('Claude API error: ${response.statusCode}');
      }
    } catch (e) {
      return 'Unable to generate analysis right now.';
    }
  }

  // ─── Fallback for unknown foods ───────────────────────────
  FoodItem _createEstimatedFood(String name, String unit) {
    // Generic estimates for unknown foods
    return FoodItem(
      id: 'unknown_$name',
      name: name,
      calories: 100,
      protein: 3.0,
      carbs: 15.0,
      fat: 3.0,
      servingSize: 1,
      servingUnit: unit,
      category: 'unknown',
    );
  }

  Future<List<MealFoodEntry>> _mockParseFoodInput(String userInput) async {
    final input = userInput.toLowerCase();

    final List<MealFoodEntry> entries = [];

    Future<void> addFood(
      String name, {
      double quantity = 1,
      String unit = "serving",
    }) async {
      final food = await _db.getFoodByName(name);

      if (food != null) {
        entries.add(
          MealFoodEntry(
            scaledFood: food.scaleBy(quantity),
            quantity: quantity,
            quantityUnit: unit,
          ),
        );
      }
    }

    if (input.contains("roti")) {
      await addFood("roti", quantity: 2, unit: "piece");
    }

    if (input.contains("dal")) {
      await addFood("dal", quantity: 1, unit: "katori");
    }

    if (input.contains("paneer")) {
      await addFood("paneer", quantity: 1, unit: "serving");
    }

    if (input.contains("rice")) {
      await addFood("rice", quantity: 1, unit: "bowl");
    }

    if (input.contains("poha")) {
      await addFood("poha", quantity: 1, unit: "plate");
    }

    if (input.contains("banana")) {
      await addFood("banana", quantity: 1, unit: "piece");
    }

    if (input.contains("milk")) {
      await addFood("milk", quantity: 1, unit: "glass");
    }

    if (input.contains("egg")) {
      await addFood("egg", quantity: 2, unit: "piece");
    }

    if (entries.isEmpty) {
      final fallback = await _db.getFoodByName("roti");

      if (fallback != null) {
        entries.add(
          MealFoodEntry(
            scaledFood: fallback,
            quantity: 1,
            quantityUnit: "piece",
          ),
        );
      }
    }

    return entries;
  }

  Future<String> getHealthAnalysis(List<MealLog> meals) async {
    if (meals.isEmpty) {
      return 'No meals available for analysis.';
    }

    final allEntries = <MealFoodEntry>[];

    double calories = 0;
    double protein = 0;
    double carbs = 0;
    double fat = 0;

    for (final meal in meals) {
      allEntries.addAll(meal.foodEntries);
      calories += meal.totalCalories;
      protein += meal.totalProtein;
      carbs += meal.totalCarbs;
      fat += meal.totalFat;
    }

    return generateHealthAnalysis(
      entries: allEntries,
      totalCalories: calories,
      totalProtein: protein,
      totalCarbs: carbs,
      totalFat: fat,
      dailyCalorieGoal: 2000, // TODO: Replace with user's actual goal
    );
  }
}
