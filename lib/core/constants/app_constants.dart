/// Application constants
///
/// This class contains all the constants used in the application.
class AppConstants {
  // App Information
  static const String appName = 'Oyunlar Koleksiyonu';
  static const String appVersion = '1.0.0';

  // Animation durations
  static const int shortAnimationDuration = 200; // milliseconds
  static const int mediumAnimationDuration = 500; // milliseconds
  static const int longAnimationDuration = 800; // milliseconds

  // API timeouts (for future use)
  static const int connectionTimeout = 30000; // milliseconds
  static const int receiveTimeout = 30000; // milliseconds

  // Storage keys
  static const String userBoxName = 'user_box';
  static const String settingsBoxName = 'settings_box';
  static const String scoresBoxName = 'scores_box';
  static const String themeKey = 'app_theme';
  static const String languageKey = 'app_language';
  static const String userProfileKey = 'user_profile';

  // Default values
  static const String defaultUsername = 'Oyuncu';
  static const String defaultLanguage = 'tr';
  static const bool defaultSoundEnabled = true;
  static const double defaultSoundVolume = 0.7;
  static const bool defaultVibrationEnabled = true;
  static const bool defaultNotificationsEnabled = true;

  // Game-specific constants
  static const int flagGameTimeLimit = 15; // seconds
  static const int flagGameEasyQuestions = 10;
  static const int flagGameMediumQuestions = 15;
  static const int flagGameHardQuestions = 20;

  // Routes
  static const String homeRoute = '/';

  /// Flag game route

  static const String flagsGameRoute = '/flags-game';

  /// Settings route

  static const String settingsRoute = '/settings';

  // scoreboard route
  static const String scoreboardRoute = '/scoreboard';

  /// Math game route
  static const String mathGameRoute = '/math-game';

  /// Basket game route
  static const String basketGameRoute = '/basket-game';
}
