import 'package:flutter/material.dart';
import 'package:gardas/domain/entities/game.dart';
import 'package:gardas/domain/entities/score.dart';

/// Game interface
/// 
/// This interface defines the common properties and methods that all games should implement.
/// It ensures consistency across different games in the collection.
abstract class GameInterface {
  /// Returns the game entity with metadata
  Game get gameInfo;
  
  /// Returns the game difficulty levels
  List<GameDifficulty> get supportedDifficulties;
  
  /// Returns the widget to render the game
  Widget buildGame({
    required BuildContext context,
    required GameDifficulty difficulty,
    required Function(Score) onScoreUpdated,
    required VoidCallback onGameOver,
  });
  
  /// Returns the widget to render the difficulty selection screen
  Widget buildDifficultySelection({
    required BuildContext context,
    required Function(GameDifficulty) onDifficultySelected,
  });
  
  /// Returns the widget to render the game tutorial
  Widget? buildTutorial({
    required BuildContext context,
    required VoidCallback onTutorialCompleted,
  });
  
  /// Returns the widget to render the game over screen
  Widget buildGameOverScreen({
    required BuildContext context,
    required Score score,
    required Function() onPlayAgain,
    required Function() onExit,
  });
  
  /// Starts the game with the specified difficulty
  void startGame(GameDifficulty difficulty);
  
  /// Pauses the game
  void pauseGame();
  
  /// Resumes the game
  void resumeGame();
  
  /// Resets the game
  void resetGame();
  
  /// Disposes game resources
  void dispose();
}