import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class AICoachCard extends StatelessWidget {
  final String insight;

  const AICoachCard({super.key, required this.insight});

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
              const Icon(
                Icons.psychology_rounded,
                color: AppTheme.primary,
                size: 26,
              ),
              const SizedBox(width: AppTheme.sm),
              Text("AI Coach", style: Theme.of(context).textTheme.titleLarge),
            ],
          ),

          const SizedBox(height: AppTheme.lg),

          Text(insight, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
