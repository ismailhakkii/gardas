import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gardas/core/constants/app_strings.dart';
import 'package:gardas/core/widgets/error_display_widget.dart';
import 'package:gardas/core/widgets/loading_widget.dart';
import 'package:gardas/games_interface/game_registry.dart';
import 'package:gardas/injection_container.dart';
import 'package:gardas/presentation/bloc/settings/settings_bloc.dart';
import 'package:gardas/presentation/bloc/user/user_bloc.dart';
import 'package:gardas/presentation/pages/home/widgets/game_card.dart';
import 'package:gardas/presentation/pages/home/widgets/profile_section.dart';
import 'package:gardas/presentation/pages/home/widgets/stats_section.dart';
import 'package:gardas/presentation/routes/app_router.dart';

/// Home page
///
/// This is the main page of the application.
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GameRegistry _gameRegistry = sl<GameRegistry>();
  final AppRouter _router = AppRouter();

  @override
  void initState() {
    super.initState();
    
    // Load user and settings
    context.read<UserBloc>().add(GetCurrentUserEvent());
    context.read<SettingsBloc>().add(GetSettingsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.homeTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _router.navigateToSettings(context),
          ),
        ],
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, userState) {
          if (userState is UserLoading) {
            return const LoadingWidget();
          } else if (userState is UserLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<UserBloc>().add(GetCurrentUserEvent());
              },
              child: _buildHomeContent(userState),
            );
          } else if (userState is UserError) {
            return ErrorDisplayWidget(
              message: userState.message,
              onRetry: () {
                context.read<UserBloc>().add(GetCurrentUserEvent());
              },
            );
          } else {
            return const LoadingWidget();
          }
        },
      ),
    );
  }

  Widget _buildHomeContent(UserLoaded userState) {
    final games = _gameRegistry.getAllGameInfo();
    
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile section
          ProfileSection(user: userState.user),
          
          const SizedBox(height: 24),
          
          // Games section
          Text(
            AppStrings.gamesCollection,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Games grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
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
                  final gameInterface = _gameRegistry.getGame(game.id);
                  if (gameInterface != null) {
                    _router.navigateToGame(context, gameInterface);
                  }
                },
              );
            },
          ),
          
          const SizedBox(height: 24),
          
          // Stats section
          const StatsSection(),
        ],
      ),
    );
  }
}