import 'auth_abstract.dart';
import 'dart:async';


class DummyAuthService implements AuthService {
  String? _currentUser;
  final Map<String, String> _users = {};

  @override
  Future<void> signUp(String email, String password) async {
    if (_users.containsKey(email)) {
      throw Exception('User already exists');
    }
    _users[email] = password;
  }

  @override
  Future<void> signIn(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2)); // Add a delay of 2 seconds
    if (_users[email] != password) {
      throw Exception('Invalid email or password');
    }
    _currentUser = email;
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
  }

  @override
  bool isSignedIn() {
    return _currentUser != null;
  }

  @override
  String? getCurrentUser() {
    return _currentUser;
  }
}