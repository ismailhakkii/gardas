import 'package:flutter/material.dart';
import '../../domain/entities/basket_game_state.dart';

/// Basket oyununu çizen özel resim sınıfı
///
/// Tüm oyun elemanlarını (top, pota vb.) ve görsel efektleri çizer.
class BasketGamePainter extends CustomPainter {
  /// Oyun durumu
  final BasketGameState gameState;
  
  /// Hedef pozisyonu (atış çizgisi için)
  final Offset? targetPosition;
  
  /// Başlangıç pozisyonu
  final Offset? startPosition;
  
  /// Debug modunu göster
  final bool showDebug;
  
  /// FPS değeri
  final double fps;

  /// BasketGamePainter constructor'ı
  BasketGamePainter({
    required this.gameState,
    this.targetPosition,
    this.startPosition,
    this.showDebug = false,
    this.fps = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawBackground(canvas, size);
    
    // Potayı çiz
    gameState.basket.render(canvas);
    
    // Atış çizgisi
    if (gameState.isAiming && targetPosition != null) {
      gameState.renderAimingLine(canvas, targetPosition!);
    }
    
    // Topu çiz - ÖNEMLİ: gameState.ball.render() değil,
    // doğrudan topu çiziyoruz, çünkü ball.render() metodu
    // sadece top aktifse çizim yapıyor
    _drawBall(canvas, gameState.ball.x, gameState.ball.y, gameState.ball.radius);
    
    // Skor animasyonu (basket olduğunda)
    if (gameState.isScoringAnimation) {
      _drawScoringAnimation(canvas, size);
    }
    
    // Debug bilgileri
    if (showDebug) {
      _drawDebugInfo(canvas, size);
    }
  }
  
  /// Topu çizer
  void _drawBall(Canvas canvas, double x, double y, double radius) {
    // Top gölgesi
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    
    canvas.drawCircle(
      Offset(x, y + 5), // Gölge topun biraz altında
      radius * 0.9,
      shadowPaint,
    );
    
    // Top gövdesi
    final ballPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.orange[300]!,
          Colors.orange[700]!,
        ],
        stops: const [0.4, 1.0],
      ).createShader(Rect.fromCircle(
        center: Offset(x, y),
        radius: radius,
      ));
    
    canvas.drawCircle(Offset(x, y), radius, ballPaint);
    
    // Top çizgileri
    final linePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    
    // Yatay çizgi
    canvas.drawLine(
      Offset(x - radius * 0.7, y),
      Offset(x + radius * 0.7, y),
      linePaint,
    );
    
    // Dikey çizgi
    canvas.drawLine(
      Offset(x, y - radius * 0.7),
      Offset(x, y + radius * 0.7),
      linePaint,
    );
    
    // Top parlaklığı
    final highlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(
      Offset(x - radius * 0.3, y - radius * 0.3),
      radius * 0.3,
      highlightPaint,
    );
  }

  /// Arka planı çizer
  void _drawBackground(Canvas canvas, Size size) {
    // Gradient arka plan
    final Paint backgroundPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF2C3E50),  // Koyu mavi
          Color(0xFF4A6572),  // Orta gri-mavi
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      backgroundPaint,
    );
    
    // Basketbol sahası çizgileri
    final Paint linePaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    
    // Orta saha çizgisi
    canvas.drawLine(
      Offset(0, size.height * 0.5),
      Offset(size.width, size.height * 0.5),
      linePaint,
    );
    
    // Orta daire
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.5),
      size.width * 0.15,
      linePaint,
    );
    
    // Üç sayı çizgisi
    final threePtArc = Path()
      ..addArc(
        Rect.fromCenter(
          center: Offset(size.width * 0.5, size.height * 0.9),
          width: size.width * 0.8,
          height: size.width * 0.8,
        ),
        -3.14159, // pi
        -3.14159, // -pi
      );
    
    canvas.drawPath(threePtArc, linePaint);
    
    // Serbest atış çizgisi
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.3,
        size.height * 0.3,
        size.width * 0.4,
        size.height * 0.2,
      ),
      linePaint,
    );
    
    // Serbest atış yarım dairesi
    final ftArc = Path()
      ..addArc(
        Rect.fromCenter(
          center: Offset(size.width * 0.5, size.height * 0.5),
          width: size.width * 0.4,
          height: size.width * 0.4,
        ),
        3.14159, // pi
        -3.14159, // -pi
      );
    
    canvas.drawPath(ftArc, linePaint);
  }

  /// Basket skor animasyonunu çizer
  void _drawScoringAnimation(Canvas canvas, Size size) {
    final textStyle = TextStyle(
      color: Colors.orangeAccent.withOpacity(0.8),
      fontSize: 36,
      fontWeight: FontWeight.bold,
      shadows: [
        Shadow(
          blurRadius: 10,
          color: Colors.black.withOpacity(0.5),
          offset: const Offset(2, 2),
        ),
      ],
    );
    
    final textSpan = TextSpan(
      text: 'BASKET!',
      style: textStyle,
    );
    
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    
    textPainter.paint(
      canvas, 
      Offset(
        (size.width - textPainter.width) / 2,
        gameState.basket.y + 50,
      ),
    );
  }

  /// Debug bilgilerini çizer
  void _drawDebugInfo(Canvas canvas, Size size) {
    final textStyle = const TextStyle(
      color: Colors.white,
      fontSize: 12,
      fontWeight: FontWeight.bold,
    );
    
    final textSpan = TextSpan(
      text: 'FPS: ${fps.toStringAsFixed(1)}\n'
          'Velocity: (${gameState.ball.velocityX.toStringAsFixed(1)}, ${gameState.ball.velocityY.toStringAsFixed(1)})\n'
          'Ball active: ${gameState.ball.isActive}\n'
          'Ball pos: (${gameState.ball.x.toInt()}, ${gameState.ball.y.toInt()})',
      style: textStyle,
    );
    
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    
    // Arka plan kutusu çiz
    final bgRect = Rect.fromLTWH(
      10,
      10,
      textPainter.width + 20,
      textPainter.height + 10,
    );
    
    canvas.drawRect(
      bgRect,
      Paint()..color = Colors.black.withOpacity(0.7),
    );
    
    textPainter.paint(canvas, const Offset(20, 15));
  }

  @override
  bool shouldRepaint(covariant BasketGamePainter oldDelegate) {
    // Her zaman yeniden çiz (oyun mantığı sürekli güncelleniyor)
    return true;
  }
}