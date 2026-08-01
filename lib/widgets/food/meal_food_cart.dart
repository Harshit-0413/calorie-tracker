import 'package:flutter/material.dart';

import '../../models/meal_log.dart';
import '../../theme/app_theme.dart';

class MealFoodCard extends StatelessWidget {
  final MealFoodEntry entry;
  final VoidCallback? onIncrease;
  final VoidCallback? onDecrease;
  final VoidCallback? onDelete;

  const MealFoodCard({
    super.key,
    required this.entry,
    this.onIncrease,
    this.onDecrease,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.md),
      padding: const EdgeInsets.all(AppTheme.lg),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: .12),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text("🍽️", style: TextStyle(fontSize: 24)),
                ),
              ),

              const SizedBox(width: AppTheme.md),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.scaledFood.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "${entry.scaledFood.calories.toStringAsFixed(0)} kcal",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),

              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline),
              ),
            ],
          ),

          const SizedBox(height: AppTheme.lg),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _QuantityButton(icon: Icons.remove, onTap: onDecrease),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.lg),
                child: Text(
                  "${entry.quantity} ${entry.quantityUnit}",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),

              _QuantityButton(icon: Icons.add, onTap: onIncrease),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _QuantityButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppTheme.radiusFull),
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppTheme.background,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20),
      ),
    );
  }
}
