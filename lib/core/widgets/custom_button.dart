import 'package:flutter/material.dart';
import 'package:gardas/core/constants/app_colors.dart';

/// A customizable button widget
///
/// This widget provides a consistent button style across the application
/// with various customization options.
class CustomButton extends StatelessWidget {
  /// The text to display on the button
  final String text;
  
  /// The icon to display on the button (optional)
  final IconData? icon;
  
  /// The callback to execute when the button is pressed
  final VoidCallback onPressed;
  
  /// Whether the button is in a loading state
  final bool isLoading;
  
  /// The button type (primary, secondary, outlined, text)
  final ButtonType type;
  
  /// The button size (small, medium, large)
  final ButtonSize size;
  
  /// The button's background color (will override default color based on type)
  final Color? backgroundColor;
  
  /// The button's text color (will override default color based on type)
  final Color? textColor;
  
  /// Whether the button should take the full width of its parent
  final bool fullWidth;
  
  /// The border radius of the button
  final double borderRadius;
  
  /// Custom padding for the button
  final EdgeInsets? padding;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this.backgroundColor,
    this.textColor,
    this.fullWidth = false,
    this.borderRadius = 8,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine the button's visual properties based on type
    Color bgColor;
    Color txtColor;
    Color borderColor;
    
    switch (type) {
      case ButtonType.primary:
        bgColor = backgroundColor ?? AppColors.primaryColor;
        txtColor = textColor ?? Colors.white;
        borderColor = bgColor;
        break;
      case ButtonType.secondary:
        bgColor = backgroundColor ?? AppColors.secondaryColor;
        txtColor = textColor ?? Colors.black;
        borderColor = bgColor;
        break;
      case ButtonType.outlined:
        bgColor = backgroundColor ?? Colors.transparent;
        txtColor = textColor ?? AppColors.primaryColor;
        borderColor = AppColors.primaryColor;
        break;
      case ButtonType.text:
        bgColor = backgroundColor ?? Colors.transparent;
        txtColor = textColor ?? AppColors.primaryColor;
        borderColor = Colors.transparent;
        break;
    }
    
    // Determine the button's size properties
    EdgeInsets buttonPadding;
    double fontSize;
    double iconSize;
    
    switch (size) {
      case ButtonSize.small:
        buttonPadding = padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
        fontSize = 12;
        iconSize = 16;
        break;
      case ButtonSize.medium:
        buttonPadding = padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
        fontSize = 14;
        iconSize = 18;
        break;
      case ButtonSize.large:
        buttonPadding = padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
        fontSize = 16;
        iconSize = 20;
        break;
    }
    
    // Build the button content based on configuration
    Widget buttonContent;
    
    if (isLoading) {
      // Show loading indicator when in loading state
      buttonContent = SizedBox(
        width: iconSize,
        height: iconSize,
        child: CircularProgressIndicator(
          color: txtColor,
          strokeWidth: 2,
        ),
      );
    } else if (icon != null) {
      // Show icon and text
      buttonContent = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: txtColor,
            size: iconSize,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: txtColor,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    } else {
      // Show only text
      buttonContent = Text(
        text,
        style: TextStyle(
          color: txtColor,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      );
    }
    
    // Build the final button widget
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: MaterialButton(
        onPressed: isLoading ? null : onPressed,
        color: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: BorderSide(
            color: borderColor,
            width: type == ButtonType.outlined ? 2 : 0,
          ),
        ),
        padding: buttonPadding,
        elevation: type == ButtonType.text || type == ButtonType.outlined ? 0 : 2,
        highlightElevation: type == ButtonType.text || type == ButtonType.outlined ? 0 : 4,
        disabledColor: bgColor.withOpacity(0.6),
        child: buttonContent,
      ),
    );
  }
}

/// Button types for CustomButton
enum ButtonType {
  primary,
  secondary,
  outlined,
  text,
}

/// Button sizes for CustomButton
enum ButtonSize {
  small,
  medium,
  large,
}