import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:kiru/core/constants/app_spacing.dart';
import 'package:kiru/core/constants/app_colors.dart';
import 'package:kiru/core/routes/app_routes.dart';
import 'package:kiru/presentation/widgets/app_button.dart';

class WardrobeSetupScreen extends ConsumerStatefulWidget {
  const WardrobeSetupScreen({super.key});

  @override
  ConsumerState<WardrobeSetupScreen> createState() => _WardrobeSetupScreenState();
}

class _WardrobeSetupScreenState extends ConsumerState<WardrobeSetupScreen> {
  final List<String> _selectedItems = [];

  final List<Map<String, dynamic>> _starterItems = [
    {'name': 'White T-Shirt', 'icon': Icons.checkroom, 'category': 'Tops'},
    {'name': 'Blue Jeans', 'icon': Icons.checkroom, 'category': 'Bottoms'},
    {'name': 'Black Dress', 'icon': Icons.checkroom, 'category': 'Dresses'},
    {'name': 'Sneakers', 'icon': Icons.directions_walk, 'category': 'Shoes'},
    {'name': 'Leather Jacket', 'icon': Icons.checkroom, 'category': 'Outerwear'},
    {'name': 'Watch', 'icon': Icons.watch, 'category': 'Accessories'},
  ];

  Future<void> _completeOnboarding() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final box = Hive.box('settings');
      await box.put('onboarding_completed_${user.uid}', true);
    }
    if (mounted) context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.pop(),
                  ),
                  Text(
                    'Wardrobe Setup',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextButton(
                    onPressed: _completeOnboarding,
                    child: const Text('Skip'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                'Add some starter items to personalize your wardrobe',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: _starterItems.length,
                  itemBuilder: (context, index) {
                    final item = _starterItems[index];
                    final isSelected = _selectedItems.contains(item['name']);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedItems.remove(item['name']);
                          } else {
                            _selectedItems.add(item['name']);
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary.withValues(alpha: 0.08) : AppColors.surface,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.border,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              item['icon'],
                              size: 40,
                              color: isSelected ? AppColors.primary : AppColors.textSecondary,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              item['name'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['category'],
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppButton(
                text: 'Add Items Later',
                type: AppButtonType.secondary,
                onPressed: _completeOnboarding,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppButton(
                text: 'Complete Setup',
                onPressed: _completeOnboarding,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
