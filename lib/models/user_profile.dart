import '../core/enums/activity_level.dart';
import '../core/enums/gender.dart';
import '../core/enums/goal.dart';

class UserProfile {
  final String uid;
  final String name;
  final String email;
  final String photoUrl;

  final Gender gender;

  final double weightKg;
  final double heightCm;
  final int age;

  final Goal goal;
  final ActivityLevel activityLevel;

  final double dailyCalorieGoal;
  final double dailyProteinGoal;
  final double dailyCarbsGoal;
  final double dailyFatGoal;

  const UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    this.photoUrl = '',
    required this.gender,
    required this.weightKg,
    required this.heightCm,
    required this.age,
    required this.goal,
    this.activityLevel = ActivityLevel.moderate,
    required this.dailyCalorieGoal,
    required this.dailyProteinGoal,
    required this.dailyCarbsGoal,
    required this.dailyFatGoal,
  });

  factory UserProfile.withCalculatedGoals({
    required String uid,
    required String name,
    required String email,
    String photoUrl = '',
    required Gender gender,
    required double weightKg,
    required double heightCm,
    required int age,
    required Goal goal,
    ActivityLevel activityLevel = ActivityLevel.moderate,
  }) {
    double bmr;

    switch (gender) {
      case Gender.male:
        bmr = (10 * weightKg) + (6.25 * heightCm) - (5 * age) + 5;
        break;

      case Gender.female:
        bmr = (10 * weightKg) + (6.25 * heightCm) - (5 * age) - 161;
        break;

      case Gender.other:
        bmr = (10 * weightKg) + (6.25 * heightCm) - (5 * age);
    }

    final multipliers = {
      ActivityLevel.sedentary: 1.2,
      ActivityLevel.light: 1.375,
      ActivityLevel.moderate: 1.55,
      ActivityLevel.active: 1.725,
      ActivityLevel.veryActive: 1.9,
    };

    final tdee = bmr * (multipliers[activityLevel] ?? 1.55);

    double calorieGoal = tdee;

    switch (goal) {
      case Goal.loseWeight:
        calorieGoal -= 500;
        break;

      case Goal.gainWeight:
        calorieGoal += 500;
        break;

      case Goal.maintain:
        break;
    }

    final proteinGoal = (calorieGoal * 0.30) / 4;
    final carbsGoal = (calorieGoal * 0.40) / 4;
    final fatGoal = (calorieGoal * 0.30) / 9;

    return UserProfile(
      uid: uid,
      name: name,
      email: email,
      photoUrl: photoUrl,
      gender: gender,
      weightKg: weightKg,
      heightCm: heightCm,
      age: age,
      goal: goal,
      activityLevel: activityLevel,
      dailyCalorieGoal: calorieGoal.roundToDouble(),
      dailyProteinGoal: proteinGoal.roundToDouble(),
      dailyCarbsGoal: carbsGoal.roundToDouble(),
      dailyFatGoal: fatGoal.roundToDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'photo_url': photoUrl,
      'gender': gender.name,
      'weight_kg': weightKg,
      'height_cm': heightCm,
      'age': age,
      'goal': goal.name,
      'activity_level': activityLevel.name,
      'daily_calorie_goal': dailyCalorieGoal,
      'daily_protein_goal': dailyProteinGoal,
      'daily_carbs_goal': dailyCarbsGoal,
      'daily_fat_goal': dailyFatGoal,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      photoUrl: map['photo_url'] ?? '',
      gender: Gender.values.firstWhere((e) => e.name == map['gender']),
      weightKg: (map['weight_kg'] as num).toDouble(),
      heightCm: (map['height_cm'] as num).toDouble(),
      age: map['age'],
      goal: Goal.values.firstWhere((e) => e.name == map['goal']),
      activityLevel: ActivityLevel.values.firstWhere(
        (e) => e.name == map['activity_level'],
      ),
      dailyCalorieGoal: (map['daily_calorie_goal'] as num).toDouble(),
      dailyProteinGoal: (map['daily_protein_goal'] as num).toDouble(),
      dailyCarbsGoal: (map['daily_carbs_goal'] as num).toDouble(),
      dailyFatGoal: (map['daily_fat_goal'] as num).toDouble(),
    );
  }
  UserProfile copyWith({
    String? uid,
    String? name,
    String? email,
    String? photoUrl,
    Gender? gender,
    double? weightKg,
    double? heightCm,
    int? age,
    Goal? goal,
    ActivityLevel? activityLevel,
    double? dailyCalorieGoal,
    double? dailyProteinGoal,
    double? dailyCarbsGoal,
    double? dailyFatGoal,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      gender: gender ?? this.gender,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      age: age ?? this.age,
      goal: goal ?? this.goal,
      activityLevel: activityLevel ?? this.activityLevel,
      dailyCalorieGoal: dailyCalorieGoal ?? this.dailyCalorieGoal,
      dailyProteinGoal: dailyProteinGoal ?? this.dailyProteinGoal,
      dailyCarbsGoal: dailyCarbsGoal ?? this.dailyCarbsGoal,
      dailyFatGoal: dailyFatGoal ?? this.dailyFatGoal,
    );
  }
}
