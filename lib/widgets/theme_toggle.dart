# File: lib/widgets/theme_toggle.dart
# A switch widget to toggle between light and dark themes

import 'package:flutter/material.dart';

class ThemeToggle extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggle;

  const ThemeToggle({
    super.key,
    required this.isDarkMode,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Icon(Icons.light_mode, color: Colors.yellowAccent),
        Switch(
          value: isDarkMode,
          onChanged: (_) => onToggle(),
          activeColor: Colors.cyanAccent,
          inactiveThumbColor: Colors.grey,
        ),
        const Icon(Icons.dark_mode, color: Colors.blueGrey),
      ],
    );
  }
}
