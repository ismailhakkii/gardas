import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gardas/core/error/failures.dart';
import 'package:gardas/domain/entities/settings.dart';
import 'package:gardas/domain/usecases/base/usecase.dart';
import 'package:gardas/domain/usecases/settings/get_settings.dart';
import 'package:gardas/domain/usecases/settings/update_language.dart';
import 'package:gardas/domain/usecases/settings/update_settings.dart';
import 'package:gardas/domain/usecases/settings/update_theme_mode.dart';

// Events
abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class GetSettingsEvent extends SettingsEvent {}

class UpdateSettingsEvent extends SettingsEvent {
  final Settings settings;

  const UpdateSettingsEvent(this.settings);

  @override
  List<Object?> get props => [settings];
}

class UpdateThemeModeEvent extends SettingsEvent {
  final AppThemeMode themeMode;

  const UpdateThemeModeEvent(this.themeMode);

  @override
  List<Object?> get props => [themeMode];
}

class UpdateLanguageEvent extends SettingsEvent {
  final String languageCode;

  const UpdateLanguageEvent(this.languageCode);

  @override
  List<Object?> get props => [languageCode];
}

class UpdateSoundSettingsEvent extends SettingsEvent {
  final bool? enabled;
  final double? volume;

  const UpdateSoundSettingsEvent({this.enabled, this.volume});

  @override
  List<Object?> get props => [enabled, volume];
}

class UpdateVibrationEvent extends SettingsEvent {
  final bool enabled;

  const UpdateVibrationEvent(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

class UpdateNotificationsEvent extends SettingsEvent {
  final bool enabled;

  const UpdateNotificationsEvent(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

class ResetSettingsEvent extends SettingsEvent {}

// States
abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final Settings settings;

  const SettingsLoaded(this.settings);

  @override
  List<Object?> get props => [settings];
}

class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetSettings getSettings;
  final UpdateSettings updateSettings;
  final UpdateThemeMode updateThemeMode;
  final UpdateLanguage updateLanguage;

  SettingsBloc({
    required this.getSettings,
    required this.updateSettings,
    required this.updateThemeMode,
    required this.updateLanguage,
  }) : super(SettingsInitial()) {
    on<GetSettingsEvent>(_onGetSettings);
    on<UpdateSettingsEvent>(_onUpdateSettings);
    on<UpdateThemeModeEvent>(_onUpdateThemeMode);
    on<UpdateLanguageEvent>(_onUpdateLanguage);
    on<UpdateSoundSettingsEvent>(_onUpdateSoundSettings);
    on<UpdateVibrationEvent>(_onUpdateVibration);
    on<UpdateNotificationsEvent>(_onUpdateNotifications);
    on<ResetSettingsEvent>(_onResetSettings);
  }

  Future<void> _onGetSettings(
    GetSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());
    final result = await getSettings(NoParams());
    result.fold(
      (failure) => emit(SettingsError(_mapFailureToMessage(failure))),
      (settings) => emit(SettingsLoaded(settings)),
    );
  }

  Future<void> _onUpdateSettings(
    UpdateSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());
    final result = await updateSettings(UpdateSettingsParams(settings: event.settings));
    result.fold(
      (failure) => emit(SettingsError(_mapFailureToMessage(failure))),
      (settings) => emit(SettingsLoaded(settings)),
    );
  }

  Future<void> _onUpdateThemeMode(
    UpdateThemeModeEvent event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentSettings = (state as SettingsLoaded).settings;
      if (currentSettings.themeMode == event.themeMode) {
        return; // No change needed
      }
    }
    
    emit(SettingsLoading());
    final result = await updateThemeMode(UpdateThemeModeParams(themeMode: event.themeMode));
    result.fold(
      (failure) => emit(SettingsError(_mapFailureToMessage(failure))),
      (settings) => emit(SettingsLoaded(settings)),
    );
  }

  Future<void> _onUpdateLanguage(
    UpdateLanguageEvent event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentSettings = (state as SettingsLoaded).settings;
      if (currentSettings.languageCode == event.languageCode) {
        return; // No change needed
      }
    }
    
    emit(SettingsLoading());
    final result = await updateLanguage(UpdateLanguageParams(languageCode: event.languageCode));
    result.fold(
      (failure) => emit(SettingsError(_mapFailureToMessage(failure))),
      (settings) => emit(SettingsLoaded(settings)),
    );
  }

  Future<void> _onUpdateSoundSettings(
    UpdateSoundSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentSettings = (state as SettingsLoaded).settings;
      final updatedSettings = currentSettings.copyWith(
        soundEnabled: event.enabled ?? currentSettings.soundEnabled,
        soundVolume: event.volume ?? currentSettings.soundVolume,
      );
      
      add(UpdateSettingsEvent(updatedSettings));
    }
  }

  Future<void> _onUpdateVibration(
    UpdateVibrationEvent event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentSettings = (state as SettingsLoaded).settings;
      final updatedSettings = currentSettings.copyWith(
        vibrationEnabled: event.enabled,
      );
      
      add(UpdateSettingsEvent(updatedSettings));
    }
  }

  Future<void> _onUpdateNotifications(
    UpdateNotificationsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentSettings = (state as SettingsLoaded).settings;
      final updatedSettings = currentSettings.copyWith(
        notificationsEnabled: event.enabled,
      );
      
      add(UpdateSettingsEvent(updatedSettings));
    }
  }

  Future<void> _onResetSettings(
    ResetSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());
    final result = await updateSettings(
      UpdateSettingsParams(settings: Settings.defaultSettings()),
    );
    result.fold(
      (failure) => emit(SettingsError(_mapFailureToMessage(failure))),
      (settings) => emit(SettingsLoaded(settings)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    } else if (failure is CacheFailure) {
      return failure.message;
    } else if (failure is NetworkFailure) {
      return failure.message;
    } else {
      return 'Beklenmeyen bir hata oluştu.';
    }
  }
}