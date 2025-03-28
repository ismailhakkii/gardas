import 'package:dartz/dartz.dart';
import 'package:gardas/core/error/failures.dart';
import 'package:gardas/domain/entities/settings.dart';

/// Settings Repository Interface
/// 
/// This interface defines methods for managing application settings.
abstract class SettingsRepository {
  /// Gets the current settings
  /// 
  /// Returns a [Settings] entity if successful, or a [Failure] if an error occurs.
  Future<Either<Failure, Settings>> getSettings();
  
  /// Updates the settings
  /// 
  /// [settings] is the updated settings entity.
  /// Returns the updated [Settings] entity if successful, or a [Failure] if an error occurs.
  Future<Either<Failure, Settings>> updateSettings(Settings settings);
  
  /// Updates the theme mode
  /// 
  /// [themeMode] is the new theme mode.
  /// Returns the updated [Settings] entity if successful, or a [Failure] if an error occurs.
  Future<Either<Failure, Settings>> updateThemeMode(AppThemeMode themeMode);
  
  /// Updates the language
  /// 
  /// [languageCode] is the new language code.
  /// Returns the updated [Settings] entity if successful, or a [Failure] if an error occurs.
  Future<Either<Failure, Settings>> updateLanguage(String languageCode);
  
  /// Updates the sound settings
  /// 
  /// [enabled] indicates whether sound should be enabled.
  /// [volume] is the sound volume (0.0 - 1.0).
  /// Returns the updated [Settings] entity if successful, or a [Failure] if an error occurs.
  Future<Either<Failure, Settings>> updateSoundSettings({
    bool? enabled,
    double? volume,
  });
  
  /// Updates the vibration setting
  /// 
  /// [enabled] indicates whether vibration should be enabled.
  /// Returns the updated [Settings] entity if successful, or a [Failure] if an error occurs.
  Future<Either<Failure, Settings>> updateVibration(bool enabled);
  
  /// Updates the notifications setting
  /// 
  /// [enabled] indicates whether notifications should be enabled.
  /// Returns the updated [Settings] entity if successful, or a [Failure] if an error occurs.
  Future<Either<Failure, Settings>> updateNotifications(bool enabled);
  
  /// Resets the settings to defaults
  /// 
  /// Returns the default [Settings] entity if successful, or a [Failure] if an error occurs.
  Future<Either<Failure, Settings>> resetSettings();
}