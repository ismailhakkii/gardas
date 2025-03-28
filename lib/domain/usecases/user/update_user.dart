import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:gardas/core/error/failures.dart';
import 'package:gardas/domain/entities/user.dart';
import 'package:gardas/domain/repositories/user_repository.dart';
import 'package:gardas/domain/usecases/base/usecase.dart';

/// Update user use case
/// 
/// This use case updates the user profile.
class UpdateUser implements UseCase<User, UpdateUserParams> {
  final UserRepository repository;

  UpdateUser(this.repository);

  @override
  Future<Either<Failure, User>> call(UpdateUserParams params) {
    return repository.updateUser(params.user);
  }
}

/// Update user parameters
class UpdateUserParams extends Equatable {
  final User user;

  const UpdateUserParams({required this.user});

  @override
  List<Object?> get props => [user];
}