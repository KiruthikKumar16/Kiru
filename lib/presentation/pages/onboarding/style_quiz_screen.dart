import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:kiru/core/constants/app_strings.dart';
import 'package:kiru/core/constants/app_spacing.dart';
import 'package:kiru/core/constants/app_colors.dart';
import 'package:kiru/data/models/style_quiz_item.dart';
import 'package:kiru/presentation/widgets/app_button.dart';

class StyleQuizScreen extends ConsumerStatefulWidget {
  const StyleQuizScreen({super.key});

  @override
  ConsumerState<StyleQuizScreen> createState() => _StyleQuizScreenState();
}

class _StyleQuizScreenState extends ConsumerState<StyleQuizScreen> {
  final CardSwiperController _swiperController = CardSwiperController();
  int _currentIndex = 0;

  // Sample quiz items - later, replace with real data/API
  final List<StyleQuizItem> _quizItems = [
    StyleQuizItem(
      id: '1',
      imageUrl: 'https://picsum.photos/600/800?random=1',
      title: 'Casual Streetwear',
      category: 'Street',
      tags: ['casual', 'street', 'urban'],
    ),
    StyleQuizItem(
      id: '2',
      imageUrl: 'https://picsum.photos/600/800?random=2',
      title: 'Formal Business',
      category: 'Formal',
      tags: ['formal', 'business', 'professional'],
    ),
    StyleQuizItem(
      id: '3',
      imageUrl: 'https://picsum.photos/600/800?random=3',
      title: 'Bohemian Summer',
      category: 'Bohemian',
      tags: ['boho', 'summer', 'relaxed'],
    ),
    StyleQuizItem(
      id: '4',
      imageUrl: 'https://picsum.photos/600/800?random=4',
      title: 'Minimal Elegance',
      category: 'Minimal',
      tags: ['minimal', 'clean', 'elegant'],
    ),
    StyleQuizItem(
      id: '5',
      imageUrl: 'https://picsum.photos/600/800?random=5',
      title: 'Athleisure Active',
      category: 'Athleisure',
      tags: ['athletic', 'comfortable', 'active'],
    ),
  ];

  final List<StyleQuizItem> _likedItems = [];
  final List<StyleQuizItem> _dislikedItems = [];

  @override
  void dispose() {
    _swiperController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            children: [
              Text(
                AppStrings.onboardingTitle,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                AppStrings.onboardingSubtitle,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              Expanded(
                child: _currentIndex < _quizItems.length
                    ? CardSwiper(
                        controller: _swiperController,
                        cardsCount: _quizItems.length - _currentIndex,
                        isDisabled: false,
                        allowedSwipeDirection:
                            const AllowedSwipeDirection.only(
                          right: true,
                          left: true,
                        ),
                        onSwipe: (old, current, direction) {
                          final item = _quizItems[_currentIndex];
                          setState(() {
                            _currentIndex++;
                            if (direction == CardSwiperDirection.right) {
                              _likedItems.add(item);
                            } else if (direction == CardSwiperDirection.left) {
                              _dislikedItems.add(item);
                            }
                          });
                          return true;
                        },
                        cardBuilder: (context, index, _, __) {
                          final item = _quizItems[_currentIndex + index];
                          return _buildQuizCard(item);
                        },
                      )
                    : _buildCompletedState(),
              ),
              const SizedBox(height: AppSpacing.xl),
              if (_currentIndex < _quizItems.length) _buildActionButtons(),
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
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.network(
                item.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(
                  color: AppColors.surface,
                  child: const Icon(Icons.image, size: 100),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusSm),
                        ),
                        child: Text(
                          item.category,
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    item.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
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
          heroTag: 'dislike',
          backgroundColor: Colors.white,
          shape: const CircleBorder(),
          onPressed: () => _swiperController.swipe(CardSwiperDirection.left),
          child: const Icon(Icons.close, color: AppColors.error, size: 32),
        ),
        FloatingActionButton(
          heroTag: 'like',
          backgroundColor: AppColors.primary,
          shape: const CircleBorder(),
          onPressed: () => _swiperController.swipe(CardSwiperDirection.right),
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
          const Icon(Icons.check_circle, size: 100, color: AppColors.success),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'All Done!',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'You liked ${_likedItems.length} styles!',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.xxl),
          AppButton(
            text: 'Continue',
            onPressed: () {
              // TODO: Navigate to next onboarding step
            },
          ),
        ],
      ),
    );
  }
}
