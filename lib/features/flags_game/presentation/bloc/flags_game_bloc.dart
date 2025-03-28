import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gardas/core/constants/app_constants.dart';
import 'package:gardas/core/error/failures.dart';
import 'package:gardas/domain/entities/game.dart';
import 'package:gardas/domain/usecases/scores/get_high_score.dart';
import 'package:gardas/features/flags_game/domain/entities/flag_question.dart';
import 'package:gardas/features/flags_game/domain/entities/flag_score.dart';
import 'package:gardas/features/flags_game/domain/usecases/get_flag_questions.dart';
import 'package:gardas/features/flags_game/domain/usecases/save_flag_score.dart';

// Events
abstract class FlagsGameEvent extends Equatable {
  const FlagsGameEvent();

  @override
  List<Object?> get props => [];
}

class LoadQuestionsEvent extends FlagsGameEvent {
  final GameDifficulty difficulty;
  final int count;

  const LoadQuestionsEvent({
    required this.difficulty,
    required this.count,
  });

  @override
  List<Object?> get props => [difficulty, count];
}

class StartGameEvent extends FlagsGameEvent {}

class PauseGameEvent extends FlagsGameEvent {}

class ResumeGameEvent extends FlagsGameEvent {}

class AnswerQuestionEvent extends FlagsGameEvent {
  final FlagOption selectedOption;
  final double timeSpent;

  const AnswerQuestionEvent({
    required this.selectedOption,
    required this.timeSpent,
  });

  @override
  List<Object?> get props => [selectedOption, timeSpent];
}

class NextQuestionEvent extends FlagsGameEvent {}

class EndGameEvent extends FlagsGameEvent {
  final String userId;

  const EndGameEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class LoadHighScoreEvent extends FlagsGameEvent {
  final GameDifficulty difficulty;
  final String userId;

  const LoadHighScoreEvent({
    required this.difficulty,
    required this.userId,
  });

  @override
  List<Object?> get props => [difficulty, userId];
}

class ResetGameEvent extends FlagsGameEvent {}

// States
abstract class FlagsGameState extends Equatable {
  const FlagsGameState();

  @override
  List<Object?> get props => [];
}

class FlagsGameInitial extends FlagsGameState {}

class FlagsGameLoading extends FlagsGameState {}

class QuestionsLoaded extends FlagsGameState {
  final List<FlagQuestion> questions;
  final GameDifficulty difficulty;

  const QuestionsLoaded({
    required this.questions,
    required this.difficulty,
  });

  @override
  List<Object?> get props => [questions, difficulty];
}

class GameRunning extends FlagsGameState {
  final List<FlagQuestion> questions;
  final int currentQuestionIndex;
  final FlagQuestion currentQuestion;
  final int score;
  final int correctAnswers;
  final int wrongAnswers;
  final List<double> answerTimes;
  final GameDifficulty difficulty;
  final double timeRemaining;
  final bool isLastQuestion;

  GameRunning({
    required this.questions,
    required this.currentQuestionIndex,
    required this.score,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.answerTimes,
    required this.difficulty,
    required this.timeRemaining,
  })  : currentQuestion = questions[currentQuestionIndex],
        isLastQuestion = currentQuestionIndex == questions.length - 1;

  @override
  List<Object?> get props => [
        questions,
        currentQuestionIndex,
        currentQuestion,
        score,
        correctAnswers,
        wrongAnswers,
        answerTimes,
        difficulty,
        timeRemaining,
        isLastQuestion,
      ];

  GameRunning copyWith({
    List<FlagQuestion>? questions,
    int? currentQuestionIndex,
    int? score,
    int? correctAnswers,
    int? wrongAnswers,
    List<double>? answerTimes,
    GameDifficulty? difficulty,
    double? timeRemaining,
  }) {
    return GameRunning(
      questions: questions ?? this.questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      score: score ?? this.score,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      wrongAnswers: wrongAnswers ?? this.wrongAnswers,
      answerTimes: answerTimes ?? this.answerTimes,
      difficulty: difficulty ?? this.difficulty,
      timeRemaining: timeRemaining ?? this.timeRemaining,
    );
  }
}

class GamePaused extends FlagsGameState {
  final GameRunning gameState;

  const GamePaused(this.gameState);

  @override
  List<Object?> get props => [gameState];
}

class AnswerSelected extends FlagsGameState {
  final FlagOption selectedOption;
  final FlagOption correctOption;
  final bool isCorrect;
  final int score;
  final double timeSpent;
  final GameRunning gameState;

  const AnswerSelected({
    required this.selectedOption,
    required this.correctOption,
    required this.isCorrect,
    required this.score,
    required this.timeSpent,
    required this.gameState,
  });

  @override
  List<Object?> get props => [
        selectedOption,
        correctOption,
        isCorrect,
        score,
        timeSpent,
        gameState,
      ];
}

class GameOver extends FlagsGameState {
  final FlagScore score;
  final bool isHighScore;

