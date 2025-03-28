import 'package:flutter/material.dart';
import 'package:gardas/core/constants/app_strings.dart';
import 'package:gardas/core/widgets/custom_button.dart';
import 'package:gardas/domain/entities/game.dart';
import 'package:gardas/domain/entities/score.dart';
import 'package:gardas/games_interface/game_interface.dart';

/// Game base page
///
/// This is a container page that wraps all games to provide consistent UI.
class GameBasePage extends StatefulWidget {
  /// The game to display
  final GameInterface? game;
  
  /// Initial difficulty (optional)
  final GameDifficulty? initialDifficulty;
  
  /// Whether to start with the tutorial
  final bool startWithTutorial;

  const GameBasePage({
    Key? key,
    required this.game,
    this.initialDifficulty,
    this.startWithTutorial = false,
  }) : super(key: key);

  @override
  State<GameBasePage> createState() => _GameBasePageState();
}

class _GameBasePageState extends State<GameBasePage> {
  // Current state
  GameBaseState _currentState = GameBaseState.initial;
  
  // Selected difficulty
  GameDifficulty? _selectedDifficulty;
  
  // Current score
  Score? _currentScore;

  @override
  void initState() {
    super.initState();
    
    // Set initial difficulty if provided
    _selectedDifficulty = widget.initialDifficulty;
    
    // Determine initial state
    if (widget.startWithTutorial && widget.game?.gameInfo.hasTutorial == true) {
      _currentState = GameBaseState.tutorial;
    } else if (_selectedDifficulty != null) {
      _currentState = GameBaseState.playing;
    } else if (widget.game?.gameInfo.hasDifficultyLevels == true) {
      _currentState = GameBaseState.selectingDifficulty;
    } else {
      _currentState = GameBaseState.playing;
      _selectedDifficulty = GameDifficulty.medium; // Default
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.game == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Game not found')),
      );
    }
    
    switch (_currentState) {
      case GameBaseState.initial:
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      
      case GameBaseState.tutorial:
        return _buildTutorialScreen();
      
      case GameBaseState.selectingDifficulty:
        return _buildDifficultySelectionScreen();
      
      case GameBaseState.playing:
        return _buildGameScreen();
      
      case GameBaseState.gameOver:
        return _buildGameOverScreen();
    }
  }
  
  Widget _buildTutorialScreen() {
    final tutorialWidget = widget.game!.buildTutorial(
      context: context,
      onTutorialCompleted: _onTutorialCompleted,
    );
    
    if (tutorialWidget != null) {
      return tutorialWidget;
    } else {
      // If there's no tutorial, go directly to difficulty selection or game
      setState(() {
        if (widget.game!.gameInfo.hasDifficultyLevels) {
          _currentState = GameBaseState.selectingDifficulty;
        } else {
          _currentState = GameBaseState.playing;
          _selectedDifficulty = GameDifficulty.medium; // Default
        }
      });
      
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
  }
  
  Widget _buildDifficultySelectionScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.game!.gameInfo.name),
      ),
      body: widget.game!.buildDifficultySelection(
        context: context,
        onDifficultySelected: _onDifficultySelected,
      ),
    );
  }
  
  Widget _buildGameScreen() {
    return widget.game!.buildGame(
      context: context,
      difficulty: _selectedDifficulty ?? GameDifficulty.medium,
      onScoreUpdated: _onScoreUpdated,
      onGameOver: _onGameOver,
    );
  }
  
  Widget _buildGameOverScreen() {
    if (_currentScore == null) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.game!.gameInfo.name)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Game Over'),
              const SizedBox(height: 16),
              CustomButton(
                text: AppStrings.exit,
                onPressed: () => Navigator.of(context).pop(),
                type: ButtonType.primary,
              ),
            ],
          ),
        ),
      );
    }
    
    return Scaffold(
      appBar: AppBar(title: Text(widget.game!.gameInfo.name)),
      body: widget.game!.buildGameOverScreen(
        context: context,
        score: _currentScore!,
        onPlayAgain: _onPlayAgain,
        onExit: () => Navigator.of(context).pop(),
      ),
    );
  }
  
  void _onTutorialCompleted() {
    setState(() {
      if (widget.game!.gameInfo.hasDifficultyLevels) {
        _currentState = GameBaseState.selectingDifficulty;
      } else {
        _currentState = GameBaseState.playing;
        _selectedDifficulty = GameDifficulty.medium; // Default
      }
    });
  }
  
  void _onDifficultySelected(GameDifficulty difficulty) {
    setState(() {
      _selectedDifficulty = difficulty;
      _currentState = GameBaseState.playing;
    });
    
    // Start the game
    widget.game!.startGame(difficulty);
  }
  
  void _onScoreUpdated(Score score) {
    _currentScore = score;
  }
  
  void _onGameOver() {
    setState(() {
      _currentState = GameBaseState.gameOver;
    });
  }
  
  void _onPlayAgain() {
    setState(() {
      if (widget.game!.gameInfo.hasDifficultyLevels) {
        _currentState = GameBaseState.selectingDifficulty;
      } else {
        _currentState = GameBaseState.playing;
        widget.game!.startGame(_selectedDifficulty ?? GameDifficulty.medium);
      }
    });
  }
}

/// Game base state
enum GameBaseState {
  initial,
  tutorial,
  selectingDifficulty,
  playing,
  gameOver,
}