import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/database_service.dart';

part 'goal_event.dart';
part 'goal_state.dart';

class GoalBloc extends Bloc<GoalEvent, GoalState> {
  final DatabaseService _db;

  GoalBloc(this._db) : super(const GoalInitial()) {
    on<LoadGoal>(_onLoadGoal);
    on<UpdateGoal>(_onUpdateGoal);
  }

  Future<void> _onLoadGoal(LoadGoal event, Emitter<GoalState> emit) async {
    emit(const GoalLoading());

    try {
      final user = await _db.getUser(event.uid);

      if (user == null) {
        emit(const GoalError('User not found'));
        return;
      }

      emit(
        GoalLoaded(
          calorieGoal: user.dailyCalorieGoal,
          proteinGoal: user.dailyProteinGoal,
          carbsGoal: user.dailyCarbsGoal,
          fatGoal: user.dailyFatGoal,
        ),
      );
    } catch (e) {
      emit(GoalError(e.toString()));
    }
  }

  Future<void> _onUpdateGoal(UpdateGoal event, Emitter<GoalState> emit) async {
    emit(const GoalLoading());

    try {
      final user = await _db.getUser(event.uid);

      if (user == null) {
        emit(const GoalError('User not found'));
        return;
      }

      final updated = user.copyWith(
        dailyCalorieGoal: event.calorieGoal,
        dailyProteinGoal: event.proteinGoal,
        dailyCarbsGoal: event.carbsGoal,
        dailyFatGoal: event.fatGoal,
      );
      await _db.saveUser(updated);

      emit(
        GoalLoaded(
          calorieGoal: event.calorieGoal,
          proteinGoal: event.proteinGoal,
          carbsGoal: event.carbsGoal,
          fatGoal: event.fatGoal,
        ),
      );
    } catch (e) {
      emit(GoalError(e.toString()));
    }
  }
}