  const GameOver({
    required this.score,
    this.isHighScore = false,
  });

  @override
  List<Object?> get props => [score, isHighScore];
}

class FlagsGameError extends FlagsGameState {
  final String message;

  const FlagsGameError(this.message);

  @override
  List<Object?> get props => [message];
}

class HighScoreLoaded extends FlagsGameState {
  final FlagScore? highScore;
  final GameDifficulty difficulty;

  const HighScoreLoaded({
    required this.highScore,
    required this.difficulty,
  });

  @override
  List<Object?> get props => [highScore, difficulty];
}

// BLoC
class FlagsGameBloc extends Bloc<FlagsGameEvent, FlagsGameState> {
  final GetFlagQuestions getFlagQuestions;
  final SaveFlagScore saveFlagScore;
  final GetHighScore getHighScore;

  Timer? _gameTimer;
  final int timeLimit = AppConstants.flagGameTimeLimit; // 15 seconds per question

  FlagsGameBloc({
    required this.getFlagQuestions,
    required this.saveFlagScore,
    required this.getHighScore,
  }) : super(FlagsGameInitial()) {
    on<LoadQuestionsEvent>(_onLoadQuestions);
    on<StartGameEvent>(_onStartGame);
    on<PauseGameEvent>(_onPauseGame);
    on<ResumeGameEvent>(_onResumeGame);
    on<AnswerQuestionEvent>(_onAnswerQuestion);
    on<NextQuestionEvent>(_onNextQuestion);
    on<EndGameEvent>(_onEndGame);
    on<LoadHighScoreEvent>(_onLoadHighScore);
    on<ResetGameEvent>(_onResetGame);
  }

  @override
  Future<void> close() {
    _cancelTimer();
    return super.close();
  }

  void _startTimer(Emitter<FlagsGameState> emit) {
    _cancelTimer();
    
    if (state is GameRunning) {
      final gameState = state as GameRunning;
      
      _gameTimer = Timer.periodic(
        const Duration(milliseconds: 100),
        (timer) {
          if (state is GameRunning) {
            final currentState = state as GameRunning;
            final newTimeRemaining = currentState.timeRemaining - 0.1;
            
            if (newTimeRemaining <= 0) {
              _cancelTimer();
              emit(AnswerSelected(
                selectedOption: FlagOption(
                  countryCode: '',
                  countryName: '',
                  flagEmoji: '',
                ),
                correctOption: currentState.currentQuestion.correctOption,
                isCorrect: false,
                score: currentState.score,
                timeSpent: timeLimit.toDouble(),
                gameState: currentState.copyWith(
                  timeRemaining: 0,
                  wrongAnswers: currentState.wrongAnswers + 1,
                ),
              ));
            } else {
              emit(currentState.copyWith(timeRemaining: newTimeRemaining));
            }
          }
        },
      );
    }
  }

  void _cancelTimer() {
    _gameTimer?.cancel();
    _gameTimer = null;
  }

  Future<void> _onLoadQuestions(
    LoadQuestionsEvent event,
    Emitter<FlagsGameState> emit,
  ) async {
    emit(FlagsGameLoading());
    
    final result = await getFlagQuestions(GetFlagQuestionsParams(
      difficulty: event.difficulty,
      count: event.count,
    ));
    
    result.fold(
      (failure) => emit(FlagsGameError(_mapFailureToMessage(failure))),
      (questions) => emit(QuestionsLoaded(
        questions: questions,
        difficulty: event.difficulty,
      )),
    );
  }

  Future<void> _onStartGame(
    StartGameEvent event,
    Emitter<FlagsGameState> emit,
  ) async {
    if (state is QuestionsLoaded) {
      final questionsState = state as QuestionsLoaded;
      
      emit(GameRunning(
        questions: questionsState.questions,
        currentQuestionIndex: 0,
        score: 0,
        correctAnswers: 0,
        wrongAnswers: 0,
        answerTimes: [],
        difficulty: questionsState.difficulty,
        timeRemaining: timeLimit.toDouble(),
      ));
      
      _startTimer(emit);
    }
  }

  Future<void> _onPauseGame(
    PauseGameEvent event,
    Emitter<FlagsGameState> emit,
  ) async {
    if (state is GameRunning) {
      _cancelTimer();
      emit(GamePaused(state as GameRunning));
    }
  }

  Future<void> _onResumeGame(
    ResumeGameEvent event,
    Emitter<FlagsGameState> emit,
  ) async {
    if (state is GamePaused) {
      final pausedState = (state as GamePaused).gameState;
      emit(pausedState);
      _startTimer(emit);
    }
  }

