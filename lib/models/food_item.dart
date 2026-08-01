import 'dart:convert';

class FoodItem {
  final String id;
  final String name;
  final String nameHindi;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final double fiber;
  final double sugar;
  final double servingSize;
  final String servingUnit;
  final String category;
  final List<String> aliases;
  final String brand;
  final bool isVerified;
  final String source;

  FoodItem({
    required this.id,
    required this.name,
    this.nameHindi = '',
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.fiber = 0,
    this.sugar = 0,
    required this.servingSize,
    required this.servingUnit,
    required this.category,
    this.aliases = const [],
    this.brand = '',
    this.isVerified = true,
    this.source = 'IFCT 2017',
  });

  // Convert to map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'name_hindi': nameHindi,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'fiber': fiber,
      'sugar': sugar,
      'serving_size': servingSize,
      'serving_unit': servingUnit,
      'category': category,
      'aliases': jsonEncode(aliases),
      'brand': brand,
      'is_verified': isVerified ? 1 : 0,
      'source': source,
    };
  }

  // Create from SQLite map
  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      id: map['id'],
      name: map['name'],
      nameHindi: map['name_hindi'] ?? '',
      calories: map['calories'].toDouble(),
      protein: map['protein'].toDouble(),
      carbs: map['carbs'].toDouble(),
      fat: map['fat'].toDouble(),
      fiber: map['fiber']?.toDouble() ?? 0,
      sugar: map['sugar']?.toDouble() ?? 0,
      servingSize: map['serving_size'].toDouble(),
      servingUnit: map['serving_unit'],
      category: map['category'],
      aliases: map['aliases'] == null
          ? []
          : List<String>.from(jsonDecode(map['aliases'])),

      brand: map['brand'] ?? '',
      isVerified: (map['is_verified'] ?? 1) == 1,
      source: map['source'] ?? 'IFCT 2017',
    );
  }

  // Scale nutrients by quantity
  FoodItem scaleBy(double multiplier) {
    return FoodItem(
      id: id,
      name: name,
      nameHindi: nameHindi,
      calories: calories * multiplier,
      protein: protein * multiplier,
      carbs: carbs * multiplier,
      fat: fat * multiplier,
      fiber: fiber * multiplier,
      sugar: sugar * multiplier,
      servingSize: servingSize * multiplier,
      servingUnit: servingUnit,
      category: category,
      aliases: aliases,
      brand: brand,
      isVerified: isVerified,
      source: source,
    );
  }
}
