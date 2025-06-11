import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String? _email;
  String? _username;
  String? _profileImage;

  String? get email => _email;
  String? get username => _username;
  String? get profileImage => _profileImage;

  bool get isLoggedIn => _email != null;

  void login({
    required String email,
    required String username,
    String? profileImage,
  }) {
    _email = email;
    _username = username;
    _profileImage = profileImage;
    notifyListeners();
  }

  void logout() {
    _email = null;
    _username = null;
    _profileImage = null;
    notifyListeners();
  }

  void updateProfile({
    String? username,
    String? profileImage,
  }) {
    if (username != null) _username = username;
    if (profileImage != null) _profileImage = profileImage;
    notifyListeners();
  }
}
