import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class WaterCard extends StatelessWidget {
  const WaterCard({super.key, required this.current, required this.goal});

  final int current;
  final int goal;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.lg),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.water_drop_rounded, color: AppTheme.waterColor),

              const SizedBox(width: AppTheme.sm),

              Text(
                "Water Intake",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),

          const SizedBox(height: AppTheme.lg),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(goal, (index) {
              final filled = index < current;

              return AnimatedContainer(
                duration: AppTheme.normalAnimation,
                width: 28,
                height: 40,
                decoration: BoxDecoration(
                  color: filled ? AppTheme.waterColor : AppTheme.divider,
                  borderRadius: BorderRadius.circular(12),
                ),
              );
            }),
          ),

          const SizedBox(height: AppTheme.md),

          Text(
            "$current of $goal glasses",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
