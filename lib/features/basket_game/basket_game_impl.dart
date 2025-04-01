import 'package:flutter/material.dart';
import '../../domain/entities/game.dart';
import '../../domain/entities/score.dart';
import '../../games_interface/game_interface.dart';
import 'presentation/pages/basket_game_page.dart';
import 'presentation/tutorial/basket_game_tutorial.dart';
import 'presentation/widgets/basket_game_over_screen.dart';

/// Basket oyunu implementasyonu
///
/// GameInterface'i implemente ederek projenin oyun altyapısına entegre eder.
class BasketGame implements GameInterface {
  @override
  Game get gameInfo => Game(
    id: 'basket_game',
    name: 'Basket Atışı',
    description: 'Basketbol topunu potaya atmaya çalış! Doğru açıyı ve gücü ayarlayarak maksimum puan topla.',
    iconPath: 'assets/images/basket_icon.png', // Buraya uygun bir asset yolu girin
    iconData: Icons.sports_basketball,
    routePath: '/basket-game',
    hasDifficultyLevels: true,
    hasTutorial: true,
    tags: ['spor', 'basket', 'fizik'],
  );

  @override
  List<GameDifficulty> get supportedDifficulties => [
    GameDifficulty.easy,
    GameDifficulty.medium,
    GameDifficulty.hard,
  ];

  /// Aktif zorluk seviyesi
  GameDifficulty _activeDifficulty = GameDifficulty.medium;
  
  /// Oyun sayfası anahtarı
  final GlobalKey<BasketGamePageState> _gamePageKey = GlobalKey<BasketGamePageState>();

  @override
  Widget buildGame({
    required BuildContext context,
    required GameDifficulty difficulty,
    required Function(Score) onScoreUpdated,
    required VoidCallback onGameOver,
  }) {
    _activeDifficulty = difficulty;
    
    return BasketGamePage(
      key: _gamePageKey,
      difficulty: difficulty,
      onScoreUpdated: onScoreUpdated,
      onGameOver: onGameOver,
    );
  }

  @override
  Widget buildDifficultySelection({
    required BuildContext context,
    required Function(GameDifficulty) onDifficultySelected,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Zorluk Seviyesi Seçin',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: supportedDifficulties.map((difficulty) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () => onDifficultySelected(difficulty),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getDifficultyColor(difficulty),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    _getDifficultyName(difficulty),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget? buildTutorial({
    required BuildContext context,
    required VoidCallback onTutorialCompleted,
  }) {
    return BasketGameTutorial(
      onTutorialCompleted: onTutorialCompleted,
    );
  }

  @override
  Widget buildGameOverScreen({
    required BuildContext context,
    required Score score,
    required Function() onPlayAgain,
    required Function() onExit,
  }) {
    return BasketGameOverScreen(
      score: score,
      onPlayAgain: onPlayAgain,
      onExit: onExit,
    );
  }

  @override
  void startGame(GameDifficulty difficulty) {
    _activeDifficulty = difficulty;
    _gamePageKey.currentState?.startGame();
  }

  @override
  void pauseGame() {
    _gamePageKey.currentState?.pauseGame();
  }

  @override
  void resumeGame() {
    _gamePageKey.currentState?.resumeGame();
  }

  @override
  void resetGame() {
    _gamePageKey.currentState?.resetGame();
  }
  
  @override
  void endGame() {
    _gamePageKey.currentState?.endGame();
  }

  @override
  void dispose() {
    // Oyunla ilgili kaynakları temizle
    _gamePageKey.currentState?.dispose();
  }

  /// Zorluk seviyesine göre isim döndürür
  String _getDifficultyName(GameDifficulty difficulty) {
    switch (difficulty) {
      case GameDifficulty.easy:
        return 'Kolay';
      case GameDifficulty.medium:
        return 'Orta';
      case GameDifficulty.hard:
        return 'Zor';
    }
  }

  /// Zorluk seviyesine göre renk döndürür
  Color _getDifficultyColor(GameDifficulty difficulty) {
    switch (difficulty) {
      case GameDifficulty.easy:
        return Colors.green;
      case GameDifficulty.medium:
        return Colors.orange;
      case GameDifficulty.hard:
        return Colors.red;
    }
  }
}