import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import '../../../../domain/entities/game.dart';
import '../../../../domain/entities/score.dart';
import '../../domain/entities/basket_game_state.dart';
import '../widgets/basket_game_hud.dart';
import '../widgets/basket_game_painter.dart';
import '../widgets/basket_game_over_screen.dart';

/// Basket oyunu sayfası
///
/// Oyunun ana arayüzünü ve oyun döngüsünü yönetir
class BasketGamePage extends StatefulWidget {
  /// Oyun zorluğu
  final GameDifficulty difficulty;
  
  /// Skor güncellendiğinde çağrılacak fonksiyon
  final Function(Score) onScoreUpdated;
  
  /// Oyun bittiğinde çağrılacak fonksiyon
  final VoidCallback onGameOver;

  const BasketGamePage({
    Key? key,
    required this.difficulty,
    required this.onScoreUpdated,
    required this.onGameOver,
  }) : super(key: key);

  @override
  BasketGamePageState createState() => BasketGamePageState();
}

class BasketGamePageState extends State<BasketGamePage> with TickerProviderStateMixin {
  /// Oyun durumu
  BasketGameState? _gameState; // Null olabilir olarak işaretleyelim ve başlatmayalım
  
  /// Oyun zamanlayıcısı
  Timer? _gameTimer;
  
  /// Oyun döngüsü zamanlayıcısı
  late AnimationController _gameLoopController;
  
  /// Paused durumu
  bool _isPaused = false;
  
  /// Oyun bitmiş mi?
  bool _isGameOver = false;
  
  /// Hedef pozisyonu (atış için)
  Offset? _targetPosition;
  
  /// Başlangıç dokunma pozisyonu
  Offset? _startTouchPosition;
  
  /// Ekran boyutu
  late Size _screenSize;
  
  /// FPS sayacı için
  int _frameCount = 0;
  DateTime _lastFpsUpdate = DateTime.now();
  double _fps = 0;
  
  /// Oyun başladı mı
  bool _gameStarted = false;
  
  /// Top kayboldu mu
  bool _ballLost = false;
  
  /// Top kaybolma sayacı
  int _lostBallCounter = 0;

