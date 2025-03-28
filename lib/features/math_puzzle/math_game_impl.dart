import 'package:flutter/material.dart';
import 'package:gardas/domain/entities/game.dart';
import 'package:gardas/domain/entities/score.dart';
import 'package:gardas/features/math_puzzle/data/datasources/math_question_generator.dart';
import 'package:gardas/features/math_puzzle/domain/entities/math_question.dart';
import 'package:gardas/features/math_puzzle/presentation/pages/math_game_page.dart';
import 'package:gardas/games_interface/base_game.dart';

/// Matematik bulmaca oyunu implementasyonu
class MathGame extends BaseGame {
  /// Soru üretici
  final _questionGenerator = MathQuestionGenerator();
  
  /// Seçilen işlem türü
  MathOperationType _operationType = MathOperationType.mixed;
  
  /// Aktif sorular listesi
  List<MathQuestion> _questions = [];
  
  /// Mevcut soru indeksi
  int _currentQuestionIndex = 0;
  
  /// Doğru cevap sayısı
  int _correctAnswers = 0;
  
  /// Yanlış cevap sayısı
  int _wrongAnswers = 0;
  
  /// Toplam puan
  int _totalScore = 0;
  
  /// Cevap süreleri listesi
  List<double> _answerTimes = [];
  
  /// Callback değişkenlerini tanımlıyoruz (BaseGame'den gelmeliydi ama burada açıkça tanımlıyoruz)
  Function(Score)? _scoreCallback;
  VoidCallback? _gameOverCallback;

  /// Constructor
  MathGame();
  
  /// İşlem türünü ayarlar
  set operationType(MathOperationType type) {
    _operationType = type;
  }
  
  /// Mevcut soruyu döndürür
  MathQuestion? get currentQuestion {
    if (_questions.isEmpty || _currentQuestionIndex >= _questions.length) {
      return null;
    }
    return _questions[_currentQuestionIndex];
  }
  
  /// Public getterlar ekliyoruz
  List<MathQuestion> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get totalScore => _totalScore;
  int get correctAnswers => _correctAnswers;
  int get wrongAnswers => _wrongAnswers;
  
  @override
  Game get gameInfo => const Game(
    id: 'math_game',
    name: 'Matematik Bulmaca',
    description: 'Matematik işlemlerini çözerek puanları topla!',
    iconPath: 'assets/images/math_game_icon.png',
    routePath: '/math-game',
    hasDifficultyLevels: true,
    hasSoundEffects: true,
    isOfflineAvailable: true,
    hasTutorial: false,
    tags: ['matematik', 'bulmaca', 'zeka', 'eğitim'],
  );
  
  @override
  List<GameDifficulty> get supportedDifficulties => [
    GameDifficulty.easy,
    GameDifficulty.medium,
    GameDifficulty.hard,
  ];
  
  @override
  Widget buildGame({
    required BuildContext context,
    required GameDifficulty difficulty,
    required Function(Score) onScoreUpdated,
    required VoidCallback onGameOver,
  }) {
    currentDifficulty = difficulty;
    _scoreCallback = onScoreUpdated;
    _gameOverCallback = onGameOver;
    
    // Soruları oluştur
    _generateQuestions(difficulty);
    
    return MathGamePage(
      game: this,
      onExit: () {
        resetGame();
        onGameOver();
      },
      onAnswerSelected: _handleAnswer,
      onGameComplete: _handleGameComplete,
    );
  }
  
  @override
  void startGame(GameDifficulty difficulty) {
    super.startGame(difficulty);
    _generateQuestions(difficulty);
  }
  
  @override
  void resetGame() {
    super.resetGame();
    _questions = [];
    _currentQuestionIndex = 0;
    _correctAnswers = 0;
    _wrongAnswers = 0;
    _totalScore = 0;
    _answerTimes = [];
  }
  
  /// Soruları oluşturur
  void _generateQuestions(GameDifficulty difficulty) {
    // Zorluk seviyesine göre soru sayısı
    int questionCount;
    switch (difficulty) {
      case GameDifficulty.easy:
        questionCount = 10;
        break;
      case GameDifficulty.medium:
        questionCount = 15;
        break;
      case GameDifficulty.hard:
        questionCount = 20;
        break;
    }
    
    _questions = _questionGenerator.generateQuestions(
      difficulty: difficulty,
      operationType: _operationType,
      count: questionCount,
    );
  }
  
  /// Seçilen cevabı işler
  void _handleAnswer(MathOption selectedOption, double timeSpent) {
    final currentQ = currentQuestion;
    if (currentQ == null) return;
    
    final bool isCorrect = selectedOption.value == currentQ.correctAnswer;
    
    // Doğru/yanlış sayısını güncelle
    if (isCorrect) {
      _correctAnswers++;
      
      // Puanı hesapla (doğruluk + hız + zorluk seviyesi)
      int basePoints = 100;
      int speedBonus = (15 - timeSpent).round() * 5;
      if (speedBonus < 0) speedBonus = 0;
      
      int difficultyMultiplier = 1;
      switch (currentDifficulty) {
        case GameDifficulty.easy:
          difficultyMultiplier = 1;
          break;
        case GameDifficulty.medium:
          difficultyMultiplier = 2;
          break;
        case GameDifficulty.hard:
          difficultyMultiplier = 3;
          break;
      }
      
      _totalScore += (basePoints + speedBonus) * difficultyMultiplier;
    } else {
      _wrongAnswers++;
    }
    
    // Cevap süresini kaydet
    _answerTimes.add(timeSpent);
    
    // Skor güncellemesi yap
    if (_scoreCallback != null) {
      final score = createScore(userId: 'current_user');
      _scoreCallback!(score);
    }
  }
  
  /// Sonraki soruya geçer
  bool nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      return true;
    }
    return false;
  }
  
  /// Oyun tamamlandığında çağrılır
  void _handleGameComplete() {
    if (_gameOverCallback != null) {
      _gameOverCallback!();
    }
  }
  
  /// Matematik skoru oluşturur
  MathScore getMathScore() {
    double averageTime = _answerTimes.isEmpty 
        ? 0 
        : _answerTimes.reduce((a, b) => a + b) / _answerTimes.length;
        
    return MathScore(
      correctAnswers: _correctAnswers,
      wrongAnswers: _wrongAnswers,
      totalScore: _totalScore,
      averageTime: averageTime,
      difficulty: currentDifficulty,
      operationType: _operationType,
    );
  }
}