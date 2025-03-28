import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:gardas/core/error/failures.dart';
import 'package:gardas/domain/entities/user.dart';
import 'package:gardas/domain/repositories/user_repository.dart';
import 'package:gardas/domain/usecases/base/usecase.dart';

/// Update username use case
/// 
/// This use case updates only the username of the current user.
class UpdateUsername implements UseCase<User, UpdateUsernameParams> {
  final UserRepository repository;

  UpdateUsername(this.repository);

  @override
  Future<Either<Failure, User>> call(UpdateUsernameParams params) {
    return repository.updateUsername(params.username);
  }
}

/// Update username parameters
class UpdateUsernameParams extends Equatable {
  final String username;

  const UpdateUsernameParams({required this.username});

  @override
  List<Object?> get props => [username];
}