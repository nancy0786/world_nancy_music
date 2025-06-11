import 'package:flutter/material.dart';

class NeonButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final Color color;
  final double fontSize;
  final IconData? icon;
  final double? width;
  final MainAxisAlignment alignment;

  const NeonButton({
    super.key,
    required this.text,
    required this.onTap,
    this.color = Colors.cyanAccent,
    this.fontSize = 18,
    this.icon,
    this.width,
    this.alignment = MainAxisAlignment.center,
  });

  @override
  State<NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: widget.width,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: widget.color.withOpacity(0.8), width: 2),
          boxShadow: [
            BoxShadow(
              color: widget.color.withOpacity(_isPressed ? 0.4 : 0.8),
              blurRadius: _isPressed ? 6 : 14,
              spreadRadius: _isPressed ? 0.5 : 1.5,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: widget.alignment,
          children: [
            if (widget.icon != null) ...[
              Icon(widget.icon, color: widget.color, size: widget.fontSize + 4),
              const SizedBox(width: 8),
            ],
            Text(
              widget.text,
              style: TextStyle(
                fontSize: widget.fontSize,
                color: widget.color,
                fontFamily: 'Orbitron',
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
                shadows: [
                  Shadow(
                    color: widget.color.withOpacity(0.9),
                    blurRadius: 6,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
