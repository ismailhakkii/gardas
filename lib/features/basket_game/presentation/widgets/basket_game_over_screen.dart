import 'package:flutter/material.dart';
import '../../../../domain/entities/score.dart';
import '../../../../domain/entities/game.dart';

/// Basket oyunu bittiğinde gösterilen ekran
///
/// Oyun sonuçlarını, skorları ve oyun sonu seçeneklerini gösterir
class BasketGameOverScreen extends StatelessWidget {
  /// Oyun skoru
  final Score score;
  
  /// Tekrar oyna butonuna tıklandığında çağrılan fonksiyon
  final VoidCallback onPlayAgain;
  
  /// Çıkış butonuna tıklandığında çağrılan fonksiyon
  final VoidCallback onExit;

  const BasketGameOverScreen({
    Key? key,
    required this.score,
    required this.onPlayAgain,
    required this.onExit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Başlık
                const Text(
                  'OYUN BİTTİ',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Skor bilgisi
                _buildScoreInfo(context),
                
                const SizedBox(height: 16),
                
                // İstatistikler
                _buildStatistics(context),
                
                const SizedBox(height: 32),
                
                // Butonlar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: onPlayAgain,
                      icon: const Icon(Icons.replay),
                      label: const Text('Tekrar Oyna'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: onExit,
                      icon: const Icon(Icons.exit_to_app),
                      label: const Text('Çıkış'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Skor bilgilerini gösteren widget
  Widget _buildScoreInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          const Text(
            'SKOR',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${score.value}',
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          Text(
            _getDifficultyText(),
            style: TextStyle(
              fontSize: 14,
              color: _getDifficultyColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// İstatistikleri gösteren widget
  Widget _buildStatistics(BuildContext context) {
    // Score'dan metadata'yı güvenli bir şekilde al
    Map<String, dynamic> metadata = {};
    if (score.metadata != null) {
      metadata = score.metadata!;
    }
    
    // Varsayılan değerler (eğer metadata içinde belirli anahtarlar yoksa)
    final shots = metadata['shots'] as int? ?? 0;
    final successfulShots = metadata['successfulShots'] as int? ?? 0;
    final accuracy = metadata['accuracy'] as double? ?? 0.0;
    final streak = metadata['streak'] as int? ?? 0;
    
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatItem(
              context,
              'Atış Sayısı',
              '$shots',
              Icons.sports_basketball,
            ),
            _buildStatItem(
              context,
              'Basket Sayısı',
              '$successfulShots',
              Icons.check_circle_outline,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatItem(
              context,
              'İsabet',
              '${accuracy.toStringAsFixed(1)}%',
              Icons.track_changes,
            ),
            _buildStatItem(
              context,
              'En Uzun Seri',
              '$streak',
              Icons.local_fire_department,
              color: streak >= 3 ? Colors.orange : null,
            ),
          ],
        ),
      ],
    );
  }

  /// Tekil istatistik öğesi oluşturur
  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    Color? color,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: color ?? Colors.grey[700],
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color ?? Colors.grey[800],
          ),
        ),
      ],
    );
  }

  /// Zorluk seviyesi metnini döndürür
  String _getDifficultyText() {
    switch (score.difficulty) {
      case GameDifficulty.easy:
        return 'KOLAY';
      case GameDifficulty.medium:
        return 'ORTA';
      case GameDifficulty.hard:
        return 'ZOR';
      default:
        return 'NORMAL';
    }
  }

  /// Zorluk seviyesi rengini döndürür
  Color _getDifficultyColor() {
    switch (score.difficulty) {
      case GameDifficulty.easy:
        return Colors.green;
      case GameDifficulty.medium:
        return Colors.orange;
      case GameDifficulty.hard:
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}