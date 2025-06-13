import 'package:flutter/material.dart';

Widget loadingSpinner({double size = 50}) {
  return Center(
    child: SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 4,
        color: Colors.cyanAccent,
      ),
    ),
  );
}

Widget emptyState({String message = "No content available"}) {
  return Center(
    child: Text(
      message,
      style: const TextStyle(
        color: Colors.white54,
        fontSize: 16,
      ),
    ),
  );
}
