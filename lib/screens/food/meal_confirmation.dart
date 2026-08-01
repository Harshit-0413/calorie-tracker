import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/meal/meal_bloc.dart';
import '../../models/meal_log.dart';
import '../../theme/app_theme.dart';

import '../../widgets/food/ad_insight_card.dart';
import '../../widgets/food/meal_food_cart.dart';
import '../../widgets/food/nutrition_summary.dart';

class MealConfirmationScreen extends StatelessWidget {
  final MealLog meal;

  const MealConfirmationScreen({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return BlocListener<MealBloc, MealState>(
      listener: (context, state) {
        if (state is MealsLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Meal saved successfully!"),
              duration: Duration(seconds: 2),
            ),
          );

          // Close Confirmation Screen
          Navigator.pop(context);

          // Close Food Search Screen
          Navigator.pop(context);
        }

        if (state is MealError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(title: const Text("Review Meal")),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppTheme.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "✨ AI recognized your meal",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),

                      const SizedBox(height: AppTheme.sm),

                      Text(
                        "Review everything before saving.",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),

                      const SizedBox(height: AppTheme.md),

                      Chip(
                        avatar: const Icon(Icons.restaurant_menu),
                        label: Text(meal.mealType.name.toUpperCase()),
                      ),

                      const SizedBox(height: AppTheme.xl),

                      ...meal.foodEntries.map(
                        (entry) => MealFoodCard(
                          entry: entry,

                          // Will implement editing later
                          onIncrease: () {},

                          onDecrease: () {},

                          onDelete: () {},
                        ),
                      ),

                      const SizedBox(height: AppTheme.lg),

                      NutritionSummary(
                        calories: meal.totalCalories,
                        protein: meal.totalProtein,
                        carbs: meal.totalCarbs,
                        fat: meal.totalFat,
                      ),

                      const SizedBox(height: AppTheme.lg),

                      AIInsightCard(
                        insight: meal.aiInsight.isEmpty
                            ? "Great meal! You're getting a balanced mix of nutrients. Keep logging meals and I'll provide more personalized nutrition insights over time."
                            : meal.aiInsight,
                      ),

                      const SizedBox(height: AppTheme.xl),
                    ],
                  ),
                ),
              ),

              SafeArea(
                top: false,
                child: Container(
                  padding: const EdgeInsets.all(AppTheme.lg),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    boxShadow: AppTheme.softShadow,
                  ),
                  child: BlocBuilder<MealBloc, MealState>(
                    builder: (context, state) {
                      final saving = state is MealSaving;

                      return SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: saving
                              ? null
                              : () {
                                  context.read<MealBloc>().add(SaveMeal(meal));
                                },
                          icon: saving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.check_circle),
                          label: Text(saving ? "Saving..." : "Save Meal"),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
