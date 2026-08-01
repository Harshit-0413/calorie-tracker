import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class MacroCard extends StatelessWidget {
  const MacroCard({
    super.key,
    required this.title,
    required this.icon,
    required this.current,
    required this.goal,
    required this.color,
  });

  final String title;
  final String icon;
  final double current;
  final double goal;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final progress = goal == 0 ? 0.0 : (current / goal).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(AppTheme.md),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: AppTheme.sm),

          Text(title, style: Theme.of(context).textTheme.titleMedium),

          const SizedBox(height: AppTheme.md),

          Text(
            "${current.toStringAsFixed(0)} / ${goal.toStringAsFixed(0)} g",
            style: Theme.of(context).textTheme.bodySmall,
          ),

          const SizedBox(height: AppTheme.sm),

          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: AppTheme.divider,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    );
  }
}
