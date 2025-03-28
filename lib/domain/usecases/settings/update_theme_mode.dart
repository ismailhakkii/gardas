import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:gardas/core/error/failures.dart';
import 'package:gardas/domain/entities/settings.dart';
import 'package:gardas/domain/repositories/settings_repository.dart';
import 'package:gardas/domain/usecases/base/usecase.dart';

/// Update theme mode use case
/// 
/// This use case updates only the theme mode setting.
class UpdateThemeMode implements UseCase<Settings, UpdateThemeModeParams> {
  final SettingsRepository repository;

  UpdateThemeMode(this.repository);

  @override
  Future<Either<Failure, Settings>> call(UpdateThemeModeParams params) {
    return repository.updateThemeMode(params.themeMode);
  }
}

/// Update theme mode parameters
class UpdateThemeModeParams extends Equatable {
  final AppThemeMode themeMode;

  const UpdateThemeModeParams({required this.themeMode});

  @override
  List<Object?> get props => [themeMode];
}