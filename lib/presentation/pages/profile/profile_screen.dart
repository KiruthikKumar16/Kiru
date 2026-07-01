import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kiru/core/constants/app_spacing.dart';
import 'package:kiru/core/constants/app_colors.dart';
import 'package:kiru/core/routes/app_routes.dart';
import 'package:kiru/presentation/providers/profile_provider.dart';
import 'package:kiru/presentation/providers/theme_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final profile = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile & Settings', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              // Profile Card with Gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary.withValues(alpha: 0.2),
                      AppColors.primary.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                ),
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(profile?.photoUrl ?? 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300&auto=format&fit=crop'),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(profile?.displayName ?? 'Elena Rostova', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(
                        '@${profile?.username ?? 'elena_travels'}',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        profile?.bio ?? 'Minimalist Adventurer',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      ElevatedButton.icon(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          context.push(AppRoutes.editProfile);
                        },
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        label: const Text('Edit Profile'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Stats Row with interactive columns
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCol(context, 'Trips', '8', () {
                      HapticFeedback.lightImpact();
                    }),
                    _buildStatCol(context, 'Wardrobe', '24', () {
                      HapticFeedback.lightImpact();
                    }),
                    _buildStatCol(context, 'Followers', '142', () {
                      HapticFeedback.lightImpact();
                      context.push(AppRoutes.followersList);
                    }),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Settings Options grouped by sections
              _buildSectionTitle('General'),
              const SizedBox(height: 8),
              _buildSettingsTile(
                icon: Icons.stars_outlined,
                title: 'Kiru Pro Premium Tier',
                subtitle: 'Unlock unlimited AI styling',
                onTap: () {
                  HapticFeedback.lightImpact();
                  context.push(AppRoutes.premiumSubscription);
                },
              ),
              _buildSettingsTile(
                icon: Icons.palette_outlined,
                title: 'Dark Theme Mode',
                trailing: Switch(
                  value: themeMode == ThemeMode.dark,
                  activeThumbColor: AppColors.primary,
                  onChanged: (val) {
                    HapticFeedback.lightImpact();
                    ref.read(themeModeProvider.notifier).state = val ? ThemeMode.dark : ThemeMode.light;
                  },
                ),
              ),

              const SizedBox(height: AppSpacing.lg),
              _buildSectionTitle('Preferences'),
              const SizedBox(height: 8),
              _buildSettingsTile(
                icon: Icons.shield_outlined,
                title: 'Cultural Sensitivity Filter',
                subtitle: 'Alerts for destination dress codes',
                trailing: Switch(value: true, activeThumbColor: AppColors.primary, onChanged: (v) {}),
              ),
              _buildSettingsTile(
                icon: Icons.checkroom_outlined,
                title: 'Modest Fashion Mode',
                subtitle: 'Prioritizes high-coverage pairings',
                trailing: Switch(value: false, activeThumbColor: AppColors.primary, onChanged: (v) {}),
              ),

              const SizedBox(height: AppSpacing.lg),
              _buildSectionTitle('Privacy & Support'),
              const SizedBox(height: 8),
              _buildSettingsTile(
                icon: Icons.lock_outline,
                title: 'Privacy & Local Encryption Defaults',
                onTap: () {
                  HapticFeedback.lightImpact();
                  context.push(AppRoutes.privacySettings);
                },
              ),
              _buildSettingsTile(
                icon: Icons.help_outline,
                title: 'Help & Support FAQs',
                onTap: () {
                  HapticFeedback.lightImpact();
                  context.push(AppRoutes.helpSupport);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: AppColors.primary),
          title: Text(title),
          subtitle: subtitle != null ? Text(subtitle) : null,
          trailing: trailing ?? const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
        const Divider(height: 0),
      ],
    );
  }

  Widget _buildStatCol(BuildContext context, String label, String val, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          children: [
            Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
