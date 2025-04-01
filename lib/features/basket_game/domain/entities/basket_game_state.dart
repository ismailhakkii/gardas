import 'package:flutter/material.dart';
import '../../../../domain/entities/basket_ball.dart';
import '../../../../domain/entities/basket.dart';
import '../../../../domain/entities/score.dart';
import '../../../../domain/entities/game.dart';
import 'dart:math' as math;

/// Basket oyunu durumu
///
/// Oyunun tüm durumunu ve mantığını içerir
class BasketGameState {
  /// Basket topu
  final BasketBall ball;
  
  /// Basket potası
  final Basket basket;
  
  /// Oyunun başlangıç zamanı
  final DateTime startTime;
  
  /// Oyunun bitiş zamanı (oyun bittiğinde doldurulur)
  DateTime? endTime;
  
  /// Oyun süresi (saniye)
  final int gameDuration;
  
  /// Toplam skor
  int value;
  
  /// Art arda atılan basket sayısı
  int streak;
  
  /// Atış sayısı
  int shots;
  
  /// Başarılı atış sayısı
  int successfulShots;
  
  /// Başlangıç pozisyonu (topun başladığı yer)
  final Offset initialPosition;
  
  /// Oyunun aktif olup olmadığı
  bool isActive;
  
  /// Topun atış modunda olup olmadığı
  bool isAiming;
  
  /// Topun potaya girip girmediği
  bool isScoringAnimation;
  
  /// Skora eklenecek baz puan
  static const int basePoints = 100;
  
  /// Zorluk seviyesi
  final GameDifficulty difficulty;

  /// Oyun durumunun constructor'ı
  BasketGameState({
    required Size screenSize,
    required this.difficulty,
    this.gameDuration = 60, // Varsayılan 60 saniye
    this.value = 0,
    this.streak = 0,
    this.shots = 0,
    this.successfulShots = 0,
    this.isActive = true,
    this.isAiming = false,
    this.isScoringAnimation = false,
    Offset? initialPos,
  }) : 
    startTime = DateTime.now(),
    initialPosition = initialPos ?? Offset(
      screenSize.width / 2, 
      screenSize.height * 0.85
    ),
    ball = BasketBall(
      x: initialPos?.dx ?? screenSize.width / 2, 
      y: initialPos?.dy ?? screenSize.height * 0.85
    ),
    basket = Basket(
      x: screenSize.width / 2, 
      y: screenSize.height * 0.35
    );
  
  /// Oyun ekranını başlatır
  void initializeGame(Size screenSize) {
    // Potayı ekranda konumlandır
    basket.positionOnScreen(screenSize, heightFactor: _getBasketHeightFactor());
    
    // Topu başlangıç pozisyonuna getir
    ball.reset(initialPosition.dx, initialPosition.dy);
    
    // Top aktif olmasın ki oyuncu atış yapabilsin
    ball.isActive = false;
    
    isActive = true;
    isAiming = false;
    
    print('BasketGameState.initializeGame - Top pozisyonu: (${ball.x}, ${ball.y})');
    print('BasketGameState.initializeGame - Top aktif mi: ${ball.isActive}');
  }
  
  /// Zorluğa göre potanın konumunu ayarlar
  double _getBasketHeightFactor() {
    switch (difficulty) {
      case GameDifficulty.easy:
        return 0.4; // Daha alçak (kolay)
      case GameDifficulty.medium:
        return 0.35; // Orta seviye
      case GameDifficulty.hard:
        return 0.25; // Daha yüksek (zor)
    }
  }
  
  /// Oyun mantığını günceller
  void update(double deltaTime, Size screenSize) {
    if (!isActive) return;
    
    // Top aktifse fizik güncellemeleri
    if (ball.isActive && !isAiming) {
      ball.update(deltaTime, screenSize);
      
      // Çarpışma kontrolleri
      final backboardCollision = basket.handleBackboardCollision(ball);
      final rimCollision = basket.handleRimCollision(ball);
      
      // Basket kontrolü
      if (!isScoringAnimation && basket.checkScore(ball)) {
        onScore();
      }
    }
  }
  
  /// Atış başlat (kullanıcı topu seçtiğinde)
  void startAiming() {
    if (!ball.isActive && isActive) {
      isAiming = true;
      print('Hedefleme başladı');
    }
  }
  
