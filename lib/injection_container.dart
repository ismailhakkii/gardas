import 'package:get_it/get_it.dart';
import 'package:gardas/core/error/error_handler.dart';
import 'package:gardas/data/datasources/local/local_storage_service.dart';
import 'package:gardas/data/datasources/local/preferences_service.dart';
import 'package:gardas/data/repositories/score_repository_impl.dart';
import 'package:gardas/data/repositories/settings_repository_impl.dart';
import 'package:gardas/data/repositories/user_repository_impl.dart';
import 'package:gardas/domain/repositories/score_repository.dart';
import 'package:gardas/domain/repositories/settings_repository.dart';
import 'package:gardas/domain/repositories/user_repository.dart';
import 'package:gardas/domain/usecases/scores/get_high_score.dart';
import 'package:gardas/domain/usecases/scores/get_scores_by_game.dart';
import 'package:gardas/domain/usecases/scores/save_score.dart';
import 'package:gardas/domain/usecases/settings/get_settings.dart';
import 'package:gardas/domain/usecases/settings/update_language.dart';
import 'package:gardas/domain/usecases/settings/update_settings.dart';
import 'package:gardas/domain/usecases/settings/update_theme_mode.dart';
import 'package:gardas/domain/usecases/user/get_current_user.dart';
import 'package:gardas/domain/usecases/user/update_avatar.dart';
import 'package:gardas/domain/usecases/user/update_username.dart';
import 'package:gardas/features/flags_game/data/datasources/flags_local_datasource.dart';
import 'package:gardas/features/flags_game/data/repositories/flags_repository_impl.dart';
import 'package:gardas/features/flags_game/domain/repositories/flags_repository.dart';
import 'package:gardas/features/flags_game/domain/usecases/get_flag_questions.dart';
import 'package:gardas/features/flags_game/domain/usecases/save_flag_score.dart';
import 'package:gardas/games_interface/game_registry.dart';
import 'package:gardas/presentation/bloc/settings/settings_bloc.dart';
import 'package:gardas/presentation/bloc/user/user_bloc.dart';
import 'package:gardas/features/flags_game/presentation/bloc/flags_game_bloc.dart';

/// Service locator instance
final GetIt sl = GetIt.instance;

/// Initialize dependency injection
Future<void> init() async {
  // Core
  sl.registerSingleton<ErrorHandler>(ErrorHandler());
  
  // Data sources
  final localStorageService = LocalStorageService();
  await localStorageService.init();
  sl.registerSingleton<LocalStorageService>(localStorageService);
  
  final preferencesService = PreferencesService();
  await preferencesService.init();
  sl.registerSingleton<PreferencesService>(preferencesService);
  
  sl.registerSingleton<FlagsLocalDataSource>(FlagsLocalDataSource(sl()));
  
  // Repositories
  sl.registerSingleton<UserRepository>(UserRepositoryImpl(sl(), sl()));
  sl.registerSingleton<SettingsRepository>(SettingsRepositoryImpl(sl(), sl()));
  sl.registerSingleton<ScoreRepository>(ScoreRepositoryImpl(sl(), sl()));
  sl.registerSingleton<FlagsRepository>(FlagsRepositoryImpl(sl(), sl()));
  
  // Use cases - User
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => UpdateUsername(sl()));
  sl.registerLazySingleton(() => UpdateAvatar(sl()));
  
  // Use cases - Settings
  sl.registerLazySingleton(() => GetSettings(sl()));
  sl.registerLazySingleton(() => UpdateSettings(sl()));
  sl.registerLazySingleton(() => UpdateThemeMode(sl()));
  sl.registerLazySingleton(() => UpdateLanguage(sl()));
  
  // Use cases - Scores
  sl.registerLazySingleton(() => GetHighScore(sl()));
  sl.registerLazySingleton(() => GetScoresByGame(sl()));
  sl.registerLazySingleton(() => SaveScore(sl()));
  
  // Use cases - Flags Game
  sl.registerLazySingleton(() => GetFlagQuestions(sl()));
  sl.registerLazySingleton(() => SaveFlagScore(sl()));
  
  // Game Registry
  sl.registerSingleton<GameRegistry>(GameRegistry());
  
  // BLoCs
  sl.registerFactory<UserBloc>(() => UserBloc(
    getCurrentUser: sl(),
    updateUsername: sl(),
    updateAvatar: sl(),
  ));
  
  sl.registerFactory<SettingsBloc>(() => SettingsBloc(
    getSettings: sl(),
    updateSettings: sl(),
    updateThemeMode: sl(),
    updateLanguage: sl(),
  ));
  
  sl.registerFactory<FlagsGameBloc>(() => FlagsGameBloc(
    getFlagQuestions: sl(),
    saveFlagScore: sl(),
    getHighScore: sl(),
  ));
}