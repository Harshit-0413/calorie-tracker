import 'package:calorie_tracker/screens/food/food_search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../blocs/meal/meal_bloc.dart';
import '../../core/enums/meal_source.dart';
import '../../core/enums/meal_type.dart';
import '../../models/meal_log.dart';
import '../../services/auth_service.dart';
import '../../theme/app_theme.dart';

class MealBuilderScreen extends StatefulWidget {
  final MealType mealType;

  const MealBuilderScreen({super.key, required this.mealType});

  @override
  State<MealBuilderScreen> createState() => _MealBuilderScreenState();
}

class _MealBuilderScreenState extends State<MealBuilderScreen> {
  final List<MealFoodEntry> _currentMeal = [];

  final TextEditingController _promptController = TextEditingController();

  static const _uuid = Uuid();

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  double get totalCalories =>
      _currentMeal.fold(0, (sum, e) => sum + e.scaledFood.calories);

  double get totalProtein =>
      _currentMeal.fold(0, (sum, e) => sum + e.scaledFood.protein);

  double get totalCarbs =>
      _currentMeal.fold(0, (sum, e) => sum + e.scaledFood.carbs);

  double get totalFat =>
      _currentMeal.fold(0, (sum, e) => sum + e.scaledFood.fat);

  Future<void> _addFoodManually() async {
    final MealFoodEntry? entry = await Navigator.push<MealFoodEntry>(
      context,
      MaterialPageRoute(
        builder: (_) => FoodSearchScreen(mealType: widget.mealType),
      ),
    );

    if (entry == null) return;

    setState(() {
      _currentMeal.add(entry);
    });
  }

  void _increase(int index) {
    final entry = _currentMeal[index];

    final newQuantity = entry.quantity + 1;

    setState(() {
      _currentMeal[index] = MealFoodEntry(
        scaledFood: entry.scaledFood.scaleBy(newQuantity / entry.quantity),
        quantity: newQuantity,
        quantityUnit: entry.quantityUnit,
      );
    });
  }

  void _decrease(int index) {
    final entry = _currentMeal[index];

    if (entry.quantity <= 1) return;

    final newQuantity = entry.quantity - 1;

    setState(() {
      _currentMeal[index] = MealFoodEntry(
        scaledFood: entry.scaledFood.scaleBy(newQuantity / entry.quantity),
        quantity: newQuantity,
        quantityUnit: entry.quantityUnit,
      );
    });
  }

  void _delete(int index) {
    setState(() {
      _currentMeal.removeAt(index);
    });
  }

  void _finishMeal() {
    if (_currentMeal.isEmpty) return;

    final uid = AuthService.instance.currentUserId;

    if (uid == null) return;

    final now = DateTime.now();

    final meal = MealLog(
      id: _uuid.v4(),
      userId: uid,
      mealType: widget.mealType,
      source: MealSource.manual,
      foodEntries: List.of(_currentMeal),
      originalPrompt: _promptController.text.trim(),
      aiInsight: '',
      loggedAt: now,
      createdAt: now,
      updatedAt: now,
    );

    context.read<MealBloc>().add(SaveMeal(meal));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MealBloc, MealState>(
      listener: (context, state) {
        if (state is MealLogSuccess) {
          setState(() {
            _currentMeal.addAll(state.meal.foodEntries);
            _promptController.clear();
          });
        }

        if (state is MealsLoaded) {
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
        appBar: AppBar(title: Text("Log ${widget.mealType.displayName}")),
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
                        "What did you eat?",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),

                      const SizedBox(height: AppTheme.sm),

                      Text(
                        "Describe your meal naturally or add foods manually.",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),

                      const SizedBox(height: AppTheme.lg),

                      _buildPromptSection(),

                      const SizedBox(height: AppTheme.lg),

                      TextButton.icon(
                        onPressed: _addFoodManually,
                        icon: const Icon(Icons.add_rounded),
                        label: const Text("Add food manually"),
                      ),

                      const SizedBox(height: AppTheme.xl),

                      if (_currentMeal.isNotEmpty) ...[
                        Text(
                          "Current Meal",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),

                        const SizedBox(height: AppTheme.md),

                        ..._currentMeal.asMap().entries.map(
                          (e) => _buildMealTile(e.key, e.value),
                        ),

                        const SizedBox(height: AppTheme.xl),

                        _buildSummaryCard(),
                      ],
                    ],
                  ),
                ),
              ),

              _buildBottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  void _analyzeMeal() {
    final prompt = _promptController.text.trim();

    if (prompt.isEmpty) return;

    final uid = AuthService.instance.currentUserId;
    if (uid == null) return;

    context.read<MealBloc>().add(
      LogMealFromText(
        userId: uid,
        mealType: widget.mealType,
        originalPrompt: prompt,
      ),
    );
  }

  Widget _buildPromptSection() {
    return BlocBuilder<MealBloc, MealState>(
      builder: (context, state) {
        final loading = state is MealParsing;

        return Column(
          children: [
            TextField(
              controller: _promptController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: "e.g. 2 rotis, dal and paneer",
              ),
            ),

            const SizedBox(height: AppTheme.md),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: loading ? null : _analyzeMeal,
                icon: loading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.auto_awesome),
                label: Text(loading ? "Analyzing..." : "Analyze Meal"),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMealTile(int index, MealFoodEntry entry) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.md),
      child: ListTile(
        title: Text(entry.scaledFood.name),

        subtitle: Text(
          "${entry.quantity.toStringAsFixed(entry.quantity % 1 == 0 ? 0 : 1)} ${entry.quantityUnit}",
        ),

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => _decrease(index),
              icon: const Icon(Icons.remove_circle_outline),
            ),

            IconButton(
              onPressed: () => _increase(index),
              icon: const Icon(Icons.add_circle_outline),
            ),

            IconButton(
              onPressed: () => _delete(index),
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.lg),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.local_fire_department, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  "Meal Summary",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),

            const SizedBox(height: AppTheme.lg),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _MacroItem(
                  label: "Calories",
                  value: "${totalCalories.toInt()}",
                ),
                _MacroItem(
                  label: "Protein",
                  value: "${totalProtein.toStringAsFixed(1)}g",
                ),
                _MacroItem(
                  label: "Carbs",
                  value: "${totalCarbs.toStringAsFixed(1)}g",
                ),
                _MacroItem(
                  label: "Fat",
                  value: "${totalFat.toStringAsFixed(1)}g",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.lg),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _currentMeal.isEmpty ? null : _finishMeal,
            child: Text("Finish Meal (${_currentMeal.length})"),
          ),
        ),
      ),
    );
  }
}

class _MacroItem extends StatelessWidget {
  final String label;
  final String value;

  const _MacroItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
