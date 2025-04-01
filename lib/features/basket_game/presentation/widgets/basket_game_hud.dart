import 'package:flutter/material.dart';
import '../../domain/entities/basket_game_state.dart';

/// Basket oyunu HUD (Heads-Up Display) widget'ı
///
/// Oyun ekranındaki skor, süre ve diğer bilgileri gösterir
class BasketGameHUD extends StatelessWidget {
  /// Oyun durumu
  final BasketGameState gameState;
  
  /// Oyunu duraklatma fonksiyonu
  final VoidCallback onPause;
  
  /// Oyunu devam ettirme fonksiyonu
  final VoidCallback onResume;
  
  /// Oyunun duraklatılıp duraklatılmadığı
  final bool isPaused;

  const BasketGameHUD({
    Key? key,
    required this.gameState,
    required this.onPause,
    required this.onResume,
    required this.isPaused,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Üst bilgi çubuğu (skor ve süre)
            _buildTopBar(),
            
            // Duraklat butonu (sağ tarafta)
            Align(
              alignment: Alignment.topRight,
              child: _buildPauseButton(),
            ),
            
            // Ekranın ortasında duraklatma paneli
            if (isPaused)
              _buildPauseOverlay(context),
              
            // Alt bilgi çubuğu (isabet oranı vb.)
            const Spacer(),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  /// Üst bilgi çubuğunu oluşturur (skor ve süre)
  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Skor
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.scoreboard_outlined,
                color: Colors.orangeAccent,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Skor: ${gameState.value}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        
        // Süre
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.timer,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                _formatTime(gameState.getRemainingSeconds()),
                style: TextStyle(
                  color: gameState.getRemainingSeconds() < 10
                      ? Colors.red
                      : Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Duraklat butonunu oluşturur
  Widget _buildPauseButton() {
    return FloatingActionButton.small(
      onPressed: isPaused ? onResume : onPause,
      backgroundColor: isPaused ? Colors.green : Colors.blueGrey,
      child: Icon(
        isPaused ? Icons.play_arrow : Icons.pause,
        color: Colors.white,
      ),
    );
  }

  /// Duraklat panelini oluşturur
  Widget _buildPauseOverlay(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'OYUN DURAKLATILDI',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  onPressed: onResume,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Devam Et'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
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
    );
  }

  /// Alt bilgi çubuğunu oluşturur (isabet oranı vb.)
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Atış sayısı
          _buildStatItem(
            icon: Icons.sports_basketball,
            label: 'Atış',
            value: '${gameState.shots}',
          ),
          
          // İsabet
          _buildStatItem(
            icon: Icons.track_changes,
            label: 'İsabet',
            value: '${gameState.getAccuracy().toStringAsFixed(1)}%',
          ),
          
          // Streak
          _buildStatItem(
            icon: Icons.local_fire_department,
            label: 'Seri',
            value: '${gameState.streak}',
            valueColor: gameState.streak >= 3 ? Colors.orangeAccent : Colors.white,
          ),
        ],
      ),
    );
  }

  /// İstatistik öğesi oluşturur
  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: Colors.white70,
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// Süreyi formatlar (mm:ss)
  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}