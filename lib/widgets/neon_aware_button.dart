import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_music_nancy/providers/preferences_provider.dart';
import 'neon_button.dart';

class NeonAwareButton extends StatelessWidget {
  final String? text;
  final Widget? label;
  final VoidCallback onTap;
  final IconData? icon;
  final ButtonStyle? style; // ✅ New: support external style

  const NeonAwareButton({
    super.key,
    this.text,
    this.label,
    required this.onTap,
    this.icon,
    this.style, // ✅ New
  });

  @override
  Widget build(BuildContext context) {
    final isFuturistic = Provider.of<PreferencesProvider>(context).isFuturistic;

    return isFuturistic
        ? NeonButton(
            text: text ?? (label is Text ? (label as Text).data ?? '' : ''),
            icon: icon,
            onTap: onTap,
          )
        : ElevatedButton.icon(
            onPressed: onTap,
            icon: Icon(icon),
            label: label ?? Text(text ?? ''),
            style: style, // ✅ Now accepts external style
          );
  }
}
