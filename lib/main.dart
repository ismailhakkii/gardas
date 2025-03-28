import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gardas/core/constants/app_constants.dart';
import 'package:gardas/core/theme/app_theme.dart';
import 'package:gardas/domain/entities/settings.dart';
import 'package:gardas/injection_container.dart' as di;
import 'package:gardas/presentation/bloc/settings/settings_bloc.dart';
import 'package:gardas/presentation/bloc/user/user_bloc.dart';
import 'package:gardas/presentation/routes/app_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Main entry point of the application
void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Initialize dependencies
  await di.init();
  
  // Register games
  final appRouter = AppRouter();
  appRouter.registerGames();
  
  // Run app
  runApp(MyApp(appRouter: appRouter));
}

/// The main application class
class MyApp extends StatelessWidget {
  /// The application router
  final AppRouter appRouter;

  const MyApp({
    Key? key,
    required this.appRouter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<SettingsBloc>()..add(GetSettingsEvent())),
        BlocProvider(create: (_) => di.sl<UserBloc>()..add(GetCurrentUserEvent())),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          // Get theme mode from settings
          ThemeMode themeMode = ThemeMode.system;
          
          if (state is SettingsLoaded) {
            themeMode = _getThemeMode(state.settings.themeMode);
          }
          
          return MaterialApp(
            title: AppConstants.appName,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            initialRoute: AppConstants.homeRoute,
            routes: appRouter.routes,
            onGenerateRoute: appRouter.onGenerateRoute,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLanguage.supportedLanguages
                .map((language) => Locale(language.code))
                .toList(),
          );
        },
      ),
    );
  }
  
  ThemeMode _getThemeMode(AppThemeMode themeMode) {
    switch (themeMode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }
}