import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kiru/core/constants/app_colors.dart';
import 'package:kiru/core/constants/app_spacing.dart';
import 'package:kiru/presentation/widgets/app_button.dart';
import 'package:kiru/presentation/providers/app_mock_providers.dart';

class WardrobeItemDetailScreen extends ConsumerWidget {
  final String itemId;

  const WardrobeItemDetailScreen({super.key, required this.itemId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(wardrobeItemsProvider);
    final item = items.firstWhere(
      (i) => i.id == itemId,
      orElse: () => items.first,
    );

    final isLocalFile = !item.imageUrl.startsWith('http');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            onPressed: () async {
              await ref.read(wardrobeItemsProvider.notifier).removeItem(item.id);
              if (context.mounted) {
                context.pop();
              }
            },
          ),
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
                child: isLocalFile
                    ? Image.file(
                        File(item.imageUrl),
                        height: 280,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        item.imageUrl,
                        height: 280,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(item.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Category: ${item.category} • Color: ${item.color} • Season: ${item.season}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
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
                  children: [
                    Column(children: [Text('${item.wearCount}x', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary)), const Text('Times Worn', style: TextStyle(fontSize: 12, color: AppColors.textSecondary))]),
                    Column(children: [Text('\$${(item.cost / (item.wearCount > 0 ? item.wearCount : 1)).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary)), const Text('Cost-per-Wear', style: TextStyle(fontSize: 12, color: AppColors.textSecondary))]),
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
