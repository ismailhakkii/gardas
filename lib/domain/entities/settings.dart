import 'package:equatable/equatable.dart';
import 'package:gardas/core/constants/app_constants.dart';

/// App theme enum
enum AppThemeMode {
  light,
  dark,
  system,
}

/// App language
class AppLanguage extends Equatable {
  final String code;
  final String name;
  
  const AppLanguage({
    required this.code,
    required this.name,
  });
  
  @override
  List<Object?> get props => [code, name];
  
  /// List of supported languages
  static List<AppLanguage> get supportedLanguages => [
    const AppLanguage(code: 'tr', name: 'Türkçe'),
    const AppLanguage(code: 'en', name: 'English'),
  ];
  
  /// Get language by code
  static AppLanguage getByCode(String code) {
    return supportedLanguages.firstWhere(
      (language) => language.code == code,
      orElse: () => const AppLanguage(code: 'tr', name: 'Türkçe'),
    );
  }
}

/// Settings entity
/// 
/// Represents the user settings in the application.
class Settings extends Equatable {
  /// The theme mode of the app (light, dark, system)
  final AppThemeMode themeMode;
  
  /// The language code of the app
  final String languageCode;
  
  /// Whether sound is enabled
  final bool soundEnabled;
  
  /// The sound volume (0.0 - 1.0)
  final double soundVolume;
  
  /// Whether vibration is enabled
  final bool vibrationEnabled;
  
  /// Whether notifications are enabled
  final bool notificationsEnabled;
  
  /// Whether fun mode is enabled
  final bool funModeEnabled;

  /// Constructor for Settings entity
  const Settings({
    required this.themeMode,
    required this.languageCode,
    required this.soundEnabled,
    required this.soundVolume,
    required this.vibrationEnabled,
    required this.notificationsEnabled,
    this.funModeEnabled = true, // Varsayılan olarak aktif
  });

  /// Creates a new Settings instance with default values
  factory Settings.defaultSettings() {
    return const Settings(
      themeMode: AppThemeMode.system,
      languageCode: AppConstants.defaultLanguage,
      soundEnabled: AppConstants.defaultSoundEnabled,
      soundVolume: AppConstants.defaultSoundVolume,
      vibrationEnabled: AppConstants.defaultVibrationEnabled,
      notificationsEnabled: AppConstants.defaultNotificationsEnabled,
      funModeEnabled: true, // Varsayılan olarak aktif
    );
  }

  /// Creates a copy of this Settings with the given fields replaced with new values
  Settings copyWith({
    AppThemeMode? themeMode,
    String? languageCode,
    bool? soundEnabled,
    double? soundVolume,
    bool? vibrationEnabled,
    bool? notificationsEnabled,
    bool? funModeEnabled,
  }) {
    return Settings(
      themeMode: themeMode ?? this.themeMode,
      languageCode: languageCode ?? this.languageCode,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      soundVolume: soundVolume ?? this.soundVolume,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      funModeEnabled: funModeEnabled ?? this.funModeEnabled,
    );
  }

  @override
  List<Object?> get props => [
    themeMode,
    languageCode,
    soundEnabled,
    soundVolume,
    vibrationEnabled,
    notificationsEnabled,
    funModeEnabled,
  ];
}
