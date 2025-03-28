import 'package:gardas/domain/entities/game.dart';
import 'package:gardas/domain/entities/score.dart';

/// Score model class
/// 
/// Data layer representation of a [Score] entity.
class ScoreModel extends Score {
  /// Constructor for ScoreModel
  const ScoreModel({
    required String id,
    required String gameId,
    required String userId,
    required int value,
    required GameDifficulty difficulty,
    required DateTime date,
    Map<String, dynamic>? metadata,
  }) : super(
    id: id,
    gameId: gameId,
    userId: userId,
    value: value,
    difficulty: difficulty,
    date: date,
    metadata: metadata,
  );

  /// Creates a [ScoreModel] from a JSON map
  factory ScoreModel.fromJson(Map<String, dynamic> json) {
    return ScoreModel(
      id: json['id'],
      gameId: json['game_id'],
      userId: json['user_id'],
      value: json['value'],
      difficulty: _difficultyFromString(json['difficulty']),
      date: DateTime.parse(json['date']),
      metadata: json['metadata'],
    );
  }

  /// Converts this [ScoreModel] to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'game_id': gameId,
      'user_id': userId,
      'value': value,
      'difficulty': _difficultyToString(difficulty),
      'date': date.toIso8601String(),
      'metadata': metadata,
    };
  }

  /// Creates a [ScoreModel] from a [Score] entity
  factory ScoreModel.fromEntity(Score score) {
    return ScoreModel(
      id: score.id,
      gameId: score.gameId,
      userId: score.userId,
      value: score.value,
      difficulty: score.difficulty,
      date: score.date,
      metadata: score.metadata,
    );
  }

  /// Creates a copy of this [ScoreModel] with the given fields replaced
  @override
  ScoreModel copyWith({
    String? id,
    String? gameId,
    String? userId,
    int? value,
    GameDifficulty? difficulty,
    DateTime? date,
    Map<String, dynamic>? metadata,
  }) {
    return ScoreModel(
      id: id ?? this.id,
      gameId: gameId ?? this.gameId,
      userId: userId ?? this.userId,
      value: value ?? this.value,
      difficulty: difficulty ?? this.difficulty,
      date: date ?? this.date,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Converts a difficulty string to a [GameDifficulty]
  static GameDifficulty _difficultyFromString(String value) {
    switch (value) {
      case 'easy':
        return GameDifficulty.easy;
      case 'medium':
        return GameDifficulty.medium;
      case 'hard':
        return GameDifficulty.hard;
      default:
        return GameDifficulty.medium;
    }
  }

  /// Converts a [GameDifficulty] to a string
  static String _difficultyToString(GameDifficulty difficulty) {
    switch (difficulty) {
      case GameDifficulty.easy:
        return 'easy';
      case GameDifficulty.medium:
        return 'medium';
      case GameDifficulty.hard:
        return 'hard';
    }
  }
}