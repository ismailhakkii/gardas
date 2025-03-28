import 'package:equatable/equatable.dart';
import 'package:gardas/domain/entities/game.dart';

/// Flag option entity
/// 
/// Represents an option for a flag question.
class FlagOption extends Equatable {
  /// Country code (2-letter ISO code)
  final String countryCode;
  
  /// Country name
  final String countryName;
  
  /// Flag emoji
  final String flagEmoji;
  
  /// Constructor for FlagOption
  const FlagOption({
    required this.countryCode,
    required this.countryName,
    required this.flagEmoji,
  });
  
  @override
  List<Object?> get props => [countryCode, countryName, flagEmoji];
}

/// Flag question entity
/// 
/// Represents a question in the flags game.
class FlagQuestion extends Equatable {
  /// Unique identifier for the question
  final String id;
  
  /// Correct answer option
  final FlagOption correctOption;
  
  /// List of all options (including the correct one)
  final List<FlagOption> options;
  
  /// Difficulty level of the question
  final GameDifficulty difficulty;
  
  /// Constructor for FlagQuestion
  const FlagQuestion({
    required this.id,
    required this.correctOption,
    required this.options,
    required this.difficulty,
  });
  
  @override
  List<Object?> get props => [id, correctOption, options, difficulty];
}