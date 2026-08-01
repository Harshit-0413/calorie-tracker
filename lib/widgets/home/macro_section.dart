import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import 'macro_card.dart';

class MacroSection extends StatelessWidget {
  final double protein;
  final double carbs;
  final double fat;

  const MacroSection({
    super.key,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Today's Nutrition",
          style: Theme.of(context).textTheme.headlineMedium,
        ),

        const SizedBox(height: AppTheme.md),

        Row(
          children: [
            Expanded(
              child: MacroCard(
                title: "Protein",
                icon: "🥩",
                current: protein,
                goal: 120,
                color: AppTheme.proteinColor,
              ),
            ),

            const SizedBox(width: AppTheme.md),

            Expanded(
              child: MacroCard(
                title: "Carbs",
                icon: "🌾",
                current: carbs,
                goal: 250,
                color: AppTheme.carbsColor,
              ),
            ),

            const SizedBox(width: AppTheme.md),

            Expanded(
              child: MacroCard(
                title: "Fat",
                icon: "🥜",
                current: fat,
                goal: 70,
                color: AppTheme.fatColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
