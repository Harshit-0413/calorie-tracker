part of 'goal_bloc.dart';

abstract class GoalEvent {
  const GoalEvent();
}

class LoadGoal extends GoalEvent {
  final String uid;

  const LoadGoal(this.uid);
}

class UpdateGoal extends GoalEvent {
  final String uid;
  final double calorieGoal;
  final double proteinGoal;
  final double carbsGoal;
  final double fatGoal;

  const UpdateGoal({
    required this.uid,
    required this.calorieGoal,
    required this.proteinGoal,
    required this.carbsGoal,
    required this.fatGoal,
  });
}
