
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_music_nancy/providers/theme_provider.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Dark Mode', style: TextStyle(color: Colors.white)),
        Switch(
          value: themeProvider.isDarkMode,
          activeColor: Colors.deepPurpleAccent,
          onChanged: (value) => themeProvider.toggleTheme(),
        ),
      ],
    );
  }
}
