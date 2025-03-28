import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gardas/core/constants/app_strings.dart';
import 'package:gardas/domain/entities/game.dart';
import 'package:gardas/domain/entities/score.dart';
import 'package:gardas/domain/usecases/base/usecase.dart';
import 'package:gardas/domain/usecases/scores/get_high_score.dart';
import 'package:gardas/games_interface/game_registry.dart';
import 'package:gardas/injection_container.dart';

/// Stats section widget
///
/// This widget displays the user's statistics on the home page.
class StatsSection extends StatefulWidget {
  const StatsSection({Key? key}) : super(key: key);

  @override
  State<StatsSection> createState() => _StatsSectionState();
}

class _StatsSectionState extends State<StatsSection> {
  final GameRegistry _gameRegistry = sl<GameRegistry>();
  final GetHighScore _getHighScore = sl<GetHighScore>();
  
  // Map of game IDs to high scores
  final Map<String, Score?> _highScores = {};
  
  // Loading state
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHighScores();
  }

  Future<void> _loadHighScores() async {
    setState(() {
      _isLoading = true;
    });
    
    final games = _gameRegistry.getAllGameInfo();
    
    for (final game in games) {
      try {
        final result = await _getHighScore(GetHighScoreParams(
          gameId: game.id,
          difficulty: GameDifficulty.medium,
          userId: 'current_user', // Would normally get this from UserBloc
        ));
        
        result.fold(
          (failure) {
            // If we can't load the high score, just leave it null
          },
          (score) {
            if (mounted) {
              setState(() {
                _highScores[game.id] = score;
              });
            }
          },
        );
      } catch (e) {
        // If an error occurs, just leave the high score null
      }
    }
    
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Text(
          AppStrings.bestScores,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Stats cards
        _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _buildScoreCards(),
      ],
    );
  }
  
  Widget _buildScoreCards() {
    final games = _gameRegistry.getAllGameInfo();
    
    if (_highScores.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Text(
              'Henüz hiç oyun oynamadınız!',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      );
    }
    
    return Column(
      children: games.map((game) {
        final score = _highScores[game.id];
        
        if (score == null) {
          return const SizedBox.shrink();
        }
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Game icon
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  child: Image.asset(
                    game.iconPath,
                    width: 24,
                    height: 24,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.games,
                        color: Theme.of(context).colorScheme.primary,
                      );
                    },
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Game name and score
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        game.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _getDifficultyText(score.difficulty),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                
                // Score
                Text(
                  score.value.toString(),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
  
  String _getDifficultyText(GameDifficulty difficulty) {
    switch (difficulty) {
      case GameDifficulty.easy:
        return AppStrings.flagsGameEasy;
      case GameDifficulty.medium:
        return AppStrings.flagsGameMedium;
      case GameDifficulty.hard:
        return AppStrings.flagsGameHard;
    }
  }
}