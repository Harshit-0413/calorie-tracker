import 'package:calorie_tracker/services/insights_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/meal/meal_bloc.dart';
import '../../blocs/user/user_bloc.dart';

import '../../screens/food/food_search.dart';
import '../../theme/app_theme.dart';

import '../../widgets/home/daily_insight_card.dart';
import '../../widgets/home/greeting_header.dart';
import '../../widgets/home/hero_calorie_card.dart';
import '../../widgets/home/journey_section.dart';
import '../../widgets/home/macro_section.dart';
import '../../widgets/home/quick_log_card.dart';
import '../../widgets/home/water_card.dart';

import '../../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    final uid = AuthService.instance.currentUserId;

    if (uid != null) {
      context.read<MealBloc>().add(
        LoadMeals(userId: uid, date: DateTime.now()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, userState) {
          if (userState is! UserLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          final profile = userState.profile;

          return BlocBuilder<MealBloc, MealState>(
            builder: (context, mealState) {
              int mealCount = 0;

              if (mealState is MealsLoaded) {
                mealCount = mealState.meals.length;
              }

              final insights = mealState is MealsLoaded
                  ? InsightsService.generateInsights(
                      meals: mealState.meals,
                      user: profile,
                    )
                  : null;

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.lg,
                  vertical: AppTheme.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const GreetingHeader(),

                    const SizedBox(height: AppTheme.xl),

                    QuickLogCard(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const FoodSearchScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: AppTheme.xl),

                    HeroCalorieCard(
                      consumed: insights?.caloriesConsumed ?? 0,
                      goal: insights?.calorieGoal ?? profile.dailyCalorieGoal,
                    ),

                    const SizedBox(height: AppTheme.xl),

                    MacroSection(
                      protein: insights?.proteinConsumed ?? 0,
                      carbs: insights?.carbsConsumed ?? 0,
                      fat: insights?.fatConsumed ?? 0,
                    ),

                    const SizedBox(height: AppTheme.xl),

                    JourneySection(mealCount: mealCount),

                    const SizedBox(height: AppTheme.xl),

                    DailyInsightCard(
                      message:
                          insights?.latestAIInsight ??
                          "Log your first meal today to receive personalized AI nutrition insights.",
                    ),

                    const SizedBox(height: AppTheme.xl),

                    const WaterCard(current: 5, goal: 8),

                    const SizedBox(height: 100),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
