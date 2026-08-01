import 'package:flutter/material.dart';

import '../../models/weekly_summary.dart';
import '../../theme/app_theme.dart';

class WeeklySummaryCard extends StatelessWidget {
  final WeeklySummary summary;

  const WeeklySummaryCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.lg),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("This Week", style: Theme.of(context).textTheme.headlineSmall),

          const SizedBox(height: AppTheme.lg),

          _StatRow(
            icon: Icons.local_fire_department_rounded,
            label: "Average Calories",
            value: "${summary.averageCalories.round()} kcal",
          ),

          _StatRow(
            icon: Icons.restaurant_rounded,
            label: "Meals Logged",
            value: summary.totalMeals.toString(),
          ),

          _StatRow(
            icon: Icons.calendar_today_rounded,
            label: "Active Days",
            value: "${summary.activeDays} / ${summary.periodDays} ",
          ),

          _StatRow(
            icon: Icons.check_circle_rounded,
            label: "Consistency",
            value: "${(summary.consistency * 100).round()}%",
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.sm),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primary),

          const SizedBox(width: AppTheme.md),

          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
          ),

          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
