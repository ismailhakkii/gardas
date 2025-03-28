import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:gardas/core/error/failures.dart';
import 'package:gardas/domain/entities/game.dart';
import 'package:gardas/domain/entities/score.dart';
import 'package:gardas/domain/repositories/score_repository.dart';
import 'package:gardas/domain/usecases/base/usecase.dart';

/// Get high score use case
/// 
/// This use case retrieves the high score for a specific game and difficulty.
class GetHighScore implements UseCase<Score?, GetHighScoreParams> {
  final ScoreRepository repository;

  GetHighScore(this.repository);

  @override
  Future<Either<Failure, Score?>> call(GetHighScoreParams params) {
    return repository.getHighScore(
      gameId: params.gameId,
      difficulty: params.difficulty,
      userId: params.userId,
    );
  }
}

/// Get high score parameters
class GetHighScoreParams extends Equatable {
  final String gameId;
  final GameDifficulty difficulty;
  final String? userId;

  const GetHighScoreParams({
    required this.gameId,
    required this.difficulty,
    this.userId,
  });

  @override
  List<Object?> get props => [gameId, difficulty, userId];
}