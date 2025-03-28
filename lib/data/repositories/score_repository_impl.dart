import 'package:dartz/dartz.dart';
import 'package:gardas/core/constants/app_constants.dart';
import 'package:gardas/core/error/error_handler.dart';
import 'package:gardas/core/error/failures.dart';
import 'package:gardas/data/datasources/local/local_storage_service.dart';
import 'package:gardas/data/models/score_model.dart';
import 'package:gardas/domain/entities/game.dart';
import 'package:gardas/domain/entities/score.dart';
import 'package:gardas/domain/repositories/score_repository.dart';

/// Implementation of [ScoreRepository]
class ScoreRepositoryImpl implements ScoreRepository {
  final LocalStorageService _storageService;
  final ErrorHandler _errorHandler;

  /// Constructor for ScoreRepositoryImpl
  ScoreRepositoryImpl(this._storageService, this._errorHandler);

  @override
  Future<Either<Failure, List<Score>>> getScoresByGame(String gameId) async {
    try {
      final allData = _storageService.getAll(AppConstants.scoresBoxName);
      final scores = <ScoreModel>[];
      
      for (final entry in allData.entries) {
        try {
          final Map<String, dynamic> data = Map<String, dynamic>.from(entry.value);
          if (data['game_id'] == gameId) {
            scores.add(ScoreModel.fromJson(data));
          }
        } catch (e) {
          // Skip invalid entries
        }
      }
      
      return Right(scores);
    } catch (e) {
      return Left(_errorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<Score>>> getScoresByUser(String userId) async {
    try {
      final allData = _storageService.getAll(AppConstants.scoresBoxName);
      final scores = <ScoreModel>[];
      
      for (final entry in allData.entries) {
        try {
          final Map<String, dynamic> data = Map<String, dynamic>.from(entry.value);
          if (data['user_id'] == userId) {
            scores.add(ScoreModel.fromJson(data));
          }
        } catch (e) {
          // Skip invalid entries
        }
      }
      
      return Right(scores);
    } catch (e) {
      return Left(_errorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, Score?>> getHighScore({
    required String gameId,
    required GameDifficulty difficulty,
    String? userId,
  }) async {
    try {
      final Either<Failure, List<Score>> scoresResult = userId != null
          ? await getScoresByUser(userId)
          : await getScoresByGame(gameId);
      
      return scoresResult.fold(
        (failure) => Left(failure),
        (scores) {
          // Filter by game ID and difficulty
          final filteredScores = scores.where(
            (score) => score.gameId == gameId && score.difficulty == difficulty,
          ).toList();
          
          if (filteredScores.isEmpty) {
            return const Right(null);
          }
          
          // Sort by value (descending)
          filteredScores.sort((a, b) => b.value.compareTo(a.value));
          
          return Right(filteredScores.first);
        },
      );
    } catch (e) {
      return Left(_errorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, Score>> saveScore(Score score) async {
    try {
      final ScoreModel scoreModel = ScoreModel.fromEntity(score);
      
      await _storageService.putObject<ScoreModel>(
        AppConstants.scoresBoxName,
        score.id,
        scoreModel,
        (score) => score.toJson(),
      );
      
      return Right(scoreModel);
    } catch (e) {
      return Left(_errorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteScore(String scoreId) async {
    try {
      await _storageService.delete(
        AppConstants.scoresBoxName,
        scoreId,
      );
      
      return const Right(true);
    } catch (e) {
      return Left(_errorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteScoresByGame(String gameId) async {
    try {
      final Either<Failure, List<Score>> scoresResult = await getScoresByGame(gameId);
      
      return scoresResult.fold(
        (failure) => Left(failure),
        (scores) async {
          for (final score in scores) {
            await _storageService.delete(
              AppConstants.scoresBoxName,
              score.id,
            );
          }
          
          return const Right(true);
        },
      );
    } catch (e) {
      return Left(_errorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteScoresByUser(String userId) async {
    try {
      final Either<Failure, List<Score>> scoresResult = await getScoresByUser(userId);
      
      return scoresResult.fold(
        (failure) => Left(failure),
        (scores) async {
          for (final score in scores) {
            await _storageService.delete(
              AppConstants.scoresBoxName,
              score.id,
            );
          }
          
          return const Right(true);
        },
      );
    } catch (e) {
      return Left(_errorHandler.handleException(e));
    }
  }
}