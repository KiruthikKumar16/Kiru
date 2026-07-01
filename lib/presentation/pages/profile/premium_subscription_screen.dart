// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:kiru/core/constants/app_spacing.dart';
import 'package:kiru/presentation/widgets/app_button.dart';

class PremiumSubscriptionScreen extends StatelessWidget {
  const PremiumSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kiru Pro Premium', style: TextStyle(fontWeight: FontWeight.bold))),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFF6366F1), Color(0xFFEC4899)]),
                  borderRadius: BorderRadius.all(Radius.circular(AppSpacing.radiusXl)),
                ),
                child: Column(
                  children: const [
                    Icon(Icons.stars, color: Colors.white, size: 50),
                    SizedBox(height: 12),
                    Text('Unlock Unlimited Travel Styling', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('Unlimited AI recommendations, AR try-on, family packing plans & multi-language support.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 14)),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              AppButton(text: 'Subscribe for \$9.99/mo', onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
