import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// Returns the application's documents directory.
Future<String> getAppDirectory() async {
  final Directory dir = await getApplicationDocumentsDirectory();
  return dir.path;
}

/// Formats a duration (seconds) into mm:ss format.
String formatDuration(Duration duration) {
  final String twoDigits(int n) => n.toString().padLeft(2, '0');
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));
  return "$minutes:$seconds";
}

/// Shows a snack bar with a custom message.
void showSnack(BuildContext context, String message, {Color? color}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: color ?? Colors.black87,
    ),
  );
}
