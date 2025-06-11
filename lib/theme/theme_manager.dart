import 'package:flutter/material.dart';

class ThemeManager {
  static ThemeData get neon => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primarySwatch: Colors.deepPurple,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.cyanAccent),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.cyanAccent,
        ),
      );

  static ThemeData get light => ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.purple,
      );
}
