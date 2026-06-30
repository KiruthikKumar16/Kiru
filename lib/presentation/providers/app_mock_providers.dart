import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:kiru/data/models/wardrobe_item.dart';
import 'package:kiru/data/models/social_post.dart';

// Wardrobe State Provider
final wardrobeItemsProvider =
    StateNotifierProvider<WardrobeNotifier, List<WardrobeItem>>((ref) {
  return WardrobeNotifier();
});

class WardrobeNotifier extends StateNotifier<List<WardrobeItem>> {
  final Box<WardrobeItem> _box = Hive.box<WardrobeItem>('wardrobe_items');

  WardrobeNotifier() : super([]) {
    _loadItems();
  }

  void _loadItems() {
    if (_box.isEmpty) {
      for (final item in _initialItems) {
        _box.put(item.id, item);
      }
    }
    state = _box.values.toList();
  }

  static final List<WardrobeItem> _initialItems = [
    WardrobeItem(
      id: 'w1',
      title: 'Linen Vacation Shirt',
      category: 'Tops',
      imageUrl:
          'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=500&auto=format&fit=crop',
      color: 'White',
      season: 'Summer',
      wearCount: 12,
      cost: 45.0,
    ),
    WardrobeItem(
      id: 'w2',
      title: 'Classic Denim Jacket',
      category: 'Outerwear',
      imageUrl:
          'https://images.unsplash.com/photo-1576995853123-5a10305d93c0?w=500&auto=format&fit=crop',
      color: 'Blue',
      season: 'Autumn',
      wearCount: 24,
      cost: 89.0,
    ),
    WardrobeItem(
      id: 'w3',
      title: 'Chino Trousers',
      category: 'Bottoms',
      imageUrl:
          'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=500&auto=format&fit=crop',
      color: 'Beige',
      season: 'All-season',
      wearCount: 18,
      cost: 60.0,
    ),
    WardrobeItem(
      id: 'w4',
      title: 'Floral Midi Dress',
      category: 'Dresses',
      imageUrl:
          'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?w=500&auto=format&fit=crop',
      color: 'Multi',
      season: 'Spring/Summer',
      wearCount: 6,
      cost: 75.0,
    ),
    WardrobeItem(
      id: 'w5',
      title: 'White Canvas Sneakers',
      category: 'Shoes',
      imageUrl:
          'https://images.unsplash.com/photo-1560769629-975ec94e6a86?w=500&auto=format&fit=crop',
      color: 'White',
      season: 'All-season',
      wearCount: 35,
      cost: 65.0,
    ),
    WardrobeItem(
      id: 'w6',
      title: 'Polarized Sunglasses',
      category: 'Accessories',
      imageUrl:
          'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=500&auto=format&fit=crop',
      color: 'Black',
      season: 'Summer',
      wearCount: 40,
      cost: 120.0,
    ),
  ];

  Future<void> addItem(WardrobeItem item) async {
    await _box.put(item.id, item);
    state = _box.values.toList();
  }

  Future<void> updateItem(WardrobeItem item) async {
    await _box.put(item.id, item);
    state = _box.values.toList();
  }

  Future<void> removeItem(String id) async {
    await _box.delete(id);
    state = _box.values.toList();
  }
}

// Social Feed Provider (local persistence via Hive settings box)
final socialFeedProvider =
    StateNotifierProvider<SocialFeedNotifier, List<SocialPost>>((ref) {
  return SocialFeedNotifier();
});

class SocialFeedNotifier extends StateNotifier<List<SocialPost>> {
  SocialFeedNotifier() : super([]) {
    _loadPosts();
  }

  static const _hiveKey = 'social_feed_posts';

  void _loadPosts() {
    final box = Hive.box('settings');
    final stored = box.get(_hiveKey);
    if (stored != null) {
      final list = (stored as List)
          .map((p) => SocialPost.fromMap(Map<String, dynamic>.from(p as Map)))
          .toList();
      state = list;
    } else {
      state = _initialPosts;
      _savePosts();
    }
  }

  Future<void> _savePosts() async {
    final box = Hive.box('settings');
    await box.put(_hiveKey, state.map((p) => p.toMap()).toList());
  }

  static final List<SocialPost> _initialPosts = [
    SocialPost(
      id: 'sp1',
      authorName: 'Elena Rostova',
      authorAvatar:
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&auto=format&fit=crop',
      imageUrl:
          'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=800&auto=format&fit=crop',
      caption:
          'Sunset strolls in Amalfi! Paired my breathable linen trousers with leather sandals. 🍋✨',
      destination: 'Amalfi Coast, Italy',
      likes: 142,
      comments: 18,
    ),
    SocialPost(
      id: 'sp2',
      authorName: 'Marcus Chen',
      authorAvatar:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&auto=format&fit=crop',
      imageUrl:
          'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=800&auto=format&fit=crop',
      caption: 'Help me choose my dinner outfit in Paris tonight! Left or Right?',
      destination: 'Paris, France',
      likes: 89,
      comments: 34,
      isVote: true,
      optionA: 'Option A: Trench + Oxford',
      optionB: 'Option B: Leather + Chinos',
    ),
  ];

  Future<void> addPost(SocialPost post) async {
    state = [post, ...state];
    await _savePosts();
  }

  void toggleLike(String id) {
    state = state.map((post) {
      if (post.id == id) {
        return post.copyWith(
          likes: post.isLiked ? post.likes - 1 : post.likes + 1,
          isLiked: !post.isLiked,
        );
      }
      return post;
    }).toList();
    _savePosts();
  }
}
