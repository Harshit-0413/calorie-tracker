import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/user/user_bloc.dart';
import '../../core/enums/activity_level.dart';
import '../../core/enums/gender.dart';
import '../../core/enums/goal.dart';
import '../../models/user_profile.dart';
import '../../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is! UserLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          final profile = state.profile;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Profile",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: AppTheme.xl),

                _buildHeader(context, profile),
                const SizedBox(height: AppTheme.xl),

                _buildStatsCard(context, profile),
                const SizedBox(height: AppTheme.lg),

                _buildGoalsCard(context, profile),
                const SizedBox(height: AppTheme.xl),

                const SizedBox(height: AppTheme.lg),

                const SizedBox(height: AppTheme.xl),

                _buildSignOutButton(context),
                const SizedBox(height: AppTheme.xxl),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, UserProfile profile) {
    return Row(
      children: [
        CircleAvatar(
          radius: 32,
          backgroundColor: AppTheme.primaryLight,
          backgroundImage: profile.photoUrl.isNotEmpty
              ? NetworkImage(profile.photoUrl)
              : null,
          child: profile.photoUrl.isEmpty
              ? Text(
                  profile.name.isNotEmpty ? profile.name[0].toUpperCase() : '?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : null,
        ),
        const SizedBox(width: AppTheme.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(profile.name, style: Theme.of(context).textTheme.titleLarge),
              Text(
                profile.email,
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  double _calculateBMI(UserProfile profile) {
    final heightInMeters = profile.heightCm / 100;
    return profile.weightKg / (heightInMeters * heightInMeters);
  }

  String _bmiCategory(double bmi) {
    if (bmi < 18.5) return "Underweight";
    if (bmi < 25) return "Normal";
    if (bmi < 30) return "Overweight";
    return "Obese";
  }

  Color _bmiColor(double bmi) {
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 25) return Colors.green;
    if (bmi < 30) return Colors.orange;
    return Colors.red;
  }

  Widget _buildStatsCard(BuildContext context, UserProfile profile) {
    final bmi = _calculateBMI(profile);

    return Container(
      padding: const EdgeInsets.all(AppTheme.md),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Body Metrics",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextButton.icon(
                onPressed: () => _openEditSheet(context, profile),
                icon: const Icon(
                  Icons.edit_rounded,
                  size: 18,
                  color: AppTheme.primary,
                ),
                label: const Text("Edit"),
              ),
            ],
          ),

          const SizedBox(height: AppTheme.md),

          _statRow(context, "Age", "${profile.age} yrs"),

          _statRow(context, "Gender", _genderLabel(profile.gender)),

          _statRow(
            context,
            "Weight",
            "${profile.weightKg.toStringAsFixed(0)} kg",
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: AppTheme.sm),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "BMI",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _bmiColor(bmi).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "${bmi.toStringAsFixed(1)} • ${_bmiCategory(bmi)}",
                    style: TextStyle(
                      color: _bmiColor(bmi),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          _statRow(
            context,
            "Height",
            "${profile.heightCm.toStringAsFixed(0)} cm",
          ),

          _statRow(context, "Goal", _goalLabel(profile.goal)),

          _statRow(
            context,
            "Activity",
            _activityLabel(profile.activityLevel),
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _statRow(
    BuildContext context,
    String label,
    String value, {
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : AppTheme.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
          ),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsCard(BuildContext context, UserProfile profile) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.md),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Daily Targets", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppTheme.md),
          _statRow(
            context,
            "Calories",
            "${profile.dailyCalorieGoal.toStringAsFixed(0)} kcal",
          ),
          _statRow(
            context,
            "Protein",
            "${profile.dailyProteinGoal.toStringAsFixed(0)} g",
          ),
          _statRow(
            context,
            "Carbs",
            "${profile.dailyCarbsGoal.toStringAsFixed(0)} g",
          ),
          _statRow(
            context,
            "Fat",
            "${profile.dailyFatGoal.toStringAsFixed(0)} g",
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSignOutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: () => _confirmSignOut(context),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTheme.error,
          side: const BorderSide(color: AppTheme.error),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusFull),
          ),
        ),
        icon: const Icon(Icons.logout_rounded),
        label: const Text("Sign Out"),
      ),
    );
  }

  void _confirmSignOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        ),
        title: const Text("Sign Out"),
        content: const Text("Are you sure you want to sign out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<AuthBloc>().add(AuthSignedOut());
            },
            child: const Text(
              "Sign Out",
              style: TextStyle(color: AppTheme.error),
            ),
          ),
        ],
      ),
    );
  }

  void _openEditSheet(BuildContext context, UserProfile profile) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.88,
        child: _EditStatsSheet(profile: profile),
      ),
    );
  }

  String _genderLabel(Gender g) => switch (g) {
    Gender.male => "Male",
    Gender.female => "Female",
    Gender.other => "Other",
  };

  String _goalLabel(Goal g) => switch (g) {
    Goal.loseWeight => "Lose Weight",
    Goal.maintain => "Maintain Weight",
    Goal.gainWeight => "Gain Weight",
  };

  String _activityLabel(ActivityLevel a) => switch (a) {
    ActivityLevel.sedentary => "Sedentary",
    ActivityLevel.light => "Lightly Active",
    ActivityLevel.moderate => "Moderately Active",
    ActivityLevel.active => "Very Active",
    ActivityLevel.veryActive => "Extremely Active",
  };
}