  Future<void> _onAnswerQuestion(
    AnswerQuestionEvent event,
    Emitter<FlagsGameState> emit,
  ) async {
    if (state is GameRunning) {
      _cancelTimer();
      
      final gameState = state as GameRunning;
      final currentQuestion = gameState.currentQuestion;
      final isCorrect = currentQuestion.correctOption.countryCode == event.selectedOption.countryCode;
      
      // Calculate score for this question
      int questionScore = 0;
      if (isCorrect) {
        final timeBonus = (timeLimit - event.timeSpent).round();
        final difficultyMultiplier = _getDifficultyMultiplier(gameState.difficulty);
        questionScore = (100 + timeBonus * 10) * difficultyMultiplier;
      }
      
      // Update game state
      final updatedGameState = gameState.copyWith(
        score: gameState.score + questionScore,
        correctAnswers: isCorrect ? gameState.correctAnswers + 1 : gameState.correctAnswers,
        wrongAnswers: !isCorrect ? gameState.wrongAnswers + 1 : gameState.wrongAnswers,
        answerTimes: [...gameState.answerTimes, event.timeSpent],
      );
      
      emit(AnswerSelected(
        selectedOption: event.selectedOption,
        correctOption: currentQuestion.correctOption,
        isCorrect: isCorrect,
        score: updatedGameState.score,
        timeSpent: event.timeSpent,
        gameState: updatedGameState,
      ));
    }
  }

  Future<void> _onNextQuestion(
    NextQuestionEvent event,
    Emitter<FlagsGameState> emit,
  ) async {
    if (state is AnswerSelected) {
      final answerState = state as AnswerSelected;
      final gameState = answerState.gameState;
      
      // If this was the last question, end the game
      if (gameState.isLastQuestion) {
        // End game with current user (will be filled in _onEndGame)
        add(const EndGameEvent(userId: 'current_user'));
        return;
      }
      
      // Move to next question
      emit(gameState.copyWith(
        currentQuestionIndex: gameState.currentQuestionIndex + 1,
        timeRemaining: timeLimit.toDouble(),
      ));
      
      _startTimer(emit);
    }
  }

  Future<void> _onEndGame(
    EndGameEvent event,
    Emitter<FlagsGameState> emit,
  ) async {
    if (state is AnswerSelected) {
      final answerState = state as AnswerSelected;
      final gameState = answerState.gameState;
      
      // Calculate average time per question
      final double averageTime = gameState.answerTimes.isNotEmpty
          ? gameState.answerTimes.reduce((a, b) => a + b) / gameState.answerTimes.length
          : 0;
      
      // Create final score
      final flagScore = FlagScore(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        gameId: 'flags_game',
        userId: event.userId,
        value: gameState.score,
        difficulty: gameState.difficulty,
        date: DateTime.now(),
        correctAnswers: gameState.correctAnswers,
        wrongAnswers: gameState.wrongAnswers,
        totalQuestions: gameState.questions.length,
        averageTimePerQuestion: averageTime,
      );
      
      // Save score
      final saveResult = await saveFlagScore(SaveFlagScoreParams(score: flagScore));
      
      // Check if it's a high score
      final highScoreResult = await getHighScore(GetHighScoreParams(
        gameId: 'flags_game',
        difficulty: gameState.difficulty,
        userId: event.userId,
      ));
      
      saveResult.fold(
        (failure) => emit(FlagsGameError(_mapFailureToMessage(failure))),
        (savedScore) {
          highScoreResult.fold(
            (failure) => emit(GameOver(score: flagScore)),
            (highScore) {
              final bool isHighScore = highScore == null || flagScore.value > highScore.value;
              emit(GameOver(score: flagScore, isHighScore: isHighScore));
            },
          );
        },
      );
    }
  }

  Future<void> _onLoadHighScore(
    LoadHighScoreEvent event,
    Emitter<FlagsGameState> emit,
  ) async {
    emit(FlagsGameLoading());
    
    final result = await getHighScore(GetHighScoreParams(
      gameId: 'flags_game',
      difficulty: event.difficulty,
      userId: event.userId,
    ));
    
    result.fold(
      (failure) => emit(FlagsGameError(_mapFailureToMessage(failure))),
      (highScore) {
        if (highScore != null) {
          emit(HighScoreLoaded(
            highScore: FlagScore.fromScore(highScore),
            difficulty: event.difficulty,
          ));
        } else {
          emit(HighScoreLoaded(
            highScore: null,
            difficulty: event.difficulty,
          ));
        }
      },
    );
  }

  Future<void> _onResetGame(
    ResetGameEvent event,
    Emitter<FlagsGameState> emit,
  ) async {
    _cancelTimer();
    emit(FlagsGameInitial());
  }

  int _getDifficultyMultiplier(GameDifficulty difficulty) {
    switch (difficulty) {
      case GameDifficulty.easy:
        return 1;
      case GameDifficulty.medium:
        return 2;
      case GameDifficulty.hard:
        return 3;
    }
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    } else if (failure is CacheFailure) {
      return failure.message;
    } else if (failure is NetworkFailure) {
      return failure.message;
    } else {
      return 'Beklenmeyen bir hata oluştu.';
    }
  }
}