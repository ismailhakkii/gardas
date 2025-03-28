import 'package:flutter/material.dart';
import 'package:gardas/core/constants/app_colors.dart';

/// Game timer widget
///
/// This widget displays a timer progress bar.
class GameTimerWidget extends StatelessWidget {
  /// Time remaining in seconds
  final double timeRemaining;
  
  /// Total time in seconds
  final double totalTime;

  const GameTimerWidget({
    Key? key,
    required this.timeRemaining,
    required this.totalTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = timeRemaining / totalTime;
    final seconds = timeRemaining.ceil();
    
    // Determine color based on time remaining
    Color timerColor;
    if (progress > 0.66) {
      timerColor = AppColors.correctAnswerColor;
    } else if (progress > 0.33) {
      timerColor = AppColors.neutralColor;
    } else {
      timerColor = AppColors.wrongAnswerColor;
    }
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Timer text
        Text(
          '$seconds',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 4),
        
        // Progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            valueColor: AlwaysStoppedAnimation<Color>(timerColor),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}