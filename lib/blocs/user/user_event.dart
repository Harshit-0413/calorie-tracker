part of 'user_bloc.dart';

abstract class UserEvent {}

class LoadUser extends UserEvent {
  final String uid;
  LoadUser(this.uid);
}

class UpdateUser extends UserEvent {
  final UserProfile profile;
  UpdateUser(this.profile);
}

class CreateUser extends UserEvent {
  final UserProfile profile;
  CreateUser(this.profile);
}
