import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:gardas/core/error/failures.dart';
import 'package:gardas/domain/entities/settings.dart';
import 'package:gardas/domain/repositories/settings_repository.dart';
import 'package:gardas/domain/usecases/base/usecase.dart';

/// Update settings use case
/// 
/// This use case updates the application settings.
class UpdateSettings implements UseCase<Settings, UpdateSettingsParams> {
  final SettingsRepository repository;

  UpdateSettings(this.repository);

  @override
  Future<Either<Failure, Settings>> call(UpdateSettingsParams params) {
    return repository.updateSettings(params.settings);
  }
}

/// Update settings parameters
class UpdateSettingsParams extends Equatable {
  final Settings settings;

  const UpdateSettingsParams({required this.settings});

  @override
  List<Object?> get props => [settings];
}