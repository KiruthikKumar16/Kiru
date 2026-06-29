import 'package:flutter/material.dart';
import 'package:kiru/core/constants/app_colors.dart';
import 'package:kiru/core/constants/app_spacing.dart';
import 'package:kiru/presentation/widgets/app_button.dart';

class WardrobeItemDetailScreen extends StatelessWidget {
  final String itemId;

  const WardrobeItemDetailScreen({super.key, required this.itemId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.delete_outline, color: AppColors.error), onPressed: () {}),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                child: Image.network(
                  'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=800&auto=format&fit=crop',
                  height: 280,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const Text('Linen Vacation Shirt', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              const Text('Category: Tops • Color: White • Season: Summer', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              const SizedBox(height: AppSpacing.xl),

              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Column(children: [Text('12x', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary)), Text('Times Worn', style: TextStyle(fontSize: 12, color: AppColors.textSecondary))]),
                    Column(children: [Text('\$3.75', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary)), Text('Cost-per-Wear', style: TextStyle(fontSize: 12, color: AppColors.textSecondary))]),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text('AI Outfit Pairings', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: AppSpacing.md),
              const ListTile(
                leading: Icon(Icons.auto_awesome, color: AppColors.primary),
                title: Text('Pairs perfectly with Chino Trousers & Canvas Sneakers'),
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                text: '🤝 Loan Item to Friend',
                type: AppButtonType.secondary,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
