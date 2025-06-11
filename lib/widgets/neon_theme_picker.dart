import 'package:flutter/material.dart';

class NeonThemePicker extends StatelessWidget {
  final Function(String) onThemeSelected;

  const NeonThemePicker({super.key, required this.onThemeSelected});

  @override
  Widget build(BuildContext context) {
    final themes = ['Teal', 'Purple', 'Blue', 'Green', 'Pink'];

    return Wrap(
      spacing: 10,
      children: themes.map((themeName) {
        return ElevatedButton(
          onPressed: () => onThemeSelected(themeName),
          child: Text(themeName),
        );
      }).toList(),
    );
  }
}
