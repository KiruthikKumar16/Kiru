import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kiru/core/constants/app_spacing.dart';
import 'package:kiru/core/constants/app_colors.dart';
import 'package:kiru/presentation/providers/app_mock_providers.dart';

class PostDetailScreen extends ConsumerStatefulWidget {
  final String postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  ConsumerState<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends ConsumerState<PostDetailScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(socialFeedProvider);
    final post = posts.firstWhere((p) => p.id == widget.postId, orElse: () => posts.first);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Share Post',
            onPressed: () {
              HapticFeedback.lightImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share post coming soon!')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Author header
                    InkWell(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        context.push('/user/u1');
                      },
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(post.authorAvatar),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            post.authorName,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    // Post image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                      child: Image.network(
                        post.imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    // Action bar
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            post.isLiked ? Icons.favorite : Icons.favorite_border,
                            color: post.isLiked ? AppColors.error : AppColors.textPrimary,
                          ),
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            ref.read(socialFeedProvider.notifier).toggleLike(post.id);
                          },
                        ),
                        Text('${post.likes}'),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: const Icon(Icons.chat_bubble_outline, size: 22),
                          onPressed: () {},
                        ),
                        Text('${post.comments}'),
                        const SizedBox(width: 16),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    // Caption
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                        children: [
                          TextSpan(text: '${post.authorName} ', style: const TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: post.caption),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    // Likes
                    if (post.likes > 0)
                      InkWell(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Likes list coming soon!')),
                          );
                        },
                        child: Text(
                          'Liked by ${post.likes} people',
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    const SizedBox(height: AppSpacing.xl),
                    // Comments section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Comments (${post.comments})',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    // Dummy comments
                    ...[
                      {
                        'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
                        'name': 'Marcus Chen',
                        'text': 'Super stylish! Adding this linen outfit to my wishlist.',
                      },
                      {
                        'avatar': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150',
                        'name': 'Sophie Wong',
                        'text': 'So gorgeous! That sunset in Amalfi is perfect.',
                      },
                    ].map((comment) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundImage: NetworkImage(comment['avatar'] as String),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                                  children: [
                                    TextSpan(
                                      text: '${comment['name']} ',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(text: comment['text'] as String),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            // Comment input
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: SafeArea(
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage('https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText: 'Add a comment...',
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                          fillColor: AppColors.surface,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(color: AppColors.border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide(color: AppColors.primary),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    TextButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Comment posted!')),
                        );
                        _commentController.clear();
                      },
                      child: const Text('Post'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
