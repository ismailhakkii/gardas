import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:gardas/core/error/failures.dart';

/// Base UseCase interface
/// 
/// This interface defines a common structure for all use cases.
/// [Type] is the return type of the use case.
/// [Params] is the parameter type of the use case.
abstract class UseCase<Type, Params> {
  /// Execute the use case with the given parameters
  Future<Either<Failure, Type>> call(Params params);
}

/// No params class for use cases that don't require parameters
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}