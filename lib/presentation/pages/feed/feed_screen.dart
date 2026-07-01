import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kiru/core/constants/app_spacing.dart';
import 'package:kiru/core/constants/app_colors.dart';
import 'package:kiru/core/routes/app_routes.dart';
import 'package:kiru/presentation/providers/app_mock_providers.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(socialFeedProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Travel Style Feed', style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {
                HapticFeedback.lightImpact();
                context.push(AppRoutes.notifications);
              },
            ),
            IconButton(
              icon: const Icon(Icons.send_outlined),
              onPressed: () {
                HapticFeedback.lightImpact();
                context.push(AppRoutes.messages);
              },
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
          onPressed: () {
            HapticFeedback.lightImpact();
            context.push(AppRoutes.createPost);
          },
        ),
        body: TabBarView(
          children: [
            posts.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.feed_outlined, size: 64, color: AppColors.primary.withValues(alpha: 0.5)),
                          const SizedBox(height: AppSpacing.md),
                          Text('No posts in your feed yet', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.textSecondary)),
                          const SizedBox(height: AppSpacing.lg),
                          FilledButton.icon(
                            onPressed: () {
                              HapticFeedback.lightImpact();
                            },
                            icon: const Icon(Icons.explore_outlined),
                            label: const Text('Discover'),
                          ),
                        ],
                      ),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      HapticFeedback.lightImpact();
                    },
                    child: ListView.builder(
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
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    context.push('/user/u1');
                                  },
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
                                              Row(
                                                children: [
                                                  Text(post.destination, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                                  const SizedBox(width: 8),
                                                  const Text('•', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                                                  const SizedBox(width: 8),
                                                  const Text('2h ago', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                                                ],
                                              ),
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
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    context.push('/post/${post.id}');
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                                    child: AspectRatio(
                                      aspectRatio: 4 / 5,
                                      child: Image.network(
                                        post.imageUrl,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
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
                                            onPressed: () {
                                              HapticFeedback.lightImpact();
                                              ref.read(socialFeedProvider.notifier).toggleLike(post.id);
                                            },
                                          ),
                                          Text('${post.likes}'),
                                          const SizedBox(width: 16),
                                          IconButton(
                                            icon: const Icon(Icons.chat_bubble_outline, size: 22),
                                            onPressed: () {
                                              HapticFeedback.lightImpact();
                                              context.push('/post/${post.id}');
                                            },
                                          ),
                                          Text('${post.comments}'),
                                          const SizedBox(width: 16),
                                          IconButton(
                                            icon: const Icon(Icons.share_outlined, size: 22),
                                            onPressed: () {
                                              HapticFeedback.lightImpact();
                                            },
                                          ),
                                          const Spacer(),
                                          IconButton(
                                            icon: Icon(
                                              post.isSaved ? Icons.bookmark : Icons.bookmark_border,
                                              color: post.isSaved ? AppColors.primary : AppColors.textPrimary,
                                            ),
                                            onPressed: () {
                                              HapticFeedback.lightImpact();
                                              ref.read(socialFeedProvider.notifier).toggleSave(post.id);
                                            },
                                          ),
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
                                      const SizedBox(height: 8),
                                      if (post.comments > 0)
                                        Text(
                                          'View all ${post.comments} comments',
                                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
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
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.white,
                                                  foregroundColor: Colors.black,
                                                  minimumSize: const Size(double.infinity, 38),
                                                ),
                                                onPressed: () {
                                                  HapticFeedback.lightImpact();
                                                },
                                                child: Text(post.optionA ?? 'Option A'),
                                              ),
                                              const SizedBox(height: 6),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.white,
                                                  foregroundColor: Colors.black,
                                                  minimumSize: const Size(double.infinity, 38),
                                                ),
                                                onPressed: () {
                                                  HapticFeedback.lightImpact();
                                                },
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
                  ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.explore_outlined, size: 64, color: AppColors.primary),
                  const SizedBox(height: AppSpacing.md),
                  const Text('Discover destination outfit feeds'),
                  const SizedBox(height: AppSpacing.lg),
                  FilledButton.icon(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      context.push(AppRoutes.discover);
                    },
                    icon: const Icon(Icons.travel_explore),
                    label: const Text('Browse Destinations'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
