import 'package:calorie_tracker/models/weight_chart_data.dart';
import 'package:flutter/material.dart';

import '../../models/weight_progress.dart';
import '../../theme/app_theme.dart';
import 'weight_chart.dart';

class WeightProgressCard extends StatelessWidget {
  final VoidCallback? onTap;
  final WeightProgress progress;
  final WeightChartData chartData;

  const WeightProgressCard({
    super.key,
    required this.progress,
    required this.chartData,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          boxShadow: AppTheme.softShadow,
        ),

        child: InkWell(
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.monitor_weight_outlined,
                      color: AppTheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Weight Progress",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.lg),

                WeightChart(data: chartData, height: 220),

                const SizedBox(height: AppTheme.lg),

                Row(
                  children: [
                    _statTile(
                      context,
                      label: "Current",
                      value: "${progress.currentWeight.toStringAsFixed(1)} kg",
                    ),
                    const SizedBox(width: AppTheme.md),
                    _statTile(
                      context,
                      label: "Goal",
                      value: "${progress.goalWeight.toStringAsFixed(1)} kg",
                    ),
                  ],
                ),

                const SizedBox(height: AppTheme.lg),

                Row(
                  children: [
                    _statTile(
                      context,
                      label: "Started",
                      value: "${progress.startingWeight.toStringAsFixed(1)} kg",
                    ),
                    const SizedBox(width: AppTheme.md),
                    _statTile(
                      context,
                      label: "Change",
                      value:
                          "${progress.change >= 0 ? '+' : ''}${progress.change.toStringAsFixed(1)} kg",
                    ),
                  ],
                ),

                const SizedBox(height: AppTheme.lg),

                const Divider(),

                const SizedBox(height: AppTheme.sm),

                Text(
                  "Last updated",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  "${progress.lastUpdated.day}/${progress.lastUpdated.month}/${progress.lastUpdated.year}",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statTile(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
