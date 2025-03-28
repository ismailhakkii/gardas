import 'package:gardas/domain/entities/game.dart';
import 'package:gardas/features/flags_game/domain/entities/flag_question.dart';
import 'package:gardas/features/flags_game/domain/entities/flag_score.dart';

/// Flag option model class
/// 
/// Data layer representation of a [FlagOption] entity.
class FlagOptionModel extends FlagOption {
  /// Constructor for FlagOptionModel
  const FlagOptionModel({
    required String countryCode,
    required String countryName,
    required String flagEmoji,
  }) : super(
    countryCode: countryCode,
    countryName: countryName,
    flagEmoji: flagEmoji,
  );

  /// Creates a [FlagOptionModel] from a JSON map
  factory FlagOptionModel.fromJson(Map<String, dynamic> json) {
    return FlagOptionModel(
      countryCode: json['country_code'],
      countryName: json['country_name'],
      flagEmoji: json['flag_emoji'],
    );
  }

  /// Converts this [FlagOptionModel] to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'country_code': countryCode,
      'country_name': countryName,
      'flag_emoji': flagEmoji,
    };
  }

  /// Creates a [FlagOptionModel] from a [FlagOption] entity
  factory FlagOptionModel.fromEntity(FlagOption option) {
    return FlagOptionModel(
      countryCode: option.countryCode,
      countryName: option.countryName,
      flagEmoji: option.flagEmoji,
    );
  }
}

/// Flag question model class
/// 
/// Data layer representation of a [FlagQuestion] entity.
class FlagQuestionModel extends FlagQuestion {
  /// Constructor for FlagQuestionModel
  const FlagQuestionModel({
    required String id,
    required FlagOption correctOption,
    required List<FlagOption> options,
    required GameDifficulty difficulty,
  }) : super(
    id: id,
    correctOption: correctOption,
    options: options,
    difficulty: difficulty,
  );

  /// Creates a [FlagQuestionModel] from a JSON map
  factory FlagQuestionModel.fromJson(Map<String, dynamic> json) {
    return FlagQuestionModel(
      id: json['id'],
      correctOption: FlagOptionModel.fromJson(json['correct_option']),
      options: (json['options'] as List)
          .map((option) => FlagOptionModel.fromJson(option))
          .toList(),
      difficulty: _difficultyFromString(json['difficulty']),
    );
  }

  /// Converts this [FlagQuestionModel] to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'correct_option': (correctOption as FlagOptionModel).toJson(),
      'options': options
          .map((option) => (option as FlagOptionModel).toJson())
          .toList(),
      'difficulty': _difficultyToString(difficulty),
    };
  }

  /// Creates a [FlagQuestionModel] from a [FlagQuestion] entity
  factory FlagQuestionModel.fromEntity(FlagQuestion question) {
    return FlagQuestionModel(
      id: question.id,
      correctOption: FlagOptionModel.fromEntity(question.correctOption),
      options: question.options
          .map((option) => FlagOptionModel.fromEntity(option))
          .toList(),
      difficulty: question.difficulty,
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

/// Flag score model class
/// 
/// Data layer representation of a [FlagScore] entity.
class FlagScoreModel extends FlagScore {
  /// Constructor for FlagScoreModel
  FlagScoreModel({
    required String id,
    required String gameId,
    required String userId,
    required int value,
    required GameDifficulty difficulty,
    required DateTime date,
    required int correctAnswers,
    required int wrongAnswers,
    required int totalQuestions,
    required double averageTimePerQuestion,
  }) : super(
    id: id,
    gameId: gameId,
    userId: userId,
    value: value,
    difficulty: difficulty,
    date: date,
    correctAnswers: correctAnswers,
    wrongAnswers: wrongAnswers,
    totalQuestions: totalQuestions,
    averageTimePerQuestion: averageTimePerQuestion,
  );

  /// Creates a [FlagScoreModel] from a JSON map
  factory FlagScoreModel.fromJson(Map<String, dynamic> json) {
    final metadata = json['metadata'] as Map<String, dynamic>;
    return FlagScoreModel(
      id: json['id'],
      gameId: json['game_id'],
      userId: json['user_id'],
      value: json['value'],
      difficulty: _difficultyFromString(json['difficulty']),
      date: DateTime.parse(json['date']),
      correctAnswers: metadata['correctAnswers'] ?? 0,
      wrongAnswers: metadata['wrongAnswers'] ?? 0,
      totalQuestions: metadata['totalQuestions'] ?? 0,
      averageTimePerQuestion: (metadata['averageTimePerQuestion'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Converts this [FlagScoreModel] to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'game_id': gameId,
      'user_id': userId,
      'value': value,
      'difficulty': _difficultyToString(difficulty),
      'date': date.toIso8601String(),
      'metadata': {
        'correctAnswers': correctAnswers,
        'wrongAnswers': wrongAnswers,
        'totalQuestions': totalQuestions,
        'averageTimePerQuestion': averageTimePerQuestion,
      },
    };
  }

  /// Creates a [FlagScoreModel] from a [FlagScore] entity
  factory FlagScoreModel.fromEntity(FlagScore score) {
    return FlagScoreModel(
      id: score.id,
      gameId: score.gameId,
      userId: score.userId,
      value: score.value,
      difficulty: score.difficulty,
      date: score.date,
      correctAnswers: score.correctAnswers,
      wrongAnswers: score.wrongAnswers,
      totalQuestions: score.totalQuestions,
      averageTimePerQuestion: score.averageTimePerQuestion,
    );
  }

  @override
  FlagScoreModel copyWith({
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
    return FlagScoreModel(
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