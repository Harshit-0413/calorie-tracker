import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class NutritionSummary extends StatelessWidget {
  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  const NutritionSummary({
    super.key,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.lg),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Nutrition Summary",
            style: Theme.of(context).textTheme.titleLarge,
          ),

          const SizedBox(height: AppTheme.lg),

          Row(
            children: [
              Expanded(
                child: _NutritionTile(
                  icon: "🔥",
                  title: "Calories",
                  value: calories.toStringAsFixed(0),
                  color: AppTheme.primary,
                ),
              ),

              Expanded(
                child: _NutritionTile(
                  icon: "💪",
                  title: "Protein",
                  value: "${protein.toStringAsFixed(1)} g",
                  color: AppTheme.proteinColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppTheme.md),

          Row(
            children: [
              Expanded(
                child: _NutritionTile(
                  icon: "🌾",
                  title: "Carbs",
                  value: "${carbs.toStringAsFixed(1)} g",
                  color: AppTheme.carbsColor,
                ),
              ),

              Expanded(
                child: _NutritionTile(
                  icon: "🥑",
                  title: "Fat",
                  value: "${fat.toStringAsFixed(1)} g",
                  color: AppTheme.fatColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NutritionTile extends StatelessWidget {
  final String icon;
  final String title;
  final String value;
  final Color color;

  const _NutritionTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      padding: const EdgeInsets.all(AppTheme.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),

          const SizedBox(height: 8),

          Text(title, style: Theme.of(context).textTheme.bodySmall),

          const SizedBox(height: 4),

          Text(value, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}