class _EditStatsSheet extends StatefulWidget {
  final UserProfile profile;

  const _EditStatsSheet({required this.profile});

  @override
  State<_EditStatsSheet> createState() => _EditStatsSheetState();
}

class _EditStatsSheetState extends State<_EditStatsSheet> {
  late final TextEditingController _ageController;
  late final TextEditingController _weightController;
  late final TextEditingController _heightController;

  late Gender _gender;
  late Goal _goal;
  late ActivityLevel _activityLevel;

  @override
  void initState() {
    super.initState();
    _ageController = TextEditingController(text: widget.profile.age.toString());
    _weightController = TextEditingController(
      text: widget.profile.weightKg.toStringAsFixed(0),
    );
    _heightController = TextEditingController(
      text: widget.profile.heightCm.toStringAsFixed(0),
    );
    _gender = widget.profile.gender;
    _goal = widget.profile.goal;
    _activityLevel = widget.profile.activityLevel;
  }

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _save() {
    final age = int.tryParse(_ageController.text) ?? widget.profile.age;
    final weight =
        double.tryParse(_weightController.text) ?? widget.profile.weightKg;
    final height =
        double.tryParse(_heightController.text) ?? widget.profile.heightCm;

    final updated = UserProfile.withCalculatedGoals(
      uid: widget.profile.uid,
      name: widget.profile.name,
      email: widget.profile.email,
      photoUrl: widget.profile.photoUrl,
      gender: _gender,
      weightKg: weight,
      heightCm: height,
      age: age,
      goal: _goal,
      activityLevel: _activityLevel,
    );

    context.read<UserBloc>().add(UpdateUser(updated));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile updated successfully")),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.lg),
        decoration: const BoxDecoration(
          color: AppTheme.background,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppTheme.radiusLg),
          ),
        ),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.divider,
                      borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.lg),
                Row(
                  children: [
                    const Icon(Icons.edit_rounded, color: AppTheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      "Edit Profile",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.lg),

                _label(context, "Age"),
                const SizedBox(height: AppTheme.sm),

                TextField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.calendar_month_outlined),
                    hintText: "Age",
                  ),
                ),

                const SizedBox(height: AppTheme.md),

                _label(context, "Weight (kg)"),
                const SizedBox(height: AppTheme.sm),

                TextField(
                  controller: _weightController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.monitor_weight_outlined),
                    hintText: "Weight",
                  ),
                ),

                const SizedBox(height: AppTheme.md),

                _label(context, "Height (cm)"),
                const SizedBox(height: AppTheme.sm),

                TextField(
                  controller: _heightController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.straighten_rounded),
                    hintText: "Height",
                  ),
                ),

                const SizedBox(height: AppTheme.md),
                const SizedBox(height: AppTheme.lg),

                Divider(),

                const SizedBox(height: AppTheme.lg),
                _label(context, "Gender"),
                const SizedBox(height: AppTheme.sm),

                Row(
                  children: Gender.values.map((g) {
                    final selected = _gender == g;

                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: OutlinedButton(
                          onPressed: () => setState(() => _gender = g),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(52),
                            backgroundColor: selected
                                ? AppTheme.primary
                                : Colors.transparent,
                            foregroundColor: selected
                                ? Colors.white
                                : AppTheme.charcoal,
                            side: BorderSide(
                              color: selected
                                  ? AppTheme.primary
                                  : AppTheme.charcoal,
                              width: 1.5,
                            ),
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              _genderText(g),
                              maxLines: 1,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: AppTheme.md),
                const SizedBox(height: AppTheme.lg),

                Divider(),

                const SizedBox(height: AppTheme.lg),

                _label(context, "Goal"),
                const SizedBox(height: AppTheme.sm),

                DropdownButtonFormField<Goal>(
                  initialValue: _goal,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.flag_outlined),
                    border: OutlineInputBorder(),
                  ),
                  items: Goal.values.map((g) {
                    return DropdownMenuItem(
                      value: g,
                      child: Text(_goalText(g)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _goal = value);
                    }
                  },
                ),

                const SizedBox(height: AppTheme.sm),

                _label(context, "Activity Level"),
                const SizedBox(height: AppTheme.sm),

                DropdownButtonFormField<ActivityLevel>(
                  initialValue: _activityLevel,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.directions_run_outlined),
                    border: OutlineInputBorder(),
                  ),
                  items: ActivityLevel.values.map((a) {
                    return DropdownMenuItem(
                      value: a,
                      child: Text(_activityText(a)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _activityLevel = value);
                    }
                  },
                ),

                const SizedBox(height: AppTheme.lg),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text(
                      "Save Changes",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.md),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: AppTheme.textSecondary,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  String _genderText(Gender g) => switch (g) {
    Gender.male => "Male",
    Gender.female => "Female",
    Gender.other => "Other",
  };

  String _goalText(Goal g) => switch (g) {
    Goal.loseWeight => "Lose Weight",
    Goal.maintain => "Maintain Weight",
    Goal.gainWeight => "Gain Weight",
  };

  String _activityText(ActivityLevel a) => switch (a) {
    ActivityLevel.sedentary => "Sedentary",
    ActivityLevel.light => "Lightly Active",
    ActivityLevel.moderate => "Moderately Active",
    ActivityLevel.active => "Very Active",
    ActivityLevel.veryActive => "Extremely Active",
  };
}
