import 'package:flutter/material.dart';

import '../../models/food_item.dart';
import '../../theme/app_theme.dart';

class FoodResultTile extends StatelessWidget {
  final FoodItem food;
  final VoidCallback onTap;

  const FoodResultTile({super.key, required this.food, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppTheme.md),
        padding: const EdgeInsets.all(AppTheme.lg),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          boxShadow: AppTheme.softShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: .10),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.restaurant, color: AppTheme.primary),
            ),

            const SizedBox(width: AppTheme.md),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  if (food.nameHindi.isNotEmpty)
                    Text(
                      food.nameHindi,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),

                  const SizedBox(height: 4),

                  Text(
                    "${food.servingSize.toStringAsFixed(0)} ${food.servingUnit}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  food.calories.toStringAsFixed(0),
                  style: Theme.of(context).textTheme.titleMedium,
                ),

                Text("kcal", style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
