import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class MacroCard extends StatelessWidget {
  final String title;
  final double value;
  final double goal;
  final Color color;
  final IconData icon;

  const MacroCard({
    super.key,
    required this.title,
    required this.value,
    required this.goal,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (value / goal).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(AppTheme.md),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),

          const SizedBox(height: AppTheme.sm),

          Text(title, style: Theme.of(context).textTheme.titleMedium),

          const SizedBox(height: AppTheme.md),

          Text(
            "${value.toInt()} / ${goal.toInt()} g",
            style: Theme.of(context).textTheme.bodyLarge,
          ),

          const SizedBox(height: AppTheme.md),

          ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radiusFull),
            child: SizedBox(
              height: 8,
              child: Stack(
                children: [
                  Container(color: AppTheme.divider),
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progress,
                    child: Container(color: color),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppTheme.sm),

          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "${(progress * 100).toInt()}%",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
