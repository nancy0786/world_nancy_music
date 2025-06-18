import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesProvider extends ChangeNotifier {
  String _uiStyle = 'futuristic'; // default
  String _backgroundCategory = 'girls'; // default

  String get uiStyle => _uiStyle;
  String get backgroundCategory => _backgroundCategory;

  bool get isFuturistic => _uiStyle == 'futuristic';
  bool get isNormal => _uiStyle == 'normal';

  bool get isGirlsBG => _backgroundCategory == 'girls';
  bool get isCyberpunkBG => _backgroundCategory == 'cyberpunk';
  bool get isNatureBG => _backgroundCategory == 'nature';
  bool get isDarkBG => _backgroundCategory == 'dark';

  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _uiStyle = prefs.getString('uiStyle') ?? 'futuristic';
    _backgroundCategory = prefs.getString('backgroundCategory') ?? 'girls';
    notifyListeners();
  }

  Future<void> setUIStyle(String style) async {
    final prefs = await SharedPreferences.getInstance();
    _uiStyle = style;
    await prefs.setString('uiStyle', style);
    notifyListeners();
  }

  Future<void> setBackgroundCategory(String category) async {
    final prefs = await SharedPreferences.getInstance();
    _backgroundCategory = category;
    await prefs.setString('backgroundCategory', category);
    notifyListeners();
  }
}
