import 'package:flutter/material.dart';
import 'package:nancy_music_world/lib/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  Future<void> login(String email, String password) async {
    _isAuthenticated = await AuthService.login(email, password);
    notifyListeners();
  }

  Future<void> register(String email, String password) async {
    _isAuthenticated = await AuthService.register(email, password);
    notifyListeners();
  }

  Future<void> logout() async {
    await AuthService.logout();
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    _isAuthenticated = await AuthService.isLoggedIn();
    notifyListeners();
  }
}
