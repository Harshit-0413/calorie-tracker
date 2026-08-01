import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class RecentMeals extends StatelessWidget {
  final List<String> meals;
  final ValueChanged<String>? onSelected;

  const RecentMeals({super.key, required this.meals, this.onSelected});

  @override
  Widget build(BuildContext context) {
    if (meals.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Recent", style: Theme.of(context).textTheme.titleLarge),

        const SizedBox(height: AppTheme.md),

        ...meals.map(
          (meal) => Padding(
            padding: const EdgeInsets.only(bottom: AppTheme.sm),
            child: InkWell(
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              onTap: () => onSelected?.call(meal),
              child: Container(
                padding: const EdgeInsets.all(AppTheme.md),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  boxShadow: AppTheme.softShadow,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.history, color: AppTheme.primary),

                    const SizedBox(width: AppTheme.md),

                    Expanded(
                      child: Text(
                        meal,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),

                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
