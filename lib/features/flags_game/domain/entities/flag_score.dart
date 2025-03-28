import 'package:gardas/domain/entities/game.dart';
import 'package:gardas/domain/entities/score.dart';

/// Flag game score entity
/// 
/// Extends the base Score entity with additional metadata specific to the flags game.
class FlagScore extends Score {
  /// Number of correct answers
  final int correctAnswers;
  
  /// Number of wrong answers
  final int wrongAnswers;
  
  /// Number of questions answered
  final int totalQuestions;
  
  /// Average time per question (in seconds)
  final double averageTimePerQuestion;
  
  /// Constructor for FlagScore
  FlagScore({
    required String id,
    required String gameId,
    required String userId,
    required int value,
    required GameDifficulty difficulty,
    required DateTime date,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.totalQuestions,
    required this.averageTimePerQuestion,
  }) : super(
    id: id,
    gameId: gameId,
    userId: userId,
    value: value,
    difficulty: difficulty,
    date: date,
    metadata: {
      'correctAnswers': correctAnswers,
      'wrongAnswers': wrongAnswers,
      'totalQuestions': totalQuestions,
      'averageTimePerQuestion': averageTimePerQuestion,
    },
  );
  
  /// Factory constructor to create a FlagScore from a base Score
  factory FlagScore.fromScore(Score score) {
    final metadata = score.metadata ?? {};
    return FlagScore(
      id: score.id,
      gameId: score.gameId,
      userId: score.userId,
      value: score.value,
      difficulty: score.difficulty,
      date: score.date,
      correctAnswers: metadata['correctAnswers'] ?? 0,
      wrongAnswers: metadata['wrongAnswers'] ?? 0,
      totalQuestions: metadata['totalQuestions'] ?? 0,
      averageTimePerQuestion: (metadata['averageTimePerQuestion'] as num?)?.toDouble() ?? 0.0,
    );
  }
  
  /// Calculate accuracy percentage
  double get accuracyPercentage => 
      totalQuestions > 0 ? (correctAnswers / totalQuestions) * 100 : 0;
      
  @override
  FlagScore copyWith({
    String? id,
    String? gameId,
    String? userId,
    int? value,
    GameDifficulty? difficulty,
    DateTime? date,
    int? correctAnswers,
    int? wrongAnswers,
    int? totalQuestions,
    double? averageTimePerQuestion,
    Map<String, dynamic>? metadata,
  }) {
    return FlagScore(
      id: id ?? this.id,
      gameId: gameId ?? this.gameId,
      userId: userId ?? this.userId,
      value: value ?? this.value,
      difficulty: difficulty ?? this.difficulty,
      date: date ?? this.date,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      wrongAnswers: wrongAnswers ?? this.wrongAnswers,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      averageTimePerQuestion: averageTimePerQuestion ?? this.averageTimePerQuestion,
    );
  }
}