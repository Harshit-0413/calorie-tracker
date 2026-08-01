part of 'goal_bloc.dart';

abstract class GoalState {
  const GoalState();
}

class GoalInitial extends GoalState {
  const GoalInitial();
}

class GoalLoading extends GoalState {
  const GoalLoading();
}

class GoalLoaded extends GoalState {
  final double calorieGoal;
  final double proteinGoal;
  final double carbsGoal;
  final double fatGoal;

  const GoalLoaded({
    required this.calorieGoal,
    required this.proteinGoal,
    required this.carbsGoal,
    required this.fatGoal,
  });
}

class GoalError extends GoalState {
  final String message;

  const GoalError(this.message);
}
