import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:gardas/core/error/failures.dart';
import 'package:gardas/domain/entities/game.dart';
import 'package:gardas/domain/usecases/base/usecase.dart';
import 'package:gardas/features/flags_game/domain/entities/flag_question.dart';
import 'package:gardas/features/flags_game/domain/repositories/flags_repository.dart';

/// Get flag questions use case
/// 
/// This use case retrieves flag questions for the game.
class GetFlagQuestions implements UseCase<List<FlagQuestion>, GetFlagQuestionsParams> {
  final FlagsRepository repository;

  GetFlagQuestions(this.repository);

  @override
  Future<Either<Failure, List<FlagQuestion>>> call(GetFlagQuestionsParams params) {
    return repository.getFlagQuestions(
      difficulty: params.difficulty,
      count: params.count,
    );
  }
}

/// Get flag questions parameters
class GetFlagQuestionsParams extends Equatable {
  final GameDifficulty difficulty;
  final int count;

  const GetFlagQuestionsParams({
    required this.difficulty,
    required this.count,
  });

  @override
  List<Object?> get props => [difficulty, count];
}