part of 'user_bloc.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final UserProfile profile;
  UserLoaded(this.profile);
}

class UserNotFound extends UserState {}

class UserError extends UserState {
  final String message;
  UserError(this.message);
}
