import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/meal_log.dart';
import '../../theme/app_theme.dart';

class MealCard extends StatelessWidget {
  const MealCard({
    super.key,
    required this.emoji,
    required this.title,
    required this.meal,
    this.onTap,
  });

  final String emoji;
  final String title;
  final MealLog? meal;
  final VoidCallback? onTap;

  bool get _logged => meal != null;

  @override
  Widget build(BuildContext context) {
    final foodNames =
        meal?.foodEntries.map((e) => e.scaledFood.name).toList() ?? [];

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        child: Container(
          margin: const EdgeInsets.only(bottom: AppTheme.md),
          padding: const EdgeInsets.all(AppTheme.md),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            boxShadow: AppTheme.softShadow,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 26)),

              const SizedBox(width: AppTheme.md),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),

                        const Spacer(),

                        Text(
                          _logged
                              ? DateFormat.jm().format(meal!.loggedAt)
                              : "--",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),

                    const SizedBox(height: AppTheme.sm),

                    if (_logged)
                      ...foodNames.map(
                        (food) => Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Text(
                            food,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      )
                    else
                      Text(
                        "Tap to log your $title",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),

                    const SizedBox(height: AppTheme.md),

                    Row(
                      children: [
                        Text(
                          _logged
                              ? "${meal!.totalCalories.toInt()} kcal"
                              : "+ Log Meal",
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: AppTheme.primary),
                        ),

                        const Spacer(),

                        Icon(
                          _logged
                              ? Icons.chevron_right
                              : Icons.add_circle_outline,
                          color: AppTheme.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
