import 'package:flutter/material.dart';
import 'package:gardas/core/theme/fun_app_theme.dart';
import 'package:gardas/games_interface/game_interface.dart';
import 'package:gardas/core/widgets/custom_button.dart';
import 'package:gardas/domain/entities/game.dart'; // Eklendi
import 'package:gardas/domain/entities/score.dart'; // Eklendi
import 'package:lottie/lottie.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;

/// Fun animated game page base
///
/// This is a base page for games with fun animations and UI elements.
class FunGamePage extends StatefulWidget {
  /// The game interface
  final GameInterface gameInterface;

  const FunGamePage({
    Key? key,
    required this.gameInterface,
  }) : super(key: key);

  @override
  State<FunGamePage> createState() => _FunGamePageState();
}

class _FunGamePageState extends State<FunGamePage> with TickerProviderStateMixin {
  late AnimationController _bgAnimationController;
  late AnimationController _gameStartController;
  bool _isGameStarted = false;
  Widget? _gameWidget;
  bool _showTutorial = false;
  Score? _currentScore;
  GameDifficulty _selectedDifficulty = GameDifficulty.medium; // Varsayılan zorluk

  @override
  void initState() {
    super.initState();
    
    _bgAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    
    _gameStartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    
    // GameInterface'in zorluk seviyelerini al
    final difficulties = widget.gameInterface.supportedDifficulties;
    if (difficulties.isNotEmpty) {
      _selectedDifficulty = difficulties.first; // İlk zorluk seviyesini seç
    }
  }

  @override
  void dispose() {
    _bgAnimationController.dispose();
    _gameStartController.dispose();
    widget.gameInterface.dispose(); // Oyun kaynaklarını temizle
    super.dispose();
  }

  void _startGame() {
    setState(() {
      _isGameStarted = true;
    });
    
    _gameStartController.forward();
    
    // Oyun başlat
    widget.gameInterface.startGame(_selectedDifficulty);
  }
  
  void _showGameTutorial() {
    setState(() {
      _showTutorial = true;
    });
  }
  
  void _hideGameTutorial() {
    setState(() {
      _showTutorial = false;
    });
  }
  
  void _handleScoreUpdate(Score score) {
    setState(() {
      _currentScore = score;
    });
  }
  
