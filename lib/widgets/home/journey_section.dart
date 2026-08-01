import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import 'meal_card.dart';

class JourneySection extends StatelessWidget {
  final int mealCount;

  const JourneySection({super.key, required this.mealCount});

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

        const MealCard(
          emoji: "☀️",
          title: "Breakfast",
          time: "--",
          calories: 0,
          items: [],
          logged: false,
        ),

        const MealCard(
          emoji: "🌤",
          title: "Lunch",
          time: "--",
          calories: 0,
          items: [],
          logged: false,
        ),

        const MealCard(
          emoji: "🌇",
          title: "Snack",
          time: "--",
          calories: 0,
          items: [],
          logged: false,
        ),

        const MealCard(
          emoji: "🌙",
          title: "Dinner",
          time: "--",
          calories: 0,
          items: [],
          logged: false,
        ),
      ],
    );
  }
}
