import 'package:flutter/material.dart';
import 'package:gardas/core/constants/app_colors.dart';
import 'package:gardas/core/constants/app_strings.dart';
import 'package:gardas/features/flags_game/domain/entities/flag_question.dart';

/// Flag question widget
///
/// This widget displays a flag question with options.
class FlagQuestionWidget extends StatelessWidget {
  /// The question to display
  final FlagQuestion question;
  
  /// The callback for when an option is selected
  final Function(FlagOption)? onOptionSelected;
  
  /// Whether the widget is enabled
  final bool enabled;
  
  /// The selected option (for showing results)
  final FlagOption? selectedOption;
  
  /// Whether the selected option is correct
  final bool? isCorrect;

  const FlagQuestionWidget({
    Key? key,
    required this.question,
    this.onOptionSelected,
    this.enabled = true,
    this.selectedOption,
    this.isCorrect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Question text
          Text(
            AppStrings.flagsGameGuessCountry,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 32),
          
          // Flag
          Text(
            question.correctOption.flagEmoji,
            style: const TextStyle(
              fontSize: 120,
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Options
          ...question.options.map((option) => _buildOptionButton(context, option)),
        ],
      ),
    );
  }
  
  Widget _buildOptionButton(BuildContext context, FlagOption option) {
    // Determine button color based on selection state
    Color? buttonColor;
    Color? textColor;
    
    if (selectedOption != null) {
      if (option.countryCode == question.correctOption.countryCode) {
        // Correct option
        buttonColor = AppColors.correctAnswerColor;
        textColor = Colors.white;
      } else if (option.countryCode == selectedOption?.countryCode) {
        // Selected wrong option
        buttonColor = AppColors.wrongAnswerColor;
        textColor = Colors.white;
      }
    }
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: !enabled || selectedOption != null
              ? null
              : () => onOptionSelected?.call(option),
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            foregroundColor: textColor,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            disabledBackgroundColor: buttonColor,
            disabledForegroundColor: textColor,
          ),
          child: Text(
            option.countryName,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}