import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class MealCard extends StatelessWidget {
  const MealCard({
    super.key,
    required this.emoji,
    required this.title,
    required this.time,
    required this.items,
    required this.calories,
    this.logged = true,
  });

  final String emoji;
  final String title;
  final String time;
  final List<String> items;
  final int calories;
  final bool logged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.md),
      padding: const EdgeInsets.all(AppTheme.md),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        boxShadow: AppTheme.softShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 26)),

          const SizedBox(width: AppTheme.md),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),

                    const Spacer(),

                    Text(time, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),

                const SizedBox(height: AppTheme.sm),

                if (logged)
                  ...items.map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        e,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  )
                else
                  Text(
                    "Tap to log your $title",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),

                const SizedBox(height: AppTheme.md),

                Row(
                  children: [
                    Text(
                      logged ? "$calories kcal" : "+ Log Meal",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: logged ? AppTheme.primary : AppTheme.primary,
                      ),
                    ),

                    const Spacer(),

                    Icon(
                      logged ? Icons.chevron_right : Icons.add_circle_outline,
                      color: AppTheme.primary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
