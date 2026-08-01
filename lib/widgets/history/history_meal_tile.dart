import 'package:flutter/material.dart';

import '../../models/meal_log.dart';
import '../../theme/app_theme.dart';

class HistoryMealTile extends StatelessWidget {
  final MealLog meal;
  final VoidCallback? onTap;

  const HistoryMealTile({super.key, required this.meal, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppTheme.md),
        padding: const EdgeInsets.all(AppTheme.lg),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: AppTheme.primary,
              child: Icon(Icons.restaurant, color: Colors.white),
            ),

            const SizedBox(width: AppTheme.md),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.mealType.name.toUpperCase(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    meal.foodEntries.map((e) => e.scaledFood.name).join(", "),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${meal.totalCalories.toStringAsFixed(0)} kcal",
                  style: Theme.of(context).textTheme.titleMedium,
                ),

                Text(
                  "${meal.loggedAt.hour.toString().padLeft(2, '0')}:${meal.loggedAt.minute.toString().padLeft(2, '0')}",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
