import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:go_router/go_router.dart';
import 'package:kiru/core/constants/app_strings.dart';
import 'package:kiru/core/constants/app_spacing.dart';
import 'package:kiru/core/constants/app_colors.dart';
import 'package:kiru/core/routes/app_routes.dart';
import 'package:kiru/data/models/style_quiz_item.dart';
import 'package:kiru/presentation/providers/profile_provider.dart';
import 'package:kiru/presentation/widgets/app_button.dart';

class StyleQuizScreen extends ConsumerStatefulWidget {
  const StyleQuizScreen({super.key});

  @override
  ConsumerState<StyleQuizScreen> createState() => _StyleQuizScreenState();
}

class _StyleQuizScreenState extends ConsumerState<StyleQuizScreen> {
  final CardSwiperController _controller = CardSwiperController();
  final List<String> _likedStyles = [];
  bool _isFinished = false;

  final List<StyleQuizItem> _quizItems = [
    const StyleQuizItem(
      id: '1',
      imageUrl: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=600&auto=format&fit=crop',
      title: 'Milanese Minimal Chic',
      category: 'Minimal',
      tags: ['chic', 'minimal', 'monochrome'],
    ),
    const StyleQuizItem(
      id: '2',
      imageUrl: 'https://images.unsplash.com/photo-1529139574466-a303027c1d8b?w=600&auto=format&fit=crop',
      title: 'Tokyo Streetwear',
      category: 'Streetwear',
      tags: ['oversized', 'urban', 'trendy'],
    ),
    const StyleQuizItem(
      id: '3',
      imageUrl: 'https://images.unsplash.com/photo-1496747611176-843222e1e57c?w=600&auto=format&fit=crop',
      title: 'Bohemian Coastal Sunset',
      category: 'Bohemian',
      tags: ['resort', 'breeze', 'floral'],
    ),
    const StyleQuizItem(
      id: '4',
      imageUrl: 'https://images.unsplash.com/photo-1485230895905-ec40ba36b9bc?w=600&auto=format&fit=crop',
      title: 'Parisian Business Formal',
      category: 'Formal',
      tags: ['blazer', 'tailored', 'sleek'],
    ),
    const StyleQuizItem(
      id: '5',
      imageUrl: 'https://images.unsplash.com/photo-1509631179647-0177331693ae?w=600&auto=format&fit=crop',
      title: 'Nordic Casual Winter',
      category: 'Casual',
      tags: ['cozy', 'knitwear', 'warm'],
    ),
    const StyleQuizItem(
      id: '6',
      imageUrl: 'https://images.unsplash.com/photo-1539109136881-3be0616acf4b?w=600&auto=format&fit=crop',
      title: 'High-Fashion Statement',
      category: 'High Fashion',
      tags: ['bold', 'avantgarde', 'editorial'],
    ),
    const StyleQuizItem(
      id: '7',
      imageUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=600&auto=format&fit=crop',
      title: 'Balearic Islands Resortwear',
      category: 'Resort',
      tags: ['summer', 'linen', 'relaxing'],
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _onSwipe(int previousIndex, int? currentIndex, CardSwiperDirection direction) {
    if (direction == CardSwiperDirection.right && previousIndex < _quizItems.length) {
      _likedStyles.add(_quizItems[previousIndex].category);
    }
    setState(() {
      if (currentIndex == null) _isFinished = true;
    });
    return true;
  }

  Future<void> _saveAndContinue() async {
    if (_likedStyles.isNotEmpty) {
      await ref.read(userProfileProvider.notifier).updateProfile(
            stylePreferences: _likedStyles.toSet().toList(),
          );
    }
    if (mounted) context.go(AppRoutes.bodyProfile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.onboardingTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextButton(
                    onPressed: _saveAndContinue,
                    child: const Text('Skip'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                AppStrings.onboardingSubtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: _isFinished
                    ? _buildCompletedState()
                    : CardSwiper(
                        controller: _controller,
                        cardsCount: _quizItems.length,
                        onSwipe: _onSwipe,
                        onEnd: () => setState(() => _isFinished = true),
                        padding: EdgeInsets.zero,
                        cardBuilder: (context, index, percentX, percentY) {
                          return _buildQuizCard(_quizItems[index]);
                        },
                      ),
              ),
              const SizedBox(height: AppSpacing.lg),
              if (!_isFinished) _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuizCard(StyleQuizItem item) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXxl),
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXxl),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              item.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: AppColors.surface,
                child: const Icon(Icons.dry_cleaning, size: 80, color: AppColors.primary),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.8),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                      child: Text(
                        item.category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      item.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
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

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FloatingActionButton(
          heroTag: 'dislike_btn',
          backgroundColor: Colors.white,
          elevation: 4,
          shape: const CircleBorder(),
          onPressed: () => _controller.swipe(CardSwiperDirection.left),
          child: const Icon(Icons.close, color: AppColors.error, size: 32),
        ),
        FloatingActionButton(
          heroTag: 'like_btn',
          backgroundColor: AppColors.primary,
          elevation: 4,
          shape: const CircleBorder(),
          onPressed: () => _controller.swipe(CardSwiperDirection.right),
          child: const Icon(Icons.favorite, color: Colors.white, size: 32),
        ),
      ],
    );
  }

  Widget _buildCompletedState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.stars, size: 90, color: AppColors.primary),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Style Profile Calibrated!',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            _likedStyles.isEmpty
                ? 'We analyzed your preferences to tailor personalized AI outfit recommendations.'
                : 'You love: ${_likedStyles.toSet().join(', ')}',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xxl),
          AppButton(
            text: 'Next: Body Profile',
            onPressed: _saveAndContinue,
          ),
        ],
      ),
    );
  }
}
