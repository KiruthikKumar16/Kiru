import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// Uploads wardrobe images to Firebase Storage when authenticated.
/// Falls back to local file path when upload fails or user is offline.
class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadWardrobeImage(File file, String itemId) async {
    final user = _auth.currentUser;
    if (user == null) return file.path;

    try {
      final ref = _storage.ref().child('users/${user.uid}/wardrobe/$itemId.jpg');
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (_) {
      return file.path;
    }
  }
}
