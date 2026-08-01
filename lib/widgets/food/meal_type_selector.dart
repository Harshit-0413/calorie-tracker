import 'package:flutter/material.dart';

import '../../core/enums/meal_type.dart';
import '../../theme/app_theme.dart';

class MealTypeSelector extends StatelessWidget {
  final MealType selected;
  final ValueChanged<MealType> onChanged;

  const MealTypeSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: MealType.values.map((meal) {
        final selectedChip = meal == selected;

        return ChoiceChip(
          label: Text((meal.displayName)),
          selected: selectedChip,
          onSelected: (_) => onChanged(meal),
          selectedColor: AppTheme.primary,
          backgroundColor: AppTheme.surface,
          labelStyle: TextStyle(
            color: selectedChip ? Colors.white : AppTheme.charcoal,
            fontWeight: FontWeight.w600,
          ),
        );
      }).toList(),
    );
  }
}
