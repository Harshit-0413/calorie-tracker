import 'dart:convert';

import 'package:flutter/material.dart';

import '../utils/asset_loader.dart';
import 'database_service.dart';

class DatabaseSeeder {
  final DatabaseService _databaseService;

  DatabaseSeeder(this._databaseService);

  Future<void> seedFoods() async {
    final db = await _databaseService.database;

    // Already seeded?
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM food_items',
    );

    final count = (result.first['count'] as num).toInt();

    if (count > 0) {
      debugPrint("Food database already seeded.");
      return;
    }

    final foods = await AssetLoader.loadFoods();

    final batch = db.batch();

    for (final food in foods) {
      batch.insert('food_items', {
        'id': food['id'],
        'name': food['name'],
        'name_hindi': food['nameHindi'],
        'aliases': jsonEncode(food['aliases']),
        'brand': food['brand'],
        'category': food['category'],
        'serving_size': food['servingSize'],
        'serving_unit': food['servingUnit'],
        'calories': food['calories'],
        'protein': food['protein'],
        'carbs': food['carbs'],
        'fat': food['fat'],
        'fiber': food['fiber'],
        'sugar': food['sugar'],
        'is_verified': food['isVerified'] ? 1 : 0,
        'source': food['source'],
      });
    }

    await batch.commit(noResult: true);

    debugPrint("Seeded ${foods.length} foods.");
  }
}
