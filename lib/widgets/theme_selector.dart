import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nancy_music_world/lib/providers/theme_provider.dart';

class ThemeSelector extends StatelessWidget {
  final List<String> themes;

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
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        Wrap(
          spacing: 10,
          children: themes.map((themeName) {
            final selected = currentTheme == themeName;
            return ChoiceChip(
              label: Text(themeName),
              selected: selected,
              selectedColor: Colors.pinkAccent,
              backgroundColor: Colors.grey.shade800,
              labelStyle: TextStyle(
                color: selected ? Colors.white : Colors.grey.shade400,
              ),
              onSelected: (_) => themeProvider.setTheme(themeName),
            );
          }).toList(),
        ),
      ],
    );
  }
}
EOF
