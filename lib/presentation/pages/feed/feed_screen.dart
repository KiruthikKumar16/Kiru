import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kiru/core/constants/app_spacing.dart';
import 'package:kiru/core/constants/app_colors.dart';
import 'package:kiru/core/routes/app_routes.dart';
import 'package:kiru/presentation/providers/app_mock_providers.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(socialFeedProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Travel Style Feed', style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () => context.push(AppRoutes.notifications),
            ),
            IconButton(
              icon: const Icon(Icons.send_outlined),
              onPressed: () => context.push(AppRoutes.messages),
            ),
          ],
          bottom: const TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            tabs: [
              Tab(text: 'Following'),
              Tab(text: 'Discover Destinations'),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.add_a_photo, color: Colors.white),
          onPressed: () => context.push(AppRoutes.createPost),
        ),
        body: TabBarView(
          children: [
            ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Author Header
                        InkWell(
                          onTap: () => context.push('/user/u1'),
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(post.authorAvatar),
                                  radius: 20,
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(post.authorName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                                      Text(post.destination, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                    ],
                                  ),
                                ),
                                IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
                              ],
                            ),
                          ),
                        ),
                        // Post Image
                        InkWell(
                          onTap: () => context.push('/post/${post.id}'),
                          child: ClipRRect(
                            child: Image.network(
                              post.imageUrl,
                              height: 280,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // Action Bar & Caption
                        Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      post.isLiked ? Icons.favorite : Icons.favorite_border,
                                      color: post.isLiked ? AppColors.error : AppColors.textPrimary,
                                    ),
                                    onPressed: () => ref.read(socialFeedProvider.notifier).toggleLike(post.id),
                                  ),
                                  Text('${post.likes}'),
                                  const SizedBox(width: 16),
                                  IconButton(
                                    icon: const Icon(Icons.chat_bubble_outline, size: 22),
                                    onPressed: () => context.push('/post/${post.id}'),
                                  ),
                                  Text('${post.comments}'),
                                  const Spacer(),
                                  const Icon(Icons.bookmark_border, size: 24),
                                ],
                              ),
                              const SizedBox(height: 8),
                              RichText(
                                text: TextSpan(
                                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                                  children: [
                                    TextSpan(text: '${post.authorName} ', style: const TextStyle(fontWeight: FontWeight.bold)),
                                    TextSpan(text: post.caption),
                                  ],
                                ),
                              ),
                              if (post.isVote) ...[
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.05),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('🗳️ Community Vote', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                                      const SizedBox(height: 8),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 38)),
                                        onPressed: () {},
                                        child: Text(post.optionA ?? 'Option A'),
                                      ),
                                      const SizedBox(height: 6),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 38)),
                                        onPressed: () {},
                                        child: Text(post.optionB ?? 'Option B'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const Center(
              child: Text('Discover Paris, Tokyo & Bali outfit feeds...'),
            ),
          ],
        ),
      ),
    );
  }
}
