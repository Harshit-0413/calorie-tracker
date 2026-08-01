import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/meal/meal_bloc.dart';
import '../../core/enums/meal_type.dart';
import '../../screens/food/meal_confirmation.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';

import '../../widgets/food/meal_input_card.dart';
import '../../widgets/food/meal_type_selector.dart';
import '../../widgets/food/recent_meals.dart';

class FoodSearchScreen extends StatefulWidget {
  const FoodSearchScreen({super.key});

  @override
  State<FoodSearchScreen> createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends State<FoodSearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  MealType _mealType = MealType.lunch;

  final List<String> _recentMeals = [
    "2 rotis, dal & paneer",
    "Poha & chai",
    "Chicken biryani",
    "Banana shake",
  ];

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _analyzeMeal() {
    if (_controller.text.trim().isEmpty) return;

    context.read<MealBloc>().add(
      LogMealFromText(
        userId: AuthService.instance.currentUserId!,
        originalPrompt: _controller.text.trim(),
        mealType: _mealType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MealBloc, MealState>(
      listener: (context, state) {
        if (state is MealLogSuccess) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MealConfirmationScreen(meal: state.meal),
            ),
          );
        }

        if (state is MealError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(title: const Text("Log Meal")),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "What did you eat today?",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),

                const SizedBox(height: AppTheme.sm),

                Text(
                  "Describe your meal naturally. I'll estimate nutrition for you.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                const SizedBox(height: AppTheme.xl),

                MealTypeSelector(
                  selected: _mealType,
                  onChanged: (meal) {
                    setState(() => _mealType = meal);
                  },
                ),

                const SizedBox(height: AppTheme.xl),

                MealInputCard(
                  controller: _controller,
                  focusNode: _focusNode,
                  onChanged: (_) => setState(() {}),
                  onClear: () {
                    _controller.clear();
                    setState(() {});
                  },
                ),

                const SizedBox(height: AppTheme.xl),

                RecentMeals(
                  meals: _recentMeals,
                  onSelected: (meal) {
                    _controller.text = meal;
                    setState(() {});
                  },
                ),

                const SizedBox(height: AppTheme.xl),

                BlocBuilder<MealBloc, MealState>(
                  builder: (context, state) {
                    final loading = state is MealLogging;

                    return SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: loading ? null : _analyzeMeal,
                        icon: loading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.auto_awesome),
                        label: Text(loading ? "Analyzing..." : "Analyze Meal"),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
