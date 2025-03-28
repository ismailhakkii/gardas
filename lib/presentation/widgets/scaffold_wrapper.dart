import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gardas/core/constants/app_strings.dart';
import 'package:gardas/presentation/bloc/user/user_bloc.dart';
import 'package:gardas/presentation/routes/app_router.dart';
import 'package:gardas/games_interface/game_registry.dart';
import 'package:gardas/presentation/pages/home/widgets/game_card.dart';
import 'package:gardas/injection_container.dart';

/// Scaffold wrapper for consistent UI across the app
///
/// This widget provides a consistent scaffold with bottom navigation bar and drawer
class ScaffoldWrapper extends StatefulWidget {
  /// The body content of the scaffold
  final Widget body;
  
  /// The app bar title
  final String title;
  
  /// Whether to show the bottom navigation bar
  final bool showBottomBar;
  
  /// Whether to show the drawer
  final bool showDrawer;
  
  /// The currently selected index in the bottom navigation bar
  final int currentIndex;
  
  /// Whether to show back button
  final bool showBackButton;

  const ScaffoldWrapper({
    Key? key,
    required this.body,
    required this.title,
    this.showBottomBar = true,
    this.showDrawer = true,
    this.currentIndex = 0,
    this.showBackButton = false,
  }) : super(key: key);

  @override
  State<ScaffoldWrapper> createState() => _ScaffoldWrapperState();
}

class _ScaffoldWrapperState extends State<ScaffoldWrapper> {
  final AppRouter _router = sl<AppRouter>();
  final GameRegistry _gameRegistry = sl<GameRegistry>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: widget.showBackButton 
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _router.navigateToSettings(context),
          ),
        ],
      ),
      drawer: widget.showDrawer ? _buildDrawer(context) : null,
      body: widget.body,
      bottomNavigationBar: widget.showBottomBar ? _buildBottomNavigationBar() : null,
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text(AppStrings.homeTitle),
            onTap: () {
              Navigator.pop(context);
              _router.navigateToHome(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.games),
            title: const Text("Oyunlar"),
            onTap: () {
              Navigator.pop(context);
              _showGamesPage();
            },
          ),
          ListTile(
            leading: const Icon(Icons.leaderboard),
            title: const Text("Skor Tablosu"),
            onTap: () {
              Navigator.pop(context);
              // Skor tablosu sayfasına yönlendirme yapılabilir (gerekirse)
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text(AppStrings.settingsTitle),
            onTap: () {
              Navigator.pop(context);
              _router.navigateToSettings(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text("Hakkında"),
            onTap: () {
              Navigator.pop(context);
              _showAboutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoaded) {
          return UserAccountsDrawerHeader(
            accountName: Text(state.user.username),
            accountEmail: const Text(""), // E-posta yoksa boş bırakılabilir
            currentAccountPicture: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: Text(
                _getInitials(state.user.username),
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
          );
        } else {
          return DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: const Text(
              AppStrings.appName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: (index) {
        if (index == widget.currentIndex) return;
        
        switch (index) {
          case 0:
            _router.navigateToHome(context);
            break;
          case 1:
            _showGamesPage();
            break;
          case 2:
            _router.navigateToSettings(context);
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: AppStrings.homeTitle,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.games),
          label: "Oyunlar",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: AppStrings.settingsTitle,
        ),
      ],
    );
  }

  void _showGamesPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _GamesPage(gameRegistry: _gameRegistry, router: _router),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: AppStrings.appName,
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2025',
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 16),
          child: Text(
            'Bu uygulama, oyunlar koleksiyonu olarak tasarlanmıştır. Clean Architecture ve SOLID prensiplerine uygun olarak geliştirilmiştir.',
          ),
        ),
      ],
    );
  }
  
  String _getInitials(String name) {
    if (name.isEmpty) return '';
    
    final nameParts = name.trim().split(' ');
    if (nameParts.length > 1) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    } else {
      return name.substring(0, 1).toUpperCase();
    }
  }
}

/// Games Page
class _GamesPage extends StatelessWidget {
  final GameRegistry gameRegistry;
  final AppRouter router;

  const _GamesPage({
    Key? key, 
    required this.gameRegistry,
    required this.router,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final games = gameRegistry.getAllGameInfo();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Oyunlar'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.0,
          ),
          itemCount: games.length,
          itemBuilder: (context, index) {
            final game = games[index];
            return GameCard(
              game: game,
              onTap: () {
                final gameInterface = gameRegistry.getGame(game.id);
                if (gameInterface != null) {
                  router.navigateToGame(context, gameInterface);
                }
              },
            );
          },
        ),
      ),
    );
  }
}