import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:gardas/core/error/failures.dart';
import 'package:gardas/domain/entities/settings.dart';
import 'package:gardas/domain/repositories/settings_repository.dart';
import 'package:gardas/domain/usecases/base/usecase.dart';

/// Update language use case
/// 
/// This use case updates only the language setting.
class UpdateLanguage implements UseCase<Settings, UpdateLanguageParams> {
  final SettingsRepository repository;

  UpdateLanguage(this.repository);

  @override
  Future<Either<Failure, Settings>> call(UpdateLanguageParams params) {
    return repository.updateLanguage(params.languageCode);
  }
}

/// Update language parameters
class UpdateLanguageParams extends Equatable {
  final String languageCode;

  const UpdateLanguageParams({required this.languageCode});

  @override
  List<Object?> get props => [languageCode];
}