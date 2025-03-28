import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gardas/core/constants/app_colors.dart';
import 'package:gardas/core/widgets/custom_button.dart';
import 'package:gardas/features/math_puzzle/domain/entities/math_question.dart';
import 'package:gardas/features/math_puzzle/math_game_impl.dart';

/// Matematik oyun sayfası
class MathGamePage extends StatefulWidget {
  /// Oyun
  final MathGame game;
  
  /// Çıkış callback'i
  final VoidCallback onExit;
  
  /// Cevap seçildiğinde callback
  final Function(MathOption, double) onAnswerSelected;
  
  /// Oyun tamamlandığında callback
  final VoidCallback onGameComplete;

  const MathGamePage({
    Key? key,
    required this.game,
    required this.onExit,
    required this.onAnswerSelected,
    required this.onGameComplete,
  }) : super(key: key);

  @override
  State<MathGamePage> createState() => _MathGamePageState();
}

class _MathGamePageState extends State<MathGamePage> {
  /// Mevcut soru
  MathQuestion? _currentQuestion;
  
  /// Seçilen cevap
  MathOption? _selectedOption;
  
  /// Sorunun doğru cevabı
  int? _correctAnswer;
  
  /// Soru zamanı (saniye)
  int _timeLeft = 15;
  
  /// Timer
  Timer? _timer;
  
  /// Soru başlangıç zamanı
  DateTime? _questionStartTime;
  
  /// Yanıt verildi mi?
  bool _hasAnswered = false;

  @override
  void initState() {
    super.initState();
    _loadQuestion();
  }
  
  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }
  
  /// Soruyu yükler
  void _loadQuestion() {
    setState(() {
      _currentQuestion = widget.game.currentQuestion;
      _selectedOption = null;
      _correctAnswer = _currentQuestion?.correctAnswer;
      _timeLeft = 15;
      _hasAnswered = false;
    });
    
    _startTimer();
  }
  
  /// Timer'ı başlatır
  void _startTimer() {
    _cancelTimer();
    
    // Soru başlangıç zamanını kaydet
    _questionStartTime = DateTime.now();
    
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (mounted) {
          setState(() {
            if (_timeLeft > 0) {
              _timeLeft--;
            } else {
              _cancelTimer();
              _handleTimeout();
            }
          });
        }
      },
    );
  }
  
  /// Timer'ı iptal eder
  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }
  
  /// Süre dolduğunda çağrılır
  void _handleTimeout() {
    if (!_hasAnswered) {
      _hasAnswered = true;
      
      // Otomatik olarak yanlış cevap olarak işle
      if (_currentQuestion != null && _currentQuestion!.options.isNotEmpty) {
        // Rastgele bir yanlış cevap seç
        final wrongOptions = _currentQuestion!.options.where(
          (option) => option.value != _correctAnswer
        ).toList();
        
        final randomWrongOption = wrongOptions.isNotEmpty
            ? wrongOptions.first
            : _currentQuestion!.options.first;
            
        setState(() {
          _selectedOption = randomWrongOption;
        });
        
        // Cevabı işle
        widget.onAnswerSelected(randomWrongOption, 15.0);
      }
      
      // 2 saniye sonra bir sonraki soruya geç
      Future.delayed(const Duration(seconds: 2), _goToNextQuestion);
    }
  }
  
  /// Bir sonraki soruya geçer
  void _goToNextQuestion() {
    // Sonraki soru var mı kontrol et
    final hasNextQuestion = widget.game.nextQuestion();
    
    if (hasNextQuestion) {
      _loadQuestion();
    } else {
      widget.onGameComplete();
    }
  }
  
  /// Bir cevap seçildiğinde çağrılır
  void _handleOptionSelected(MathOption option) {
    if (_hasAnswered) return;
    
    _hasAnswered = true;
    _cancelTimer();
    
    // Geçen süreyi hesapla
    final timeSpent = _questionStartTime != null
        ? DateTime.now().difference(_questionStartTime!).inMilliseconds / 1000
        : 15.0;
        
    setState(() {
      _selectedOption = option;
    });
    
    // Cevabı işle
    widget.onAnswerSelected(option, timeSpent);
    
    // 2 saniye sonra bir sonraki soruya geç
    Future.delayed(const Duration(seconds: 2), _goToNextQuestion);
  }
  
  /// Oyunu duraklatır
  void _pauseGame() {
    _cancelTimer();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Oyun Duraklatıldı'),
        content: const Text('Devam etmek istiyor musunuz?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startTimer();
            },
            child: const Text('Devam Et'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onExit();
            },
            child: const Text('Çıkış'),
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
          title: const Text('Matematik Bulmaca'),
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
        body: _currentQuestion == null
            ? const Center(child: CircularProgressIndicator())
            : _buildGameContent(),
      ),
    );
  }
  
  Widget _buildGameContent() {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              // Oyun durum bilgisi
              _buildGameHeader(),
              
              // Soru ve cevap alanı
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Soru
                        _buildQuestionCard(),
                        
                        const SizedBox(height: 24),
                        
                        // Cevap seçenekleri
                        ..._buildOptions(),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Sonraki soru düğmesi (sadece cevap verilmişse)
              if (_hasAnswered)
                Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  child: CustomButton(
                    text: 'İleri',
                    icon: Icons.arrow_forward,
                    type: ButtonType.primary,
                    onPressed: _goToNextQuestion,
                    fullWidth: true,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
  
  Widget _buildGameHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Soru sayacı
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '${widget.game.currentQuestionIndex + 1}/${widget.game.questions.length}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Zamanlayıcı
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$_timeLeft',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.start,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: _timeLeft / 15,
                    backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _timeLeft > 10
                          ? AppColors.correctAnswerColor
                          : _timeLeft > 5
                              ? AppColors.neutralColor
                              : AppColors.wrongAnswerColor,
                    ),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 8),
          
          // Skor
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Puan',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '${widget.game.totalScore}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildQuestionCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              'Soruyu Çöz',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Text(
              _currentQuestion?.questionText ?? '',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Doğru cevabı seç',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
  
  List<Widget> _buildOptions() {
    final options = _currentQuestion?.options ?? [];
    
    return options.map((option) {
      // Cevap verildiyse renk belirle
      Color? buttonColor;
      Color? textColor;
      
      if (_selectedOption != null) {
        if (option.value == _correctAnswer) {
          // Doğru cevap
          buttonColor = AppColors.correctAnswerColor;
          textColor = Colors.white;
        } else if (option.value == _selectedOption?.value) {
          // Kullanıcının seçtiği yanlış cevap
          buttonColor = AppColors.wrongAnswerColor;
          textColor = Colors.white;
        }
      }
      
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _hasAnswered ? null : () => _handleOptionSelected(option),
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              foregroundColor: textColor,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              disabledBackgroundColor: buttonColor,
              disabledForegroundColor: textColor,
            ),
            child: Text(
              option.text,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ),
      );
    }).toList();
  }
}