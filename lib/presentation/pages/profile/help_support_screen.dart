import 'package:flutter/material.dart';
import 'package:kiru/core/constants/app_colors.dart';
import 'package:kiru/core/constants/app_spacing.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support', style: TextStyle(fontWeight: FontWeight.bold))),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: const [
            ExpansionTile(
              title: Text('How does Kiru select outfits from my wardrobe?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              children: [
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('Kiru analyzes destination temperature, weather forecasts, trip occasion, and your skin tone/color preferences to synthesize pairings from your digitized wardrobe items.', style: TextStyle(color: AppColors.textSecondary)),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('Is my photo and location data kept private?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              children: [
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('Yes! All photo uploads automatically strip EXIF metadata, and exact travel dates and location pinpoints are hidden by default.', style: TextStyle(color: AppColors.textSecondary)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
