import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../core/enums/meal_source.dart';
import '../../core/enums/meal_type.dart';
import '../../models/meal_log.dart';
import '../../repositories/meal_repository.dart';

part 'meal_event.dart';
part 'meal_state.dart';

class MealBloc extends Bloc<MealEvent, MealState> {
  final MealRepository _repository;
  final Uuid _uuid = const Uuid();

  MealBloc(this._repository) : super(const MealInitial()) {
    on<LoadMeals>(_onLoadMeals);
    on<LogMealFromText>(_onLogMealFromText);
    on<SaveMeal>(_onSaveMeal);
    on<DeleteMeal>(_onDeleteMeal);
    on<GetHealthAnalysis>(_onGetHealthAnalysis);
  }

  Future<void> _onLoadMeals(LoadMeals event, Emitter<MealState> emit) async {
    emit(const MealLoading());

    try {
      final meals = await _repository.getMealsForDate(event.userId, event.date);

      emit(MealsLoaded.fromMeals(meals));
    } catch (e) {
      emit(MealError(e.toString()));
    }
  }

  Future<void> _onLogMealFromText(
    LogMealFromText event,
    Emitter<MealState> emit,
  ) async {
    emit(const MealLogging());

    try {
      final entries = await _repository.parseFoodInput(event.originalPrompt);

      if (entries.isEmpty) {
        emit(const MealError("Couldn't recognize any food. Try again."));
        return;
      }

      final now = DateTime.now();

      final meal = MealLog(
        id: _uuid.v4(),
        userId: event.userId,
        mealType: event.mealType,
        source: MealSource.manual,
        foodEntries: entries,
        originalPrompt: event.originalPrompt,
        aiInsight: "",
        loggedAt: now,
        createdAt: now,
        updatedAt: now,
      );

      emit(MealLogSuccess(meal));
    } catch (e) {
      emit(MealError(e.toString()));
    }
  }

  Future<void> _onSaveMeal(SaveMeal event, Emitter<MealState> emit) async {
    emit(const MealSaving());

    try {
      await _repository.saveMeal(event.meal);

      final meals = await _repository.getMealsForDate(
        event.meal.userId,
        event.meal.loggedAt,
      );

      emit(MealsLoaded.fromMeals(meals));
    } catch (e) {
      emit(MealError(e.toString()));
    }
  }

  Future<void> _onDeleteMeal(DeleteMeal event, Emitter<MealState> emit) async {
    try {
      await _repository.deleteMeal(event.mealId);

      final meals = await _repository.getMealsForDate(
        event.userId,
        DateTime.now(),
      );

      emit(MealsLoaded.fromMeals(meals));
    } catch (e) {
      emit(MealError(e.toString()));
    }
  }

  Future<void> _onGetHealthAnalysis(
    GetHealthAnalysis event,
    Emitter<MealState> emit,
  ) async {
    emit(const MealLoading());

    try {
      final meals = await _repository.getMealsForDate(event.userId, event.date);

      final analysis = await _repository.generateHealthAnalysis(meals);

      emit(HealthAnalysisLoaded(analysis));
    } catch (e) {
      emit(MealError(e.toString()));
    }
  }
}
