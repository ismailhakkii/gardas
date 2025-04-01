import 'package:equatable/equatable.dart';
import 'package:flutter/src/widgets/icon_data.dart';

/// Difficulty level for games
enum GameDifficulty {
  easy,
  medium,
  hard,
}

/// Game entity
/// 
/// Represents a game in the application.
class Game extends Equatable {
  /// Unique identifier for the game
  final String id;
  
  /// Name of the game
  final String name;
  
  /// Description of the game
  final String description;
  
  /// Icon path for the game
  final String iconPath;
  
  /// Route path for the game
  final String routePath;
  
  /// Whether the game supports difficulty levels
  final bool hasDifficultyLevels;
  
  /// Whether the game has sound effects
  final bool hasSoundEffects;
  
  /// Whether the game is available offline
  final bool isOfflineAvailable;
  
  /// Whether the game has a tutorial
  final bool hasTutorial;
  
  /// Tags for the game
  final List<String> tags;

  /// Constructor for Game entity
  const Game({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    required this.routePath,
    this.hasDifficultyLevels = false,
    this.hasSoundEffects = false,
    this.isOfflineAvailable = true,
    this.hasTutorial = false,
    this.tags = const [], required IconData iconData,
  });
  
  @override
  List<Object?> get props => [
    id,
    name,
    description,
    iconPath,
    routePath,
    hasDifficultyLevels,
    hasSoundEffects,
    isOfflineAvailable,
    hasTutorial,
    tags,
  ];
}

/// Base game stats entity
/// 
/// Represents base statistics for a game.
abstract class GameStats extends Equatable {
  /// ID of the game
  final String gameId;
  
  /// High score in the game
  final int highScore;
  
  /// Total number of games played
  final int gamesPlayed;
  
  /// Date of the last game played
  final DateTime lastPlayed;

  /// Constructor for GameStats entity
  const GameStats({
    required this.gameId,
    required this.highScore,
    required this.gamesPlayed,
    required this.lastPlayed,
  });
  
  @override
  List<Object?> get props => [gameId, highScore, gamesPlayed, lastPlayed];
}