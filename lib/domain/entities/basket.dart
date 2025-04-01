import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'basket_ball.dart';

/// Basket potası entitesi
///
/// Bu sınıf, basketbol potasının özelliklerini ve davranışlarını temsil eder.
class Basket {
  /// Potanın merkez X konumu
  double x;
  
  /// Potanın merkez Y konumu
  double y;

  
  /// Çemberin yarıçapı
  final double rimRadius;
  
  /// Çember genişliği
  final double rimThickness;
  
  /// Pota tahtasının genişliği
  final double backboardWidth;
  
  /// Pota tahtasının yüksekliği
  final double backboardHeight;
  
  /// Potaya topun girmesi için gereken minimum y değeri
  double get topScoreY => y - rimThickness / 2;
  
  /// Potaya topun girmesi için gereken maksimum y değeri
  double get bottomScoreY => y + rimThickness / 2;
  
  /// Sol skor sınırı
  double get leftScoreX => x - rimRadius;
  
  /// Sağ skor sınırı
  double get rightScoreX => x + rimRadius;
  
  /// Pota tahtasının sol kenarı
  double get backboardLeft => x - backboardWidth / 2;
  
  /// Pota tahtasının sağ kenarı
  double get backboardRight => x + backboardWidth / 2;
  
  /// Pota tahtasının üst kenarı
  double get backboardTop => y - backboardHeight / 2 - rimRadius * 1.2;
  
  /// Pota tahtasının alt kenarı
  double get backboardBottom => y - backboardHeight / 2 + rimRadius * 0.8;
  
  /// Basket potasının constructor'ı
  Basket({
    required this.x,
    required this.y,
    this.rimRadius = 40,
    this.rimThickness = 8,
    this.backboardWidth = 150,
    this.backboardHeight = 100,
  });
  
  /// Topun potaya girip girmediğini kontrol eder
  bool checkScore(BasketBall ball) {
    // Topun merkezi potanın içinde mi?
    final bool isWithinRim = 
        ball.x > leftScoreX && 
        ball.x < rightScoreX && 
        ball.y > topScoreY && 
        ball.y < bottomScoreY;
    
    // Topun hızı yeterince düşük mü (doğal düşüş için)
    final bool isMovingSlow = ball.velocityY > 0 && ball.velocityY < 200;
    
    return isWithinRim && isMovingSlow;
  }
  
  /// Topun pota tahtasına çarpıp çarpmadığını kontrol eder ve fiziksel tepkiyi uygular
  bool handleBackboardCollision(BasketBall ball) {
    // Topun pota tahtasına çarpıp çarpmadığını kontrol et
    if (ball.x + ball.radius > backboardLeft && 
        ball.x - ball.radius < backboardRight && 
        ball.y + ball.radius > backboardTop && 
        ball.y - ball.radius < backboardBottom) {
      
      // Topun merkezi tahtanın içindeyse
      if (ball.x > backboardLeft && ball.x < backboardRight && 
          ball.y > backboardTop && ball.y < backboardBottom) {
          
        // Hangi kenardan çarptığını belirle
        final distLeft = ball.x - backboardLeft;
        final distRight = backboardRight - ball.x;
        final distTop = ball.y - backboardTop;
        final distBottom = backboardBottom - ball.y;
        
        // En yakın kenarı bul
        final minDist = math.min(math.min(distLeft, distRight), math.min(distTop, distBottom));
        
        if (minDist == distLeft) {
          // Sol kenardan çarptı
          ball.x = backboardLeft - ball.radius;
          ball.velocityX *= -0.7; // Zıplama katsayısı
        } else if (minDist == distRight) {
          // Sağ kenardan çarptı
          ball.x = backboardRight + ball.radius;
          ball.velocityX *= -0.7;
        } else if (minDist == distTop) {
          // Üst kenardan çarptı
          ball.y = backboardTop - ball.radius;
          ball.velocityY *= -0.7;
        } else if (minDist == distBottom) {
          // Alt kenardan çarptı
          ball.y = backboardBottom + ball.radius;
          ball.velocityY *= -0.7;
        }
        
        return true;
      }
    }
    
    return false;
  }
  
