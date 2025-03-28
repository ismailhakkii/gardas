import 'package:flutter/material.dart';

/// Application colors
/// 
/// This class contains all the colors used in the application.
class AppColors {
  // Primary colors
  static const Color primaryColor = Color(0xFF6200EE);
  static const Color primaryColorLight = Color(0xFF9E47FF);
  static const Color primaryColorDark = Color(0xFF3700B3);
  
  // Secondary colors
  static const Color secondaryColor = Color(0xFF03DAC6);
  static const Color secondaryColorLight = Color(0xFF66FFF9);
  static const Color secondaryColorDark = Color(0xFF00A896);
  
  // Background colors
  static const Color backgroundLightColor = Color(0xFFF5F5F5);
  static const Color backgroundDarkColor = Color(0xFF121212);
  static const Color surfaceLightColor = Color(0xFFFFFFFF);
  static const Color surfaceDarkColor = Color(0xFF1E1E1E);
  
  // Text colors
  static const Color textLightColor = Color(0xFF000000);
  static const Color textDarkColor = Color(0xFFFFFFFF);
  static const Color textLightSecondaryColor = Color(0xFF757575);
  static const Color textDarkSecondaryColor = Color(0xFFB5B5B5);
  
  // Game colors
  static const Color correctAnswerColor = Color(0xFF4CAF50);
  static const Color wrongAnswerColor = Color(0xFFF44336);
  static const Color neutralColor = Color(0xFFFFEB3B);
  
  // Additional colors
  static const Color errorColor = Color(0xFFB00020);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFFC107);
  static const Color infoColor = Color(0xFF2196F3);
  
  // Gradient colors
  static const List<Color> primaryGradient = [
    Color(0xFF6200EE),
    Color(0xFF9E47FF),
  ];
  
  static const List<Color> secondaryGradient = [
    Color(0xFF03DAC6),
    Color(0xFF66FFF9),
  ];
  
  static const List<Color> successGradient = [
    Color(0xFF4CAF50),
    Color(0xFF8BC34A),
  ];
  
  static const List<Color> errorGradient = [
    Color(0xFFF44336),
    Color(0xFFFF7043),
  ];
}