part of 'meal_bloc.dart';

abstract class MealState extends Equatable {
  const MealState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class MealInitial extends MealState {
  const MealInitial();
}

/// Loading meals from database (Home / History)
class MealLoading extends MealState {
  const MealLoading();
}

/// AI is analyzing the meal text
class MealParsing extends MealState {
  const MealParsing();
}

/// Meal is being saved to SQLite
class MealSaving extends MealState {
  const MealSaving();
}

/// Meals successfully loaded
class MealsLoaded extends MealState {
  final List<MealLog> meals;

  const MealsLoaded({required this.meals});

  factory MealsLoaded.fromMeals(List<MealLog> meals) {
    return MealsLoaded(meals: meals);
  }

  @override
  List<Object?> get props => [meals];
}

/// AI successfully parsed a meal.
/// Navigates to Meal Confirmation screen.
class MealLogSuccess extends MealState {
  final MealLog meal;

  const MealLogSuccess(this.meal);

  @override
  List<Object?> get props => [meal];
}

/// AI health analysis generated
class HealthAnalysisLoaded extends MealState {
  final String analysis;

  const HealthAnalysisLoaded(this.analysis);

  @override
  List<Object?> get props => [analysis];
}

/// Any error during meal operations
class MealError extends MealState {
  final String message;

  const MealError(this.message);

  @override
  List<Object?> get props => [message];
}
