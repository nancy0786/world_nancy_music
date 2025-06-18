import 'package:world_music_nancy/widgets/neon_aware_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:world_music_nancy/providers/preferences_provider.dart';

class NeonAwareCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;
  final Color? color;

  const NeonAwareCard({
    super.key,
    required this.child,
    this.margin,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isFuturistic = Provider.of<PreferencesProvider>(context).isFuturistic;

    return NeonAwareCard(
      color: color ?? (isFuturistic ? Colors.black87 : Colors.grey.shade800),
      margin: margin,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: isFuturistic ? 12 : 4,
      shadowColor: isFuturistic ? Colors.cyanAccent.withOpacity(0.5) : Colors.black,
      child: child,
    );
  }
}
