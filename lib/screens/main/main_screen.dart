import 'package:flutter/material.dart';

import '../home/home_screen.dart';
import '../history/meal_history_screen.dart';
import '../insights/insights_screen.dart';
import '../profile/profile_screen.dart';

import '../../widgets/navigation/custom_bottom_nav.dart';
import '../../theme/app_theme.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  late final List<Widget> pages = [
    const HomeScreen(),
    const MealHistoryScreen(),
    const InsightsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      body: IndexedStack(index: currentIndex, children: pages),

      bottomNavigationBar: CustomBottomNav(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
