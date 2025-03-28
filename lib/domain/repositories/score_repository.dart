import 'package:dartz/dartz.dart';
import 'package:gardas/core/error/failures.dart';
import 'package:gardas/domain/entities/game.dart';
import 'package:gardas/domain/entities/score.dart';

/// Score Repository Interface
/// 
/// This interface defines methods for managing game scores.
abstract class ScoreRepository {
  /// Gets all scores for a specific game
  /// 
  /// [gameId] is the ID of the game.
  /// Returns a list of [Score] entities if successful, or a [Failure] if an error occurs.
  Future<Either<Failure, List<Score>>> getScoresByGame(String gameId);
  
  /// Gets all scores for a specific user
  /// 
  /// [userId] is the ID of the user.
  /// Returns a list of [Score] entities if successful, or a [Failure] if an error occurs.
  Future<Either<Failure, List<Score>>> getScoresByUser(String userId);
  
  /// Gets the high score for a specific game and difficulty
  /// 
  /// [gameId] is the ID of the game.
  /// [difficulty] is the difficulty level.
  /// [userId] is the optional ID of the user. If not provided, returns the global high score.
  /// Returns a [Score] entity if successful, or a [Failure] if an error occurs.
  Future<Either<Failure, Score?>> getHighScore({
    required String gameId,
    required GameDifficulty difficulty,
    String? userId,
  });
  
  /// Saves a new score
  /// 
  /// [score] is the score entity to save.
  /// Returns the saved [Score] entity if successful, or a [Failure] if an error occurs.
  Future<Either<Failure, Score>> saveScore(Score score);
  
  /// Deletes a score
  /// 
  /// [scoreId] is the ID of the score to delete.
  /// Returns [true] if successful, or a [Failure] if an error occurs.
  Future<Either<Failure, bool>> deleteScore(String scoreId);
  
  /// Deletes all scores for a specific game
  /// 
  /// [gameId] is the ID of the game.
  /// Returns [true] if successful, or a [Failure] if an error occurs.
  Future<Either<Failure, bool>> deleteScoresByGame(String gameId);
  
  /// Deletes all scores for a specific user
  /// 
  /// [userId] is the ID of the user.
  /// Returns [true] if successful, or a [Failure] if an error occurs.
  Future<Either<Failure, bool>> deleteScoresByUser(String userId);
}