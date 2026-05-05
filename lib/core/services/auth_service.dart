import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Simple local auth service backed by shared_preferences.
/// Stores a list of registered users and the currently logged-in email.
/// NOTE: Passwords are stored in plain text — fine for a class assignment,
/// never do this in a real production app.
class AuthService {
  static const _usersKey = 'isango_users';
  static const _currentUserKey = 'isango_current_user';

  Future<String?> currentUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentUserKey);
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final users = _readUsers(prefs);

    final normalizedEmail = email.trim().toLowerCase();
    if (users.containsKey(normalizedEmail)) {
      throw Exception('An account with this email already exists.');
    }

    users[normalizedEmail] = {
      'name': name.trim(),
      'password': password,
    };

    await prefs.setString(_usersKey, jsonEncode(users));
    await prefs.setString(_currentUserKey, normalizedEmail);
  }

  Future<void> logIn({
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final users = _readUsers(prefs);

    final normalizedEmail = email.trim().toLowerCase();
    final user = users[normalizedEmail];

    if (user == null || user['password'] != password) {
      throw Exception('Invalid email or password.');
    }

    await prefs.setString(_currentUserKey, normalizedEmail);
  }

  Future<void> logOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_currentUserKey);
  }

  Map<String, dynamic> _readUsers(SharedPreferences prefs) {
    final raw = prefs.getString(_usersKey);
    if (raw == null || raw.isEmpty) return {};
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    return Map<String, dynamic>.from(decoded);
  }
}