// lib/controllers/background_controller.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackgroundController extends ChangeNotifier {
  String _selectedCategory = 'girls';
  final Map<String, List<String>> _backgrounds = {
    'cyberpunk': [
      'assets/backgrounds/cyberpunk/cyber1.jpg',
      'assets/backgrounds/cyberpunk/cyber2.jpg',
      'assets/backgrounds/cyberpunk/cyber3.mp4',
    ],
    'girls': [
      'assets/backgrounds/girls/girl1.jpg',
      'assets/backgrounds/girls/girl2.jpg',
      'assets/backgrounds/girls/girl3.mp4',
    ],
    'nature': [
      'assets/backgrounds/nature/nature1.jpg',
      'assets/backgrounds/nature/nature2.jpg',
      'assets/backgrounds/nature/nature3.mp4',
    ],
  };

  final Random _random = Random();

  String? _currentBackground;

  String get selectedCategory => _selectedCategory;
  String get currentBackground =>
      _currentBackground ??
      _backgrounds[_selectedCategory]![_random.nextInt(_backgrounds[_selectedCategory]!.length)];

  BackgroundController() {
    _loadCategory();
    _updateRandomBackground();
  }

  void _loadCategory() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedCategory = prefs.getString('backgroundCategory') ?? 'girls';
    notifyListeners();
  }

  void selectCategory(String category) async {
    _selectedCategory = category;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('backgroundCategory', category);
    _updateRandomBackground();
    notifyListeners();
  }

  void _updateRandomBackground() {
    final list = _backgrounds[_selectedCategory] ?? [];
    if (list.isNotEmpty) {
      _currentBackground = list[_random.nextInt(list.length)];
    }
  }

  void nextBackground() {
    _updateRandomBackground();
    notifyListeners();
  }
}
