import 'package:calorie_tracker/models/meal_timeline_item.dart';
import 'package:calorie_tracker/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'meal_details_bottom_sheet.dart';

class MealTimelineCard extends StatelessWidget {
  final List<MealTimelineItem> meals;

  const MealTimelineCard({super.key, required this.meals});

  IconData _mealIcon(String meal) {
    switch (meal.toLowerCase()) {
      case "breakfast":
        return Icons.free_breakfast_rounded;
      case "lunch":
        return Icons.lunch_dining_rounded;
      case "dinner":
        return Icons.dinner_dining_rounded;
      case "snack":
        return Icons.cookie_rounded;
      default:
        return Icons.restaurant_menu_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
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
          Row(
            children: [
              const Icon(Icons.timeline_rounded, color: AppTheme.primary),
              const SizedBox(width: AppTheme.sm),
              Text(
                "Meal Timeline",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),

          const SizedBox(height: AppTheme.lg),

          if (meals.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppTheme.xl),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.restaurant_menu_rounded,
                      size: 48,
                      color: AppTheme.textHint,
                    ),
                    const SizedBox(height: AppTheme.md),
                    Text(
                      "No meals logged today",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppTheme.xs),
                    Text(
                      "Start logging meals to unlock nutrition insights.",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            )
          else
            ...List.generate(meals.length, (index) {
              final meal = meals[index];

              return Column(
                children: [
                  AnimatedContainer(
                    duration: AppTheme.fastAnimation,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            useSafeArea: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) =>
                                MealDetailsBottomSheet(meal: meal.mealLog),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppTheme.sm,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: AppTheme.primary.withValues(
                                  alpha: 0.1,
                                ),
                                child: Icon(
                                  _mealIcon(meal.mealType),
                                  color: AppTheme.primary,
                                ),
                              ),

                              const SizedBox(width: AppTheme.md),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      meal.mealType,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),

                                    const SizedBox(height: AppTheme.xs),

                                    Text(
                                      DateFormat(
                                        'h:mm a',
                                      ).format(meal.loggedAt),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),

                                    const SizedBox(height: AppTheme.sm),

                                    Text(
                                      "${meal.calories.toInt()} kcal • ${meal.foodCount} ${meal.foodCount == 1 ? 'food' : 'foods'}",
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),

                              AnimatedSwitcher(
                                duration: AppTheme.fastAnimation,
                                child: const Icon(
                                  Icons.chevron_right_rounded,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  if (index != meals.length - 1)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppTheme.md),
                      child: Divider(),
                    ),
                ],
              );
            }),
        ],
      ),
    );
  }
}
