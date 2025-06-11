// lib/theme.dart

import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.pink,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.pink,
    foregroundColor: Colors.white,
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.black),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black,
  primarySwatch: Colors.deepPurple,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.white),
  ),
);

final ThemeData neonTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF0D0D0D),
  primaryColor: const Color(0xFFFF2D95),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF0D0D0D),
    foregroundColor: Colors.white,
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Color(0xFF00FFFF)),
    headlineMedium: TextStyle(
      color: Color(0xFFFF2D95),
      fontWeight: FontWeight.bold,
    ),
  ),
  iconTheme: const IconThemeData(color: Color(0xFF9B30FF)),
);
