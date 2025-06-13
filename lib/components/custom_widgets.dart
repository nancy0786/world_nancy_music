import 'package:flutter/material.dart';

Widget neonButton({
  required String text,
  required VoidCallback onPressed,
  Color color = Colors.cyanAccent,
}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.black,
      foregroundColor: color,
      side: BorderSide(color: color, width: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      elevation: 10,
      shadowColor: color.withOpacity(0.6),
    ),
    onPressed: onPressed,
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    ),
  );
}

Widget neonTitle(String text) {
  return Text(
    text,
    style: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.cyanAccent,
      shadows: [
        Shadow(
          color: Colors.cyanAccent,
          blurRadius: 10,
        ),
      ],
    ),
  );
}