  void _handleGameOver() {
    // Oyun bittiğinde burada gerekli işlemleri yapabilirsiniz
    // Örneğin, bir oyun bitti ekranı gösterebilirsiniz
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated background
          AnimatedBuilder(
            animation: _bgAnimationController,
            builder: (context, child) {
              return CustomPaint(
                painter: FunBackgroundPainter(
                  animation: _bgAnimationController.value,
                  primaryColor: FunAppTheme.primaryColor,
                  secondaryColor: FunAppTheme.accentColor,
                ),
                size: MediaQuery.of(context).size,
              );
            },
          ),
          
          // Main content
          SafeArea(
            child: _isGameStarted ? _buildGameContent() : _buildStartScreen(),
          ),
          
          // Tutorial overlay
          if (_showTutorial)
            _buildTutorialOverlay(),
        ],
      ),
    );
  }

  Widget _buildStartScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Game logo or animation
        Center(
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: FunAppTheme.primaryColor.withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Center(
              child: Icon(
                _getIconForGame(widget.gameInterface.gameInfo.id),
                size: 100,
                color: FunAppTheme.primaryColor,
              ),
            ),
          ).animate()
          .scale(
            duration: const Duration(milliseconds: 800),
            curve: Curves.elasticOut,
          ),
        ),
        
        const SizedBox(height: 40),
        
        // Game title
        Text(
          widget.gameInterface.gameInfo.name,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
        ).animate()
        .fadeIn(delay: const Duration(milliseconds: 200))
        .slideY(
          begin: 30,
          end: 0,
          curve: Curves.easeOutQuad,
        ),
        
        const SizedBox(height: 16),
        
        // Game description
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            widget.gameInterface.gameInfo.description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 5,
                ),
              ],
            ),
          ),
        ).animate()
        .fadeIn(delay: const Duration(milliseconds: 400))
        .slideY(
          begin: 30,
          end: 0,
          curve: Curves.easeOutQuad,
        ),
        
        const SizedBox(height: 32),
        
        // Difficulty selection
        if (widget.gameInterface.supportedDifficulties.length > 1)
          _buildDifficultySelector(),
        
        const SizedBox(height: 32),
        
        // Start and tutorial buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              onPressed: _showGameTutorial,
              text: 'Nasıl Oynanır',
              icon: Icons.help_outline,
              backgroundColor: Colors.white,
              textColor: FunAppTheme.primaryColor,
            ),
            
            const SizedBox(width: 16),
            
            CustomButton(
              onPressed: _startGame,
              text: 'Başla',
              icon: Icons.play_arrow_rounded,
              backgroundColor: FunAppTheme.accentColor,
              textColor: Colors.black87,
            ),
          ],
        ).animate()
        .fadeIn(delay: const Duration(milliseconds: 600))
        .slideY(
          begin: 30,
          end: 0,
          curve: Curves.easeOutQuad,
        ),
        
        const SizedBox(height: 40),
        
        // High score display
        _buildHighScoreWidget().animate()
        .fadeIn(delay: const Duration(milliseconds: 800))
        .slideY(
          begin: 30,
          end: 0,
          curve: Curves.easeOutQuad,
        ),
      ],
    );
  }

  Widget _buildDifficultySelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Zorluk Seviyesi',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: widget.gameInterface.supportedDifficulties.map((difficulty) {
              final isSelected = difficulty == _selectedDifficulty;
              final difficultyName = _getDifficultyName(difficulty);
              
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDifficulty = difficulty;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? FunAppTheme.accentColor : Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                      border: isSelected
                          ? Border.all(color: Colors.white, width: 2)
                          : null,
                    ),
                    child: Text(
                      difficultyName,
                      style: TextStyle(
                        color: isSelected ? Colors.black : Colors.white,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  String _getDifficultyName(GameDifficulty difficulty) {
    switch (difficulty) {
      case GameDifficulty.easy:
        return 'Kolay';
      case GameDifficulty.medium:
        return 'Orta';
      case GameDifficulty.hard:
        return 'Zor';


    }
  }

  Widget _buildGameContent() {
    return AnimatedBuilder(
      animation: _gameStartController,
      builder: (context, child) {
        // Apply transition animation when game starts
        return Transform.translate(
          offset: Offset(
            0,
            (1 - _gameStartController.value) * MediaQuery.of(context).size.height,
          ),
          child: Opacity(
            opacity: _gameStartController.value,
            child: child,
          ),
        );
      },
      child: Stack(
        children: [
          // Main game widget - GameInterface'ten doğru şekilde oluşturuldu
          widget.gameInterface.buildGame(
            context: context,
            difficulty: _selectedDifficulty,
            onScoreUpdated: _handleScoreUpdate,
            onGameOver: _handleGameOver,
          ),
          
          // Tutorial button
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              onPressed: _showGameTutorial,
              icon: const Icon(
                Icons.help_outline,
                color: Colors.white,
              ),
              style: IconButton.styleFrom(
                backgroundColor: FunAppTheme.primaryColor.withOpacity(0.7),
                padding: const EdgeInsets.all(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTutorialOverlay() {
    // GameInterface'in kendi tutorial widget'ı varsa onu kullan
    Widget? customTutorial = widget.gameInterface.buildTutorial?.call(
      context: context, 
      onTutorialCompleted: _hideGameTutorial,
    );
    
    if (customTutorial != null) {
      return customTutorial;
    }
    
    // Varsayılan tutorial
    return GestureDetector(
      onTap: _hideGameTutorial,
      child: Container(
        color: Colors.black.withOpacity(0.8),
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Nasıl Oynanır',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: FunAppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                Lottie.network(
                  _getTutorialAnimationUrl(widget.gameInterface.gameInfo.id),
                  height: 150,
                ),
                
                const SizedBox(height: 16),
                
                Text(
                  _getTutorialText(widget.gameInterface.gameInfo.id),
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 24),
                
                ElevatedButton(
                  onPressed: _hideGameTutorial,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: FunAppTheme.accentColor,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text('Anladım'),
                ),
              ],
            ),
          ).animate()
          .scale(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutBack,
          ),
        ),
      ),
    );
  }

  Widget _buildHighScoreWidget() {
    // This is a placeholder - you would implement your actual high score UI
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.emoji_events,
            color: Colors.amber,
            size: 24,
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'En Yüksek Puan',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '5200',  // Replace with actual high score
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method to get icon based on game id
  IconData _getIconForGame(String id) {
    // Map game IDs to specific icons
    switch (id) {
      case 'flags_game':
        return Icons.flag_rounded;
      case 'math_puzzle':
        return Icons.calculate_rounded;
      case 'word_game':
        return Icons.abc_rounded;
      case 'memory_game':
        return Icons.psychology_rounded;
      case 'puzzle_game':
        return Icons.extension_rounded;
      default:
        return Icons.videogame_asset_rounded;
    }
  }
  
  // Helper to get a tutorial animation URL based on game ID
  String _getTutorialAnimationUrl(String id) {
    // These are placeholder animation URLs - replace with your actual animations
    switch (id) {
      case 'flags_game':
        return 'https://assets5.lottiefiles.com/packages/lf20_azyqopt6.json';
      case 'math_puzzle':
        return 'https://assets7.lottiefiles.com/private_files/lf30_fup2uejx.json';
      default:
        return 'https://assets5.lottiefiles.com/packages/lf20_tll0j4i.json';
    }
  }
  
  // Helper to get tutorial text based on game ID
  String _getTutorialText(String id) {
    // You would implement your actual tutorial text here
    switch (id) {
      case 'flags_game':
        return 'Bayrakları tahmin et! Doğru cevabı seç ve puanı topla. Hızlı ol, süre dolmadan cevap ver!';
      case 'math_puzzle':
        return 'Matematik bulmacalarını çöz! Doğru cevabı hesapla ve gir. Her doğru cevap için puan kazan!';
      default:
        return 'Oyunu oynamak için talimatları takip et ve puan topla! Eğlenceli vakit geçir.';
    }
  }
}

/// Fun background painter for animated background
class FunBackgroundPainter extends CustomPainter {
  final double animation;
  final Color primaryColor;
  final Color secondaryColor;
  final List<Offset> dots = [];
  final int dotCount = 20;

  FunBackgroundPainter({
    required this.animation,
    required this.primaryColor,
    required this.secondaryColor,
  }) {
    // Generate random dots for the background
    final random = math.Random(42);
    for (int i = 0; i < dotCount; i++) {
      dots.add(Offset(
        random.nextDouble(),
        random.nextDouble(),
      ));
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Paint for the gradient background
    final Paint gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          primaryColor.withOpacity(0.8),
          primaryColor.withOpacity(0.6),
        ],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Draw gradient background
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), gradientPaint);
    
    // Paint for the circles
    final Paint circlePaint = Paint()
      ..color = secondaryColor.withOpacity(0.1)
      ..style = PaintingStyle.fill;
      
    // Paint for the strokes
    final Paint strokePaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw animated circles in the background
    for (int i = 0; i < dots.length; i++) {
      // Calculate position with animation
      final offset = Offset(
        dots[i].dx * size.width,
        (dots[i].dy + animation * 0.1) % 1.0 * size.height,
      );
      
      // Calculate size that varies with animation
      final sizeMultiplier = 0.2 + 0.1 * math.sin(animation * 2 * math.pi + i);
      final radius = size.width * 0.1 * sizeMultiplier;
      
      // Draw filled circle
      canvas.drawCircle(offset, radius, circlePaint);
      
      // Draw stroke circle for added effect
      canvas.drawCircle(offset, radius * 1.3, strokePaint);
    }
    
    // Add some floating particles for extra effect
    final particlePaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.fill;
      
    final random = math.Random(animation.toInt() * 1000);
    for (int i = 0; i < 50; i++) {
      final particleOffset = Offset(
        random.nextDouble() * size.width,
        random.nextDouble() * size.height,
      );
      
      final particleSize = random.nextDouble() * 4 + 1;
      canvas.drawCircle(particleOffset, particleSize, particlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant FunBackgroundPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}