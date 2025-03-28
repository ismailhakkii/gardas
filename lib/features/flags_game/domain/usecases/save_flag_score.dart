import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:gardas/core/error/failures.dart';
import 'package:gardas/domain/usecases/base/usecase.dart';
import 'package:gardas/features/flags_game/domain/entities/flag_score.dart';
import 'package:gardas/features/flags_game/domain/repositories/flags_repository.dart';

/// Save flag score use case
/// 
/// This use case saves a flag game score.
class SaveFlagScore implements UseCase<FlagScore, SaveFlagScoreParams> {
  final FlagsRepository repository;

  SaveFlagScore(this.repository);

  @override
  Future<Either<Failure, FlagScore>> call(SaveFlagScoreParams params) {
    return repository.saveFlagScore(params.score);
  }
}

/// Save flag score parameters
class SaveFlagScoreParams extends Equatable {
  final FlagScore score;

  const SaveFlagScoreParams({required this.score});

  @override
  List<Object?> get props => [score];
}