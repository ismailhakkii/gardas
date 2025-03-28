import 'package:flutter/material.dart';
import 'package:gardas/core/constants/app_strings.dart';
import 'package:gardas/core/widgets/custom_button.dart';
import 'package:gardas/domain/entities/game.dart';
import 'package:gardas/domain/entities/score.dart';
import 'package:gardas/games_interface/game_interface.dart';

/// Base game implementation
/// 
/// This class provides a base implementation of the GameInterface
/// with common functionality that can be reused by specific games.
abstract class BaseGame implements GameInterface {
  /// Game state (running, paused, ended)
  GameState _gameState = GameState.notStarted;
  
  /// Selected difficulty level
  GameDifficulty _currentDifficulty = GameDifficulty.medium;
  
  /// Current score
  int _currentScore = 0;
  
  /// Game metadata
  Map<String, dynamic> _gameMetadata = {};
  
  /// Score update callback
  Function(Score)? _scoreCallback;
  
  /// Game over callback
  VoidCallback? _gameOverCallback;
  
  /// Returns the current game state
  GameState get gameState => _gameState;
  
  /// Returns the current difficulty level
  GameDifficulty get currentDifficulty => _currentDifficulty;
  
  /// Returns the current score
  int get currentScore => _currentScore;
  
  /// Returns the game metadata
  Map<String, dynamic> get gameMetadata => _gameMetadata;
  
  /// Sets the game difficulty
  set currentDifficulty(GameDifficulty difficulty) {
    _currentDifficulty = difficulty;
  }
  
  /// Sets the current score
  set currentScore(int score) {
    _currentScore = score;
    _notifyScoreUpdated();
  }
  
  /// Adds to the current score
  void addToScore(int points) {
    _currentScore += points;
    _notifyScoreUpdated();
  }
  
  /// Sets game metadata
  void setMetadata(String key, dynamic value) {
    _gameMetadata[key] = value;
  }
  
  /// Creates a new score object
  Score createScore({
    required String userId,
  }) {
    return Score(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      gameId: gameInfo.id,
      userId: userId,
      value: currentScore,
      difficulty: currentDifficulty,
      date: DateTime.now(),
      metadata: gameMetadata,
    );
  }
  
  /// Notifies about score updates
  void _notifyScoreUpdated() {
    if (_scoreCallback != null && gameState == GameState.running) {
      final score = createScore(userId: 'current_user');
      _scoreCallback!(score);
    }
  }
  
  /// Notifies that the game is over
  void endGame() {
    if (_gameState == GameState.running) {
      _gameState = GameState.ended;
      if (_gameOverCallback != null) {
        _gameOverCallback!();
      }
    }
  }

  @override
  void startGame(GameDifficulty difficulty) {
    _gameState = GameState.running;
    _currentDifficulty = difficulty;
    _currentScore = 0;
    _gameMetadata = {};
  }

  @override
  void pauseGame() {
    if (_gameState == GameState.running) {
      _gameState = GameState.paused;
    }
  }

  @override
  void resumeGame() {
    if (_gameState == GameState.paused) {
      _gameState = GameState.running;
    }
  }

  @override
  void resetGame() {
    _gameState = GameState.notStarted;
    _currentScore = 0;
    _gameMetadata = {};
  }

  @override
  Widget buildDifficultySelection({
    required BuildContext context,
    required Function(GameDifficulty) onDifficultySelected,
  }) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppStrings.flagsGameSelectDifficulty,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ...supportedDifficulties.map(
                (difficulty) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: CustomButton(
                    text: _getDifficultyText(difficulty),
                    onPressed: () => onDifficultySelected(difficulty),
                    fullWidth: true,
                    type: _getDifficultyButtonType(difficulty),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Returns the appropriate text for a difficulty level
  String _getDifficultyText(GameDifficulty difficulty) {
    switch (difficulty) {
      case GameDifficulty.easy:
        return AppStrings.flagsGameEasy;
      case GameDifficulty.medium:
        return AppStrings.flagsGameMedium;
      case GameDifficulty.hard:
        return AppStrings.flagsGameHard;
    }
  }
  
  /// Returns the appropriate button type for a difficulty level
  ButtonType _getDifficultyButtonType(GameDifficulty difficulty) {
    switch (difficulty) {
      case GameDifficulty.easy:
        return ButtonType.primary;
      case GameDifficulty.medium:
        return ButtonType.secondary;
      case GameDifficulty.hard:
        return ButtonType.outlined;
    }
  }
  
  @override
  Widget buildGame({
    required BuildContext context,
    required GameDifficulty difficulty,
    required Function(Score) onScoreUpdated,
    required VoidCallback onGameOver,
  }) {
    _scoreCallback = onScoreUpdated;
    _gameOverCallback = onGameOver;
    currentDifficulty = difficulty;
    return const SizedBox();
  }
  
  @override
  Widget? buildTutorial({
    required BuildContext context,
    required VoidCallback onTutorialCompleted,
  }) {
    // Return null if game doesn't have a tutorial
    return null;
  }
  
  @override
  Widget buildGameOverScreen({
    required BuildContext context,
    required Score score,
    required Function() onPlayAgain,
    required Function() onExit,
  }) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppStrings.flagsGameGameOver,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                AppStrings.flagsGameFinalScore,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                score.value.toString(),
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: AppStrings.flagsGamePlayAgain,
                onPressed: onPlayAgain,
                fullWidth: true,
                type: ButtonType.primary,
                icon: Icons.replay,
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: AppStrings.flagsGameBackToHome,
                onPressed: onExit,
                fullWidth: true,
                type: ButtonType.outlined,
                icon: Icons.home,
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _scoreCallback = null;
    _gameOverCallback = null;
  }
}

/// Game state enum
enum GameState {
  notStarted,
  running,
  paused,
  ended,
}