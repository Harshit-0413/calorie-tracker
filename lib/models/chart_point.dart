import 'package:flutter/material.dart';

class ChartPoint {
  final Offset offset;
  final double value;
  final String label;

  const ChartPoint({
    required this.offset,
    required this.value,
    required this.label,
  });
}
