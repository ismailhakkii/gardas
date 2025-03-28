import 'package:dartz/dartz.dart';
import 'package:gardas/core/error/failures.dart';
import 'package:gardas/domain/entities/user.dart';
import 'package:gardas/domain/repositories/user_repository.dart';
import 'package:gardas/domain/usecases/base/usecase.dart';

/// Get current user use case
/// 
/// This use case retrieves the current user profile.
class GetCurrentUser implements UseCase<User, NoParams> {
  final UserRepository repository;

  GetCurrentUser(this.repository);

  @override
  Future<Either<Failure, User>> call(NoParams params) {
    return repository.getCurrentUser();
  }
}