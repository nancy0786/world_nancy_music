cat > lib/components/cyberpunk_slider.dart << 'EOF'
import 'package:flutter/material.dart';

class CyberpunkSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final Color activeColor;
  final Color inactiveColor;

  const CyberpunkSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor = Colors.cyanAccent,
    this.inactiveColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: activeColor,
        inactiveTrackColor: inactiveColor,
        thumbColor: activeColor,
        overlayColor: activeColor.withOpacity(0.3),
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 14.0),
      ),
      child: Slider(
        value: value,
        onChanged: onChanged,
        min: 0.0,
        max: 1.0,
      ),
    );
  }
}
EOF
