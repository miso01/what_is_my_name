import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User> signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    return authResult.user;
  }

  bool isSignedIn() {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser != null;
  }

  User getUser() {
    return _firebaseAuth.currentUser;
  }
}
