import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class MealInputCard extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback? onClear;
  final ValueChanged<String>? onChanged;

  const MealInputCard({
    super.key,
    required this.controller,
    required this.focusNode,
    this.onClear,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(AppTheme.lg),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(
          color: focusNode.hasFocus ? AppTheme.primary : AppTheme.divider,
          width: 1.4,
        ),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Describe your meal",
            style: Theme.of(context).textTheme.titleMedium,
          ),

          const SizedBox(height: AppTheme.md),

          TextField(
            controller: controller,
            focusNode: focusNode,
            minLines: 4,
            maxLines: 8,
            onChanged: onChanged,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText:
                  "Example:\n\n2 rotis\n1 bowl dal\n100g paneer\n1 glass milk",
              suffixIcon: controller.text.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: onClear,
                    ),
            ),
          ),

          const SizedBox(height: AppTheme.md),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _ExampleChip("2 rotis + dal"),
              _ExampleChip("Poha & chai"),
              _ExampleChip("Chicken biryani"),
              _ExampleChip("Banana shake"),
            ],
          ),

          const SizedBox(height: AppTheme.md),

          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "${controller.text.length}/500",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExampleChip extends StatelessWidget {
  final String text;

  const _ExampleChip(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.md,
        vertical: AppTheme.sm,
      ),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(AppTheme.radiusFull),
      ),
      child: Text(text, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}
