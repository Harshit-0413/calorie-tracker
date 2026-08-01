import 'package:calorie_tracker/models/weight_chart_data.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeightChart extends StatelessWidget {
  final WeightChartData data;
  final double height;

  const WeightChart({super.key, required this.data, required this.height});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const SizedBox(
        height: 220,
        child: Center(child: Text("No weight history available")),
      );
    }

    return SizedBox(
      height: height,
      child: LineChart(
        _buildChart(context),
        duration: const Duration(milliseconds: 450),
      ),
    );
  }

  LineChartData _buildChart(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return LineChartData(
      minY: data.minY,
      maxY: data.maxY,

      minX: 0,
      maxX: (data.spots.length - 1).toDouble(),

      gridData: const FlGridData(show: false),

      borderData: FlBorderData(show: false),

      titlesData: _titlesData(),

      lineTouchData: _touchData(context),

      lineBarsData: [_lineData(colorScheme)],
    );
  }

  LineChartBarData _lineData(ColorScheme colors) {
    return LineChartBarData(
      spots: data.spots,

      isCurved: true,

      curveSmoothness: 0.35,

      barWidth: 3,

      isStrokeCapRound: true,

      color: colors.primary,

      dotData: FlDotData(show: data.hasSinglePoint),

      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colors.primary.withValues(alpha: .30),
            colors.primary.withValues(alpha: .05),
          ],
        ),
      ),
    );
  }

  FlTitlesData _titlesData() {
    return FlTitlesData(
      topTitles: const AxisTitles(),

      rightTitles: const AxisTitles(),

      leftTitles: const AxisTitles(),

      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,

          interval: 1,

          reservedSize: 30,

          getTitlesWidget: (value, meta) {
            final index = value.toInt();

            if (index < 0 || index >= data.dates.length) {
              return const SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                DateFormat('dd MMM').format(data.dates[index]),
                style: const TextStyle(fontSize: 11),
              ),
            );
          },
        ),
      ),
    );
  }

  LineTouchData _touchData(BuildContext context) {
    return LineTouchData(
      handleBuiltInTouches: true,

      touchTooltipData: LineTouchTooltipData(
        fitInsideHorizontally: true,
        fitInsideVertically: true,

        getTooltipItems: (spots) {
          return spots.map((spot) {
            final index = spot.x.toInt();

            return LineTooltipItem(
              "${spot.y.toStringAsFixed(1)} kg\n"
              "${DateFormat('dd MMM yyyy').format(data.dates[index])}",
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            );
          }).toList();
        },
      ),
    );
  }
}
