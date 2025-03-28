import 'dart:math';
import 'package:gardas/domain/entities/game.dart';
import 'package:gardas/features/math_puzzle/domain/entities/math_question.dart';

/// Matematik bulmaca soruları üreten sınıf
class MathQuestionGenerator {
  final Random _random = Random();
  
  /// Belirtilen zorluk ve işlem türüne göre rastgele soru üretir
  List<MathQuestion> generateQuestions({
    required GameDifficulty difficulty,
    required MathOperationType operationType,
    required int count,
  }) {
    final questions = <MathQuestion>[];
    
    for (int i = 0; i < count; i++) {
      questions.add(_generateQuestion(
        difficulty: difficulty,
        operationType: operationType,
        questionId: 'q_${DateTime.now().millisecondsSinceEpoch}_$i',
      ));
    }
    
    return questions;
  }
  
  /// Tek bir matematik sorusu üretir
  MathQuestion _generateQuestion({
    required GameDifficulty difficulty,
    required MathOperationType operationType,
    required String questionId,
  }) {
    // İşlem türünü belirle
    final MathOperationType actualOperationType = operationType == MathOperationType.mixed
        ? _getRandomOperationType()
        : operationType;
    
    // Zorluk seviyesine göre sayıları üret
    int num1, num2, answer;
    String questionText;
    
    switch (actualOperationType) {
      case MathOperationType.addition:
        (num1, num2, answer, questionText) = _generateAdditionQuestion(difficulty);
        break;
      case MathOperationType.subtraction:
        (num1, num2, answer, questionText) = _generateSubtractionQuestion(difficulty);
        break;
      case MathOperationType.multiplication:
        (num1, num2, answer, questionText) = _generateMultiplicationQuestion(difficulty);
        break;
      case MathOperationType.division:
        (num1, num2, answer, questionText) = _generateDivisionQuestion(difficulty);
        break;
      case MathOperationType.mixed:
        // Bu duruma girmeyeceğiz, çünkü yukarıda kontrol ettik
        (num1, num2, answer, questionText) = _generateAdditionQuestion(difficulty);
        break;
    }
    
    // Seçenekleri oluştur
    final options = _generateOptions(answer, difficulty);
    
    return MathQuestion(
      id: questionId,
      questionText: questionText,
      correctAnswer: answer,
      difficulty: difficulty,
      operationType: actualOperationType,
      options: options,
    );
  }
  
  /// Rastgele bir işlem türü seçer
  MathOperationType _getRandomOperationType() {
    final types = [
      MathOperationType.addition,
      MathOperationType.subtraction,
      MathOperationType.multiplication,
      MathOperationType.division,
    ];
    return types[_random.nextInt(types.length)];
  }
  
  /// Toplama sorusu üretir
  (int, int, int, String) _generateAdditionQuestion(GameDifficulty difficulty) {
    int num1, num2;
    
    switch (difficulty) {
      case GameDifficulty.easy:
        num1 = _random.nextInt(10) + 1; // 1-10
        num2 = _random.nextInt(10) + 1; // 1-10
        break;
      case GameDifficulty.medium:
        num1 = _random.nextInt(50) + 10; // 10-59
        num2 = _random.nextInt(40) + 10; // 10-49
        break;
      case GameDifficulty.hard:
        num1 = _random.nextInt(500) + 50; // 50-549
        num2 = _random.nextInt(450) + 50; // 50-499
        break;
    }
    
    final int answer = num1 + num2;
    final String questionText = '$num1 + $num2 = ?';
    
    return (num1, num2, answer, questionText);
  }
  
  /// Çıkarma sorusu üretir
  (int, int, int, String) _generateSubtractionQuestion(GameDifficulty difficulty) {
    int num1, num2;
    
    switch (difficulty) {
      case GameDifficulty.easy:
        num1 = _random.nextInt(10) + 10; // 10-19
        num2 = _random.nextInt(num1 - 1) + 1; // 1'den num1-1'e kadar
        break;
      case GameDifficulty.medium:
        num1 = _random.nextInt(90) + 10; // 10-99
        num2 = _random.nextInt(num1 - 5) + 5; // 5'ten num1-5'e kadar
        break;
      case GameDifficulty.hard:
        num1 = _random.nextInt(900) + 100; // 100-999
        num2 = _random.nextInt(num1 - 50) + 50; // 50'den num1-50'ye kadar
        break;
    }
    
    final int answer = num1 - num2;
    final String questionText = '$num1 - $num2 = ?';
    
    return (num1, num2, answer, questionText);
  }
  
