import 'package:flutter/material.dart';

import '../../models/meal_log.dart';
import '../../theme/app_theme.dart';
import 'history_meal_tile.dart';

class HistoryDayCard extends StatelessWidget {
  final List<MealLog> meals;

  const HistoryDayCard({super.key, required this.meals});

  @override
  Widget build(BuildContext context) {
    if (meals.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppTheme.xl),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        ),
        child: const Center(child: Text("No meals logged.")),
      );
    }

    return Column(
      children: meals.map((meal) => HistoryMealTile(meal: meal)).toList(),
    );
  }
}
