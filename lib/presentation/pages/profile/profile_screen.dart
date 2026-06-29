import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kiru/core/constants/app_spacing.dart';
import 'package:kiru/core/constants/app_colors.dart';
import 'package:kiru/core/routes/app_routes.dart';
import 'package:kiru/presentation/providers/theme_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

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
              // Profile Card
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 45,
                      backgroundImage: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300&auto=format&fit=crop'),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const Text('Elena Rostova', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    const Text('@elena_travels • Minimalist Adventurer', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Stats Row
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
                      _buildStatCol('Trips', '8'),
                      _buildStatCol('Wardrobe', '24'),
                      _buildStatCol('Followers', '142'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Settings Options
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
                  activeColor: AppColors.primary,
                  onChanged: (val) {
                    ref.read(themeModeProvider.notifier).state = val ? ThemeMode.dark : ThemeMode.light;
                  },
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.shield_outlined, color: AppColors.primary),
                title: const Text('Cultural Sensitivity Filter'),
                subtitle: const Text('Alerts for destination dress codes'),
                trailing: Switch(value: true, activeColor: AppColors.primary, onChanged: (v) {}),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.checkroom_outlined, color: AppColors.primary),
                title: const Text('Modest Fashion Mode'),
                subtitle: const Text('Prioritizes high-coverage pairings'),
                trailing: Switch(value: false, activeColor: AppColors.primary, onChanged: (v) {}),
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
