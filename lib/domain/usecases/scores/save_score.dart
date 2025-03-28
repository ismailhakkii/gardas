import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:gardas/core/error/failures.dart';
import 'package:gardas/domain/entities/score.dart';
import 'package:gardas/domain/repositories/score_repository.dart';
import 'package:gardas/domain/usecases/base/usecase.dart';

/// Save score use case
/// 
/// This use case saves a new score.
class SaveScore implements UseCase<Score, SaveScoreParams> {
  final ScoreRepository repository;

  SaveScore(this.repository);

  @override
  Future<Either<Failure, Score>> call(SaveScoreParams params) {
    return repository.saveScore(params.score);
  }
}

/// Save score parameters
class SaveScoreParams extends Equatable {
  final Score score;

  const SaveScoreParams({required this.score});

  @override
  List<Object?> get props => [score];
}