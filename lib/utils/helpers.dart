# ---------------- lib/utils/helpers.dart ----------------
mkdir -p lib/utils && cat > lib/utils/helpers.dart << 'EOF'
String formatDuration(Duration duration) {
  final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}
EOF
