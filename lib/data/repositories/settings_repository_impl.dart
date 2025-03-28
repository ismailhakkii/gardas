import 'package:dartz/dartz.dart';
import 'package:gardas/core/constants/app_constants.dart';
import 'package:gardas/core/error/error_handler.dart';
import 'package:gardas/core/error/failures.dart';
import 'package:gardas/data/datasources/local/local_storage_service.dart';
import 'package:gardas/data/models/settings_model.dart';
import 'package:gardas/domain/entities/settings.dart';
import 'package:gardas/domain/repositories/settings_repository.dart';

/// Implementation of [SettingsRepository]
class SettingsRepositoryImpl implements SettingsRepository {
  final LocalStorageService _storageService;
  final ErrorHandler _errorHandler;

  /// Constructor for SettingsRepositoryImpl
  SettingsRepositoryImpl(this._storageService, this._errorHandler);

  @override
  Future<Either<Failure, Settings>> getSettings() async {
    try {
      final SettingsModel? settingsModel = _storageService.getObject<SettingsModel>(
        AppConstants.settingsBoxName,
        AppConstants.settingsBoxName,
        SettingsModel.fromJson,
      );
      
      if (settingsModel != null) {
        return Right(settingsModel);
      } else {
        // Return default settings if none exist
        final defaultSettings = SettingsModel.fromEntity(Settings.defaultSettings());
        
        // Save default settings
        await _storageService.putObject<SettingsModel>(
          AppConstants.settingsBoxName,
          AppConstants.settingsBoxName,
          defaultSettings,
          (settings) => settings.toJson(),
        );
        
        return Right(defaultSettings);
      }
    } catch (e) {
      return Left(_errorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, Settings>> updateSettings(Settings settings) async {
    try {
      final SettingsModel settingsModel = SettingsModel.fromEntity(settings);
      
      await _storageService.putObject<SettingsModel>(
        AppConstants.settingsBoxName,
        AppConstants.settingsBoxName,
        settingsModel,
        (settings) => settings.toJson(),
      );
      
      return Right(settingsModel);
    } catch (e) {
      return Left(_errorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, Settings>> updateThemeMode(AppThemeMode themeMode) async {
    try {
      // Get current settings
      final Either<Failure, Settings> settingsResult = await getSettings();
      
      return settingsResult.fold(
        (failure) => Left(failure),
        (settings) async {
          // Update theme mode
          final SettingsModel updatedSettings = SettingsModel.fromEntity(settings).copyWith(
            themeMode: themeMode,
          );
          
          // Save updated settings
          await _storageService.putObject<SettingsModel>(
            AppConstants.settingsBoxName,
            AppConstants.settingsBoxName,
            updatedSettings,
            (settings) => settings.toJson(),
          );
          
          return Right(updatedSettings);
        },
      );
    } catch (e) {
      return Left(_errorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, Settings>> updateLanguage(String languageCode) async {
    try {
      // Get current settings
      final Either<Failure, Settings> settingsResult = await getSettings();
      
      return settingsResult.fold(
        (failure) => Left(failure),
        (settings) async {
          // Update language
          final SettingsModel updatedSettings = SettingsModel.fromEntity(settings).copyWith(
            languageCode: languageCode,
          );
          
          // Save updated settings
          await _storageService.putObject<SettingsModel>(
            AppConstants.settingsBoxName,
            AppConstants.settingsBoxName,
            updatedSettings,
            (settings) => settings.toJson(),
          );
          
          return Right(updatedSettings);
        },
      );
    } catch (e) {
      return Left(_errorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, Settings>> updateSoundSettings({
    bool? enabled,
    double? volume,
  }) async {
    try {
      // Get current settings
      final Either<Failure, Settings> settingsResult = await getSettings();
      
      return settingsResult.fold(
        (failure) => Left(failure),
        (settings) async {
          // Update sound settings
          final SettingsModel updatedSettings = SettingsModel.fromEntity(settings).copyWith(
            soundEnabled: enabled ?? settings.soundEnabled,
            soundVolume: volume ?? settings.soundVolume,
          );
          
          // Save updated settings
          await _storageService.putObject<SettingsModel>(
            AppConstants.settingsBoxName,
            AppConstants.settingsBoxName,
            updatedSettings,
            (settings) => settings.toJson(),
          );
          
          return Right(updatedSettings);
        },
      );
    } catch (e) {
      return Left(_errorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, Settings>> updateVibration(bool enabled) async {
    try {
      // Get current settings
      final Either<Failure, Settings> settingsResult = await getSettings();
      
      return settingsResult.fold(
        (failure) => Left(failure),
        (settings) async {
          // Update vibration
          final SettingsModel updatedSettings = SettingsModel.fromEntity(settings).copyWith(
            vibrationEnabled: enabled,
          );
          
          // Save updated settings
          await _storageService.putObject<SettingsModel>(
            AppConstants.settingsBoxName,
            AppConstants.settingsBoxName,
            updatedSettings,
            (settings) => settings.toJson(),
          );
          
          return Right(updatedSettings);
        },
      );
    } catch (e) {
      return Left(_errorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, Settings>> updateNotifications(bool enabled) async {
    try {
      // Get current settings
      final Either<Failure, Settings> settingsResult = await getSettings();
      
      return settingsResult.fold(
        (failure) => Left(failure),
        (settings) async {
          // Update notifications
          final SettingsModel updatedSettings = SettingsModel.fromEntity(settings).copyWith(
            notificationsEnabled: enabled,
          );
          
          // Save updated settings
          await _storageService.putObject<SettingsModel>(
            AppConstants.settingsBoxName,
            AppConstants.settingsBoxName,
            updatedSettings,
            (settings) => settings.toJson(),
          );
          
          return Right(updatedSettings);
        },
      );
    } catch (e) {
      return Left(_errorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, Settings>> resetSettings() async {
    try {
      // Create default settings
      final SettingsModel defaultSettings = SettingsModel.fromEntity(Settings.defaultSettings());
      
      // Save default settings
      await _storageService.putObject<SettingsModel>(
        AppConstants.settingsBoxName,
        AppConstants.settingsBoxName,
        defaultSettings,
        (settings) => settings.toJson(),
      );
      
      return Right(defaultSettings);
    } catch (e) {
      return Left(_errorHandler.handleException(e));
    }
  }
}