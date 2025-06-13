import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_music_nancy/providers/theme_provider.dart';

class ThemeSelector extends StatelessWidget {
  final Map<String, ThemeData> themes;

  const ThemeSelector({super.key, required this.themes});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final currentTheme = themeProvider.currentTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose Theme',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: themes.keys.map((themeName) {
            final selected = currentTheme == themeName;
            return ChoiceChip(
              label: Text(themeName),
              selected: selected,
              selectedColor: Colors.pinkAccent,
              backgroundColor: Colors.grey.shade800,
              labelStyle: TextStyle(
                color: selected ? Colors.white : Colors.grey.shade300,
              ),
              onSelected: (_) => themeProvider.setTheme(themeName),
            );
          }).toList(),
        ),
      ],
    );
  }
}
