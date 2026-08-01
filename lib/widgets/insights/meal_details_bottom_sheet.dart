import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/meal_log.dart';
import '../../theme/app_theme.dart';

class MealDetailsBottomSheet extends StatelessWidget {
  final MealLog meal;

  const MealDetailsBottomSheet({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.8,
        minChildSize: 0.6,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppTheme.radiusLg),
              ),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(AppTheme.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDragHandle(),

                  const SizedBox(height: AppTheme.lg),

                  _buildHeader(context),

                  const SizedBox(height: AppTheme.xl),

                  _buildFoodSection(context),

                  const SizedBox(height: AppTheme.xl),

                  _buildNutritionSection(context),

                  const SizedBox(height: AppTheme.xl),

                  _buildAISection(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatMealType() {
    final name = meal.mealType.name;
    return name[0].toUpperCase() + name.substring(1);
  }

  Widget _buildDragHandle() {
    return Center(
      child: Container(
        width: 48,
        height: 5,
        decoration: BoxDecoration(
          color: AppTheme.divider,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _formatMealType(),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: AppTheme.xs),
        Text(
          DateFormat('EEEE • h:mm a').format(meal.loggedAt),
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
        ),
      ],
    );
  }

  Widget _buildFoodSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Foods", style: Theme.of(context).textTheme.titleLarge),

        const SizedBox(height: AppTheme.md),

        ...List.generate(meal.foodEntries.length, (index) {
          final entry = meal.foodEntries[index];
          final food = entry.scaledFood;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppTheme.sm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.restaurant_rounded,
                      color: AppTheme.primary,
                      size: 20,
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

                          const SizedBox(height: AppTheme.xs),

                          Text(
                            "${entry.quantity} ${entry.quantityUnit}",
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppTheme.textSecondary),
                          ),

                          const SizedBox(height: 2),

                          Text(
                            "${food.calories.toStringAsFixed(0)} kcal",
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppTheme.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              if (index != meal.foodEntries.length - 1)
                const Divider(color: AppTheme.divider),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildNutritionSection(BuildContext context) {
    Widget nutritionRow(String title, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppTheme.sm),
        child: Row(
          children: [
            Expanded(
              child: Text(title, style: Theme.of(context).textTheme.bodyMedium),
            ),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Nutrition", style: Theme.of(context).textTheme.titleLarge),

        const SizedBox(height: AppTheme.md),

        nutritionRow("Calories", "${meal.totalCalories.toInt()} kcal"),

        nutritionRow("Protein", "${meal.totalProtein.toStringAsFixed(1)} g"),

        nutritionRow("Carbs", "${meal.totalCarbs.toStringAsFixed(1)} g"),

        nutritionRow("Fat", "${meal.totalFat.toStringAsFixed(1)} g"),

        nutritionRow("Fiber", "${meal.totalFiber.toStringAsFixed(1)} g"),

        nutritionRow("Sugar", "${meal.totalSugar.toStringAsFixed(1)} g"),
      ],
    );
  }

  Widget _buildAISection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("AI Coach", style: Theme.of(context).textTheme.titleLarge),

        const SizedBox(height: AppTheme.md),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppTheme.md),
          decoration: BoxDecoration(
            color: AppTheme.background,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.auto_awesome_rounded, color: AppTheme.primary),

              const SizedBox(width: AppTheme.md),

              Expanded(
                child: Text(
                  meal.aiInsight.isEmpty
                      ? "No AI insight available for this meal yet."
                      : meal.aiInsight,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
