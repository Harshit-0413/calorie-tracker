import 'package:flutter/material.dart';

import '../../core/enums/meal_type.dart';
import '../../models/meal_log.dart';
import '../../theme/app_theme.dart';
import 'meal_card.dart';

class JourneySection extends StatelessWidget {
  final List<MealLog> meals;
  final ValueChanged<MealType> onMealTap;

  const JourneySection({
    super.key,
    required this.meals,
    required this.onMealTap,
  });

  static const _mealMeta = [
    (MealType.breakfast, "☀️", "Breakfast"),
    (MealType.lunch, "🌤", "Lunch"),
    (MealType.snack, "🌇", "Snack"),
    (MealType.dinner, "🌙", "Dinner"),
  ];

  MealLog? _mealForType(MealType type) {
    try {
      return meals.firstWhere((meal) => meal.mealType == type);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Today's Journey",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.md,
                vertical: AppTheme.sm,
              ),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(AppTheme.radiusFull),
              ),
              child: Text(
                "${meals.length} meal${meals.length == 1 ? '' : 's'}",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),

        const SizedBox(height: AppTheme.md),

        ..._mealMeta.map((meta) {
          final type = meta.$1;
          final emoji = meta.$2;
          final title = meta.$3;

          final meal = _mealForType(type);

          return MealCard(
            emoji: emoji,
            title: title,
            meal: meal,
            onTap: () => onMealTap(type),
          );
        }),
      ],
    );
  }
}
