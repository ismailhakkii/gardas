import 'package:equatable/equatable.dart';
import 'package:gardas/domain/entities/game.dart';

/// Matematik işlem türleri
enum MathOperationType {
  addition,
  subtraction,
  multiplication,
  division,
  mixed
}

/// Matematik bulmaca seçeneği
class MathOption extends Equatable {
  /// Seçeneğin değeri
  final int value;
  
  /// Seçeneğin metni
  final String text;

  const MathOption({
    required this.value,
    required this.text,
  });
  
  @override
  List<Object?> get props => [value, text];
}

/// Matematik bulmaca sorusu
class MathQuestion extends Equatable {
  /// Sorunun kimliği
  final String id;
  
  /// Sorunun metni (örn: "5 + 7 = ?")
  final String questionText;
  
  /// Doğru cevap
  final int correctAnswer;
  
  /// Sorunun zorluk seviyesi
  final GameDifficulty difficulty;
  
  /// İşlem türü
  final MathOperationType operationType;
  
  /// Mevcut seçenekler (doğru cevap dahil)
  final List<MathOption> options;

  const MathQuestion({
    required this.id,
    required this.questionText,
    required this.correctAnswer,
    required this.difficulty,
    required this.operationType,
    required this.options,
  });
  
  /// İşlem türüne göre sembol döndürür
  static String getOperationSymbol(MathOperationType type) {
    switch (type) {
      case MathOperationType.addition:
        return '+';
      case MathOperationType.subtraction:
        return '-';
      case MathOperationType.multiplication:
        return '×';
      case MathOperationType.division:
        return '÷';
      case MathOperationType.mixed:
        return '';
    }
  }

  @override
  List<Object?> get props => [id, questionText, correctAnswer, difficulty, operationType, options];
}

/// Matematik bulmaca skoru
class MathScore extends Equatable {
  /// Doğru cevap sayısı
  final int correctAnswers;
  
  /// Yanlış cevap sayısı
  final int wrongAnswers;
  
  /// Toplam puan
  final int totalScore;
  
  /// Ortalama cevap süresi (saniye)
  final double averageTime;
  
  /// Zorluk seviyesi
  final GameDifficulty difficulty;
  
  /// İşlem türü
  final MathOperationType operationType;

  const MathScore({
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.totalScore,
    required this.averageTime,
    required this.difficulty,
    required this.operationType,
  });
  
  /// Doğruluk oranını hesaplar
  double get accuracyPercentage {
    final total = correctAnswers + wrongAnswers;
    if (total == 0) return 0;
    return (correctAnswers / total) * 100;
  }

  @override
  List<Object?> get props => [
    correctAnswers,
    wrongAnswers,
    totalScore,
    averageTime,
    difficulty,
    operationType
  ];
}