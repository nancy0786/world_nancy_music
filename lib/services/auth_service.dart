import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _key = 'user_credentials';

  /// Registers a new user
  static Future<bool> register(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);
    final Map<String, dynamic> users = data != null
        ? Map<String, dynamic>.from(jsonDecode(data))
        : {};

    if (users.containsKey(email)) {
      return false; // User already exists
    }

    users[email] = password; // In real apps, hash the password!
    await prefs.setString(_key, jsonEncode(users));
    return true;
  }

  /// Logs in a user
  static Future<bool> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);
    final Map<String, dynamic> users = data != null
        ? Map<String, dynamic>.from(jsonDecode(data))
        : {};

    if (users.containsKey(email) && users[email] == password) {
      await prefs.setString('loggedInUser', email);
      return true;
    }

    return false;
  }

  /// Logs out the current user
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('loggedInUser');
  }

  /// Get the currently logged in user
  static Future<String?> currentUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('loggedInUser');
  }

  /// Check if a user is currently logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('loggedInUser');
  }
}
