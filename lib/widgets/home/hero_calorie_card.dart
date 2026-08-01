import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class HeroCalorieCard extends StatelessWidget {
  final double consumed;
  final double goal;

  const HeroCalorieCard({
    super.key,
    required this.consumed,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    final remaining = (goal - consumed).clamp(0, goal);
    final progress = goal == 0 ? 0.0 : (consumed / goal).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.xl),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 10,
                  backgroundColor: AppTheme.divider,
                  valueColor: const AlwaysStoppedAnimation(AppTheme.primary),
                ),
              ),

              const Text("🔥", style: TextStyle(fontSize: 42)),
            ],
          ),

          const SizedBox(height: AppTheme.lg),

          Text(
            remaining.toStringAsFixed(0),
            style: Theme.of(
              context,
            ).textTheme.displayLarge?.copyWith(fontSize: 44),
          ),

          Text(
            "kcal remaining",
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: AppTheme.textSecondary),
          ),

          const SizedBox(height: AppTheme.xl),

          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(value: progress, minHeight: 8),
          ),

          const SizedBox(height: AppTheme.md),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${consumed.toStringAsFixed(0)} consumed",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                "${goal.toStringAsFixed(0)} goal",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
