import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/weight_entry.dart';
import '../../services/database_service.dart';

part 'weight_event.dart';
part 'weight_state.dart';

class WeightBloc extends Bloc<WeightEvent, WeightState> {
  final DatabaseService _db;

  WeightBloc(this._db) : super(WeightInitial()) {
    on<LoadWeightHistory>(_onLoadWeightHistory);
    on<AddWeightEntry>(_onAddWeightEntry);
    on<DeleteWeightEntry>(_onDeleteWeightEntry);
  }

  Future<void> _onLoadWeightHistory(
    LoadWeightHistory event,
    Emitter<WeightState> emit,
  ) async {
    emit(WeightLoading());

    try {
      final entries = await _db.getWeightEntries(event.userId);

      emit(WeightLoaded(entries));
    } catch (e) {
      emit(WeightError(e.toString()));
    }
  }

  Future<void> _onAddWeightEntry(
    AddWeightEntry event,
    Emitter<WeightState> emit,
  ) async {
    try {
      await _db.insertWeightEntry(event.entry);

      final entries = await _db.getWeightEntries(event.entry.userId);

      emit(WeightLoaded(entries));
    } catch (e) {
      emit(WeightError(e.toString()));
    }
  }

  Future<void> _onDeleteWeightEntry(
    DeleteWeightEntry event,
    Emitter<WeightState> emit,
  ) async {
    try {
      await _db.deleteWeightEntry(event.id);

      final entries = await _db.getWeightEntries(event.userId);

      emit(WeightLoaded(entries));
    } catch (e) {
      emit(WeightError(e.toString()));
    }
  }
}
