import 'package:flutter/material.dart';
import 'package:kiru/core/constants/app_colors.dart';
import 'package:kiru/core/constants/app_spacing.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  bool _publicProfile = true;
  bool _hideWardrobe = false;
  bool _hideTrips = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy & Visibility', style: TextStyle(fontWeight: FontWeight.bold))),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            SwitchListTile(
              title: const Text('Public Profile', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Allow non-followers to view your posts and style score'),
              value: _publicProfile,
              activeColor: AppColors.primary,
              onChanged: (v) => setState(() => _publicProfile = v),
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Hide Wardrobe from Public', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Only approved friends can view your virtual wardrobe items'),
              value: _hideWardrobe,
              activeColor: AppColors.primary,
              onChanged: (v) => setState(() => _hideWardrobe = v),
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Hide Trip Location / Dates by Default', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Security Standard: Prevents exact location tracking during trips'),
              value: _hideTrips,
              activeColor: AppColors.primary,
              onChanged: (v) => setState(() => _hideTrips = v),
            ),
          ],
        ),
      ),
    );
  }
}
