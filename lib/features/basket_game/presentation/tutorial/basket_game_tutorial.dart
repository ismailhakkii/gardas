import 'package:flutter/material.dart';

/// Basket oyunu öğretici ekranı
///
/// Oyunun nasıl oynanacağını gösteren öğretici ekran
class BasketGameTutorial extends StatefulWidget {
  /// Eğitim tamamlandığında çağrılacak fonksiyon
  final VoidCallback onTutorialCompleted;

  const BasketGameTutorial({
    Key? key,
    required this.onTutorialCompleted,
  }) : super(key: key);

  @override
  State<BasketGameTutorial> createState() => _BasketGameTutorialState();
}

class _BasketGameTutorialState extends State<BasketGameTutorial> {
  /// Aktif sayfa indeksi
  int _currentPageIndex = 0;
  
  /// Toplam sayfa sayısı
  final int _totalPages = 3;
  
  /// Sayfa kontrolcüsü
  final PageController _pageController = PageController();
  
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Arka plan overlay
          GestureDetector(
            onTap: widget.onTutorialCompleted,
            child: Container(
              color: Colors.black.withOpacity(0.7),
            ),
          ),
          
          // Tutorial içeriği
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Başlık
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.sports_basketball,
                          color: Colors.orange,
                          size: 32,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Basket Atışı - Nasıl Oynanır',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const Divider(),
                  
                  // Sayfa içeriği
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPageIndex = index;
                        });
                      },
                      children: [
                        _buildTutorialPage(
                          title: '1. Topu Seç',
                          description: 'Basket atmak için önce ekranın altındaki basket topuna dokunun.',
                          image: 'assets/tutorials/basket_tutorial_1.png',
                          icon: Icons.touch_app,
                        ),
                        _buildTutorialPage(
                          title: '2. Açı ve Gücü Ayarla',
                          description: 'Parmağınızı sürükleyerek atış açısını ve gücünü ayarlayın. '
                              'Parmağınızı uzağa sürüklediğinizde atış daha güçlü olacaktır.',
                          image: 'assets/tutorials/basket_tutorial_2.png',
                          icon: Icons.swipe,
                        ),
                        _buildTutorialPage(
                          title: '3. Basket At ve Puan Kazan',
                          description: 'Topu potaya atın. Her başarılı basket için puan kazanacaksınız. '
                              'Art arda basket attıkça daha fazla bonus puan kazanırsınız!',
                          image: 'assets/tutorials/basket_tutorial_3.png',
                          icon: Icons.emoji_events,
                        ),
                      ],
                    ),
                  ),
                  
                  // Navigasyon butonları
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Önceki sayfa butonu
                        if (_currentPageIndex > 0)
                          ElevatedButton.icon(
                            onPressed: () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            icon: const Icon(Icons.arrow_back),
                            label: const Text('Önceki'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[300],
                              foregroundColor: Colors.black,
                            ),
                          )
                        else
                          const SizedBox(width: 100),
                          
                        // Sayfa indikatörleri
                        Row(
                          children: List.generate(_totalPages, (index) {
                            return Container(
                              width: 10,
                              height: 10,
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: index == _currentPageIndex 
                                    ? Colors.orange 
                                    : Colors.grey[300],
                              ),
                            );
                          }),
                        ),
                        
                        // Sonraki veya bitir butonu
                        _currentPageIndex < _totalPages - 1
                            ? ElevatedButton.icon(
                                onPressed: () {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                icon: const Icon(Icons.arrow_forward),
                                label: const Text('Sonraki'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Colors.white,
                                ),
                              )
                            : ElevatedButton.icon(
                                onPressed: widget.onTutorialCompleted,
                                icon: const Icon(Icons.check),
                                label: const Text('Anladım'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Kapatma butonu
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              onPressed: widget.onTutorialCompleted,
              icon: const Icon(
                Icons.close,
                color: Colors.white,
                size: 30,
              ),
              style: IconButton.styleFrom(
                backgroundColor: Colors.red.withOpacity(0.7),
                padding: const EdgeInsets.all(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Eğitim sayfası widget'ı oluşturur
  Widget _buildTutorialPage({
    required String title,
    required String description,
    required String image,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Icon(
            icon,
            size: 48,
            color: Colors.orange,
          ),
          
          const SizedBox(height: 16),
          
          // Başlık
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 24),
          
          // Görsel
          // Not: Eğer görsel yoksa placeholder bir widget kullanıyoruz
          Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: _buildImagePlaceholder(icon),
          ),
          
          const SizedBox(height: 24),
          
          // Açıklama
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  /// Görsel yerine placeholder oluşturur
  /// Not: Gerçek bir uygulamada, bu kısma assetlerden veya ağdan gerçek görseller yüklenebilir
  Widget _buildImagePlaceholder(IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 8),
          Text(
            'Örnek Görseli',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}