import 'package:flutter/material.dart';
import 'package:gardas/core/constants/app_colors.dart';
import 'package:gardas/core/constants/app_strings.dart';

/// A loading widget to show during loading states
///
/// This widget provides a consistent loading indicator with an optional message.
class LoadingWidget extends StatelessWidget {
  /// The message to display below the loading indicator
  final String? message;
  
  /// Whether to show a fullscreen loading overlay or just the indicator
  final bool fullscreen;
  
  /// The color of the loading indicator
  final Color? color;
  
  /// The size of the loading indicator
  final double size;

  const LoadingWidget({
    Key? key,
    this.message,
    this.fullscreen = false,
    this.color,
    this.size = 40,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loadingIndicator = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            color: color ?? AppColors.primaryColor,
            strokeWidth: 3,
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: 16),
          Text(
            message ?? AppStrings.loading,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );

    if (fullscreen) {
      return Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: loadingIndicator,
            ),
          ),
        ),
      );
    } else {
      return Center(
        child: loadingIndicator,
      );
    }
  }
}

/// A loading overlay that can be shown on top of existing content
class LoadingOverlay extends StatelessWidget {
  /// Whether the loading overlay is visible
  final bool isLoading;
  
  /// The child widget to display under the loading overlay
  final Widget child;
  
  /// The message to display in the loading indicator
  final String? message;
  
  /// The color of the loading indicator
  final Color? color;

  const LoadingOverlay({
    Key? key,
    required this.isLoading,
    required this.child,
    this.message,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          LoadingWidget(
            fullscreen: true,
            message: message,
            color: color,
          ),
      ],
    );
  }
}