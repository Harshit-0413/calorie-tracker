class WeightProgress {
  final double currentWeight;
  final double startingWeight;
  final double goalWeight;
  final DateTime lastUpdated;

  const WeightProgress({
    required this.currentWeight,
    required this.startingWeight,
    required this.goalWeight,
    required this.lastUpdated,
  });

  double get change => currentWeight - startingWeight;

  bool get isGain => change >= 0;
}
