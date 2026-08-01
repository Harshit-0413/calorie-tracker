import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class GreetingHeader extends StatelessWidget {
  const GreetingHeader({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Good Morning ☀️";
    }

    if (hour < 17) {
      return "Good Afternoon 🌤";
    }

    if (hour < 21) {
      return "Good Evening 🌇";
    }

    return "Good Night 🌙";
  }

  String _subtitle() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Ready for a healthy day?";
    }

    if (hour < 17) {
      return "Let's keep the momentum going.";
    }

    if (hour < 21) {
      return "You're doing great today.";
    }

    return "Don't forget to log dinner.";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_greeting(), style: Theme.of(context).textTheme.displayMedium),

        const SizedBox(height: AppTheme.sm),

        Text(
          _subtitle(),
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: AppTheme.textSecondary),
        ),
      ],
    );
  }
}
