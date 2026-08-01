import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user_profile.dart';
import '../../services/database_service.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final DatabaseService _db;

  UserBloc(this._db) : super(UserInitial()) {
    on<LoadUser>(_onLoadUser);
    on<CreateUser>(_onCreateUser);
    on<UpdateUser>(_onUpdateUser);
  }

  Future<void> _onLoadUser(LoadUser event, Emitter<UserState> emit) async {
    emit(UserLoading());

    try {
      final profile = await _db.getUser(event.uid);

      if (profile == null) {
        emit(UserNotFound());
        return;
      }

      emit(UserLoaded(profile));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onCreateUser(CreateUser event, Emitter<UserState> emit) async {
    emit(UserLoading());

    try {
      await _db.saveUser(event.profile);
      await _db.logWeight(
        userId: event.profile.uid,
        weightKg: event.profile.weightKg,
      );
      emit(UserLoaded(event.profile));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onUpdateUser(UpdateUser event, Emitter<UserState> emit) async {
    emit(UserLoading());

    try {
      // Load current profile
      final currentProfile = await _db.getUser(event.profile.uid);

      // Save updated profile
      await _db.saveUser(event.profile);

      // Log weight only if it actually changed
      if (currentProfile != null &&
          currentProfile.weightKg != event.profile.weightKg) {
        await _db.logWeight(
          userId: event.profile.uid,
          weightKg: event.profile.weightKg,
        );
      }

      emit(UserLoaded(event.profile));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
