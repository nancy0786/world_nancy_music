cat > lib/components/blur_container.dart << 'EOF'
import 'dart:ui';
import 'package:flutter/material.dart';

class BlurContainer extends StatelessWidget {
  final Widget child;
  final double blur;
  final double borderRadius;

  const BlurContainer({
    super.key,
    required this.child,
    this.blur = 10.0,
    this.borderRadius = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
EOF
