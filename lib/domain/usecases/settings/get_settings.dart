import 'package:dartz/dartz.dart';
import 'package:gardas/core/error/failures.dart';
import 'package:gardas/domain/entities/settings.dart';
import 'package:gardas/domain/repositories/settings_repository.dart';
import 'package:gardas/domain/usecases/base/usecase.dart';

/// Get settings use case
/// 
/// This use case retrieves the current application settings.
class GetSettings implements UseCase<Settings, NoParams> {
  final SettingsRepository repository;

  GetSettings(this.repository);

  @override
  Future<Either<Failure, Settings>> call(NoParams params) {
    return repository.getSettings();
  }
}