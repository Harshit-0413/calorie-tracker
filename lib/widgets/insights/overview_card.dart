import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class OverviewCard extends StatelessWidget {
  final double caloriesConsumed;
  final double calorieGoal;

  const OverviewCard({
    super.key,
    required this.caloriesConsumed,
    required this.calorieGoal,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (caloriesConsumed / calorieGoal).clamp(0.0, 1.0);

    final remaining = (calorieGoal - caloriesConsumed).clamp(0.0, calorieGoal);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.lg),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(
                Icons.local_fire_department_rounded,
                color: AppTheme.primary,
                size: 26,
              ),
              const SizedBox(width: AppTheme.sm),
              Text(
                "Daily Progress",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),

          const SizedBox(height: AppTheme.xl),

          // Calories
          Center(
            child: Column(
              children: [
                Text(
                  "${caloriesConsumed.toInt()} kcal",
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Consumed Today",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppTheme.lg),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radiusFull),
            child: SizedBox(
              height: 12,
              child: Stack(
                children: [
                  Container(color: AppTheme.divider),
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress,
                    child: Container(
                      decoration: const BoxDecoration(color: AppTheme.primary),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppTheme.md),

          // Percentage
          Center(
            child: Text(
              "${(progress * 100).toInt()}% of your daily goal",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),

          const SizedBox(height: AppTheme.lg),

          // Bottom Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Remaining",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    "${remaining.toInt()} kcal",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
              //TODO : TweenAnimationBuilder
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Goal", style: Theme.of(context).textTheme.bodySmall),
                  Text(
                    "${calorieGoal.toInt()} kcal",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
