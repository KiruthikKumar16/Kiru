import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kiru/core/constants/app_spacing.dart';
import 'package:kiru/core/constants/app_colors.dart';
import 'package:kiru/core/utils/exif_helper.dart';
import 'package:kiru/data/models/wardrobe_item.dart';
import 'package:kiru/presentation/providers/app_mock_providers.dart';
import 'package:kiru/presentation/providers/service_providers.dart';
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
  File? _imageFile;
  bool _isSaving = false;
  final ImagePicker _picker = ImagePicker();

  static const _colors = [
    'White', 'Black', 'Blue', 'Beige', 'Red', 'Green', 'Pink', 'Multi', 'Grey', 'Brown',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() => _imageFile = File(pickedFile.path));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to pick image: $e')),
        );
      }
    }
  }

  Future<void> _addItem() async {
    if (_titleController.text.isEmpty) return;

    setState(() => _isSaving = true);
    final itemId = 'w_${DateTime.now().millisecondsSinceEpoch}';
    String finalImageUrl =
        'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?w=500&auto=format&fit=crop';

    if (_imageFile != null) {
      try {
        final strippedFile = await ExifHelper.stripExif(_imageFile!);
        finalImageUrl = await ref
            .read(firebaseStorageServiceProvider)
            .uploadWardrobeImage(strippedFile, itemId);
      } catch (e) {
        finalImageUrl = _imageFile!.path;
      }
    }

    final item = WardrobeItem(
      id: itemId,
      title: _titleController.text.trim(),
      category: _category,
      imageUrl: finalImageUrl,
      color: _color,
      season: _season,
      wearCount: 0,
      cost: 49.0,
    );

    await ref.read(wardrobeItemsProvider.notifier).addItem(item);
    if (mounted) {
      context.pop();
    }
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
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => SafeArea(
                      child: Wrap(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.photo_library),
                            title: const Text('Pick from Gallery'),
                            onTap: () {
                              Navigator.pop(context);
                              _pickImage(ImageSource.gallery);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.camera_alt),
                            title: const Text('Take Photo'),
                            onTap: () {
                              Navigator.pop(context);
                              _pickImage(ImageSource.camera);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    border: Border.all(color: AppColors.border),
                    image: _imageFile != null
                        ? DecorationImage(image: FileImage(_imageFile!), fit: BoxFit.cover)
                        : null,
                  ),
                  child: _imageFile == null
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt_outlined, size: 48, color: AppColors.primary),
                            SizedBox(height: 8),
                            Text('Tap to take photo or pick from gallery',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            SizedBox(height: 4),
                            Text('🔒 Auto-stripping EXIF metadata for privacy',
                                style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          ],
                        )
                      : null,
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
                initialValue: _category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: ['Tops', 'Bottoms', 'Dresses', 'Outerwear', 'Shoes', 'Accessories']
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _category = v!),
              ),
              const SizedBox(height: AppSpacing.lg),
              DropdownButtonFormField<String>(
                initialValue: _color,
                decoration: const InputDecoration(labelText: 'Color'),
                items: _colors.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() => _color = v!),
              ),
              const SizedBox(height: AppSpacing.lg),
              DropdownButtonFormField<String>(
                initialValue: _season,
                decoration: const InputDecoration(labelText: 'Seasonality'),
                items: ['Summer', 'Winter', 'Spring/Autumn', 'All-season']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setState(() => _season = v!),
              ),
              const SizedBox(height: AppSpacing.xxl),
              AppButton(
                text: 'Save to Virtual Wardrobe',
                onPressed: _addItem,
                isLoading: _isSaving,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
