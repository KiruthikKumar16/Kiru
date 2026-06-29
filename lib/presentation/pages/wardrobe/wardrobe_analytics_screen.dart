import 'package:flutter/material.dart';
import 'package:kiru/core/constants/app_colors.dart';
import 'package:kiru/core/constants/app_spacing.dart';

class WardrobeAnalyticsScreen extends StatelessWidget {
  const WardrobeAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wardrobe Analytics', style: TextStyle(fontWeight: FontWeight.bold))),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('🎨 Color Palette Distribution', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 12),
                  LinearProgressIndicator(value: 0.45, color: Colors.white, backgroundColor: AppColors.primary),
                  SizedBox(height: 8),
                  Text('45% White/Neutrals • 30% Indigo/Blue • 25% Earthy Tones', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Card(
              child: ListTile(
                leading: const Icon(Icons.cleaning_services_outlined, color: AppColors.warning),
                title: const Text('Decluttering Suggestions', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('3 items haven\'t been worn in over 6 months.'),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
