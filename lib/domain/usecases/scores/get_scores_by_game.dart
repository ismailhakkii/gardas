import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:gardas/core/error/failures.dart';
import 'package:gardas/domain/entities/score.dart';
import 'package:gardas/domain/repositories/score_repository.dart';
import 'package:gardas/domain/usecases/base/usecase.dart';

/// Get scores by game use case
/// 
/// This use case retrieves all scores for a specific game.
class GetScoresByGame implements UseCase<List<Score>, GetScoresByGameParams> {
  final ScoreRepository repository;

  GetScoresByGame(this.repository);

  @override
  Future<Either<Failure, List<Score>>> call(GetScoresByGameParams params) {
    return repository.getScoresByGame(params.gameId);
  }
}

/// Get scores by game parameters
class GetScoresByGameParams extends Equatable {
  final String gameId;

  const GetScoresByGameParams({required this.gameId});

  @override
  List<Object?> get props => [gameId];
}