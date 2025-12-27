import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<User?> authChanges() => _auth.authStateChanges();

  Future<void> signUp({required String name, required String email, required String password}) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final uid = cred.user!.uid;

    await _db.collection('users').doc(uid).set({
      'email': email.trim(),
      'name': name.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> login({required String email, required String password}) async {
    await _auth.signInWithEmailAndPassword(email: email.trim(), password: password);
  }

  Future<void> resetPassword(String email) => _auth.sendPasswordResetEmail(email: email.trim());

  Future<void> logout() async {
    // Also sign out from Google if the current session used it.
    try {
      await GoogleSignIn().signOut();
    } catch (_) {}
    await _auth.signOut();
  }

  /// Google Sign-In (Android/iOS)
  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return; // user canceled

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCred = await _auth.signInWithCredential(credential);
    final user = userCred.user;
    if (user == null) return;

    await _db.collection('users').doc(user.uid).set({
      'email': user.email ?? '',
      'name': user.displayName ?? 'Google User',
      'photoUrl': user.photoURL ?? '',
      'provider': 'google',
      'updatedAt': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
