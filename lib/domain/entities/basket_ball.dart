import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Basket topu entitesi
/// 
/// Bu sınıf, basketbol topunun fiziksel özelliklerini ve davranışlarını temsil eder.
class BasketBall {
  /// Topun X pozisyonu
  double x;
  
  /// Topun Y pozisyonu
  double y;
  
  /// Topun X yönündeki hızı
  double velocityX;
  
  /// Topun Y yönündeki hızı
  double velocityY;
  
  /// Topun yarıçapı
  final double radius;
  
  /// Topun aktif olup olmadığı
  bool isActive;
  
  /// Yerçekimi sabiti
  static const double gravity = 980.0; // Artırıldı
  
  /// Sürtünme katsayısı
  static const double friction = 0.02;
  
  /// Top için hava direnci katsayısı
  static const double airResistance = 0.005;
  
  /// Basket topunun oluşturucusu
  BasketBall({
    required this.x,
    required this.y,
    this.velocityX = 0,
    this.velocityY = 0,
    this.radius = 25,
    this.isActive = false,
  });
  
  /// Topun pozisyonunu Offset olarak döndürür
  Offset getPosition() {
    return Offset(x, y);
  }
  
  /// Topu belirtilen güç ve açı ile fırlatır
  void shoot(double power, double angle) {
    // Radyana çevir
    final radians = angle * (math.pi / 180);
    
    // Hızı hesapla (power 0-100 arası)
    velocityX = power * math.cos(radians);
    velocityY = -power * math.sin(radians); // Ekran koordinat sisteminde yukarı negatif
    
    isActive = true;
  }
  
  /// Topu belirtilen güçle başlangıç noktasından hedefe doğru fırlatır
  void shootToTarget(Offset startPosition, Offset targetPosition, double power) {
    final dx = targetPosition.dx - startPosition.dx;
    final dy = targetPosition.dy - startPosition.dy;
    
    // Mesafeyi hesapla
    final distance = math.sqrt(dx * dx + dy * dy);
    
    // Yön vektörünü normalize et
    final normalizedDx = dx / distance;
    final normalizedDy = dy / distance;
    
    // Hızı hesapla (power 0-100 arası)
    velocityX = normalizedDx * power * 10.0; // Faktör arttırıldı
    velocityY = normalizedDy * power * 10.0; // Faktör arttırıldı
    
    isActive = true;
    
    // Debug
    print('Top fırlatılıyor - Hız: ($velocityX, $velocityY), Güç: $power');
  }
  
  /// Topu verilen süre kadar simüle eder (fizik motoru)
  void update(double deltaTime, Size screenSize) {
    if (!isActive) return;
    
    // Yerçekimi etkisi
    velocityY += gravity * deltaTime;
    
    // Hava direnci
    velocityX *= (1 - airResistance);
    velocityY *= (1 - airResistance);
    
    // Pozisyonu güncelle
    x += velocityX * deltaTime;
    y += velocityY * deltaTime;
    
    // Ekran sınırları kontrolü
    _handleBoundaries(screenSize);
  }
  
  /// Ekran sınırları ile etkileşimi yönetir
  void _handleBoundaries(Size screenSize) {
    // Sağ ve sol duvarlar
    if (x - radius < 0) {
      x = radius;
      velocityX = -velocityX * 0.7; // Zıplama etkisi için enerji kaybı
    } else if (x + radius > screenSize.width) {
      x = screenSize.width - radius;
      velocityX = -velocityX * 0.7;
    }
    
    // Alt sınır (yere çarpma)
    if (y + radius > screenSize.height) {
      y = screenSize.height - radius;
      
      // Zıplama - enerji kaybı ile
      if (velocityY.abs() > 2.0) {
        velocityY = -velocityY * 0.6;
      } else {
        // Çok yavaşsa hareketi durdur
        velocityY = 0;
        // Sürtünme etkisi
        velocityX *= (1 - friction * 10);
        
        // Çok yavaşsa topu durdur
        if (velocityX.abs() < 0.5) {
          velocityX = 0;
        }
      }
    }
  }
  
  /// Topun çizimini gerçekleştirir
  void render(Canvas canvas) {
    // Top rengi ve gölgesi
    final Paint ballPaint = Paint()
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
    
    // Topu çiz
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
  }
  
  /// İki top arasındaki mesafeyi hesaplar
  double distanceTo(BasketBall other) {
    final dx = x - other.x;
    final dy = y - other.y;
    return math.sqrt(dx * dx + dy * dy);
  }
  
  /// Bir noktanın top içinde olup olmadığını kontrol eder
  bool containsPoint(Offset point) {
    final dx = x - point.dx;
    final dy = y - point.dy;
    final distance = math.sqrt(dx * dx + dy * dy);
    return distance <= radius;
  }
  
  /// Topu belirtilen pozisyona konumlandırır
  void reset(double newX, double newY) {
    x = newX;
    y = newY;
    velocityX = 0;
    velocityY = 0;
    isActive = false;
  }
}