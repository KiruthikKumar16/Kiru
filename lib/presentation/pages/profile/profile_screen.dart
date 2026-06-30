import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kiru/core/constants/app_spacing.dart';
import 'package:kiru/core/constants/app_colors.dart';
import 'package:kiru/core/routes/app_routes.dart';
import 'package:kiru/presentation/providers/app_mock_providers.dart';
import 'package:kiru/presentation/providers/auth_providers.dart';
import 'package:kiru/presentation/providers/profile_provider.dart';
import 'package:kiru/presentation/providers/theme_provider.dart';
import 'package:kiru/presentation/providers/trip_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final profile = ref.watch(userProfileProvider);
    final trips = ref.watch(tripsProvider);
    final wardrobe = ref.watch(wardrobeItemsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile & Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
            onPressed: () => context.push(AppRoutes.editProfile),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundImage: NetworkImage(
                        profile?.photoUrl ??
                            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300&auto=format&fit=crop',
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      profile?.displayName ?? 'User',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '@${profile?.username ?? 'username'} • ${profile?.bio ?? ''}',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                    if (profile != null && profile.bodyShape.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        '${profile.bodyShape} • ${profile.undertone}',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              InkWell(
                onTap: () => context.push(AppRoutes.followersList),
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatCol('Trips', '${trips.length}'),
                      _buildStatCol('Wardrobe', '${wardrobe.length}'),
                      _buildStatCol('Styles', '${profile?.stylePreferences.length ?? 0}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              ListTile(
                leading: const Icon(Icons.stars_outlined, color: AppColors.primary),
                title: const Text('Kiru Pro Premium Tier'),
                subtitle: const Text('Unlock unlimited AI styling'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(AppRoutes.premiumSubscription),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.palette_outlined, color: AppColors.primary),
                title: const Text('Dark Theme Mode'),
                trailing: Switch(
                  value: themeMode == ThemeMode.dark,
                  activeThumbColor: AppColors.primary,
                  onChanged: (val) {
                    ref.read(themeModeProvider.notifier).state =
                        val ? ThemeMode.dark : ThemeMode.light;
                  },
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.shield_outlined, color: AppColors.primary),
                title: const Text('Cultural Sensitivity Filter'),
                subtitle: const Text('Alerts for destination dress codes'),
                trailing: Switch(
                  value: profile?.culturalSensitivity ?? true,
                  activeThumbColor: AppColors.primary,
                  onChanged: (v) {
                    ref.read(userProfileProvider.notifier).updateProfile(culturalSensitivity: v);
                  },
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.checkroom_outlined, color: AppColors.primary),
                title: const Text('Modest Fashion Mode'),
                subtitle: const Text('Prioritizes high-coverage pairings'),
                trailing: Switch(
                  value: profile?.modestFashion ?? false,
                  activeThumbColor: AppColors.primary,
                  onChanged: (v) {
                    ref.read(userProfileProvider.notifier).updateProfile(modestFashion: v);
                  },
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.lock_outline, color: AppColors.primary),
                title: const Text('Privacy & Local Encryption Defaults'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(AppRoutes.privacySettings),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.help_outline, color: AppColors.primary),
                title: const Text('Help & Support FAQs'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push(AppRoutes.helpSupport),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout, color: AppColors.error),
                title: const Text('Sign Out', style: TextStyle(color: AppColors.error)),
                onTap: () async {
                  await ref.read(firebaseAuthDataSourceProvider).signOut();
                  if (context.mounted) context.go(AppRoutes.welcome);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCol(String label, String val) {
    return Column(
      children: [
        Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }
}
