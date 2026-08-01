import '../models/user_profile.dart';
import '../models/weight_entry.dart';
import '../models/weight_progress.dart';

import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';

import '../models/weight_chart_data.dart';

class WeightProgressService {
  const WeightProgressService();

  static WeightProgress calculate({
    required List<WeightEntry> entries,
    required UserProfile profile,
  }) {
    if (entries.isEmpty) {
      return WeightProgress(
        currentWeight: profile.weightKg,
        startingWeight: profile.weightKg,
        goalWeight: _goalWeight(profile),
        lastUpdated: DateTime.now(),
      );
    }

    final sortedEntries = List<WeightEntry>.from(entries)
      ..sort((a, b) => a.recordedAt.compareTo(b.recordedAt));

    final first = sortedEntries.first;
    final latest = sortedEntries.last;

    return WeightProgress(
      currentWeight: latest.weightKg,
      startingWeight: first.weightKg,
      goalWeight: _goalWeight(profile),
      lastUpdated: latest.recordedAt,
    );
  }

  static double _goalWeight(UserProfile profile) {
    // Temporary implementation.
    // We'll replace this later when users can set a target weight.
    return profile.weightKg;
  }

  static WeightChartData buildChartData(List<WeightEntry> entries) {
    if (entries.isEmpty) {
      return const WeightChartData(spots: [], dates: [], minY: 0, maxY: 0);
    }

    final sortedEntries = [...entries]
      ..sort((a, b) => a.recordedAt.compareTo(b.recordedAt));

    final spots = <FlSpot>[];

    double minWeight = sortedEntries.first.weightKg;
    double maxWeight = sortedEntries.first.weightKg;

    for (int i = 0; i < sortedEntries.length; i++) {
      final weight = sortedEntries[i].weightKg;

      spots.add(FlSpot(i.toDouble(), weight));

      minWeight = math.min(minWeight, weight);
      maxWeight = math.max(maxWeight, weight);
    }

    double padding = (maxWeight - minWeight) * 0.20;

    if (padding < 0.5) {
      padding = 0.5;
    }

    return WeightChartData(
      spots: spots,
      dates: sortedEntries.map((e) => e.recordedAt).toList(),
      minY: minWeight - padding,
      maxY: maxWeight + padding,
    );
  }
}
