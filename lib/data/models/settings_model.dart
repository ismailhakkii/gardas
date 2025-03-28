import 'package:gardas/domain/entities/settings.dart';

/// Settings model class
/// 
/// Data layer representation of a [Settings] entity.
class SettingsModel extends Settings {
  /// Constructor for SettingsModel
  const SettingsModel({
    required AppThemeMode themeMode,
    required String languageCode,
    required bool soundEnabled,
    required double soundVolume,
    required bool vibrationEnabled,
    required bool notificationsEnabled,
    bool funModeEnabled = true,
  }) : super(
    themeMode: themeMode,
    languageCode: languageCode,
    soundEnabled: soundEnabled,
    soundVolume: soundVolume,
    vibrationEnabled: vibrationEnabled,
    notificationsEnabled: notificationsEnabled,
    funModeEnabled: funModeEnabled,
  );

  /// Creates a [SettingsModel] from a JSON map
  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      themeMode: _themeFromString(json['theme_mode'] ?? 'system'),
      languageCode: json['language_code'] ?? 'tr',
      soundEnabled: json['sound_enabled'] ?? true,
      soundVolume: (json['sound_volume'] ?? 0.7).toDouble(),
      vibrationEnabled: json['vibration_enabled'] ?? true,
      notificationsEnabled: json['notifications_enabled'] ?? true,
      funModeEnabled: json['fun_mode_enabled'] ?? true,
    );
  }

  /// Converts this [SettingsModel] to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'theme_mode': _themeToString(themeMode),
      'language_code': languageCode,
      'sound_enabled': soundEnabled,
      'sound_volume': soundVolume,
      'vibration_enabled': vibrationEnabled,
      'notifications_enabled': notificationsEnabled,
      'fun_mode_enabled': funModeEnabled,
    };
  }

  /// Creates a [SettingsModel] from a [Settings] entity
  factory SettingsModel.fromEntity(Settings settings) {
    return SettingsModel(
      themeMode: settings.themeMode,
      languageCode: settings.languageCode,
      soundEnabled: settings.soundEnabled,
      soundVolume: settings.soundVolume,
      vibrationEnabled: settings.vibrationEnabled,
      notificationsEnabled: settings.notificationsEnabled,
      funModeEnabled: settings.funModeEnabled,
    );
  }

  /// Creates a copy of this [SettingsModel] with the given fields replaced
  @override
  SettingsModel copyWith({
    AppThemeMode? themeMode,
    String? languageCode,
    bool? soundEnabled,
    double? soundVolume,
    bool? vibrationEnabled,
    bool? notificationsEnabled,
    bool? funModeEnabled,
  }) {
    return SettingsModel(
      themeMode: themeMode ?? this.themeMode,
      languageCode: languageCode ?? this.languageCode,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      soundVolume: soundVolume ?? this.soundVolume,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      funModeEnabled: funModeEnabled ?? this.funModeEnabled,
    );
  }

  /// Converts a theme string to an [AppThemeMode]
  static AppThemeMode _themeFromString(String value) {
    switch (value) {
      case 'light':
        return AppThemeMode.light;
      case 'dark':
        return AppThemeMode.dark;
      case 'system':
      default:
        return AppThemeMode.system;
    }
  }

  /// Converts an [AppThemeMode] to a string
  static String _themeToString(AppThemeMode themeMode) {
    switch (themeMode) {
      case AppThemeMode.light:
        return 'light';
      case AppThemeMode.dark:
        return 'dark';
      case AppThemeMode.system:
        return 'system';
    }
  }
}