import 'package:flutter/material.dart';

import '../../core/enums/meal_type.dart';
import '../../models/food_item.dart';
import '../../models/meal_log.dart';
import '../../theme/app_theme.dart';

class FoodDetailScreen extends StatefulWidget {
  final FoodItem food;
  final MealType mealType;

  const FoodDetailScreen({
    super.key,
    required this.food,
    required this.mealType,
  });

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  double quantity = 1;

  double get calories => widget.food.calories * quantity;

  double get protein => widget.food.protein * quantity;

  double get carbs => widget.food.carbs * quantity;

  double get fat => widget.food.fat * quantity;

  double get fiber => widget.food.fiber * quantity;

  void _increase() {
    setState(() {
      quantity++;
    });
  }

  void _decrease() {
    if (quantity <= 1) return;

    setState(() {
      quantity--;
    });
  }

  void _addFood() {
    Navigator.pop(
      context,
      MealFoodEntry(
        scaledFood: widget.food.scaleBy(quantity),
        quantity: quantity,
        quantityUnit: widget.food.servingUnit,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(title: Text(widget.food.name)),

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
                      widget.food.name,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),

                    const SizedBox(height: AppTheme.sm),

                    Row(
                      children: [
                        Icon(Icons.verified, color: AppTheme.primary, size: 18),

                        const SizedBox(width: 6),

                        Text(
                          "Verified Food",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),

                    const SizedBox(height: AppTheme.xl),

                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppTheme.lg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Serving",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),

                            const SizedBox(height: AppTheme.sm),

                            Text(
                              "${widget.food.servingSize.toStringAsFixed(widget.food.servingSize % 1 == 0 ? 0 : 1)} ${widget.food.servingUnit}",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: AppTheme.lg),

                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppTheme.lg),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _MacroTile(
                                    title: "Calories",
                                    value: "${calories.toInt()}",
                                  ),
                                ),
                                Expanded(
                                  child: _MacroTile(
                                    title: "Protein",
                                    value: "${protein.toStringAsFixed(1)} g",
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: AppTheme.lg),

                            Row(
                              children: [
                                Expanded(
                                  child: _MacroTile(
                                    title: "Carbs",
                                    value: "${carbs.toStringAsFixed(1)} g",
                                  ),
                                ),
                                Expanded(
                                  child: _MacroTile(
                                    title: "Fat",
                                    value: "${fat.toStringAsFixed(1)} g",
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: AppTheme.lg),

                            Row(
                              children: [
                                Expanded(
                                  child: _MacroTile(
                                    title: "Fiber",
                                    value: "${fiber.toStringAsFixed(1)} g",
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: AppTheme.xl),

                    Text(
                      "Quantity",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),

                    const SizedBox(height: AppTheme.md),

                    Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.lg,
                          vertical: AppTheme.md,
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: _decrease,
                              icon: const Icon(Icons.remove_circle_outline),
                            ),

                            Expanded(
                              child: Center(
                                child: Text(
                                  quantity.toStringAsFixed(
                                    quantity % 1 == 0 ? 0 : 1,
                                  ),
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineSmall,
                                ),
                              ),
                            ),

                            IconButton(
                              onPressed: _increase,
                              icon: const Icon(Icons.add_circle_outline),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.lg),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _addFood,
                    child: Text("Add To ${widget.mealType.displayName}"),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MacroTile extends StatelessWidget {
  final String title;
  final String value;

  const _MacroTile({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(title, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
