part of 'weight_bloc.dart';

abstract class WeightState {}

class WeightInitial extends WeightState {}

class WeightLoading extends WeightState {}

class WeightLoaded extends WeightState {
  final List<WeightEntry> entries;

  WeightLoaded(this.entries);
}

class WeightError extends WeightState {
  final String message;

  WeightError(this.message);
}
