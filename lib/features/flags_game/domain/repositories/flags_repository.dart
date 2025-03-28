import 'package:dartz/dartz.dart';
import 'package:gardas/core/error/failures.dart';
import 'package:gardas/domain/entities/game.dart';
import 'package:gardas/features/flags_game/domain/entities/flag_question.dart';
import 'package:gardas/features/flags_game/domain/entities/flag_score.dart';

/// Flags Repository Interface
/// 
/// This interface defines methods for the flags game.
abstract class FlagsRepository {
  /// Gets a list of flag questions based on difficulty
  /// 
  /// [difficulty] is the difficulty level.
  /// [count] is the number of questions to retrieve.
  /// Returns a list of [FlagQuestion] entities if successful, or a [Failure] if an error occurs.
  Future<Either<Failure, List<FlagQuestion>>> getFlagQuestions({
    required GameDifficulty difficulty,
    required int count,
  });
  
  /// Gets all available flag options
  /// 
  /// Returns a list of all available [FlagOption] entities if successful, or a [Failure] if an error occurs.
  Future<Either<Failure, List<FlagOption>>> getAllFlagOptions();
  
  /// Saves a flag game score
  /// 
  /// [score] is the flag game score to save.
  /// Returns the saved [FlagScore] if successful, or a [Failure] if an error occurs.
  Future<Either<Failure, FlagScore>> saveFlagScore(FlagScore score);
  
  /// Gets the highest flag game score for a specific difficulty
  /// 
  /// [difficulty] is the difficulty level.
  /// [userId] is the optional ID of the user. If not provided, returns the global high score.
  /// Returns a [FlagScore] if successful, or a [Failure] if an error occurs.
  Future<Either<Failure, FlagScore?>> getHighestFlagScore({
    required GameDifficulty difficulty,
    String? userId,
  });
  
  /// Gets all flag game scores for a specific user
  /// 
  /// [userId] is the ID of the user.
  /// Returns a list of [FlagScore] entities if successful, or a [Failure] if an error occurs.
  Future<Either<Failure, List<FlagScore>>> getFlagScoresByUser(String userId);
}