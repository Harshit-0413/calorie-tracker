import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../theme/app_theme.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/user/user_bloc.dart';
import '../../models/user_profile.dart';
import '../../core/enums/activity_level.dart';
import '../../core/enums/gender.dart';
import '../../core/enums/goal.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final PageController _pageController =
      PageController(); // always page 0 — this screen has one entry point
  int _currentPage = 0;

  String _name = '';
  int _age = 0;
  double _weightKg = 0;
  double _heightCm = 0;
  Gender _gender = Gender.male;
  Goal _goal = Goal.maintain;
  ActivityLevel _activityLevel = ActivityLevel.moderate;

  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  static const _pageCount = 4; // Personal, Body, Goal, Activity

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pageCount - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _submitOnboarding();
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _submitOnboarding() {
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated) {
      return; // shouldn't happen — this screen only builds when authenticated
    }

    final profile = UserProfile.withCalculatedGoals(
      uid: authState.uid,
      name: _name.isEmpty ? authState.name : _name,
      email: authState.email,
      photoUrl: authState.photoUrl,
      weightKg: _weightKg,
      heightCm: _heightCm,
      age: _age,
      goal: _goal,
      activityLevel: _activityLevel,
      gender: _gender,
    );

    context.read<UserBloc>().add(CreateUser(profile));
  }

  bool _canProceed() {
    switch (_currentPage) {
      case 0:
        return _nameController.text.isNotEmpty &&
            _ageController.text.isNotEmpty;
      case 1:
        return _weightController.text.isNotEmpty &&
            _heightController.text.isNotEmpty;
      case 2:
        return true;
      case 3:
        return true;
      default:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppTheme.error,
            ),
          );
        }
        // UserLoaded is handled by AppRouter, which will swap this screen for MainScreen.
      },
      child: Scaffold(
        backgroundColor: AppTheme.background,
        body: SafeArea(
          child: Column(
            children: [
              _buildProgressBar(),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) =>
                      setState(() => _currentPage = index),
                  children: [
                    _buildPersonalInfoPage(),
                    _buildBodyMeasurementsPage(),
                    _buildGoalPage(),
                    _buildActivityPage(),
                  ],
                ),
              ),
              _buildBottomNav(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppTheme.md,
        AppTheme.md,
        AppTheme.md,
        0,
      ),
      child: Row(
        children: List.generate(_pageCount, (index) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 4),
              height: 3,
              decoration: BoxDecoration(
                color: index <= _currentPage
                    ? AppTheme.primary
                    : AppTheme.divider,
                borderRadius: BorderRadius.circular(AppTheme.radiusFull),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.md),
      child: Row(
        children: [
          if (_currentPage > 0)
            GestureDetector(
              onTap: _prevPage,
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                  boxShadow: AppTheme.softShadow,
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: AppTheme.charcoal,
                ),
              ),
            ),
          if (_currentPage > 0) const SizedBox(width: AppTheme.sm),
          Expanded(
            child: SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _canProceed() ? _nextPage : null,
                child: Text(
                  _currentPage == _pageCount - 1 ? 'Get Started' : 'Continue',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoPage() {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.lg),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppTheme.xl),
            Text(
              'Tell us about\nyourself.',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: AppTheme.sm),
            Text(
              'This helps us calculate your daily calorie needs accurately.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: AppTheme.xl),
            _buildLabel('Your name'),
            const SizedBox(height: AppTheme.sm),
            TextField(
              controller: _nameController,
              onChanged: (v) => setState(() => _name = v),
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(hintText: 'e.g. Harshit'),
            ),
            const SizedBox(height: AppTheme.md),
            _buildLabel('Age'),
            const SizedBox(height: AppTheme.sm),
            TextField(
              controller: _ageController,
              onChanged: (v) => setState(() => _age = int.tryParse(v) ?? 0),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(hintText: 'e.g. 20'),
            ),
            const SizedBox(height: AppTheme.md),
            _buildLabel('Gender'),
            const SizedBox(height: AppTheme.sm),
            Row(
              children: [
                _buildSelectChip(
                  'Male',
                  Gender.male,
                  _gender,
                  (v) => setState(() => _gender = v),
                ),
                const SizedBox(width: AppTheme.sm),
                _buildSelectChip(
                  'Female',
                  Gender.female,
                  _gender,
                  (v) => setState(() => _gender = v),
                ),
                const SizedBox(width: AppTheme.sm),
                _buildSelectChip(
                  'Other',
                  Gender.other,
                  _gender,
                  (v) => setState(() => _gender = v),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyMeasurementsPage() {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.lg),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppTheme.xl),
            Text(
              'Your body\nmeasurements.',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: AppTheme.sm),
            Text(
              'Used to calculate your BMR and daily calorie needs.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: AppTheme.xl),
            _buildLabel('Weight (kg)'),
            const SizedBox(height: AppTheme.sm),
            TextField(
              controller: _weightController,
              onChanged: (v) =>
                  setState(() => _weightKg = double.tryParse(v) ?? 0),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(hintText: 'e.g. 68'),
            ),
            const SizedBox(height: AppTheme.md),
            _buildLabel('Height (cm)'),
            const SizedBox(height: AppTheme.sm),
            TextField(
              controller: _heightController,
              onChanged: (v) =>
                  setState(() => _heightCm = double.tryParse(v) ?? 0),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(hintText: 'e.g. 175'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalPage() {
    final goals = [
      {
        'value': Goal.loseWeight,
        'title': 'Lose Weight',
        'subtitle': 'Calorie deficit of 500 kcal/day',
        'icon': Icons.trending_down_rounded,
      },
      {
        'value': Goal.maintain,
        'title': 'Maintain Weight',
        'subtitle': 'Stay at your current weight',
        'icon': Icons.balance_rounded,
      },
      {
        'value': Goal.gainWeight,
        'title': 'Gain Weight',
        'subtitle': 'Calorie surplus of 500 kcal/day',
        'icon': Icons.trending_up_rounded,
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(AppTheme.lg),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppTheme.xl),
            Text(
              "What's your\ngoal?",
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: AppTheme.sm),
            Text(
              'We will set your daily targets accordingly.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: AppTheme.xl),
            ...goals.map(
              (g) => _buildGoalCard(
                value: g['value'] as Goal,
                title: g['title'] as String,
                subtitle: g['subtitle'] as String,
                icon: g['icon'] as IconData,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalCard({
    required Goal value,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = _goal == value;
    return GestureDetector(
      onTap: () => setState(() => _goal = value),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppTheme.sm),
        padding: const EdgeInsets.all(AppTheme.md),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          boxShadow: AppTheme.softShadow,
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.divider,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.2)
                    : AppTheme.background,
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AppTheme.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: AppTheme.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isSelected ? Colors.white : AppTheme.charcoal,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.8)
                          : AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: Colors.white,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityPage() {
    final levels = [
      {
        'value': ActivityLevel.sedentary,
        'title': 'Sedentary',
        'subtitle': 'Little or no exercise',
        'emoji': '🪑',
      },
      {
        'value': ActivityLevel.light,
        'title': 'Lightly Active',
        'subtitle': 'Light exercise 1–3 days/week',
        'emoji': '🚶',
      },
      {
        'value': ActivityLevel.moderate,
        'title': 'Moderately Active',
        'subtitle': 'Moderate exercise 3–5 days/week',
        'emoji': '🏃',
      },
      {
        'value': ActivityLevel.active,
        'title': 'Very Active',
        'subtitle': 'Hard exercise 6–7 days/week',
        'emoji': '💪',
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(AppTheme.lg),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppTheme.xl),
            Text(
              'How active\nare you?',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: AppTheme.sm),
            Text(
              'Be honest — this directly affects your calorie target.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: AppTheme.xl),
            ...levels.map(
              (l) => _buildActivityCard(
                value: l['value'] as ActivityLevel,
                title: l['title'] as String,
                subtitle: l['subtitle'] as String,
                emoji: l['emoji'] as String,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard({
    required ActivityLevel value,
    required String title,
    required String subtitle,
    required String emoji,
  }) {
    final isSelected = _activityLevel == value;
    return GestureDetector(
      onTap: () => setState(() => _activityLevel = value),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppTheme.sm),
        padding: const EdgeInsets.all(AppTheme.md),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          boxShadow: AppTheme.softShadow,
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.divider,
          ),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: AppTheme.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isSelected ? Colors.white : AppTheme.charcoal,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.8)
                          : AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle_rounded,
                color: Colors.white,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: AppTheme.textSecondary,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildSelectChip(
    String label,
    Gender value,
    Gender selected,
    ValueChanged<Gender> onTap,
  ) {
    final isSelected = selected == value;
    return GestureDetector(
      onTap: () => onTap(value),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.md,
          vertical: AppTheme.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusFull),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.divider,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isSelected ? Colors.white : AppTheme.charcoal,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
