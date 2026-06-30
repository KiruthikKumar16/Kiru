import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:kiru/data/datasources/ai_stylist_service.dart';
import 'package:kiru/data/datasources/firestore_trip_datasource.dart';
import 'package:kiru/data/models/trip_model.dart';
import 'package:kiru/data/models/user_profile.dart';
import 'package:kiru/data/models/wardrobe_item.dart';
import 'package:kiru/presentation/providers/service_providers.dart';

final tripsProvider = StateNotifierProvider<TripsNotifier, List<TripModel>>((ref) {
  return TripsNotifier(
    ref.watch(firestoreTripDataSourceProvider),
    ref.watch(aiStylistServiceProvider),
  );
});

class TripsNotifier extends StateNotifier<List<TripModel>> {
  TripsNotifier(this._firestore, this._aiService) : super([]) {
    _loadTrips();
  }

  final FirestoreTripDataSource _firestore;
  final AiStylistService _aiService;
  Box<TripModel>? _box;

  Future<Box<TripModel>> get _tripsBox async {
    _box ??= Hive.box<TripModel>('trips');
    return _box!;
  }

  Future<void> _loadTrips() async {
    final box = await _tripsBox;

    if (box.isEmpty) {
      for (final trip in _seedTrips) {
        await box.put(trip.id, trip);
      }
    }

    state = box.values.toList()
      ..sort((a, b) => a.startDate.compareTo(b.startDate));

    final cloudTrips = await _firestore.fetchTrips();
    if (cloudTrips.isNotEmpty) {
      for (final trip in cloudTrips) {
        await box.put(trip.id, trip);
      }
      state = box.values.toList()
        ..sort((a, b) => a.startDate.compareTo(b.startDate));
    }
  }

  Future<void> addTrip(
    TripModel trip, {
    List<WardrobeItem>? wardrobe,
    UserProfile? profile,
  }) async {
    final outfits = await _aiService.generateDailyOutfits(
      trip: trip,
      wardrobe: wardrobe,
      profile: profile,
    );
    final enriched = trip.copyWith(dailyOutfits: outfits);

    final box = await _tripsBox;
    await box.put(enriched.id, enriched);
    state = [enriched, ...state.where((t) => t.id != enriched.id)]
      ..sort((a, b) => a.startDate.compareTo(b.startDate));

    await _firestore.saveTrip(enriched);
  }

  Future<void> togglePackingItem(String tripId, String itemId) async {
    final box = await _tripsBox;
    final trip = state.firstWhere((t) => t.id == tripId);
    final updatedList = trip.packingList.map((item) {
      if (item.id == itemId) {
        return item.copyWith(isPacked: !item.isPacked);
      }
      return item;
    }).toList();

    final updated = trip.copyWith(packingList: updatedList);
    await box.put(tripId, updated);
    state = state.map((t) => t.id == tripId ? updated : t).toList();
    await _firestore.saveTrip(updated);
  }

  Future<void> deleteTrip(String tripId) async {
    final box = await _tripsBox;
    await box.delete(tripId);
    state = state.where((t) => t.id != tripId).toList();
    await _firestore.deleteTrip(tripId);
  }

  static List<TripModel> get _seedTrips => [
        TripModel(
          id: 't1',
          destination: 'Kyoto',
          country: 'Japan',
          imageUrl:
              'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=800&auto=format&fit=crop',
          startDate: DateTime.now().add(const Duration(days: 14)),
          endDate: DateTime.now().add(const Duration(days: 21)),
          occasion: 'Sightseeing & Culture',
          weatherTemp: '22°C',
          weatherCondition: 'Partly Cloudy',
          isPrivate: true,
          packingList: [
            PackingListItem(
                id: 'p1',
                title: 'Light Jacket / Kimono Layer',
                category: 'Clothing',
                isPacked: true),
            PackingListItem(
                id: 'p2',
                title: 'Walking Shoes',
                category: 'Footwear',
                isPacked: true),
            PackingListItem(
                id: 'p3',
                title: 'Travel Adapter (Type A)',
                category: 'Electronics',
                isPacked: false),
            PackingListItem(
                id: 'p4',
                title: 'Passport & Rail Pass',
                category: 'Documents',
                isPacked: false),
          ],
          dailyOutfits: [
            'Day 1: Arrival & Temple Exploration — Linen Vacation Shirt + Chino Trousers',
            'Day 2: Cultural Walking Tour — Classic Denim Jacket + Canvas Sneakers',
            'Day 3: Sunset Dinner — Floral Midi Dress / Tailored Blazer',
          ],
        ),
        TripModel(
          id: 't2',
          destination: 'Santorini',
          country: 'Greece',
          imageUrl:
              'https://images.unsplash.com/photo-1570077188670-e3a8d69ac5ff?w=800&auto=format&fit=crop',
          startDate: DateTime.now().add(const Duration(days: 45)),
          endDate: DateTime.now().add(const Duration(days: 52)),
          occasion: 'Beach & Resort',
          weatherTemp: '28°C',
          weatherCondition: 'Sunny',
          isPrivate: false,
          packingList: [
            PackingListItem(
                id: 'p5',
                title: 'Linen Shirts & Dresses',
                category: 'Clothing',
                isPacked: false),
            PackingListItem(
                id: 'p6',
                title: 'Sunscreen SPF50',
                category: 'Toiletries',
                isPacked: false),
          ],
          dailyOutfits: [
            'Day 1: Beach arrival — Linen shirt + sandals + sunglasses',
            'Day 2: Island tour — Light dress + sun hat',
          ],
        ),
      ];
}
