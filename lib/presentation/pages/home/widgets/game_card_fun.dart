import 'package:flutter/material.dart';
import 'package:gardas/domain/entities/game.dart'; // Game sınıfını içe aktarıyoruz
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;

/// A fun animated game card widget
///
/// Displays game information in a visually appealing and animated way.
class GameCardFun extends StatefulWidget {
  /// The game to display
  final Game game; // GameInfo yerine Game kullanıyoruz

  /// Callback when the card is tapped
  final VoidCallback onTap;

  const GameCardFun({
    Key? key,
    required this.game,
    required this.onTap,
  }) : super(key: key);

  @override
  State<GameCardFun> createState() => _GameCardFunState();
}

class _GameCardFunState extends State<GameCardFun> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _bounceAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
    
    if (isHovered) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define a list of gradient pairs for different game types
    final List<List<Color>> gradientPairs = [
      [Colors.purple.shade400, Colors.purple.shade200],
      [Colors.blue.shade400, Colors.blue.shade200],
      [Colors.pink.shade400, Colors.pink.shade200],
      [Colors.teal.shade400, Colors.teal.shade200],
      [Colors.amber.shade400, Colors.amber.shade200],
      [Colors.deepOrange.shade400, Colors.deepOrange.shade200],
      [Colors.indigo.shade400, Colors.indigo.shade200],
      [Colors.green.shade400, Colors.green.shade200],
    ];
    
    // Calculate a consistent color based on the game ID - so the same game always has the same color
    final int colorIndex = widget.game.id.hashCode % gradientPairs.length;
    final gradientColors = gradientPairs[colorIndex.abs()];

    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      cursor: SystemMouseCursors.click,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _bounceAnimation.value,
            child: child,
          );
        },
        child: GestureDetector(
          onTap: () {
            // Add tap animation before calling the onTap callback
            _controller.forward().then((_) => _controller.reverse());
            
            // Small delay for better UX
            Future.delayed(const Duration(milliseconds: 150), widget.onTap);
          },
          child: Stack(
            children: [
              // Main card with gradient background
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: gradientColors,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: gradientColors[0].withOpacity(_isHovered ? 0.5 : 0.3),
                      blurRadius: _isHovered ? 16 : 8,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    children: [
                      // Background pattern
                      CustomPaint(
                        painter: BubblePatternPainter(
                          color: Colors.white.withOpacity(0.1),
                          bubbleCount: 15,
                        ),
                        size: const Size(double.infinity, double.infinity),
                      ),
                      
                      // Game content
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Game icon
                            Container(
                              height: 56,
                              width: 56,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                _getIconForGame(widget.game.id),
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                            
                            const Spacer(),
                            
                            // Game title
                            Text(
                              widget.game.name,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            
                            const SizedBox(height: 4),
                            
                            // Game description
                            Text(
                              widget.game.description,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withOpacity(0.8),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            
                            const SizedBox(height: 16),
                            
                            // Play button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Oyna',
                                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(
                                        Icons.play_arrow_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      // "New" badge if needed
                      if (_isNewGame(widget.game.id))
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Yeni',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: gradientColors[0],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ).animate().shimmer(
                            duration: const Duration(seconds: 2),
                            curve: Curves.easeInOut,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              
              // Floating elements for extra fun
              if (_isHovered)
                ..._buildFloatingElements().animate().fadeIn(
                  duration: const Duration(milliseconds: 300),
                ),
            ],
          ),
        ),
      ),
    )
    .animate()
    .fade(duration: const Duration(milliseconds: 400))
    .scale(
      begin: const Offset(0.8, 0.8),
      end: const Offset(1.0, 1.0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutBack,
    );
  }

  // Helper method to get icon based on game id
  IconData _getIconForGame(String id) {
    // Map game IDs to specific icons
    // You can customize this based on your actual game IDs
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

  // Helper method to check if a game is new
  bool _isNewGame(String id) {
    // This is a placeholder - you would implement your own logic
    // For example, check if the game was added in the last 30 days
    return id == 'math_puzzle'; // Just for demonstration
  }

  // Method to build floating decoration elements
  List<Widget> _buildFloatingElements() {
    return [
      Positioned(
        top: 10,
        right: 60,
        child: _buildDecorativeElement(
          Icons.stars_rounded,
          Colors.amber,
          24,
        ),
      ),
      Positioned(
        bottom: 20,
        left: 10,
        child: _buildDecorativeElement(
          Icons.brightness_1_rounded,
          Colors.white.withOpacity(0.3),
          12,
        ),
      ),
      Positioned(
        top: 70,
        right: 20,
        child: _buildDecorativeElement(
          Icons.circle,
          Colors.white.withOpacity(0.2),
          16,
        ),
      ),
    ];
  }

  // Helper to build a single decorative element
  Widget _buildDecorativeElement(IconData icon, Color color, double size) {
    return Icon(
      icon,
      color: color,
      size: size,
    ).animate().rotate(
      duration: const Duration(seconds: 3),
      curve: Curves.linear,
      alignment: Alignment.center,
    );
  }
}

/// Custom painter for creating bubble patterns in the background
class BubblePatternPainter extends CustomPainter {
  final Color color;
  final int bubbleCount;
  final List<Bubble> bubbles = [];

  BubblePatternPainter({
    required this.color,
    required this.bubbleCount,
  }) {
    // Generate random bubbles
    final random = math.Random(42); // Fixed seed for consistent pattern
    for (int i = 0; i < bubbleCount; i++) {
      bubbles.add(
        Bubble(
          x: random.nextDouble(),
          y: random.nextDouble(),
          radius: random.nextDouble() * 0.1 + 0.02,
        ),
      );
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (final bubble in bubbles) {
      canvas.drawCircle(
        Offset(bubble.x * size.width, bubble.y * size.height),
        bubble.radius * size.width,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Helper class for storing bubble data
class Bubble {
  final double x;
  final double y;
  final double radius;

  Bubble({
    required this.x,
    required this.y,
    required this.radius,
  });
}