  @override
  void initState() {
    super.initState();
    
    // Oyun döngüsünü başlat (60 FPS)
    _gameLoopController = AnimationController(
      vsync: this,
      duration: const Duration(days: 1), // Sürekli çalışması için uzun süre
    )..addListener(_gameLoop);
    
    // Ekran boyutunu almak için sonraki karede oyunu başlat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _screenSize = MediaQuery.of(context).size;
        
        // _gameState'i doğrudan burada başlatalım
        _gameState = BasketGameState(
          screenSize: _screenSize,
          difficulty: widget.difficulty,
          gameDuration: _getDurationByDifficulty(),
        );
        
        // Oyunu başlat
        _gameState!.initializeGame(_screenSize);
        
        // Oyun döngüsünü başlat (topun görünmesi için)
        _gameLoopController.repeat();
      });
    });
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    _gameLoopController.dispose();
    super.dispose();
  }

  /// Oyunu başlatır
  void startGame() {
    // _gameState null ise henüz başlatılmamış olabilir
    if (_gameState == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) startGame();
      });
      return;
    }
    
    if (_isPaused) {
      resumeGame();
      return;
    }
    
    setState(() {
      _isGameOver = false;
      _isPaused = false;
      _gameStarted = true; // Oyun başladı
      _ballLost = false;
      _lostBallCounter = 0;
      
      // Yeni bir BasketGameState oluştur (startTime şu anki zamanı alacak)
      _gameState = BasketGameState(
        screenSize: _screenSize,
        difficulty: widget.difficulty,
        gameDuration: _getDurationByDifficulty(),
      );
      
      _gameState!.initializeGame(_screenSize);
    });
    
    _startGameLoop();
    _startGameTimer();
  }

  /// Oyunu duraklatır
  void pauseGame() {
    if (_isPaused) return;
    
    setState(() {
      _isPaused = true;
    });
    
    _gameLoopController.stop();
    _gameTimer?.cancel();
  }

  /// Duraklatılmış oyunu devam ettirir
  void resumeGame() {
    if (!_isPaused) return;
    
    setState(() {
      _isPaused = false;
    });
    
    _startGameLoop();
    _startGameTimer();
  }
  
  /// Oyunu bitirir
  void endGame() {
    if (_isGameOver || _gameState == null) return;
    
    _gameState!.endGame();
    _gameLoopController.stop();
    _gameTimer?.cancel();
    
    setState(() {
      _isGameOver = true;
      _gameStarted = false;
    });
    
    // Score'u bildir
    final score = _gameState!.getGameScore();
    widget.onScoreUpdated(score);
    widget.onGameOver();
  }

  /// Oyunu sıfırlar
  void resetGame() {
    _gameTimer?.cancel();
    
    // _gameState null ise işlemi ertele
    if (_gameState == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) resetGame();
      });
      return;
    }
    
    setState(() {
      // Yeni bir BasketGameState oluştur (startTime şu anki zamanı alacak)
      _gameState = BasketGameState(
        screenSize: _screenSize,
        difficulty: widget.difficulty,
        gameDuration: _getDurationByDifficulty(),
      );
      
      _gameState!.initializeGame(_screenSize);
      _isGameOver = false;
      _isPaused = false;
      _gameStarted = true;
      _ballLost = false;
      _lostBallCounter = 0;
    });
    
    _startGameLoop();
    _startGameTimer();
  }
  
  /// Yeni bir top verir
  void getNewBall() {
    if (_gameState == null) return;
    
    setState(() {
      _ballLost = false;
      _gameState!.ball.reset(_screenSize.width / 2, _screenSize.height * 0.85);
      _gameState!.ball.isActive = false;
    });
  }

  /// Zorluğa göre oyun süresini belirler
  int _getDurationByDifficulty() {
    switch (widget.difficulty) {
      case GameDifficulty.easy:
        return 90; // 1.5 dakika
      case GameDifficulty.medium:
        return 60; // 1 dakika
      case GameDifficulty.hard:
        return 45; // 45 saniye
    }
  }
  
  /// Oyun döngüsünü başlatır
  void _startGameLoop() {
    if (!_gameLoopController.isAnimating) {
      _gameLoopController.repeat();
    }
  }
  
  /// Süre sayacını başlatır
  void _startGameTimer() {
    _gameTimer?.cancel();
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // _gameState null ise zamanlayıcıyı iptal et
      if (_gameState == null) {
        timer.cancel();
        return;
      }
      
      if (_gameStarted && _gameState!.getRemainingSeconds() <= 0) {
        endGame();
        timer.cancel();
      } else {
        // Her saniye state'i güncelleyelim
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  /// Ana oyun döngüsü
  void _gameLoop() {
    if (_isPaused || _isGameOver || _gameState == null) return;
    
    // FPS hesaplama
    _frameCount++;
    final now = DateTime.now();
    final elapsed = now.difference(_lastFpsUpdate).inMilliseconds;
    
    if (elapsed > 1000) { // Her saniyede bir FPS güncelle
      _fps = _frameCount * 1000 / elapsed;
      _frameCount = 0;
      _lastFpsUpdate = now;
    }
    
    // İki kare arasındaki delta zamanı hesapla (saniye)
    final deltaTime = 1 / 60; // 60 FPS hedefi
    
    // Oyun başladıysa oyun mantığını güncelle
    if (_gameStarted) {
      _gameState!.update(deltaTime, _screenSize);
      
      // Topun kaybolup kaybolmadığını kontrol et
      if (_gameState!.ball.y > _screenSize.height + 100 || 
          _gameState!.ball.x < -100 || 
          _gameState!.ball.x > _screenSize.width + 100) {
        
        if (!_ballLost) {
          _ballLost = true;
          _lostBallCounter++;
          
          // 2 saniye sonra yeni top ver
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted && _gameStarted && !_isGameOver) {
              getNewBall();
            }
          });
        }
      }
      
      // Topu sıfırla (eğer gerekiyorsa)
      if (!_ballLost) {
        _gameState!.resetBallIfNeeded(_screenSize);
      }
    }
    
    // Ekranı güncelle
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // _gameState null ise yükleniyor ekranı göster
    if (_gameState == null) {
      return Scaffold(
        backgroundColor: Colors.black87,
        body: const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      );
    }
    
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Stack(
          children: [
            // Oyun alanı
            GestureDetector(
              onPanStart: _onPanStart,
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              child: CustomPaint(
                painter: BasketGamePainter(
                  gameState: _gameState!,
                  targetPosition: _targetPosition,
                  startPosition: _startTouchPosition,
                  showDebug: false, // Debug modunu kapatıyoruz, gerçek oyunda gerekmez
                  fps: _fps,
                ),
                size: Size.infinite,
              ),
            ),
            
            // Oyun HUD (arayüz elemanları)
            BasketGameHUD(
              gameState: _gameState!,
              onPause: pauseGame,
              onResume: resumeGame,
              isPaused: _isPaused,
            ),
            
            // Top kaybolduğunda bilgilendirme ve yeniden top alma butonu
            if (_ballLost && _gameStarted && !_isGameOver)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Top kayboldu!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.8),
                            blurRadius: 5,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: getNewBall,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'Yeni Top Al',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            
            // Başlangıç ekranı
            if (!_gameStarted && !_isGameOver)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Basket Atışı',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.8),
                            blurRadius: 5,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Doğru açıyı ve gücü ayarlayarak topu potaya at!',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.8),
                            blurRadius: 5,
                            offset: const Offset(1, 1),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: startGame,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                      ),
                      child: const Text(
                        'BAŞLA',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            
            // Yeniden başlatma butonu (sağ üst köşe)
            if (_gameStarted && !_isGameOver)
              Positioned(
                top: 16,
                right: 16,
                child: FloatingActionButton(
                  mini: true,
                  onPressed: resetGame,
                  backgroundColor: Colors.red.withOpacity(0.8),
                  child: const Icon(
                    Icons.refresh,
                    color: Colors.white,
                  ),
                ),
              ),
            
            // Oyun sonu ekranı
            if (_isGameOver)
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Oyun Bitti!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Skor: ${_gameState!.getGameScore().value}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'İsabet: ${_gameState!.getAccuracy().toStringAsFixed(1)}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Kayıp Top: $_lostBallCounter',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: resetGame,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Tekrar Oyna'),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Çıkış'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Kullanıcı dokunmaya başladığında
  void _onPanStart(DragStartDetails details) {
    // _gameState null ise işlem yapma
    if (_gameState == null || !_gameStarted || _ballLost) return;
    
    // Eğer oyun durmuşsa veya top aktifse işlem yapma
    if (_isPaused || _isGameOver || _gameState!.ball.isActive) return;
    
    // Parmak topa değdi mi kontrol et
    final touchPosition = details.localPosition;
    if (_gameState!.ball.containsPoint(touchPosition)) {
      setState(() {
        _gameState!.startAiming();
        _startTouchPosition = _gameState!.ball.getPosition(); // Topun gerçek pozisyonunu al
        _targetPosition = touchPosition;
        print('Dokunma başladı: $_startTouchPosition -> $_targetPosition');
      });
    }
  }

  /// Kullanıcı parmağını sürüklediğinde
  void _onPanUpdate(DragUpdateDetails details) {
    // _gameState null ise işlem yapma
    if (_gameState == null || !_gameStarted || _ballLost) return;
    
    // Eğer hedefleme modunda değilse çık
    if (!_gameState!.isAiming) return;
    
    setState(() {
      _targetPosition = details.localPosition;
      print('Sürükleme: $_targetPosition');
    });
  }

  /// Kullanıcı parmağını çektiğinde
  void _onPanEnd(DragEndDetails details) {
    // _gameState null ise işlem yapma
    if (_gameState == null || !_gameStarted || _ballLost) return;
    
    // Eğer hedefleme modunda değilse çık
    if (!_gameState!.isAiming || _targetPosition == null || _startTouchPosition == null) return;
    
    // Atış gücünü hesapla (hedef ile başlangıç arasındaki mesafeye göre)
    final dx = _startTouchPosition!.dx - _targetPosition!.dx;
    final dy = _startTouchPosition!.dy - _targetPosition!.dy;
    final distance = math.sqrt(dx * dx + dy * dy);
    
    // Maksimum güç için 200 piksel mesafe
    final power = (distance / 200).clamp(0.2, 1.0) * 100;
    
    print('Atış yapılıyor: $_startTouchPosition -> $_targetPosition, Güç: $power');
    
    // Burada atış yönünü belirleyelim - toptan sürükleme yönünün tersi yönde
    final shootDir = Offset(
      _targetPosition!.dx + (_startTouchPosition!.dx - _targetPosition!.dx) * 2,
      _targetPosition!.dy + (_startTouchPosition!.dy - _targetPosition!.dy) * 2,
    );
    
    // Atış yap 
    _gameState!.shoot(_startTouchPosition!, shootDir, power);
    
    setState(() {
      _targetPosition = null;
      _startTouchPosition = null;
    });
  }
}