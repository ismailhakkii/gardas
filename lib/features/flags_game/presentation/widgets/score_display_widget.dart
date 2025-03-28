import 'package:flutter/material.dart';
import 'package:gardas/core/constants/app_strings.dart';

/// Score display widget
///
/// This widget displays the current score.
class ScoreDisplayWidget extends StatelessWidget {
  /// The score to display
  final int score;
  
  /// Whether to show a large score (for game over screen)
  final bool isLarge;

  const ScoreDisplayWidget({
    Key? key,
    required this.score,
    this.isLarge = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLarge) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppStrings.flagsGameScore,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            score.toString(),
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppStrings.flagsGameScore,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              score.toString(),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
  }
}