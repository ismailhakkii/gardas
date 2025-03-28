import 'package:flutter/material.dart';
import 'package:gardas/core/constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

/// Fun Application theme manager
/// 
/// This class provides light and dark theme data with a fun and playful style.
class FunAppTheme {
  // Fun colors - daha canlı renk paleti
  static const Color primaryColor = Color(0xFF6A5AE0);
  static const Color secondaryColor = Color(0xFFFF8FA2);
  static const Color accentColor = Color(0xFFFFD166);
  static const Color successColor = Color(0xFF66D995);
  static const Color errorColor = Color(0xFFFF6B6B);
  static const Color infoColor = Color(0xFF5BC0EB);

  // Gradient colors
  static const List<Color> primaryGradient = [
    Color(0xFF6A5AE0),
    Color(0xFF9087E5),
  ];
  
  static const List<Color> secondaryGradient = [
    Color(0xFFFF8FA2),
    Color(0xFFFFB8C1),
  ];
  
  static const List<Color> accentGradient = [
    Color(0xFFFFD166),
    Color(0xFFFFE699),
  ];

  /// Returns fun light theme data
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        primaryContainer: Color(0xFFE4E0FF),
        secondary: secondaryColor,
        secondaryContainer: Color(0xFFFFE8ED),
        tertiary: accentColor,
        tertiaryContainer: Color(0xFFFFF1D6),
        surface: Color(0xFFFEFEFE),
        background: Color(0xFFF7F6FF),
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onTertiary: Colors.black,
        onSurface: Color(0xFF303054),
        onBackground: Color(0xFF303054),
        onError: Colors.white,
      ),
      
      // Text Theme
      textTheme: TextTheme(
        displayLarge: GoogleFonts.fredoka(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: Color(0xFF303054),
        ),
        displayMedium: GoogleFonts.fredoka(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Color(0xFF303054),
        ),
        displaySmall: GoogleFonts.fredoka(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Color(0xFF303054),
        ),
        headlineMedium: GoogleFonts.fredoka(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF303054),
        ),
        headlineSmall: GoogleFonts.fredoka(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color(0xFF303054),
        ),
        titleLarge: GoogleFonts.fredoka(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF303054),
        ),
        bodyLarge: GoogleFonts.quicksand(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Color(0xFF303054),
        ),
        bodyMedium: GoogleFonts.quicksand(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF303054),
        ),
        labelLarge: GoogleFonts.quicksand(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF303054),
        ),
      ),
      
      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.fredoka(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
      ),
              
      // Card Theme
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 5,
        shadowColor: primaryColor.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      
      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(primaryColor),
          foregroundColor: MaterialStateProperty.all(Colors.white),
          elevation: MaterialStateProperty.all(4),
          shadowColor: MaterialStateProperty.all(primaryColor.withOpacity(0.5)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 14,
            ),
          ),
          textStyle: MaterialStateProperty.all(
            GoogleFonts.fredoka(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      
      // Fab Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accentColor,
        foregroundColor: Colors.black,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: errorColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintStyle: GoogleFonts.quicksand(
          fontSize: 16,
          color: Colors.grey,
        ),
      ),
      
      // Dialog Theme
      dialogTheme: DialogTheme(
        backgroundColor: Colors.white,
        elevation: 20,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        titleTextStyle: GoogleFonts.fredoka(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color(0xFF303054),
        ),
        contentTextStyle: GoogleFonts.quicksand(
          fontSize: 16,
          color: Color(0xFF303054),
        ),
      ),
      
      // Bottom Sheet Theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.white,
        elevation: 20,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: Color(0xFFBBB8D9),
        type: BottomNavigationBarType.fixed,
        elevation: 16,
        selectedLabelStyle: GoogleFonts.quicksand(
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: GoogleFonts.quicksand(),
        showUnselectedLabels: true,
      ),
      
      // Progress Indicator Theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primaryColor,
        circularTrackColor: primaryColor.withOpacity(0.2),
        linearTrackColor: primaryColor.withOpacity(0.2),
      ),
      
      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryColor;
          }
          return null;
        }),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      
      // Slider Theme
      sliderTheme: SliderThemeData(
        activeTrackColor: primaryColor,
        inactiveTrackColor: primaryColor.withOpacity(0.2),
        thumbColor: primaryColor,
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 12,
          pressedElevation: 8,
        ),
        overlayColor: primaryColor.withOpacity(0.2),
        valueIndicatorColor: accentColor,
        valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
        valueIndicatorTextStyle: GoogleFonts.fredoka(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
      
      // Toggle Buttons Theme
      toggleButtonsTheme: ToggleButtonsThemeData(
        color: Color(0xFF303054),
        selectedColor: Colors.white,
        fillColor: primaryColor,
        borderColor: primaryColor.withOpacity(0.3),
        selectedBorderColor: primaryColor,
        borderRadius: BorderRadius.circular(12),
        textStyle: GoogleFonts.quicksand(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      
      // Tooltip Theme
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: accentColor,
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.quicksand(
          color: Colors.black,
          fontSize: 14,
        ),
      ),
      
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Color(0xFF303054),
        contentTextStyle: GoogleFonts.quicksand(
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Returns fun dark theme data
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        primaryContainer: Color(0xFF534294),
        secondary: secondaryColor,
        secondaryContainer: Color(0xFFCC7183),
        tertiary: accentColor,
        tertiaryContainer: Color(0xFFCCA752),
        surface: Color(0xFF23233A),
        background: Color(0xFF1A1A2E),
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onTertiary: Colors.black,
        onSurface: Colors.white,
        onBackground: Colors.white,
        onError: Colors.white,
      ),
      
      // Text Theme
      textTheme: TextTheme(
        displayLarge: GoogleFonts.fredoka(
          fontSize: 36,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        displayMedium: GoogleFonts.fredoka(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        displaySmall: GoogleFonts.fredoka(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        headlineMedium: GoogleFonts.fredoka(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        headlineSmall: GoogleFonts.fredoka(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        titleLarge: GoogleFonts.fredoka(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        bodyLarge: GoogleFonts.quicksand(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        bodyMedium: GoogleFonts.quicksand(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        labelLarge: GoogleFonts.quicksand(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      
      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.fredoka(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
      ),
              
      // Card Theme
      cardTheme: CardTheme(
        color: Color(0xFF23233A),
        elevation: 5,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      
      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(primaryColor),
          foregroundColor: MaterialStateProperty.all(Colors.white),
          elevation: MaterialStateProperty.all(4),
          shadowColor: MaterialStateProperty.all(primaryColor.withOpacity(0.5)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 14,
            ),
          ),
          textStyle: MaterialStateProperty.all(
            GoogleFonts.fredoka(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      
      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accentColor,
        foregroundColor: Colors.black,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      
      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFF23233A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: errorColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintStyle: GoogleFonts.quicksand(
          fontSize: 16,
          color: Colors.grey,
        ),
      ),
      
      // Dialog Theme
      dialogTheme: DialogTheme(
        backgroundColor: Color(0xFF23233A),
        elevation: 20,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        titleTextStyle: GoogleFonts.fredoka(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        contentTextStyle: GoogleFonts.quicksand(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      
      // Bottom Sheet Theme
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Color(0xFF23233A),
        elevation: 20,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF23233A),
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 16,
        selectedLabelStyle: GoogleFonts.quicksand(
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: GoogleFonts.quicksand(),
        showUnselectedLabels: true,
      ),
      
      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryColor;
          }
          return null;
        }),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      
      // Slider Theme
      sliderTheme: SliderThemeData(
        activeTrackColor: primaryColor,
        inactiveTrackColor: primaryColor.withOpacity(0.2),
        thumbColor: primaryColor,
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 12,
          pressedElevation: 8,
        ),
        overlayColor: primaryColor.withOpacity(0.2),
        valueIndicatorColor: accentColor,
        valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
        valueIndicatorTextStyle: GoogleFonts.fredoka(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
      
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.grey[900],
        contentTextStyle: GoogleFonts.quicksand(
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}