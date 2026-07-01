import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kiru/core/constants/app_spacing.dart';
import 'package:kiru/core/constants/app_colors.dart';
import 'package:kiru/core/routes/app_routes.dart';
import 'package:kiru/presentation/providers/profile_provider.dart';
import 'package:kiru/presentation/providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final profile = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold))),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            _buildSectionTitle('Appearance'),
            SwitchListTile(
              title: const Text('Dark Theme'),
              value: themeMode == ThemeMode.dark,
              activeThumbColor: AppColors.primary,
              onChanged: (val) {
                ref.read(themeModeProvider.notifier).state = val ? ThemeMode.dark : ThemeMode.light;
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildSectionTitle('Notifications'),
            ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title: const Text('Notification Settings'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildSectionTitle('Privacy'),
            ListTile(
              leading: const Icon(Icons.lock_outlined),
              title: const Text('Privacy Settings'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(AppRoutes.privacySettings),
            ),
            ListTile(
              leading: const Icon(Icons.block_outlined),
              title: const Text('Blocked Users'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildSectionTitle('Preferences'),
            SwitchListTile(
              title: const Text('Modest Fashion Mode'),
              subtitle: const Text('Prioritizes high-coverage pairings'),
              value: profile?.modestFashion ?? false,
              activeThumbColor: AppColors.primary,
              onChanged: (val) async {
                await ref.read(userProfileProvider.notifier).updateProfile(modestFashion: val);
              },
            ),
            SwitchListTile(
              title: const Text('Cultural Sensitivity'),
              subtitle: const Text('Alerts for destination dress codes'),
              value: profile?.culturalSensitivity ?? true,
              activeThumbColor: AppColors.primary,
              onChanged: (val) async {
                await ref.read(userProfileProvider.notifier).updateProfile(culturalSensitivity: val);
              },
            ),
            ListTile(
              leading: const Icon(Icons.language_outlined),
              title: const Text('Language'),
              subtitle: const Text('English'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
