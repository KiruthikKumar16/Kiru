import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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

  String get _settingsKey {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
    return 'privacy_settings_$uid';
  }

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    final box = Hive.box('settings');
    final data = box.get(_settingsKey);
    if (data != null) {
      final map = Map<String, dynamic>.from(data as Map);
      setState(() {
        _publicProfile = map['publicProfile'] as bool? ?? true;
        _hideWardrobe = map['hideWardrobe'] as bool? ?? false;
        _hideTrips = map['hideTrips'] as bool? ?? true;
      });
    }
  }

  Future<void> _saveSettings() async {
    final box = Hive.box('settings');
    await box.put(_settingsKey, {
      'publicProfile': _publicProfile,
      'hideWardrobe': _hideWardrobe,
      'hideTrips': _hideTrips,
    });
  }

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
              activeThumbColor: AppColors.primary,
              onChanged: (v) {
                setState(() => _publicProfile = v);
                _saveSettings();
              },
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Hide Wardrobe from Public', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Only approved friends can view your virtual wardrobe items'),
              value: _hideWardrobe,
              activeThumbColor: AppColors.primary,
              onChanged: (v) {
                setState(() => _hideWardrobe = v);
                _saveSettings();
              },
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Hide Trip Location / Dates by Default', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Security Standard: Prevents exact location tracking during trips'),
              value: _hideTrips,
              activeThumbColor: AppColors.primary,
              onChanged: (v) {
                setState(() => _hideTrips = v);
                _saveSettings();
              },
            ),
          ],
        ),
      ),
    );
  }
}
