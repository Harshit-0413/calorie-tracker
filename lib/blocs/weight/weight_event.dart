part of 'weight_bloc.dart';

abstract class WeightEvent {}

class LoadWeightHistory extends WeightEvent {
  final String userId;

  LoadWeightHistory(this.userId);
}

class AddWeightEntry extends WeightEvent {
  final WeightEntry entry;

  AddWeightEntry(this.entry);
}

class DeleteWeightEntry extends WeightEvent {
  final int id;
  final String userId;

  DeleteWeightEntry({required this.id, required this.userId});
}
