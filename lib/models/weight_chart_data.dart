import 'package:fl_chart/fl_chart.dart';

class WeightChartData {
  final List<FlSpot> spots;
  final List<DateTime> dates;
  final double minY;
  final double maxY;

  const WeightChartData({
    required this.spots,
    required this.dates,
    required this.minY,
    required this.maxY,
  });

  bool get isEmpty => spots.isEmpty;

  bool get hasSinglePoint => spots.length == 1;
}
