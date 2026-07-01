// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiru/core/constants/app_spacing.dart';
import 'package:kiru/presentation/providers/profile_provider.dart';

class StylePreferencesScreen extends ConsumerStatefulWidget {
  const StylePreferencesScreen({super.key});

  @override
  ConsumerState<StylePreferencesScreen> createState() => _StylePreferencesScreenState();
}

class _StylePreferencesScreenState extends ConsumerState<StylePreferencesScreen> {
  final List<String> _stylePersonas = [
    'The Minimalist',
    'The Trendsetter',
    'The Bohemian',
    'The Classic',
    'The Streetwear Enthusiast',
  ];

  final List<String> _colorOptions = [
    'Black',
    'White',
    'Navy',
    'Gray',
    'Beige',
    'Brown',
    'Blue',
    'Green',
    'Red',
    'Pink',
    'Purple',
    'Yellow',
  ];

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Style Preferences', style: TextStyle(fontWeight: FontWeight.bold))),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text('Style Persona', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSpacing.md),
            ..._stylePersonas.map((persona) => RadioListTile<String>(
              title: Text(persona),
              value: persona,
              groupValue: profile?.stylePersona,
              onChanged: (value) async {
                if (value != null) {
                  await ref.read(userProfileProvider.notifier).updateProfile(stylePersona: value);
                }
              },
            )),
            const SizedBox(height: AppSpacing.xl),
            Text('Favorite Colors', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _colorOptions.map((color) => FilterChip(
                label: Text(color),
                selected: (profile?.favoriteColors ?? []).contains(color),
                onSelected: (selected) async {
                  final currentColors = List<String>.from(profile?.favoriteColors ?? []);
                  if (selected) {
                    currentColors.add(color);
                  } else {
                    currentColors.remove(color);
                  }
                  await ref.read(userProfileProvider.notifier).updateProfile(favoriteColors: currentColors);
                },
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
