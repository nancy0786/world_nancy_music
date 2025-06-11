import 'package:flutter/material.dart';

class CyberButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const CyberButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.pinkAccent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        elevation: 10,
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Orbitron',
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
