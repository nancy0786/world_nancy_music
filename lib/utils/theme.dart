# ---------------- lib/utils/theme.dart ----------------
mkdir -p lib/utils && cat > lib/utils/theme.dart << 'EOF'
import 'package:flutter/material.dart';

class AppThemes {
  static final ThemeData neon = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: const Color(0xFF0F0F1E),
    appBarTheme: const AppBarTheme(
      color: Colors.deepPurple,
      foregroundColor: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white),
    ),
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurpleAccent),
    useMaterial3: true,
  );

  static final ThemeData light = ThemeData.light().copyWith(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      color: Colors.blue,
      foregroundColor: Colors.white,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.black),
    ),
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
    useMaterial3: true,
  );
}
EOF
