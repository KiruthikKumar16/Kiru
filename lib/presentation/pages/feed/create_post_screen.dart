import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kiru/core/constants/app_colors.dart';
import 'package:kiru/core/constants/app_spacing.dart';
import 'package:kiru/presentation/widgets/app_button.dart';
import 'package:kiru/presentation/widgets/app_input_field.dart';

enum PostType { outfit, trip, vote }

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _captionController = TextEditingController();
  PostType _postType = PostType.outfit;

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Post', style: TextStyle(fontWeight: FontWeight.bold))),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Choose Post Type', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: _PostTypeCard(
                      icon: Icons.checkroom_outlined,
                      title: 'Outfit Post',
                      selected: _postType == PostType.outfit,
                      onTap: () => setState(() => _postType = PostType.outfit),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _PostTypeCard(
                      icon: Icons.flight_takeoff_outlined,
                      title: 'Trip Post',
                      selected: _postType == PostType.trip,
                      onTap: () => setState(() => _postType = PostType.trip),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _PostTypeCard(
                icon: Icons.poll_outlined,
                title: 'Outfit Vote (2 Options)',
                selected: _postType == PostType.vote,
                onTap: () => setState(() => _postType = PostType.vote),
                isWide: true,
              ),
              const SizedBox(height: AppSpacing.xl),
              Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_photo_alternate_outlined, size: 40, color: AppColors.primary),
                    SizedBox(height: 8),
                    Text('Select photo to post', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppInputField(
                controller: _captionController,
                labelText: 'Caption ${_postType == PostType.outfit || _postType == PostType.trip ? '& Destination' : ''}',
                hintText: _postType == PostType.vote
                    ? 'e.g. Which outfit should I wear in Paris tonight?'
                    : 'e.g. Exploring Paris wearing Kiru outfit pairing...',
              ),
              if (_postType == PostType.vote) ...[
                const SizedBox(height: AppSpacing.lg),
                AppInputField(
                  labelText: 'Option A',
                  hintText: 'e.g. Trench Coat + Oxfords',
                ),
                const SizedBox(height: AppSpacing.md),
                AppInputField(
                  labelText: 'Option B',
                  hintText: 'e.g. Leather Jacket + Chinos',
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                text: 'Publish Post to Community',
                onPressed: () => context.pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PostTypeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool selected;
  final VoidCallback onTap;
  final bool isWide;

  const _PostTypeCard({
    required this.icon,
    required this.title,
    required this.selected,
    required this.onTap,
    this.isWide = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: isWide ? 80 : 100,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: selected ? AppColors.primary : AppColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: selected ? AppColors.primary : AppColors.textSecondary, size: 32),
            const SizedBox(height: 8),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: selected ? AppColors.primary : AppColors.textPrimary, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
