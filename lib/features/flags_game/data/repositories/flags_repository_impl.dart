import 'package:dartz/dartz.dart';
import 'package:gardas/core/error/error_handler.dart';
import 'package:gardas/core/error/failures.dart';
import 'package:gardas/domain/entities/game.dart';
import 'package:gardas/features/flags_game/data/datasources/flags_local_datasource.dart';
import 'package:gardas/features/flags_game/data/models/flag_models.dart';
import 'package:gardas/features/flags_game/domain/entities/flag_question.dart';
import 'package:gardas/features/flags_game/domain/entities/flag_score.dart';
import 'package:gardas/features/flags_game/domain/repositories/flags_repository.dart';

/// Implementation of [FlagsRepository]
class FlagsRepositoryImpl implements FlagsRepository {
  final FlagsLocalDataSource _localDataSource;
  final ErrorHandler _errorHandler;

  /// Constructor for FlagsRepositoryImpl
  FlagsRepositoryImpl(this._localDataSource, this._errorHandler);

  @override
  Future<Either<Failure, List<FlagQuestion>>> getFlagQuestions({
    required GameDifficulty difficulty,
    required int count,
  }) async {
    try {
      final questions = await _localDataSource.getFlagQuestions(
        difficulty: difficulty,
        count: count,
      );
      
      return Right(questions);
    } catch (e) {
      return Left(_errorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<FlagOption>>> getAllFlagOptions() async {
    try {
      final options = await _localDataSource.getAllFlagOptions();
      
      return Right(options);
    } catch (e) {
      return Left(_errorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, FlagScore>> saveFlagScore(FlagScore score) async {
    try {
      final scoreModel = FlagScoreModel.fromEntity(score);
      final savedScore = await _localDataSource.saveFlagScore(scoreModel);
      
      return Right(savedScore);
    } catch (e) {
      return Left(_errorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, FlagScore?>> getHighestFlagScore({
    required GameDifficulty difficulty,
    String? userId,
  }) async {
    try {
      final highScore = await _localDataSource.getHighestFlagScore(
        difficulty: difficulty,
        userId: userId,
      );
      
      return Right(highScore);
    } catch (e) {
      return Left(_errorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<FlagScore>>> getFlagScoresByUser(String userId) async {
    try {
      final scores = await _localDataSource.getFlagScoresByUser(userId);
      
      return Right(scores);
    } catch (e) {
      return Left(_errorHandler.handleException(e));
    }
  }
}