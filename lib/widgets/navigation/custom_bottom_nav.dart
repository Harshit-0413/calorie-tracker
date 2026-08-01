import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class CustomBottomNav extends StatelessWidget {
  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.home_rounded, "Home"),
      (Icons.history_rounded, "History"),
      (Icons.insights_rounded, "Insights"),
      (Icons.person_rounded, "Profile"),
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppTheme.lg,
          0,
          AppTheme.lg,
          AppTheme.md,
        ),
        child: Container(
          height: 72,
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.radiusFull),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Row(
            children: List.generate(items.length, (index) {
              final selected = currentIndex == index;

              return Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                  onTap: () => onTap(index),
                  child: AnimatedContainer(
                    duration: AppTheme.normalAnimation,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          items[index].$1,
                          color: selected
                              ? AppTheme.primary
                              : AppTheme.textHint,
                        ),

                        const SizedBox(height: 4),

                        Text(
                          items[index].$2,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: selected
                                    ? AppTheme.primary
                                    : AppTheme.textHint,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
