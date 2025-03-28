import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;

/// Animation utilities for the fun theme
class FunAnimations {
  /// Applies a staggered entrance animation to a list of children
  static List<Widget> staggeredList({
    required List<Widget> children,
    Duration initialDelay = Duration.zero,
    Duration staggerDelay = const Duration(milliseconds: 50),
    Duration animationDuration = const Duration(milliseconds: 400),
    Curve curve = Curves.easeOutQuad,
    Offset beginOffset = const Offset(0, 30),
  }) {
    List<Widget> animatedChildren = [];

    for (int i = 0; i < children.length; i++) {
      animatedChildren.add(
        children[i]
            .animate(
              onPlay: (controller) => controller.repeat(), // only for autoPlay: true items
            )
            .fadeIn(
              delay: initialDelay + (staggerDelay * i),
              duration: animationDuration,
              curve: curve,
            )
            .slideY(
              delay: initialDelay + (staggerDelay * i),
              duration: animationDuration,
              begin: beginOffset.dy,
              curve: curve,
            ),
      );
    }

    return animatedChildren;
  }

  /// Applies a page entrance animation to a widget
  static Widget pageEntrance(Widget child) {
    return child
        .animate()
        .fadeIn(duration: const Duration(milliseconds: 400))
        .scale(
          begin: const Offset(0.95, 0.95),
          end: const Offset(1, 1),
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutQuad,
        );
  }

  /// Creates a winning celebration effect
  static Widget winCelebration({
    required BuildContext context,
    required String message,
  }) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Lottie animation here
          Lottie.network(
            'https://assets9.lottiefiles.com/private_files/lf30_yJttYE.json',
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Tebrikler!',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Devam Et'),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn().scale();
  }

  /// Creates a pulsing effect
  static Widget pulseEffect(Widget child) {
    return child.animate(
      onPlay: (controller) => controller.repeat(),
    ).scale(
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
      begin: const Offset(1, 1),
      end: const Offset(1.05, 1.05),
    );
  }

  /// Creates a shimmer loading effect
  static Widget shimmerLoading({
    required double width,
    required double height,
    BorderRadius? borderRadius,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
    ).animate(
      onPlay: (controller) => controller.repeat(),
    ).shimmer(
      duration: const Duration(seconds: 1),
      color: Colors.white.withOpacity(0.5),
    );
  }
}

/// A widget that displays floating bubbles as a background effect
class FloatingBubblesBackground extends StatefulWidget {
  final Widget child;
  final Color bubbleColor;
  final int bubbleCount;

  const FloatingBubblesBackground({
    Key? key,
    required this.child,
    this.bubbleColor = Colors.white,
    this.bubbleCount = 20,
  }) : super(key: key);

  @override
  State<FloatingBubblesBackground> createState() => _FloatingBubblesBackgroundState();
}

class _FloatingBubblesBackgroundState extends State<FloatingBubblesBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Bubble> bubbles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _generateBubbles();
  }

  void _generateBubbles() {
    final random = math.Random();
    bubbles = List.generate(
      widget.bubbleCount,
      (index) => Bubble(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * 30 + 10,
        speed: random.nextDouble() * 0.1 + 0.05,
        opacity: random.nextDouble() * 0.2 + 0.1,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return CustomPaint(
              painter: BubblesPainter(
                bubbles: bubbles,
                color: widget.bubbleColor,
                animationValue: _controller.value,
              ),
            );
          },
        ),
        widget.child,
      ],
    );
  }
}

/// Bubble data
class Bubble {
  final double x;
  double y;
  final double size;
  final double speed;
  final double opacity;

  Bubble({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });

  void update(double animationValue) {
    y = (y - speed * animationValue) % 1.2;
    if (y < 0) y = 1.0 + y;
  }
}

/// Bubble painter
class BubblesPainter extends CustomPainter {
  final List<Bubble> bubbles;
  final Color color;
  final double animationValue;

  BubblesPainter({
    required this.bubbles,
    required this.color,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final bubble in bubbles) {
      bubble.update(animationValue);

      final paint = Paint()
        ..color = color.withOpacity(bubble.opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(bubble.x * size.width, bubble.y * size.height),
        bubble.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant BubblesPainter oldDelegate) => true;
}