import 'package:flutter/material.dart';

class CyberpunkSlider extends StatelessWidget {
  final double value;
  final Function(double) onChanged;
  final Color activeColor;
  final Color inactiveColor;

  const CyberpunkSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor = const Color(0xFF00FFFF),
    this.inactiveColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 4,
        activeTrackColor: activeColor,
        inactiveTrackColor: inactiveColor,
        thumbColor: activeColor,
        overlayColor: activeColor.withOpacity(0.2),
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 14.0),
      ),
      child: Slider(
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
