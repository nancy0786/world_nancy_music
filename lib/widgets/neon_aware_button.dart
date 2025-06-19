import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_music_nancy/providers/preferences_provider.dart';
import 'neon_button.dart';

class NeonAwareButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final IconData? icon;

  const NeonAwareButton({
    super.key,
    required this.text,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isFuturistic = Provider.of<PreferencesProvider>(context).isFuturistic;

    return isFuturistic
        ? NeonButton(text: text, icon: icon, onTap: onTap)
        : ElevatedButton.icon(
            onTap: onTap,
            icon: Icon(icon),
            label: Text(text),
          );
  }
}
