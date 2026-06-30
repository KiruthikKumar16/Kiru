import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

/// Notifies GoRouter when Firebase auth state changes so redirects re-run.
class AuthRefreshNotifier extends ChangeNotifier {
  AuthRefreshNotifier() {
    FirebaseAuth.instance.authStateChanges().listen((_) => notifyListeners());
  }
}
