import 'dart:convert';

import '../core/enums/meal_source.dart';
import '../core/enums/meal_type.dart';
import 'food_item.dart';

class MealLog {
  final String id;
  final String userId;

  final MealType mealType;
  final MealSource source;

  final List<MealFoodEntry> foodEntries;

  /// User's original input
  /// Example:
  /// "2 rotis, dal and paneer"
  final String originalPrompt;

  /// AI generated nutrition summary
  final String aiInsight;

  final DateTime loggedAt;

  /// Record timestamps
  final DateTime createdAt;
  final DateTime updatedAt;

  const MealLog({
    required this.id,
    required this.userId,
    required this.mealType,
    required this.source,
    required this.foodEntries,
    this.originalPrompt = '',
    this.aiInsight = '',
    required this.loggedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  // ===========================
  // Nutrition Getters
  // ===========================

  double get totalCalories =>
      foodEntries.fold(0, (sum, e) => sum + e.scaledFood.calories);

  double get totalProtein =>
      foodEntries.fold(0, (sum, e) => sum + e.scaledFood.protein);

  double get totalCarbs =>
      foodEntries.fold(0, (sum, e) => sum + e.scaledFood.carbs);

  double get totalFat =>
      foodEntries.fold(0, (sum, e) => sum + e.scaledFood.fat);

  double get totalFiber =>
      foodEntries.fold(0, (sum, e) => sum + e.scaledFood.fiber);

  double get totalSugar =>
      foodEntries.fold(0, (sum, e) => sum + e.scaledFood.sugar);

  // ===========================
  // SQLite
  // ===========================

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'meal_type': mealType.name,
      'meal_source': source.name,
      'food_entries': jsonEncode(foodEntries.map((e) => e.toMap()).toList()),
      'original_prompt': originalPrompt,
      'ai_insight': aiInsight,
      'logged_at': loggedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory MealLog.fromMap(Map<String, dynamic> map) {
    final entries = (jsonDecode(map['food_entries']) as List)
        .map((e) => MealFoodEntry.fromMap(e))
        .toList();

    return MealLog(
      id: map['id'],
      userId: map['user_id'],

      mealType: MealType.values.firstWhere((e) => e.name == map['meal_type']),

      source: MealSource.values.firstWhere((e) => e.name == map['meal_source']),

      foodEntries: entries,

      originalPrompt: map['original_prompt'] ?? '',
      aiInsight: map['ai_insight'] ?? '',

      loggedAt: DateTime.parse(map['logged_at']),

      createdAt: DateTime.parse(map['created_at']),

      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  // ===========================
  // CopyWith
  // ===========================

  MealLog copyWith({
    String? id,
    String? userId,
    MealType? mealType,
    MealSource? source,
    List<MealFoodEntry>? foodEntries,
    String? originalPrompt,
    String? aiInsight,
    DateTime? loggedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MealLog(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      mealType: mealType ?? this.mealType,
      source: source ?? this.source,
      foodEntries: foodEntries ?? this.foodEntries,
      originalPrompt: originalPrompt ?? this.originalPrompt,
      aiInsight: aiInsight ?? this.aiInsight,
      loggedAt: loggedAt ?? this.loggedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class MealFoodEntry {
  final FoodItem scaledFood;
  final double quantity;
  final String quantityUnit;

  const MealFoodEntry({
    required this.scaledFood,
    required this.quantity,
    required this.quantityUnit,
  });

  Map<String, dynamic> toMap() {
    return {
      'food': scaledFood.toMap(),
      'quantity': quantity,
      'quantity_unit': quantityUnit,
    };
  }

  factory MealFoodEntry.fromMap(Map<String, dynamic> map) {
    return MealFoodEntry(
      scaledFood: FoodItem.fromMap(map['food']),
      quantity: (map['quantity'] as num).toDouble(),
      quantityUnit: map['quantity_unit'],
    );
  }
}
