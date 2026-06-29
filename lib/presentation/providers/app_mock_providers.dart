import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiru/data/models/wardrobe_item.dart';
import 'package:kiru/data/models/trip_model.dart';
import 'package:kiru/data/models/social_post.dart';

// Wardrobe State Provider
final wardrobeItemsProvider = StateNotifierProvider<WardrobeNotifier, List<WardrobeItem>>((ref) {
  return WardrobeNotifier();
});

class WardrobeNotifier extends StateNotifier<List<WardrobeItem>> {
  WardrobeNotifier() : super(_initialItems);

  static final List<WardrobeItem> _initialItems = [
    const WardrobeItem(
      id: 'w1',
      title: 'Linen Vacation Shirt',
      category: 'Tops',
      imageUrl: 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=500&auto=format&fit=crop',
      color: 'White',
      season: 'Summer',
      wearCount: 12,
      cost: 45.0,
    ),
    const WardrobeItem(
      id: 'w2',
      title: 'Classic Denim Jacket',
      category: 'Outerwear',
      imageUrl: 'https://images.unsplash.com/photo-1576995853123-5a10305d93c0?w=500&auto=format&fit=crop',
      color: 'Blue',
      season: 'Autumn',
      wearCount: 24,
      cost: 89.0,
    ),
    const WardrobeItem(
      id: 'w3',
      title: 'Chino Trousers',
      category: 'Bottoms',
      imageUrl: 'https://images.unsplash.com/photo-1473966968600-fa801b869a1a?w=500&auto=format&fit=crop',
      color: 'Beige',
      season: 'All-season',
      wearCount: 18,
      cost: 60.0,
    ),
    const WardrobeItem(
      id: 'w4',
      title: 'Floral Midi Dress',
      category: 'Dresses',
      imageUrl: 'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?w=500&auto=format&fit=crop',
      color: 'Multi',
      season: 'Spring/Summer',
      wearCount: 6,
      cost: 75.0,
    ),
    const WardrobeItem(
      id: 'w5',
      title: 'White Canvas Sneakers',
      category: 'Shoes',
      imageUrl: 'https://images.unsplash.com/photo-1560769629-975ec94e6a86?w=500&auto=format&fit=crop',
      color: 'White',
      season: 'All-season',
      wearCount: 35,
      cost: 65.0,
    ),
    const WardrobeItem(
      id: 'w6',
      title: 'Polarized Sunglasses',
      category: 'Accessories',
      imageUrl: 'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=500&auto=format&fit=crop',
      color: 'Black',
      season: 'Summer',
      wearCount: 40,
      cost: 120.0,
    ),
  ];

  void addItem(WardrobeItem item) {
    state = [...state, item];
  }

  void removeItem(String id) {
    state = state.where((item) => item.id != id).toList();
  }
}

// Trips State Provider
final tripsProvider = StateNotifierProvider<TripsNotifier, List<TripModel>>((ref) {
  return TripsNotifier();
});

class TripsNotifier extends StateNotifier<List<TripModel>> {
  TripsNotifier() : super(_initialTrips);

  static final List<TripModel> _initialTrips = [
    TripModel(
      id: 't1',
      destination: 'Kyoto',
      country: 'Japan',
      imageUrl: 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=800&auto=format&fit=crop',
      startDate: DateTime.now().add(const Duration(days: 14)),
      endDate: DateTime.now().add(const Duration(days: 21)),
      occasion: 'Sightseeing & Culture',
      weatherTemp: '22°C',
      weatherCondition: 'Partly Cloudy',
      isPrivate: true,
      packingList: const [
        PackingListItem(id: 'p1', title: 'Light Jacket / Kimono Layer', category: 'Clothing', isPacked: true),
        PackingListItem(id: 'p2', title: 'Walking Shoes', category: 'Footwear', isPacked: true),
        PackingListItem(id: 'p3', title: 'Travel Adapter (Type A)', category: 'Electronics', isPacked: false),
        PackingListItem(id: 'p4', title: 'Passport & Rail Pass', category: 'Documents', isPacked: false),
      ],
    ),
    TripModel(
      id: 't2',
      destination: 'Santorini',
      country: 'Greece',
      imageUrl: 'https://images.unsplash.com/photo-1570077188670-e3a8d69ac5ff?w=800&auto=format&fit=crop',
      startDate: DateTime.now().add(const Duration(days: 45)),
      endDate: DateTime.now().add(const Duration(days: 52)),
      occasion: 'Beach & Resort',
      weatherTemp: '28°C',
      weatherCondition: 'Sunny',
      isPrivate: false,
      packingList: const [
        PackingListItem(id: 'p5', title: 'Linen Shirts & Dresses', category: 'Clothing', isPacked: false),
        PackingListItem(id: 'p6', title: 'Sunscreen SPF50', category: 'Toiletries', isPacked: false),
      ],
    ),
  ];

  void addTrip(TripModel trip) {
    state = [trip, ...state];
  }

  void togglePackingItem(String tripId, String itemId) {
    state = state.map((trip) {
      if (trip.id == tripId) {
        final updatedList = trip.packingList.map((item) {
          if (item.id == itemId) {
            return item.copyWith(isPacked: !item.isPacked);
          }
          return item;
        }).toList();
        return TripModel(
          id: trip.id,
          destination: trip.destination,
          country: trip.country,
          imageUrl: trip.imageUrl,
          startDate: trip.startDate,
          endDate: trip.endDate,
          occasion: trip.occasion,
          weatherTemp: trip.weatherTemp,
          weatherCondition: trip.weatherCondition,
          packingList: updatedList,
          isPrivate: trip.isPrivate,
        );
      }
      return trip;
    }).toList();
  }
}

// Social Feed Provider
final socialFeedProvider = StateNotifierProvider<SocialFeedNotifier, List<SocialPost>>((ref) {
  return SocialFeedNotifier();
});

class SocialFeedNotifier extends StateNotifier<List<SocialPost>> {
  SocialFeedNotifier() : super(_initialPosts);

  static final List<SocialPost> _initialPosts = [
    const SocialPost(
      id: 'sp1',
      authorName: 'Elena Rostova',
      authorAvatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150&auto=format&fit=crop',
      imageUrl: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=800&auto=format&fit=crop',
      caption: 'Sunset strolls in Amalfi! Paired my breathable linen trousers with leather sandals. 🍋✨',
      destination: 'Amalfi Coast, Italy',
      likes: 142,
      comments: 18,
    ),
    const SocialPost(
      id: 'sp2',
      authorName: 'Marcus Chen',
      authorAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&auto=format&fit=crop',
      imageUrl: 'https://images.unsplash.com/photo-1490481651871-ab68de25d43d?w=800&auto=format&fit=crop',
      caption: 'Help me choose my dinner outfit in Paris tonight! Left or Right?',
      destination: 'Paris, France',
      likes: 89,
      comments: 34,
      isVote: true,
      optionA: 'Option A: Trench + Oxford',
      optionB: 'Option B: Leather + Chinos',
    ),
  ];

  void toggleLike(String id) {
    state = state.map((post) {
      if (post.id == id) {
        return SocialPost(
          id: post.id,
          authorName: post.authorName,
          authorAvatar: post.authorAvatar,
          imageUrl: post.imageUrl,
          caption: post.caption,
          destination: post.destination,
          likes: post.isLiked ? post.likes - 1 : post.likes + 1,
          comments: post.comments,
          isLiked: !post.isLiked,
          isVote: post.isVote,
          optionA: post.optionA,
          optionB: post.optionB,
        );
      }
      return post;
    }).toList();
  }
}
