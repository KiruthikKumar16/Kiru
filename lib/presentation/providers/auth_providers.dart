import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiru/data/datasources/firebase_auth_datasource.dart';

final firebaseAuthDataSourceProvider = Provider<FirebaseAuthDataSource>((ref) {
  return FirebaseAuthDataSource();
});

final authStateChangesProvider = StreamProvider<User?>((ref) {
  final authDataSource = ref.watch(firebaseAuthDataSourceProvider);
  return authDataSource.authStateChanges;
});

final currentUserProvider = Provider<User?>((ref) {
  final authDataSource = ref.watch(firebaseAuthDataSourceProvider);
  return authDataSource.currentUser;
});
