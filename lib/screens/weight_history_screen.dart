import 'package:calorie_tracker/models/weight_chart_data.dart';
import 'package:calorie_tracker/models/weight_entry.dart';
import 'package:calorie_tracker/models/weight_progress.dart';
import 'package:calorie_tracker/theme/app_theme.dart';
import 'package:calorie_tracker/widgets/insights/weight_chart.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeightHistoryScreen extends StatelessWidget {
  final WeightProgress progress;
  final WeightChartData chartData;
  final List<WeightEntry> entries;

  const WeightHistoryScreen({
    super.key,
    required this.progress,
    required this.chartData,
    required this.entries,
  });

  @override
  Widget build(BuildContext context) {
    final sortedEntries = [...entries]
      ..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));

    return Scaffold(
      appBar: AppBar(title: const Text("Weight History")),
      body: entries.isEmpty
          ? const Center(
              child: Text(
                "No weight history yet.",
                style: TextStyle(fontSize: 16),
              ),
            )
          : SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(AppTheme.md),
                children: [
                  // Header
                  Text(
                    "${progress.currentWeight.toStringAsFixed(1)} kg",
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "Current Weight",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: progress.change >= 0
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          progress.change >= 0
                              ? Icons.trending_up
                              : Icons.trending_down,
                          color: progress.change >= 0
                              ? Colors.green
                              : Colors.red,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${progress.change >= 0 ? '+' : ''}${progress.change.toStringAsFixed(1)} kg since you started",
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: progress.change >= 0
                                    ? Colors.green
                                    : Colors.red,
                              ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Chart
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppTheme.md),
                      child: WeightChart(data: chartData, height: 320),
                    ),
                  ),

                  const SizedBox(height: 32),

                  Text(
                    "Weight Entries",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  ...sortedEntries.map(
                    (entry) => Card(
                      elevation: 0,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: CircleAvatar(
                          backgroundColor: AppTheme.primary.withValues(
                            alpha: .1,
                          ),
                          child: const Icon(
                            Icons.monitor_weight_outlined,
                            color: AppTheme.primary,
                          ),
                        ),
                        title: Text(
                          "${entry.weightKg.toStringAsFixed(1)} kg",
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          DateFormat("dd MMM yyyy").format(entry.recordedAt),
                        ),
                        trailing: const Icon(Icons.chevron_right, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // We'll implement Add Weight later.
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
