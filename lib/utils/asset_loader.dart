import 'dart:convert';

import 'package:flutter/services.dart';

class AssetLoader {
  static const List<String> foodFiles = [
    'assets/data/staples.json',
    'assets/data/rice.json',
    'assets/data/dal.json',
    'assets/data/vegetables.json',
    'assets/data/fruits.json',
    'assets/data/paneer.json',
    'assets/data/chicken.json',
    'assets/data/eggs.json',
    'assets/data/fish.json',
    'assets/data/breakfast.json',
    'assets/data/snacks.json',
    'assets/data/drinks.json',
    'assets/data/desserts.json',
    'assets/data/street_food.json',
    'assets/data/restaurant.json',
  ];

  static Future<List<Map<String, dynamic>>> loadFoods() async {
    List<Map<String, dynamic>> foods = [];

    for (final file in foodFiles) {
      final jsonString = await rootBundle.loadString(file);

      final List<dynamic> data = jsonDecode(jsonString);

      foods.addAll(data.cast<Map<String, dynamic>>());
    }

    return foods;
  }
}
