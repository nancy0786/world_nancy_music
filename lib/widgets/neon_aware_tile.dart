import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_music_nancy/providers/preferences_provider.dart';

class NeonAwareTile extends StatelessWidget {
  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? contentPadding;
  final Color? tileColor;

  const NeonAwareTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.contentPadding,
    this.tileColor,
  });

  @override
  Widget build(BuildContext context) {
    final isFuturistic = Provider.of<PreferencesProvider>(context).isFuturistic;

    return ListTile(
      onTap: onTap,
      leading: leading,
      trailing: trailing,
      title: DefaultTextStyle(
        style: TextStyle(
          color: isFuturistic ? Colors.cyanAccent : Colors.white,
          fontWeight: FontWeight.bold,
        ),
        child: title,
      ),
      subtitle: subtitle != null
          ? DefaultTextStyle(
              style: TextStyle(
                color: isFuturistic ? Colors.white54 : Colors.white70,
              ),
              child: subtitle!,
            )
          : null,
      contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      tileColor: tileColor ?? (isFuturistic ? Colors.black54 : Colors.grey[850]),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isFuturistic
            ? BorderSide(color: Colors.cyanAccent.withOpacity(0.5))
            : BorderSide.none,
      ),
    );
  }
}
