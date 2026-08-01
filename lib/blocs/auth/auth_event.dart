part of 'auth_bloc.dart';

abstract class AuthEvent {}

class AuthStarted extends AuthEvent {}

class AuthSignInWithGoogle extends AuthEvent {}

class AuthSignInWithEmail extends AuthEvent {
  final String email;
  final String password;
  AuthSignInWithEmail({required this.email, required this.password});
}

class AuthSignUpWithEmail extends AuthEvent {
  final String email;
  final String password;
  AuthSignUpWithEmail({required this.email, required this.password});
}

class AuthSignedOut extends AuthEvent {}
