import 'package:gardas/domain/entities/game.dart';
import 'package:gardas/games_interface/game_interface.dart';

/// Game Registry
/// 
/// This class is responsible for registering and managing all games in the application.
/// It provides methods to access and manage the available games.
class GameRegistry {
  /// Singleton instance
  static final GameRegistry _instance = GameRegistry._internal();
  
  /// Factory constructor
  factory GameRegistry() => _instance;
  
  /// Internal constructor
  GameRegistry._internal();
  
  /// Map of registered games
  final Map<String, GameInterface> _games = {};
  
  /// Registers a game in the registry
  void registerGame(GameInterface game) {
    _games[game.gameInfo.id] = game;
  }
  
  /// Returns a game by ID
  GameInterface? getGame(String id) {
    return _games[id];
  }
  
  /// Returns a game by route path
  GameInterface? getGameByRoute(String routePath) {
    return _games.values.firstWhere(
      (game) => game.gameInfo.routePath == routePath,
      orElse: () => throw Exception('Game not found for route: $routePath'),
    );
  }
  
  /// Returns all registered games
  List<GameInterface> getAllGames() {
    return _games.values.toList();
  }
  
  /// Returns all game info objects
  List<Game> getAllGameInfo() {
    return _games.values.map((game) => game.gameInfo).toList();
  }
  
  /// Returns games filtered by tags
  List<GameInterface> getGamesByTags(List<String> tags) {
    return _games.values.where((game) {
      return game.gameInfo.tags.any((tag) => tags.contains(tag));
    }).toList();
  }
  
  /// Unregisters a game from the registry
  void unregisterGame(String id) {
    _games.remove(id);
  }
  
  /// Clears all registered games
  void clearGames() {
    _games.clear();
  }
}