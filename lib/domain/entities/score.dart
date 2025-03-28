import 'package:equatable/equatable.dart';
import 'package:gardas/domain/entities/game.dart';

/// Score entity
/// 
/// Represents a score entry for a game.
class Score extends Equatable {
  /// Unique identifier for the score
  final String id;
  
  /// ID of the game
  final String gameId;
  
  /// ID of the user
  final String userId;
  
  /// Score value
  final int value;
  
  /// Difficulty level of the game when the score was achieved
  final GameDifficulty difficulty;
  
  /// Date when the score was achieved
  final DateTime date;
  
  /// Additional metadata for the score (e.g., game-specific information)
  final Map<String, dynamic>? metadata;

  /// Constructor for Score entity
  const Score({
    required this.id,
    required this.gameId,
    required this.userId,
    required this.value,
    required this.difficulty,
    required this.date,
    this.metadata,
  });

  /// Creates a copy of this Score with the given fields replaced with new values
  Score copyWith({
    String? id,
    String? gameId,
    String? userId,
    int? value,
    GameDifficulty? difficulty,
    DateTime? date,
    Map<String, dynamic>? metadata,
  }) {
    return Score(
      id: id ?? this.id,
      gameId: gameId ?? this.gameId,
      userId: userId ?? this.userId,
      value: value ?? this.value,
      difficulty: difficulty ?? this.difficulty,
      date: date ?? this.date,
      metadata: metadata ?? this.metadata,
    );
  }
  
  @override
  List<Object?> get props => [
    id,
    gameId,
    userId,
    value,
    difficulty,
    date,
    metadata,
  ];
}