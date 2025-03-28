import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gardas/core/error/failures.dart';
import 'package:gardas/domain/entities/user.dart';
import 'package:gardas/domain/usecases/base/usecase.dart';
import 'package:gardas/domain/usecases/user/get_current_user.dart';
import 'package:gardas/domain/usecases/user/update_avatar.dart';
import 'package:gardas/domain/usecases/user/update_username.dart';

// Events
abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class GetCurrentUserEvent extends UserEvent {}

class UpdateUsernameEvent extends UserEvent {
  final String username;

  const UpdateUsernameEvent(this.username);

  @override
  List<Object?> get props => [username];
}

class UpdateAvatarEvent extends UserEvent {
  final String avatarPath;

  const UpdateAvatarEvent(this.avatarPath);

  @override
  List<Object?> get props => [avatarPath];
}

// States
abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final User user;

  const UserLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class UserBloc extends Bloc<UserEvent, UserState> {
  final GetCurrentUser getCurrentUser;
  final UpdateUsername updateUsername;
  final UpdateAvatar updateAvatar;

  UserBloc({
    required this.getCurrentUser,
    required this.updateUsername,
    required this.updateAvatar,
  }) : super(UserInitial()) {
    on<GetCurrentUserEvent>(_onGetCurrentUser);
    on<UpdateUsernameEvent>(_onUpdateUsername);
    on<UpdateAvatarEvent>(_onUpdateAvatar);
  }

  Future<void> _onGetCurrentUser(
    GetCurrentUserEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    final result = await getCurrentUser(NoParams());
    result.fold(
      (failure) => emit(UserError(_mapFailureToMessage(failure))),
      (user) => emit(UserLoaded(user)),
    );
  }

  Future<void> _onUpdateUsername(
    UpdateUsernameEvent event,
    Emitter<UserState> emit,
  ) async {
    if (state is UserLoaded) {
      final currentUser = (state as UserLoaded).user;
      if (currentUser.username == event.username) {
        return; // No change needed
      }
    }
    
    emit(UserLoading());
    final result = await updateUsername(UpdateUsernameParams(username: event.username));
    result.fold(
      (failure) => emit(UserError(_mapFailureToMessage(failure))),
      (user) => emit(UserLoaded(user)),
    );
  }

  Future<void> _onUpdateAvatar(
    UpdateAvatarEvent event,
    Emitter<UserState> emit,
  ) async {
    if (state is UserLoaded) {
      final currentUser = (state as UserLoaded).user;
      if (currentUser.avatarUrl == event.avatarPath) {
        return; // No change needed
      }
    }
    
    emit(UserLoading());
    final result = await updateAvatar(UpdateAvatarParams(avatarPath: event.avatarPath));
    result.fold(
      (failure) => emit(UserError(_mapFailureToMessage(failure))),
      (user) => emit(UserLoaded(user)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    } else if (failure is CacheFailure) {
      return failure.message;
    } else if (failure is NetworkFailure) {
      return failure.message;
    } else {
      return 'Beklenmeyen bir hata oluştu.';
    }
  }
}