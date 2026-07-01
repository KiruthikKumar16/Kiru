import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:kiru/data/models/user_profile.dart';

final userProfileProvider = StateNotifierProvider<ProfileNotifier, UserProfile?>((ref) {
  return ProfileNotifier();
});

class ProfileNotifier extends StateNotifier<UserProfile?> {
  ProfileNotifier() : super(null) {
    _loadProfile();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        state = null;
      } else {
        _loadProfile();
      }
    });
  }

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> _loadProfile() async {
    final user = _auth.currentUser;
    if (user == null) {
      state = null;
      return;
    }

    final box = Hive.box('settings');
    final localData = box.get('profile_${user.uid}');
    if (localData != null) {
      final map = Map<String, dynamic>.from(localData as Map);
      state = UserProfile.fromMap(map);
    } else {
      state = UserProfile(
        uid: user.uid,
        username: user.email?.split('@').first ?? 'username',
        displayName: user.displayName ?? 'New User',
        photoUrl: user.photoURL ??
            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300&auto=format&fit=crop',
        bio: 'Minimalist Adventurer',
        bodyShape: 'Hourglass',
        undertone: 'Warm Undertone',
      );
    }

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data() != null) {
        final profile = UserProfile.fromMap(doc.data()!);
        state = profile;
        await box.put('profile_${user.uid}', profile.toMap());
      }
    } catch (_) {}
  }

  Future<void> createProfileForUser(User user) async {
    final profile = UserProfile(
      uid: user.uid,
      username: user.email?.split('@').first ?? 'user_${user.uid.substring(0, 6)}',
      displayName: user.displayName ?? 'New User',
      photoUrl: user.photoURL ??
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300&auto=format&fit=crop',
      bio: 'Minimalist Adventurer',
      bodyShape: 'Hourglass',
      undertone: 'Warm Undertone',
    );

    state = profile;
    await _persist(profile);
  }

  Future<void> updateProfile({
    String? displayName,
    String? username,
    String? bio,
    String? photoUrl,
    String? bodyShape,
    String? undertone,
    String? stylePersona,
    List<String>? stylePreferences,
    List<String>? favoriteColors,
    BodyMeasurements? measurements,
    bool? culturalSensitivity,
    bool? modestFashion,
  }) async {
    final current = state;
    if (current == null) return;

    final updated = current.copyWith(
      displayName: displayName,
      username: username,
      bio: bio,
      photoUrl: photoUrl,
      bodyShape: bodyShape,
      undertone: undertone,
      stylePersona: stylePersona,
      stylePreferences: stylePreferences,
      favoriteColors: favoriteColors,
      measurements: measurements,
      culturalSensitivity: culturalSensitivity,
      modestFashion: modestFashion,
    );

    state = updated;
    await _persist(updated);
  }

  Future<void> _persist(UserProfile profile) async {
    final box = Hive.box('settings');
    await box.put('profile_${profile.uid}', profile.toMap());

    try {
      await _firestore.collection('users').doc(profile.uid).set(
            profile.toMap(),
            SetOptions(merge: true),
          );
    } catch (_) {}
  }

  Future<void> reload() => _loadProfile();
}
