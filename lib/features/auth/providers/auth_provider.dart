import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../data/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _service = AuthService();

  User? _user;
  StreamSubscription<User?>? _sub;

  AuthProvider() {
    _sub = _service.authChanges().listen((u) {
      _user = u;
      notifyListeners();
    });
  }

  String? get userId => _user?.uid;
  String? get email => _user?.email;
  bool get isLoggedIn => _user != null;

  Future<void> signUp(String name, String email, String password) => _service.signUp(name: name, email: email, password: password);
  Future<void> login(String email, String password) => _service.login(email: email, password: password);
  Future<void> resetPassword(String email) => _service.resetPassword(email);
  Future<void> logout() => _service.logout();

  Future<void> loginWithGoogle() => _service.signInWithGoogle();

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
