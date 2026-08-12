part of 'meal_bloc.dart';

abstract class MealEvent extends Equatable {
  const MealEvent();

  @override
  List<Object?> get props => [];
}

class LoadMeals extends MealEvent {
  final String userId;
  final DateTime date;

  const LoadMeals({required this.userId, required this.date});

  @override
  List<Object?> get props => [userId, date];
}

class LogMealFromText extends MealEvent {
  final String userId;
  final String originalPrompt;
  final MealType mealType;

  const LogMealFromText({
    required this.userId,
    required this.originalPrompt,
    required this.mealType,
  });

  @override
  List<Object?> get props => [userId, originalPrompt, mealType];
}

class SaveMeal extends MealEvent {
  final MealLog meal;

  const SaveMeal(this.meal);

  @override
  List<Object?> get props => [meal];
}

class DeleteMeal extends MealEvent {
  final String mealId;
  final String userId;

  const DeleteMeal({required this.mealId, required this.userId});

  @override
  List<Object?> get props => [mealId, userId];
}

class GetHealthAnalysis extends MealEvent {
  final String userId;
  final DateTime date;

  const GetHealthAnalysis({required this.userId, required this.date});

  @override
  List<Object?> get props => [userId, date];
}

class UpdateMeal extends MealEvent {
  final MealLog meal;

  const UpdateMeal(this.meal);

  @override
  List<Object?> get props => [meal];
}
