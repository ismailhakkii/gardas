import 'package:flutter/material.dart';
import 'package:gardas/core/constants/app_strings.dart';
import 'package:gardas/core/widgets/custom_button.dart';

/// Flag game tutorial page
///
/// This page displays a tutorial for the flag game.
class FlagGameTutorialPage extends StatefulWidget {
  /// Callback for completing the tutorial
  final VoidCallback onComplete;

  const FlagGameTutorialPage({
    Key? key,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<FlagGameTutorialPage> createState() => _FlagGameTutorialPageState();
}

class _FlagGameTutorialPageState extends State<FlagGameTutorialPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 3;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      widget.onComplete();
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipTutorial() {
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nasıl Oynanır?'),
        actions: [
          TextButton(
            onPressed: _skipTutorial,
            child: const Text('Geç'),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: [
                _buildTutorialPage(
                  title: 'Bayrak Bilme Oyunu',
                  description: 'Ekranda gösterilen bayrağın hangi ülkeye ait olduğunu bulmaya çalışın.',
                  icon: Icons.flag,
                ),
                _buildTutorialPage(
                  title: 'Süre Sınırı',
                  description: 'Her soru için 15 saniye süreniz var. Ne kadar hızlı cevap verirseniz o kadar çok puan kazanırsınız.',
                  icon: Icons.timer,
                ),
                _buildTutorialPage(
                  title: 'Zorluk Seviyeleri',
                  description: 'Kolay, orta ve zor olmak üzere üç zorluk seviyesi vardır. Zorluk arttıkça, daha fazla seçenek ve daha az bilinen ülkeler gösterilir.',
                  icon: Icons.trending_up,
                ),
              ],
            ),
          ),
          _buildPageIndicator(),
          _buildBottomButtons(),
        ],
      ),
    );
  }

  Widget _buildTutorialPage({
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 32),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_totalPages, (index) {
          return Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentPage == index
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surfaceVariant,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentPage > 0)
            CustomButton(
              text: AppStrings.previous,
              onPressed: _goToPreviousPage,
              type: ButtonType.outlined,
              icon: Icons.arrow_back,
            )
          else
            const SizedBox(width: 100),
          CustomButton(
            text: _currentPage == _totalPages - 1
                ? AppStrings.start
                : AppStrings.next,
            onPressed: _goToNextPage,
            type: ButtonType.primary,
            icon: _currentPage == _totalPages - 1
                ? Icons.play_arrow
                : Icons.arrow_forward,
          ),
        ],
      ),
    );
  }
}