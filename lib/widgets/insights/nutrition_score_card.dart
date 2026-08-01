import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class NutritionScoreCard extends StatelessWidget {
  final int score;
  final String message;

  const NutritionScoreCard({
    super.key,
    required this.score,
    required this.message,
  });

  Color get scoreColor {
    if (score >= 80) return AppTheme.success;
    if (score >= 60) return AppTheme.warning;
    return AppTheme.error;
  }

  String get label {
    if (score >= 80) return "Excellent";
    if (score >= 60) return "Good";
    if (score >= 40) return "Needs Improvement";
    return "Poor";
  }

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
          Row(
            children: [
              Icon(Icons.star_rounded, color: scoreColor, size: 28),
              const SizedBox(width: AppTheme.sm),
              Text(
                "Nutrition Score",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),

          const SizedBox(height: AppTheme.xl),

          Center(
            child: Text(
              "$score / 100",
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: scoreColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          const SizedBox(height: AppTheme.sm),

          Center(
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: scoreColor),
            ),
          ),

          const SizedBox(height: AppTheme.lg),

          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
