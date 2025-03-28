import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gardas/core/constants/app_strings.dart';
import 'package:gardas/core/widgets/custom_button.dart';
import 'package:gardas/core/widgets/error_display_widget.dart';
import 'package:gardas/core/widgets/loading_widget.dart';
import 'package:gardas/domain/entities/game.dart';
import 'package:gardas/features/flags_game/domain/entities/flag_question.dart';
import 'package:gardas/features/flags_game/presentation/bloc/flags_game_bloc.dart';
import 'package:gardas/features/flags_game/presentation/widgets/flag_question_widget.dart';
import 'package:gardas/features/flags_game/presentation/widgets/game_timer_widget.dart';
import 'package:gardas/features/flags_game/presentation/widgets/score_display_widget.dart';

/// Flag game page
///
/// This page displays the flag guessing game.
class FlagGamePage extends StatefulWidget {
  /// The difficulty level of the game
  final GameDifficulty difficulty;
  
  /// Callback for exiting the game
  final VoidCallback onExit;

  const FlagGamePage({
    Key? key,
    required this.difficulty,
    required this.onExit,
  }) : super(key: key);

  @override
  State<FlagGamePage> createState() => _FlagGamePageState();
}

class _FlagGamePageState extends State<FlagGamePage> {
  bool _isAnswering = false;
  
  @override
  void initState() {
    super.initState();
    
    // Start the game
    _loadGame();
  }
  
  void _loadGame() {
    final bloc = context.read<FlagsGameBloc>();
    
    // Reset game state
    bloc.add(ResetGameEvent());
    
    // Load questions
    int questionCount;
    switch (widget.difficulty) {
      case GameDifficulty.easy:
        questionCount = 10;
        break;
      case GameDifficulty.medium:
        questionCount = 15;
        break;
      case GameDifficulty.hard:
        questionCount = 20;
        break;
    }
    
    bloc.add(LoadQuestionsEvent(
      difficulty: widget.difficulty,
      count: questionCount,
    ));
  }
  
  void _startGame() {
    context.read<FlagsGameBloc>().add(StartGameEvent());
  }
  
  void _handleAnswer(FlagOption selectedOption, double timeSpent) {
    if (_isAnswering) return;
    
    setState(() {
      _isAnswering = true;
    });
    
    context.read<FlagsGameBloc>().add(AnswerQuestionEvent(
      selectedOption: selectedOption,
      timeSpent: timeSpent,
    ));
    
    // Add a delay before allowing next question
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isAnswering = false;
        });
      }
    });
  }
  
  void _goToNextQuestion() {
    context.read<FlagsGameBloc>().add(NextQuestionEvent());
  }
  
  void _pauseGame() {
    context.read<FlagsGameBloc>().add(PauseGameEvent());
    
    // Show pause dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.pause),
        content: const Text('Oyun duraklatıldı. Devam etmek istiyor musunuz?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<FlagsGameBloc>().add(ResumeGameEvent());
            },
            child: const Text(AppStrings.resume),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onExit();
            },
            child: const Text(AppStrings.exit),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _pauseGame();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppStrings.flagsGameTitle),
          leading: IconButton(
            icon: const Icon(Icons.pause),
            onPressed: _pauseGame,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: widget.onExit,
            ),
          ],
        ),
        body: BlocConsumer<FlagsGameBloc, FlagsGameState>(
          listener: (context, state) {
            if (state is GameOver) {
              widget.onExit();
            }
          },
          builder: (context, state) {
            if (state is FlagsGameLoading) {
              return const LoadingWidget(message: AppStrings.loading);
            } else if (state is QuestionsLoaded) {
              return _buildStartGameView(state);
            } else if (state is GameRunning) {
              return _buildGameRunningView(state);
            } else if (state is AnswerSelected) {
              return _buildAnswerResultView(state);
            } else if (state is FlagsGameError) {
              return ErrorDisplayWidget(
                message: state.message,
                onRetry: _loadGame,
              );
            } else {
              return const LoadingWidget(message: AppStrings.loading);
            }
          },
        ),
      ),
    );
  }
  
  Widget _buildStartGameView(QuestionsLoaded state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _getDifficultyText(state.difficulty),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Text(
            '${state.questions.length} Soru',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 32),
          CustomButton(
            text: AppStrings.start,
            onPressed: _startGame,
            type: ButtonType.primary,
            size: ButtonSize.large,
            icon: Icons.play_arrow,
          ),
        ],
      ),
    );
  }
  
  Widget _buildGameRunningView(GameRunning state) {
    return SafeArea(
      child: Column(
        children: [
          _buildGameHeader(state),
          Expanded(
            child: FlagQuestionWidget(
              question: state.currentQuestion,
              onOptionSelected: (option) => _handleAnswer(
                option,
                15 - state.timeRemaining,
              ),
              enabled: !_isAnswering,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAnswerResultView(AnswerSelected state) {
    // Piksel taşmasını önlemek için LayoutBuilder kullanıyoruz
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              _buildGameHeader(state.gameState),
              
              // Esnek bir şekilde büyüyen içerik
              Expanded(
                child: SingleChildScrollView(
                  child: FlagQuestionWidget(
                    question: state.gameState.currentQuestion,
                    selectedOption: state.selectedOption,
                    isCorrect: state.isCorrect,
                    enabled: false,
                  ),
                ),
              ),
              
              // Sabit yüksekliğe sahip alt buton bölgesi
              Container(
                padding: const EdgeInsets.all(16),
                child: CustomButton(
                  text: state.gameState.isLastQuestion
                      ? AppStrings.finish
                      : AppStrings.next,
                  onPressed: _isAnswering ? () {} : _goToNextQuestion,
                  type: ButtonType.primary,
                  fullWidth: true,
                  icon: state.gameState.isLastQuestion
                      ? Icons.check
                      : Icons.arrow_forward,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
  
  Widget _buildGameHeader(GameRunning state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Question counter
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '${state.currentQuestionIndex + 1}/${state.questions.length}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Timer
          Expanded(
            child: GameTimerWidget(
              timeRemaining: state.timeRemaining,
              totalTime: 15,
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Score
          ScoreDisplayWidget(score: state.score),
        ],
      ),
    );
  }
  
  String _getDifficultyText(GameDifficulty difficulty) {
    switch (difficulty) {
      case GameDifficulty.easy:
        return AppStrings.flagsGameEasy;
      case GameDifficulty.medium:
        return AppStrings.flagsGameMedium;
      case GameDifficulty.hard:
        return AppStrings.flagsGameHard;
    }
  }
}