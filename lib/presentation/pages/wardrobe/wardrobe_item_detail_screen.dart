// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kiru/core/constants/app_colors.dart';
import 'package:kiru/core/constants/app_spacing.dart';
import 'package:kiru/presentation/widgets/app_button.dart';
import 'package:kiru/presentation/providers/app_mock_providers.dart';
import 'package:kiru/presentation/widgets/app_network_image.dart';

class WardrobeItemDetailScreen extends ConsumerStatefulWidget {
  final String itemId;
  const WardrobeItemDetailScreen({super.key, required this.itemId});

  @override
  ConsumerState<WardrobeItemDetailScreen> createState() => _WardrobeItemDetailScreenState();
}

class _WardrobeItemDetailScreenState extends ConsumerState<WardrobeItemDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final items = ref.watch(wardrobeItemsProvider);
    final item = items.firstWhere(
      (i) => i.id == widget.itemId,
      orElse: () => items.first,
    );

    final isLocalFile = !item.imageUrl.startsWith('http');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit Item',
            onPressed: () {
              HapticFeedback.lightImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Edit Item coming soon!')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            onPressed: () async {
              _showDeleteConfirmation();
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
                    : AppNetworkImage(
                        imageUrl: item.imageUrl,
                        height: 280,
                        width: double.infinity,
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
              AppButton(
                text: 'Log Wear',
                onPressed: () {
                  HapticFeedback.lightImpact();
                  ref.read(wardrobeItemsProvider.notifier).logWear(item.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Logged wear for ${item.title}')),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.md),
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
                onPressed: () {
                  HapticFeedback.lightImpact();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Loan Item coming soon!')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              HapticFeedback.lightImpact();
              await ref.read(wardrobeItemsProvider.notifier).removeItem(widget.itemId);
              if (mounted) {
                context.pop();
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
