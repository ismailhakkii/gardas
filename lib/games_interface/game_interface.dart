import 'package:flutter/material.dart';
import 'package:gardas/domain/entities/game.dart';
import 'package:gardas/domain/entities/score.dart';

/// Game interface
/// 
/// This interface defines the common properties and methods that all games should implement.
/// It ensures consistency across different games in the collection.
abstract class GameInterface {
  /// Returns the game entity with metadata
  /// 
  /// This includes game name, description, ID, and route path
  Game get gameInfo;
  
  /// Returns the game difficulty levels supported by this game
  /// 
  /// The first difficulty in the list is treated as the default
  List<GameDifficulty> get supportedDifficulties;
  
  /// Returns the widget to render the game UI
  /// 
  /// @param context The build context
  /// @param difficulty The selected difficulty level
  /// @param onScoreUpdated Callback for when the score changes
  /// @param onGameOver Callback for when the game ends
  Widget buildGame({
    required BuildContext context,
    required GameDifficulty difficulty,
    required Function(Score) onScoreUpdated,
    required VoidCallback onGameOver,
  });
  
  /// Returns the widget to render the difficulty selection screen
  /// 
  /// @param context The build context
  /// @param onDifficultySelected Callback for when a difficulty is chosen
  Widget buildDifficultySelection({
    required BuildContext context,
    required Function(GameDifficulty) onDifficultySelected,
  });
  
  /// Returns the widget to render the game tutorial
  /// 
  /// This is optional and can return null if no custom tutorial is needed.
  /// @param context The build context
  /// @param onTutorialCompleted Callback for when tutorial is completed/closed
  Widget? buildTutorial({
    required BuildContext context,
    required VoidCallback onTutorialCompleted,
  });
  
  /// Returns the widget to render the game over screen
  /// 
  /// @param context The build context
  /// @param score The final score achieved
  /// @param onPlayAgain Callback for when player wants to play again
  /// @param onExit Callback for when player wants to exit
  Widget buildGameOverScreen({
    required BuildContext context,
    required Score score,
    required Function() onPlayAgain,
    required Function() onExit,
  });
  
  /// Starts the game with the specified difficulty
  /// 
  /// This should initialize game state and begin any timers or animations
  void startGame(GameDifficulty difficulty);
  
  /// Pauses the game
  /// 
  /// This should pause any active timers, animations, and game logic
  void pauseGame();
  
  /// Resumes the game
  /// 
  /// This should resume previously paused timers, animations, and game logic
  void resumeGame();
  
  /// Resets the game
  /// 
  /// This should reset the game to its initial state, ready to be played again
  void resetGame();
  
  /// Cleanly ends the current game session
  /// 
  /// This should stop any ongoing game activities, save state as needed,
  /// and prepare for either a new game or for the game to be disposed.
  /// 
  /// This is called before dispose() when exiting a game and should handle
  /// game-specific cleanup that needs to happen while the widget is still mounted.
  void endGame() {
    // Default implementation safely ends the current game
    try {
      pauseGame();
      // No need to do additional cleanup in the base implementation
    } catch (e) {
      // Safely catch any errors that might occur during game ending
      print("Error in endGame(): $e");
    }
  }
  
  /// Disposes game resources
  /// 
  /// This should clean up any resources used by the game,
  /// such as controllers, streams, or other disposable objects.
  /// It is called when the game widget is being removed from the tree.
  void dispose();
}