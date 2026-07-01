import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:go_router/go_router.dart';
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
  final List<String> _selectedColors = [];
  String _selectedPersona = '';
  int _currentStep = 0; // 0: Outfit cards, 1: Color palette, 2: Persona

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
  ];

  final List<Map<String, dynamic>> _colors = [
    {'name': 'Black', 'color': const Color(0xFF000000)},
    {'name': 'White', 'color': const Color(0xFFFFFFFF)},
    {'name': 'Navy', 'color': const Color(0xFF000080)},
    {'name': 'Gray', 'color': const Color(0xFF808080)},
    {'name': 'Beige', 'color': const Color(0xFFF5F5DC)},
    {'name': 'Brown', 'color': const Color(0xFFA52A2A)},
    {'name': 'Blue', 'color': const Color(0xFF0000FF)},
    {'name': 'Green', 'color': const Color(0xFF008000)},
    {'name': 'Red', 'color': const Color(0xFFFF0000)},
    {'name': 'Pink', 'color': const Color(0xFFFFC0CB)},
    {'name': 'Purple', 'color': const Color(0xFF800080)},
    {'name': 'Yellow', 'color': const Color(0xFFFFFF00)},
  ];

  final List<Map<String, String>> _personas = [
    {
      'name': 'The Minimalist',
      'description': 'Clean lines, neutral tones, and timeless pieces',
      'icon': '🧥',
    },
    {
      'name': 'The Trendsetter',
      'description': 'Always up-to-date with the latest fashion',
      'icon': '👗',
    },
    {
      'name': 'The Bohemian',
      'description': 'Free-spirited with flowy fabrics and patterns',
      'icon': '🌿',
    },
    {
      'name': 'The Classic',
      'description': 'Elegant, sophisticated, and traditional',
      'icon': '🎩',
    },
    {
      'name': 'The Streetwear Enthusiast',
      'description': 'Urban, casual, and bold styles',
      'icon': '👟',
    },
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
    return true;
  }

  Future<void> _saveAndContinue() async {
    if (_likedStyles.isNotEmpty || _selectedColors.isNotEmpty || _selectedPersona.isNotEmpty) {
      await ref.read(userProfileProvider.notifier).updateProfile(
            stylePreferences: _likedStyles.toSet().toList(),
            favoriteColors: _selectedColors,
            stylePersona: _selectedPersona,
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
                children: List.generate(3, (index) => Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
                    height: 4,
                    decoration: BoxDecoration(
                      color: index <= _currentStep ? AppColors.primary : AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                )),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentStep > 0)
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => setState(() => _currentStep--),
                    ),
                  Text(
                    _getStepTitle(),
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
              const SizedBox(height: AppSpacing.sm),
              Text(
                _getStepDescription(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: _buildCurrentStep(),
              ),
              const SizedBox(height: AppSpacing.lg),
              if (_currentStep == 0) _buildActionButtons(),
              if (_currentStep > 0)
                AppButton(
                  text: _currentStep == 2 ? 'Continue' : 'Next',
                  onPressed: () {
                    if (_currentStep < 2) {
                      setState(() => _currentStep++);
                    } else {
                      _saveAndContinue();
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 0:
        return 'Outfit Preferences';
      case 1:
        return 'Favorite Colors';
      case 2:
        return 'Style Persona';
      default:
        return '';
    }
  }

  String _getStepDescription() {
    switch (_currentStep) {
      case 0:
        return 'Swipe right if you like it, left if you don\'t';
      case 1:
        return 'Select colors that you love to wear';
      case 2:
        return 'Choose the style that best describes you';
      default:
        return '';
    }
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return CardSwiper(
          controller: _controller,
          cardsCount: _quizItems.length,
          onSwipe: _onSwipe,
          padding: EdgeInsets.zero,
          cardBuilder: (context, index, percentX, percentY) {
            return _buildQuizCard(_quizItems[index]);
          },
        );
      case 1:
        return _buildColorSelection();
      case 2:
        return _buildPersonaSelection();
      default:
        return const SizedBox.shrink();
    }
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

  Widget _buildColorSelection() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _colors.length,
      itemBuilder: (context, index) {
        final color = _colors[index];
        final isSelected = _selectedColors.contains(color['name']);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedColors.remove(color['name']);
              } else {
                _selectedColors.add(color['name']);
              }
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: color['color'],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: isSelected ? 3 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      )
                    ]
                  : [],
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white)
                : null,
          ),
        );
      },
    );
  }

  Widget _buildPersonaSelection() {
    return ListView.builder(
      itemCount: _personas.length,
      itemBuilder: (context, index) {
        final persona = _personas[index];
        final isSelected = _selectedPersona == persona['name'];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: GestureDetector(
            onTap: () => setState(() => _selectedPersona = persona['name']!),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary.withValues(alpha: 0.08) : AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Text(
                    persona['icon']!,
                    style: const TextStyle(fontSize: 40),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          persona['name']!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: isSelected ? AppColors.primary : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          persona['description']!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                    color: isSelected ? AppColors.primary : AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