  /// Atış yap (kullanıcı parmağını çektiğinde)
  void shoot(Offset startPosition, Offset targetPosition, double power) {
    if (isAiming && isActive) {
      // Atış sayısını artır
      shots++;
      
      // Atış gücünü zorluğa göre ayarla
      final adjustedPower = _adjustPowerByDifficulty(power);
      
      // Topu fırlat - ÖNEMLİ: Tersine çevriliyor (kullanıcının çektiği yönün tersine)
      ball.shootToTarget(startPosition, targetPosition, adjustedPower);
      
      isAiming = false;
      print('Atış yapıldı - Hedef: $targetPosition, Güç: $adjustedPower');
    }
  }
  
  /// Zorluğa göre atış gücünü ayarlar
  double _adjustPowerByDifficulty(double power) {
    switch (difficulty) {
      case GameDifficulty.easy:
        return power * 1.2; // Daha güçlü (kolay)
      case GameDifficulty.medium:
        return power; // Normal güç
      case GameDifficulty.hard:
        return power * 0.8; // Daha az güç (zor)
    }
  }
  
  /// Basket olduğunda skor artışı
  void onScore() {
    // Skor artışını hesapla
    final int bonusPoints = (streak * 10); // Her ardışık basket için 10 bonus puan
    final int distanceBonus = _calculateDistanceBonus();
    final int points = basePoints + bonusPoints + distanceBonus;
    
    // Değerleri güncelle
    value += points;
    streak++;
    successfulShots++;
    
    // Basket animasyonu
    isScoringAnimation = true;
    
    // 1 saniye sonra topu sıfırla
    Future.delayed(const Duration(seconds: 1), () {
      if (!isActive) return; // Eğer oyun bitmişse işlemi iptal et
      ball.reset(initialPosition.dx, initialPosition.dy);
      isScoringAnimation = false;
    });
  }
  
  /// Mesafeye göre bonus puan hesaplar
  int _calculateDistanceBonus() {
    // Topun atış noktası ile pota arasındaki mesafeyi hesapla
    final double dx = basket.x - initialPosition.dx;
    final double dy = basket.y - initialPosition.dy;
    final double distance = math.sqrt(dx * dx + dy * dy) / 10.0;
    
    // Mesafeye göre bonus puan (maksimum 50 puan)
    return (distance * 5).clamp(0, 50).toInt();
  }
  
  /// Top yere düştüğünde sıfırla
  void resetBallIfNeeded(Size screenSize) {
    // Top yere düştü ve durdu mu?
    if (ball.isActive && 
        ball.y >= screenSize.height - ball.radius && 
        ball.velocityY.abs() < 0.5 &&
        ball.velocityX.abs() < 0.5) {
      
      // Streak'i sıfırla (başarısız atış)
      streak = 0;
      
      // Topu sıfırla
      ball.reset(initialPosition.dx, initialPosition.dy);
      
      // Top aktif olmasın ki oyuncu tekrar atış yapabilsin
      ball.isActive = false;
      print('Top yere düştü ve sıfırlandı');
    }
  }
  
