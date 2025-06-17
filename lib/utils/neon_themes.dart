import 'package:flutter/material.dart';

class NeonThemes {
  static final Map<String, ThemeData> themes = {
    'Teal': _buildNeonTheme(Colors.tealAccent, Colors.cyanAccent),
    'Purple': _buildNeonTheme(Colors.purpleAccent, Colors.deepPurpleAccent),
    'Blue': _buildNeonTheme(Colors.blueAccent, Colors.lightBlueAccent),
    'Green': _buildNeonTheme(Colors.greenAccent, Colors.lightGreenAccent),
    'Pink': _buildNeonTheme(Colors.pinkAccent, Colors.purpleAccent),
  };

  static ThemeData _buildNeonTheme(Color primary, Color secondary) {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
      colorScheme: ColorScheme.dark(
        primary: primary,
        secondary: secondary,
      ),
      textTheme: TextTheme(
        bodyMedium: TextStyle(color: primary),
        titleLarge: TextStyle(color: secondary, fontSize: 22, fontWeight: FontWeight.bold),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: primary,
        elevation: 0,
      ),
      iconTheme: IconThemeData(color: primary),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.black,
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[900],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: primary),
        ),
        labelStyle: TextStyle(color: secondary),
        hintStyle: TextStyle(color: Colors.grey[600]),
      ),
    );
  }

  /// ✅ Add this getter to be used from screens
  static Map<String, ThemeData> get availableNeonThemes => themes;
}
