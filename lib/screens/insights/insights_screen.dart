import 'package:calorie_tracker/screens/weight_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/meal/meal_bloc.dart';
import '../../blocs/user/user_bloc.dart';
import '../../blocs/weight/weight_bloc.dart';

import '../../services/insights_service.dart';
import '../../services/weight_progress_service.dart';

import '../../theme/app_theme.dart';

import '../../widgets/insights/ai_coach_card.dart';
import '../../widgets/insights/macro_card.dart';
import '../../widgets/insights/meal_timeline_card.dart';
import '../../widgets/insights/nutrition_score_card.dart';
import '../../widgets/insights/overview_card.dart';
import '../../widgets/insights/weight_progress_card.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  bool _weightLoaded = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, userState) {
        if (userState is UserLoading || userState is UserInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (userState is! UserLoaded) {
          return const Center(child: Text("Unable to load profile."));
        }

        final profile = userState.profile;

        if (!_weightLoaded) {
          _weightLoaded = true;
          context.read<WeightBloc>().add(LoadWeightHistory(profile.uid));
        }

        return BlocBuilder<MealBloc, MealState>(
          builder: (context, mealState) {
            if (mealState is MealLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (mealState is! MealsLoaded) {
              return const Center(child: Text("No nutrition data available."));
            }

            final insights = InsightsService.generateInsights(
              meals: mealState.meals,
              user: profile,
            );

            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppTheme.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Insights",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),

                    const SizedBox(height: AppTheme.lg),

                    OverviewCard(
                      caloriesConsumed: insights.caloriesConsumed,
                      calorieGoal: insights.calorieGoal,
                    ),

                    const SizedBox(height: AppTheme.lg),

                    NutritionScoreCard(
                      score: insights.nutritionScore,
                      message: insights.nutritionMessage,
                    ),

                    const SizedBox(height: AppTheme.lg),

                    Row(
                      children: [
                        Expanded(
                          child: MacroCard(
                            title: "Protein",
                            value: insights.proteinConsumed,
                            goal: insights.proteinGoal,
                            color: AppTheme.proteinColor,
                            icon: Icons.fitness_center_rounded,
                          ),
                        ),
                        const SizedBox(width: AppTheme.md),
                        Expanded(
                          child: MacroCard(
                            title: "Carbs",
                            value: insights.carbsConsumed,
                            goal: insights.carbsGoal,
                            color: AppTheme.carbsColor,
                            icon: Icons.rice_bowl_rounded,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppTheme.md),

                    MacroCard(
                      title: "Fat",
                      value: insights.fatConsumed,
                      goal: insights.fatGoal,
                      color: AppTheme.fatColor,
                      icon: Icons.water_drop_rounded,
                    ),

                    const SizedBox(height: AppTheme.lg),

                    BlocBuilder<WeightBloc, WeightState>(
                      builder: (context, weightState) {
                        if (weightState is WeightLoading ||
                            weightState is WeightInitial) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (weightState is WeightLoaded) {
                          final progress = WeightProgressService.calculate(
                            entries: weightState.entries,
                            profile: profile,
                          );
                          final chartData =
                              WeightProgressService.buildChartData(
                                weightState.entries,
                              );

                          return WeightProgressCard(
                            progress: progress,
                            chartData: chartData,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => WeightHistoryScreen(
                                    progress: progress,
                                    chartData: chartData,
                                    entries: weightState.entries,
                                  ),
                                ),
                              );
                            },
                          );
                        }

                        if (weightState is WeightError) {
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(AppTheme.md),
                              child: Text(weightState.message),
                            ),
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),

                    const SizedBox(height: AppTheme.lg),

                    MealTimelineCard(meals: insights.mealTimeline),

                    const SizedBox(height: AppTheme.lg),

                    AICoachCard(insight: insights.latestAIInsight ?? ""),

                    const SizedBox(height: AppTheme.xxl),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