  /// Atış çizgisini çizer
  void renderAimingLine(Canvas canvas, Offset targetPosition) {
    if (!isAiming) return;
    
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
      
    // Yörünge çizgisini çiz
    final path = Path();
    path.moveTo(initialPosition.dx, initialPosition.dy);
    
    // Hedef noktasına doğru eğri
    final controlPoint = Offset(
      (initialPosition.dx + targetPosition.dx) / 2,
      (initialPosition.dy + targetPosition.dy) / 2 - 100
    );
    
    path.quadraticBezierTo(
      controlPoint.dx,
      controlPoint.dy,
      targetPosition.dx,
      targetPosition.dy
    );
    
    // Kesikli çizgi efekti
    final dashPath = Path();
    final dashWidth = 8.0;
    final dashSpace = 4.0;
    
    final distance = _distanceBetween(initialPosition, targetPosition, controlPoint);
    final dashCount = (distance / (dashWidth + dashSpace)).floor();
    
    for (var i = 0; i < dashCount; i++) {
      final start = i * (dashWidth + dashSpace) / distance;
      final end = (i * (dashWidth + dashSpace) + dashWidth) / distance;
      
      final startPoint = _getPointOnQuadraticBezier(
        start, initialPosition, controlPoint, targetPosition);
      final endPoint = _getPointOnQuadraticBezier(
        end, initialPosition, controlPoint, targetPosition);
      
      dashPath.moveTo(startPoint.dx, startPoint.dy);
      dashPath.lineTo(endPoint.dx, endPoint.dy);
    }
    
    canvas.drawPath(dashPath, linePaint);
    
    // Hedef noktasını göster
    final targetPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
      
    canvas.drawCircle(targetPosition, 8, targetPaint);
    
    // Ok başını çiz (atış yönünü gösterir)
    final arrowPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
      
    // Ok başı hesapla
    final dx = initialPosition.dx - targetPosition.dx;
    final dy = initialPosition.dy - targetPosition.dy;
    final angle = math.atan2(dy, dx);
    
    final arrowSize = 12.0;
    final arrowPoint1 = Offset(
      targetPosition.dx + arrowSize * math.cos(angle - 0.3),
      targetPosition.dy + arrowSize * math.sin(angle - 0.3)
    );
    final arrowPoint2 = Offset(
      targetPosition.dx + arrowSize * math.cos(angle + 0.3),
      targetPosition.dy + arrowSize * math.sin(angle + 0.3)
    );
    
    final arrowPath = Path()
      ..moveTo(targetPosition.dx, targetPosition.dy)
      ..lineTo(arrowPoint1.dx, arrowPoint1.dy)
      ..lineTo(arrowPoint2.dx, arrowPoint2.dy)
      ..close();
      
    canvas.drawPath(arrowPath, arrowPaint);
  }
  
  /// İki nokta arasındaki mesafeyi hesaplar
  double _distanceBetween(Offset p1, Offset p2, Offset controlPoint) {
    // Bezier eğrisi uzunluğunu tahmin etmek için basitleştirilmiş hesaplama
    final d1 = (p1 - controlPoint).distance;
    final d2 = (controlPoint - p2).distance;
    return d1 + d2;
  }
  
  /// Bezier eğrisi üzerindeki belirli bir noktayı hesaplar
  Offset _getPointOnQuadraticBezier(
      double t, Offset start, Offset control, Offset end) {
    final x = _quadraticBezier(t, start.dx, control.dx, end.dx);
    final y = _quadraticBezier(t, start.dy, control.dy, end.dy);
    return Offset(x, y);
  }
  
  /// Kuadratik bezier denklemi
  double _quadraticBezier(double t, double p0, double p1, double p2) {
    return (1 - t) * (1 - t) * p0 + 2 * (1 - t) * t * p1 + t * t * p2;
  }
  
  /// Oyunu bitirir
  void endGame() {
    if (isActive) {
      isActive = false;
      endTime = DateTime.now();
    }
  }
  
  /// Oyunu sıfırlar
  void resetGame(Size screenSize) {
    value = 0;
    streak = 0;
    shots = 0;
    successfulShots = 0;
    isActive = true;
    isAiming = false;
    isScoringAnimation = false;
    
    initializeGame(screenSize);
    
    // Yeni başlangıç zamanı
    endTime = null;
  }
  
  /// Oyunun kalan süresini döndürür
  int getRemainingSeconds() {
    if (!isActive && endTime != null) {
      return 0;
    }
    
    final elapsedSeconds = DateTime.now().difference(startTime).inSeconds;
    return (gameDuration - elapsedSeconds).clamp(0, gameDuration);
  }
  
  /// Atış isabetini yüzde olarak döndürür
  double getAccuracy() {
    if (shots == 0) return 0;
    return (successfulShots / shots) * 100;
  }
  
  /// Oyun skorunu döndürür
  Score getGameScore() {
    // Gerçek Score sınıfına uygun şekilde dönüştürme
    return Score(
      id: 'basket_${DateTime.now().millisecondsSinceEpoch}',
      gameId: 'basket_game',
      userId: 'user_1', // Varsayılan kullanıcı ID
      value: value,
      difficulty: difficulty,
      date: DateTime.now(),
      metadata: {
        'shots': shots,
        'successfulShots': successfulShots,
        'accuracy': getAccuracy(),
        'streak': streak,
      },
    );
  }
}