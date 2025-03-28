import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:gardas/core/error/failures.dart';
import 'package:gardas/domain/entities/user.dart';
import 'package:gardas/domain/repositories/user_repository.dart';
import 'package:gardas/domain/usecases/base/usecase.dart';

/// Update avatar use case
/// 
/// This use case updates only the avatar of the current user.
class UpdateAvatar implements UseCase<User, UpdateAvatarParams> {
  final UserRepository repository;

  UpdateAvatar(this.repository);

  @override
  Future<Either<Failure, User>> call(UpdateAvatarParams params) {
    return repository.updateAvatar(params.avatarPath);
  }
}

/// Update avatar parameters
class UpdateAvatarParams extends Equatable {
  final String avatarPath;

  const UpdateAvatarParams({required this.avatarPath});

  @override
  List<Object?> get props => [avatarPath];
}