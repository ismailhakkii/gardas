import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gardas/domain/entities/game.dart';
import 'package:gardas/domain/entities/score.dart';
import 'package:gardas/features/flags_game/domain/entities/flag_score.dart';
import 'package:gardas/features/flags_game/presentation/bloc/flags_game_bloc.dart';
import 'package:gardas/features/flags_game/presentation/pages/flag_game_page.dart';
import 'package:gardas/features/flags_game/presentation/pages/flag_game_tutorial_page.dart';
import 'package:gardas/games_interface/base_game.dart';
import 'package:gardas/injection_container.dart';

/// Flags game implementation
/// 
/// This class implements the game interface for the flags game.
class FlagsGame extends BaseGame {
  /// The BLoC for the flags game
  final FlagsGameBloc _bloc = sl<FlagsGameBloc>();
  
    // Eksik değişkenlerin tanımlanması
  Function(Score)? _scoreCallback;
  VoidCallback? _gameOverCallback;

  /// Constructor for FlagsGame
  FlagsGame();
  
  @override
  Game get gameInfo => const Game(
    id: 'flags_game',
    name: 'Bayrak Bilme Oyunu',
    description: 'Bayrağın hangi ülkeye ait olduğunu tahmin et!',
    iconPath: 'assets/images/flags_game_icon.png',
    routePath: '/flags-game',
    hasDifficultyLevels: true,
    hasSoundEffects: true,
    isOfflineAvailable: true,
    hasTutorial: true,
    tags: ['quiz', 'bayraklar', 'ülkeler', 'coğrafya'],
  );
  
  @override
  List<GameDifficulty> get supportedDifficulties => [
    GameDifficulty.easy,
    GameDifficulty.medium,
    GameDifficulty.hard,
  ];
  
  @override
  Widget buildGame({
    required BuildContext context,
    required GameDifficulty difficulty,
    required Function(Score) onScoreUpdated,
    required VoidCallback onGameOver,
  }) {
    currentDifficulty = difficulty;
    _scoreCallback = onScoreUpdated;
    _gameOverCallback = onGameOver;
    
    return BlocProvider.value(
      value: _bloc,
      child: FlagGamePage(
        difficulty: difficulty,
        onExit: () {
          resetGame();
          onGameOver();
        },
      ),
    );
  }
  
  @override
  Widget? buildTutorial({
    required BuildContext context,
    required VoidCallback onTutorialCompleted,
  }) {
    return FlagGameTutorialPage(
      onComplete: onTutorialCompleted,
    );
  }
  
  @override
  Widget buildGameOverScreen({
    required BuildContext context,
    required Score score,
    required Function() onPlayAgain,
    required Function() onExit,
  }) {
    FlagScore flagScore;
    
    if (score is FlagScore) {
      flagScore = score;
    } else {
      flagScore = FlagScore.fromScore(score);
    }
    
    return BlocProvider.value(
      value: _bloc,
      child: BlocBuilder<FlagsGameBloc, FlagsGameState>(
        builder: (context, state) {
          if (state is GameOver) {
            return super.buildGameOverScreen(
              context: context,
              score: state.score,
              onPlayAgain: onPlayAgain,
              onExit: onExit,
            );
          } else {
            return super.buildGameOverScreen(
              context: context,
              score: flagScore,
              onPlayAgain: onPlayAgain,
              onExit: onExit,
            );
          }
        },
      ),
    );
  }
  
  @override
  void startGame(GameDifficulty difficulty) {
    super.startGame(difficulty);
    
    // Load questions
    int questionCount;
    switch (difficulty) {
      case GameDifficulty.easy:
        questionCount = 10;
        break;
      case GameDifficulty.medium:
        questionCount = 15;
        break;
      case GameDifficulty.hard:
        questionCount = 20;
        break;
    }
    
    _bloc.add(LoadQuestionsEvent(
      difficulty: difficulty,
      count: questionCount,
    ));
  }
  
  @override
  void pauseGame() {
    super.pauseGame();
    _bloc.add(PauseGameEvent());
  }
  
  @override
  void resumeGame() {
    super.resumeGame();
    _bloc.add(ResumeGameEvent());
  }
  
  @override
  void resetGame() {
    super.resetGame();
    _bloc.add(ResetGameEvent());
  }
  
  @override
  void dispose() {
    super.dispose();
  }
}