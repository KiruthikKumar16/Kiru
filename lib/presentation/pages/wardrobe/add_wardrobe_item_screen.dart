import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kiru/core/constants/app_spacing.dart';
import 'package:kiru/core/constants/app_colors.dart';
import 'package:kiru/data/models/wardrobe_item.dart';
import 'package:kiru/presentation/providers/app_mock_providers.dart';
import 'package:kiru/presentation/widgets/app_button.dart';
import 'package:kiru/presentation/widgets/app_input_field.dart';

class AddWardrobeItemScreen extends ConsumerStatefulWidget {
  const AddWardrobeItemScreen({super.key});

  @override
  ConsumerState<AddWardrobeItemScreen> createState() => _AddWardrobeItemScreenState();
}

class _AddWardrobeItemScreenState extends ConsumerState<AddWardrobeItemScreen> {
  final _titleController = TextEditingController();
  String _category = 'Tops';
  String _color = 'White';
  String _season = 'Summer';

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _addItem() {
    if (_titleController.text.isEmpty) return;

    final item = WardrobeItem(
      id: 'w_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text,
      category: _category,
      imageUrl: 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=500&auto=format&fit=crop',
      color: _color,
      season: _season,
      wearCount: 0,
      cost: 49.0,
    );

    ref.read(wardrobeItemsProvider.notifier).addItem(item);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Wardrobe Item', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo Picker Card Placeholder with EXIF info notice
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  border: Border.all(color: AppColors.border, style: BorderStyle.solid),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.camera_alt_outlined, size: 48, color: AppColors.primary),
                    SizedBox(height: 8),
                    Text('Tap to take photo or pick from gallery', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    SizedBox(height: 4),
                    Text('🔒 Auto-stripping EXIF metadata for privacy', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              AppInputField(
                controller: _titleController,
                labelText: 'Item Name',
                hintText: 'e.g. Vintage Silk Blazer, Blue Slim Jeans',
              ),
              const SizedBox(height: AppSpacing.lg),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: ['Tops', 'Bottoms', 'Dresses', 'Outerwear', 'Shoes', 'Accessories'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() => _category = v!),
              ),
              const SizedBox(height: AppSpacing.lg),
              DropdownButtonFormField<String>(
                value: _season,
                decoration: const InputDecoration(labelText: 'Seasonality'),
                items: ['Summer', 'Winter', 'Spring/Autumn', 'All-season'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) => setState(() => _season = v!),
              ),
              const SizedBox(height: AppSpacing.xxl),
              AppButton(
                text: 'Save to Virtual Wardrobe',
                onPressed: _addItem,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
