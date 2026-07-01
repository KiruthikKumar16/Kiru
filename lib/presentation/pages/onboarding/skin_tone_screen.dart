import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kiru/core/constants/app_spacing.dart';
import 'package:kiru/core/constants/app_colors.dart';
import 'package:kiru/core/routes/app_routes.dart';
import 'package:kiru/presentation/providers/profile_provider.dart';
import 'package:kiru/presentation/widgets/app_button.dart';

class SkinToneScreen extends ConsumerStatefulWidget {
  const SkinToneScreen({super.key});

  @override
  ConsumerState<SkinToneScreen> createState() => _SkinToneScreenState();
}

class _SkinToneScreenState extends ConsumerState<SkinToneScreen> {
  String _selectedUndertone = 'Warm Undertone';

  final List<Map<String, dynamic>> _undertones = [
    {
      'title': 'Warm Undertone',
      'colors': [const Color(0xFFF5D0A9), const Color(0xFFE0AC69), const Color(0xFFC68642)],
      'desc': 'Earthy, gold, and warm pastel colors complement your skin standard.'
    },
    {
      'title': 'Cool Undertone',
      'colors': [const Color(0xFFFFDFC4), const Color(0xFFD1A3A4), const Color(0xFF8D5524)],
      'desc': 'Jewel tones, deep blues, and berry shades suit you best.'
    },
    {
      'title': 'Neutral Undertone',
      'colors': [const Color(0xFFF3E5AB), const Color(0xFFB58A63), const Color(0xFF5A3825)],
      'desc': 'Versatile balance of both warm and cool color palettes.'
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profile = ref.read(userProfileProvider);
      if (profile?.undertone.isNotEmpty == true) {
        setState(() => _selectedUndertone = profile!.undertone);
      }
    });
  }

  Future<void> _continue() async {
    await ref.read(userProfileProvider.notifier).updateProfile(undertone: _selectedUndertone);
    if (mounted) context.go(AppRoutes.wardrobeSetup);
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
                    'Color Palette Matching',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextButton(
                    onPressed: _continue,
                    child: const Text('Skip'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                'Used by AI Stylist to generate high-contrast outfit pairings.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.xl),
              Expanded(
                child: ListView.builder(
                  itemCount: _undertones.length,
                  itemBuilder: (context, index) {
                    final item = _undertones[index];
                    final isSelected = _selectedUndertone == item['title'];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedUndertone = item['title']!),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item['title']!,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                                    ),
                                  ),
                                  Row(
                                    children: (item['colors'] as List<Color>).map((c) => Container(
                                      margin: const EdgeInsets.only(left: 4),
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: c,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white, width: 2),
                                      ),
                                    )).toList(),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                item['desc']!,
                                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              AppButton(
                text: 'Continue',
                onPressed: _continue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
