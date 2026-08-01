class WeightEntry {
  final int? id;
  final String userId;
  final double weightKg;
  final DateTime recordedAt;

  const WeightEntry({
    this.id,
    required this.userId,
    required this.weightKg,
    required this.recordedAt,
  });

  WeightEntry copyWith({
    int? id,
    String? userId,
    double? weightKg,
    DateTime? recordedAt,
  }) {
    return WeightEntry(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      weightKg: weightKg ?? this.weightKg,
      recordedAt: recordedAt ?? this.recordedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'weight_kg': weightKg,
      'recorded_at': recordedAt.toIso8601String(),
    };
  }

  factory WeightEntry.fromMap(Map<String, dynamic> map) {
    return WeightEntry(
      id: map['id'] as int?,
      userId: map['user_id'] as String,
      weightKg: (map['weight_kg'] as num).toDouble(),
      recordedAt: DateTime.parse(map['recorded_at'] as String),
    );
  }

  @override
  String toString() {
    return 'WeightEntry('
        'id: $id, '
        'userId: $userId, '
        'weightKg: $weightKg, '
        'recordedAt: $recordedAt'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WeightEntry &&
        other.id == id &&
        other.userId == userId &&
        other.weightKg == weightKg &&
        other.recordedAt == recordedAt;
  }

  @override
  int get hashCode => Object.hash(id, userId, weightKg, recordedAt);
}
