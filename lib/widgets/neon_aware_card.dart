import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_music_nancy/providers/preferences_provider.dart';

class NeonAwareCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final ShapeBorder? shape;
  final double? elevation;
  final Color? shadowColor;

  const NeonAwareCard({
    super.key,
    required this.child,
    this.margin,
    this.color,
    this.shape,
    this.elevation,
    this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    final isFuturistic = Provider.of<PreferencesProvider>(context).isFuturistic;

    return Card(
      margin: margin,
      color: color ?? (isFuturistic ? Colors.black87 : Colors.grey.shade800),
      shape: shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: isFuturistic
                ? BorderSide(color: Colors.cyanAccent.withOpacity(0.4), width: 1)
                : BorderSide.none,
          ),
      elevation: elevation ?? (isFuturistic ? 12 : 4),
      shadowColor: shadowColor ?? (isFuturistic ? Colors.cyanAccent.withOpacity(0.5) : Colors.black),
      child: child,
    );
  }
}
