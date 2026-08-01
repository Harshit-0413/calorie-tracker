import 'package:calorie_tracker/core/enums/meal_type.dart';
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'meal_card.dart';

class JourneySection extends StatelessWidget {
  final int mealCount;
  final ValueChanged<MealType> onMealTap;

  const JourneySection({
    super.key,
    required this.mealCount,
    required this.onMealTap,
  });

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
                "$mealCount meal${mealCount == 1 ? '' : 's'}",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),

        const SizedBox(height: AppTheme.md),

        MealCard(
          emoji: "☀️",
          title: "Breakfast",
          time: "--",
          calories: 0,
          items: const [],
          logged: false,
          onTap: () => onMealTap(MealType.breakfast),
        ),

        MealCard(
          emoji: "🌤",
          title: "Lunch",
          time: "--",
          calories: 0,
          items: const [],
          logged: false,
          onTap: () => onMealTap(MealType.lunch),
        ),

        MealCard(
          emoji: "🌇",
          title: "Snack",
          time: "--",
          calories: 0,
          items: const [],
          logged: false,
          onTap: () => onMealTap(MealType.snack),
        ),

        MealCard(
          emoji: "🌙",
          title: "Dinner",
          time: "--",
          calories: 0,
          items: const [],
          logged: false,
          onTap: () => onMealTap(MealType.dinner),
        ),
      ],
    );
  }
}
