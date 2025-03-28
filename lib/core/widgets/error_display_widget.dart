import 'package:flutter/material.dart';
import 'package:gardas/core/constants/app_strings.dart';
import 'package:gardas/core/widgets/custom_button.dart';

/// A widget to display error messages with optional retry action
///
/// This widget provides a consistent way to display errors in the application.
class ErrorDisplayWidget extends StatelessWidget {
  /// The error message to display
  final String message;
  
  /// The callback to execute when the retry button is pressed
  final VoidCallback? onRetry;
  
  /// An icon to display with the error message
  final IconData icon;
  
  /// Whether to use a compact layout
  final bool compact;

  const ErrorDisplayWidget({
    Key? key,
    required this.message,
    this.onRetry,
    this.icon = Icons.error_outline,
    this.compact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.error,
            size: 20,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              message,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 14,
              ),
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(width: 8),
            TextButton(
              onPressed: onRetry,
              child: const Text(AppStrings.retry),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: const Size(0, 36),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.error,
            size: 48,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 16,
              ),
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 24),
            CustomButton(
              text: AppStrings.retry,
              onPressed: onRetry!,
              type: ButtonType.primary,
              icon: Icons.refresh,
            ),
          ],
        ],
      );
    }
  }
}

/// A full page error widget
class FullPageErrorWidget extends StatelessWidget {
  /// The error message to display
  final String message;
  
  /// The callback to execute when the retry button is pressed
  final VoidCallback? onRetry;
  
  /// An icon to display with the error message
  final IconData icon;
  
  /// The title of the error
  final String? title;

  const FullPageErrorWidget({
    Key? key,
    required this.message,
    this.onRetry,
    this.icon = Icons.error_outline,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.error,
              size: 64,
            ),
            const SizedBox(height: 24),
            if (title != null) ...[
              Text(
                title!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              const SizedBox(height: 16),
            ],
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 32),
              CustomButton(
                text: AppStrings.retry,
                onPressed: onRetry!,
                type: ButtonType.primary,
                icon: Icons.refresh,
                size: ButtonSize.large,
              ),
            ],
          ],
        ),
      ),
    );
  }
}