import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_music_nancy/providers/preferences_provider.dart';

class NeonAwareContainer extends StatelessWidget {
  final Widget child; // ✅ Required child
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double? width;
  final double? height;
  final AlignmentGeometry? alignment;
  final BoxDecoration? decoration;

  const NeonAwareContainer({
    super.key,
    required this.child, // ✅ Error 6: Required named parameter added
    this.padding,
    this.margin,
    this.color,
    this.width,
    this.height,
    this.alignment,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    final isFuturistic = Provider.of<PreferencesProvider>(context).isFuturistic;

    return Container(
      width: width,
      height: height,
      alignment: alignment,
      margin: margin,
      padding: padding,
      decoration: decoration ??
          BoxDecoration(
            color: color ?? (isFuturistic ? Colors.black.withOpacity(0.5) : Colors.grey.shade900),
            borderRadius: BorderRadius.circular(16),
            border: isFuturistic
                ? Border.all(color: Colors.cyanAccent, width: 1.5)
                : null,
            boxShadow: isFuturistic
                ? [
                    BoxShadow(
                      color: Colors.cyanAccent.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ]
                : [],
          ),
      child: child,
    );
  }
}