  /// Çarpma sorusu üretir
  (int, int, int, String) _generateMultiplicationQuestion(GameDifficulty difficulty) {
    int num1, num2;
    
    switch (difficulty) {
      case GameDifficulty.easy:
        num1 = _random.nextInt(5) + 1; // 1-5
        num2 = _random.nextInt(5) + 1; // 1-5
        break;
      case GameDifficulty.medium:
        num1 = _random.nextInt(8) + 3; // 3-10
        num2 = _random.nextInt(8) + 3; // 3-10
        break;
      case GameDifficulty.hard:
        num1 = _random.nextInt(13) + 8; // 8-20
        num2 = _random.nextInt(13) + 8; // 8-20
        break;
    }
    
    final int answer = num1 * num2;
    final String questionText = '$num1 × $num2 = ?';
    
    return (num1, num2, answer, questionText);
  }
  
  /// Bölme sorusu üretir (sonucu tam sayı olacak şekilde)
  (int, int, int, String) _generateDivisionQuestion(GameDifficulty difficulty) {
    int num1, num2, answer;
    
    switch (difficulty) {
      case GameDifficulty.easy:
        answer = _random.nextInt(5) + 1; // 1-5
        num2 = _random.nextInt(3) + 2; // 2-4
        num1 = answer * num2;
        break;
      case GameDifficulty.medium:
        answer = _random.nextInt(7) + 4; // 4-10
        num2 = _random.nextInt(5) + 3; // 3-7
        num1 = answer * num2;
        break;
      case GameDifficulty.hard:
        answer = _random.nextInt(10) + 11; // 11-20
        num2 = _random.nextInt(7) + 4; // 4-10
        num1 = answer * num2;
        break;
    }
    
    final String questionText = '$num1 ÷ $num2 = ?';
    
    return (num1, num2, answer, questionText);
  }
  
  /// Cevap seçeneklerini oluşturur
  List<MathOption> _generateOptions(int correctAnswer, GameDifficulty difficulty) {
    final List<MathOption> options = [];
    final Set<int> usedValues = {correctAnswer};
    
    // Doğru cevabı ekle
    options.add(MathOption(
      value: correctAnswer,
      text: correctAnswer.toString(),
    ));
    
    // Yanlış seçenekleri ekle
    int maxOffset;
    int minOffset = 1;
    
    switch (difficulty) {
      case GameDifficulty.easy:
        maxOffset = correctAnswer < 5 ? 5 : correctAnswer ~/ 2 + 2;
        break;
      case GameDifficulty.medium:
        maxOffset = correctAnswer < 10 ? 10 : correctAnswer ~/ 2 + 5;
        break;
      case GameDifficulty.hard:
        maxOffset = correctAnswer < 20 ? 20 : correctAnswer ~/ 2 + 10;
        minOffset = 2;
        break;
    }
    
    // Seçenek sayısını zorluk seviyesine göre belirle
    int optionCount;
    switch (difficulty) {
      case GameDifficulty.easy:
        optionCount = 3;
        break;
      case GameDifficulty.medium:
        optionCount = 4;
        break;
      case GameDifficulty.hard:
        optionCount = 4;
        break;
    }
    
    // Yanlış seçenekleri oluştur
    while (options.length < optionCount) {
      final int offset = _random.nextInt(maxOffset) + minOffset;
      final bool addOrSubtract = _random.nextBool();
      
      final int wrongAnswer = addOrSubtract 
          ? correctAnswer + offset 
          : max(correctAnswer - offset, 1); // Negatif olmasın
      
      if (!usedValues.contains(wrongAnswer)) {
        usedValues.add(wrongAnswer);
        options.add(MathOption(
          value: wrongAnswer,
          text: wrongAnswer.toString(),
        ));
      }
    }
    
    // Seçenekleri karıştır
    options.shuffle();
    
    return options;
  }
}