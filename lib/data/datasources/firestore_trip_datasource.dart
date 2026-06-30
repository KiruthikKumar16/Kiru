import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kiru/data/models/trip_model.dart';

class FirestoreTripDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>>? get _tripsRef {
    final uid = _uid;
    if (uid == null) return null;
    return _firestore.collection('users').doc(uid).collection('trips');
  }

  Future<List<TripModel>> fetchTrips() async {
    final ref = _tripsRef;
    if (ref == null) return [];

    try {
      final snapshot = await ref.orderBy('startDate', descending: false).get();
      return snapshot.docs.map(_fromFirestore).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveTrip(TripModel trip) async {
    final ref = _tripsRef;
    if (ref == null) return;

    try {
      await ref.doc(trip.id).set(_toFirestore(trip), SetOptions(merge: true));
    } catch (_) {}
  }

  Future<void> deleteTrip(String tripId) async {
    final ref = _tripsRef;
    if (ref == null) return;

    try {
      await ref.doc(tripId).delete();
    } catch (_) {}
  }

  Map<String, dynamic> _toFirestore(TripModel trip) {
    return {
      'id': trip.id,
      'destination': trip.destination,
      'country': trip.country,
      'imageUrl': trip.imageUrl,
      'startDate': Timestamp.fromDate(trip.startDate),
      'endDate': Timestamp.fromDate(trip.endDate),
      'occasion': trip.occasion,
      'weatherTemp': trip.weatherTemp,
      'weatherCondition': trip.weatherCondition,
      'isPrivate': trip.isPrivate,
      'hideDates': trip.hideDates,
      'hideLocation': trip.hideLocation,
      'dailyOutfits': trip.dailyOutfits,
      'packingList': trip.packingList
          .map((p) => {
                'id': p.id,
                'title': p.title,
                'category': p.category,
                'isPacked': p.isPacked,
              })
          .toList(),
    };
  }

  TripModel _fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    final packingRaw = data['packingList'] as List<dynamic>? ?? [];
    return TripModel(
      id: data['id'] as String? ?? doc.id,
      destination: data['destination'] as String? ?? '',
      country: data['country'] as String? ?? '',
      imageUrl: data['imageUrl'] as String? ?? '',
      startDate: (data['startDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endDate: (data['endDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      occasion: data['occasion'] as String? ?? 'Vacation',
      weatherTemp: data['weatherTemp'] as String? ?? '',
      weatherCondition: data['weatherCondition'] as String? ?? '',
      isPrivate: data['isPrivate'] as bool? ?? true,
      hideDates: data['hideDates'] as bool? ?? true,
      hideLocation: data['hideLocation'] as bool? ?? true,
      dailyOutfits: (data['dailyOutfits'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      packingList: packingRaw
          .map((p) => PackingListItem(
                id: p['id'] as String,
                title: p['title'] as String,
                category: p['category'] as String,
                isPacked: p['isPacked'] as bool? ?? false,
              ))
          .toList(),
    );
  }
}
