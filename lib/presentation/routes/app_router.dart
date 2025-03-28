import 'package:flutter/material.dart';
import 'package:gardas/core/constants/app_constants.dart';
import 'package:gardas/domain/entities/game.dart';
import 'package:gardas/features/flags_game/flags_game_impl.dart';
import 'package:gardas/features/math_puzzle/math_game_impl.dart';
import 'package:gardas/games_interface/game_interface.dart';
import 'package:gardas/games_interface/game_registry.dart';
import 'package:gardas/injection_container.dart';
import 'package:gardas/presentation/pages/game/fun_game_page.dart';
import 'package:gardas/presentation/pages/game_base_page.dart';
import 'package:gardas/presentation/pages/home/home_page.dart';
import 'package:gardas/presentation/pages/settings/settings_page.dart';

/// Application router
/// 
/// This class is responsible for managing application routes.
class AppRouter {
  /// The game registry instance
  final GameRegistry _gameRegistry = sl<GameRegistry>();
  
  /// Boolean to determine whether to use the fun mode for games
  bool useFunMode = true;
  
  /// Creates and registers all games
  void registerGames() {
    // Register flags game
    _gameRegistry.registerGame(FlagsGame());
    
    // Register math game
    _gameRegistry.registerGame(MathGame());
  }
  
  /// Returns the app routes
  Map<String, WidgetBuilder> get routes {
    final routes = <String, WidgetBuilder>{
      // Main routes
      AppConstants.homeRoute: (context) => const HomePage(),
      AppConstants.settingsRoute: (context) => const SettingsPage(),
      
      // Game-specific routes
      AppConstants.flagsGameRoute: (context) => GameBasePage(
        game: _gameRegistry.getGameByRoute(AppConstants.flagsGameRoute),
      ),
      
      // Math game route
      '/math-game': (context) => GameBasePage(
        game: _gameRegistry.getGameByRoute('/math-game'),
      ),
    };
    
    return routes;
  }
  
  /// Navigates to a game route
  void navigateToGame(BuildContext context, GameInterface game) {
    if (useFunMode) {
      // Use animated transition with FunGamePage in fun mode
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => 
            FunGamePage(gameInterface: game),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeOutCubic;

            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    } else {
      // Standard navigation in normal mode
      // GameInfo'ya erişmek için gameInfo özelliğini kullan
      Navigator.pushNamed(context, game.gameInfo.routePath);
    }
  }
  
  /// Navigates to a game tutorial
  void navigateToGameTutorial(BuildContext context, GameInterface game) {
    if (useFunMode) {
      // Show tutorial in FunGamePage
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => 
            FunGamePage(gameInterface: game),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    } else {
      // Standard navigation to tutorial
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GameBasePage(
            game: game,
            startWithTutorial: true,
          ),
        ),
      );
    }
  }
  
  /// Navigates to settings
  void navigateToSettings(BuildContext context) {
    Navigator.pushNamed(context, AppConstants.settingsRoute);
  }
  
  /// Navigates back to home
  void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppConstants.homeRoute,
      (route) => false,
    );
  }
  
  /// Generates a route for named navigation
  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    // Extract route name and arguments
    final routeName = settings.name;
    final arguments = settings.arguments;
    
    // Check if route is a game route
    if (routeName != null) {
      try {
        final game = _gameRegistry.getGameByRoute(routeName);
        
        // Null kontrolü ekle
        if (game != null) {
          if (useFunMode) {
            // Use FunGamePage in fun mode
            return PageRouteBuilder(
              settings: settings,
              pageBuilder: (context, animation, secondaryAnimation) => 
                FunGamePage(gameInterface: game),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.9, end: 1.0).animate(animation),
                    child: child,
                  ),
                );
              },
              transitionDuration: const Duration(milliseconds: 400),
            );
          } else {
            // Use standard GameBasePage in normal mode
            return MaterialPageRoute(
              settings: settings,
              builder: (context) => GameBasePage(
                game: game,
                initialDifficulty: arguments is GameDifficulty ? arguments : null,
              ),
            );
          }
        }
      } catch (e) {
        // Route is not a game route, continue normal routing
      }
    }
    
    return null;
  }
}