  /// Topun çembere çarpıp çarpmadığını kontrol eder ve fiziksel tepkiyi uygular
  bool handleRimCollision(BasketBall ball) {
    // Sol çember kenarı
    final Offset leftRimPoint = Offset(leftScoreX, y);
    final double leftRimDistance = _distance(Offset(ball.x, ball.y), leftRimPoint);
    
    // Sağ çember kenarı
    final Offset rightRimPoint = Offset(rightScoreX, y);
    final double rightRimDistance = _distance(Offset(ball.x, ball.y), rightRimPoint);
    
    // Çember kenarlarına çarpma kontrolü
    if (leftRimDistance < ball.radius + rimThickness/2) {
      _resolveRimCollision(ball, leftRimPoint);
      return true;
    }
    
    if (rightRimDistance < ball.radius + rimThickness/2) {
      _resolveRimCollision(ball, rightRimPoint);
      return true;
    }
    
    return false;
  }
  
  /// Çember çarpışmasını çözer
  void _resolveRimCollision(BasketBall ball, Offset rimPoint) {
    // Çarpışma yönünü hesapla
    final dx = ball.x - rimPoint.dx;
    final dy = ball.y - rimPoint.dy;
    final distance = math.sqrt(dx * dx + dy * dy);
    
    // Normal vektörü
    final nx = dx / distance;
    final ny = dy / distance;
    
    // Hız vektörünün normal vektör üzerindeki izdüşümü
    final dotProduct = ball.velocityX * nx + ball.velocityY * ny;
    
    // Yeni hızı hesapla
    ball.velocityX = ball.velocityX - 2 * dotProduct * nx * 0.7; // 0.7 zıplama katsayısı
    ball.velocityY = ball.velocityY - 2 * dotProduct * ny * 0.7;
    
    // Topu çember dışına çıkar
    final overlap = (ball.radius + rimThickness/2) - distance;
    ball.x += nx * overlap;
    ball.y += ny * overlap;
  }
  
  /// İki nokta arasındaki mesafeyi hesaplar
  double _distance(Offset p1, Offset p2) {
    final dx = p1.dx - p2.dx;
    final dy = p1.dy - p2.dy;
    return math.sqrt(dx * dx + dy * dy);
  }
  
  /// Potayı çizer
  void render(Canvas canvas) {
    // Pota tahtası
    final backboardPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.fill;
    
    final backboardRect = Rect.fromLTWH(
      backboardLeft,
      backboardTop,
      backboardWidth,
      backboardHeight
    );
    
    canvas.drawRect(backboardRect, backboardPaint);
    
    // Tahta çerçevesi
    final borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    
    canvas.drawRect(backboardRect, borderPaint);
    
    // Hedef kutusu
    final targetBox = Rect.fromLTWH(
      x - rimRadius * 0.8,
      backboardTop + backboardHeight * 0.3,
      rimRadius * 1.6,
      rimRadius * 0.8
    );
    
    canvas.drawRect(targetBox, borderPaint);
    
    // Basket çemberi
    final rimPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = rimThickness;
    
    canvas.drawArc(
      Rect.fromCircle(center: Offset(x, y), radius: rimRadius),
      0,
      math.pi,
      false,
      rimPaint
    );
    
    // Filenin temsili çizimi
    final netPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    
    // Basit file çizgileri
    for (int i = -5; i <= 5; i++) {
      final startX = x + i * (rimRadius / 5);
      canvas.drawLine(
        Offset(startX, y),
        Offset(startX + (i.abs() / 5) * 5, y + rimRadius),
        netPaint
      );
    }
    
    // Yatay file çizgileri
    for (int i = 0; i < 4; i++) {
      final yPos = y + (i + 1) * (rimRadius / 4);
      final width = rimRadius * (1 - (i + 1) / 4);
      canvas.drawLine(
        Offset(x - width, yPos),
        Offset(x + width, yPos),
        netPaint
      );
    }
  }
  
  /// Potayı ekranda uygun bir konuma yerleştirir
  void positionOnScreen(Size screenSize, {double heightFactor = 0.35}) {
    x = screenSize.width * 0.5;
    y = screenSize.height * heightFactor;
  }
}