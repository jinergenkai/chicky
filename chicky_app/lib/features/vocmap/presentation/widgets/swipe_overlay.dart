import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';

/// Visual overlay on flashcards during swipe gestures.
///
/// Shows a green ✓ when swiping right (know) and
/// a red ✗ when swiping left (don't know).
/// Opacity increases with swipe distance.
class SwipeOverlay extends StatelessWidget {
  /// Swipe progress from -1.0 (full left) to 1.0 (full right).
  /// Typically `swipeOffset.dx / threshold`.
  final double swipeProgress;
  final double cardWidth;

  const SwipeOverlay({
    super.key,
    required this.swipeProgress,
    this.cardWidth = 300,
  });

  @override
  Widget build(BuildContext context) {
    final opacity = swipeProgress.abs().clamp(0.0, 1.0);
    if (opacity < 0.05) return const SizedBox.shrink();

    final isRight = swipeProgress > 0;
    final color = isRight ? ChickyColors.success : ChickyColors.error;
    final icon = isRight ? Icons.check_rounded : Icons.close_rounded;
    final label = isRight ? 'KNOW IT' : 'LEARN';

    return Positioned.fill(
      child: IgnorePointer(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: color.withOpacity(opacity * 0.2),
          ),
          child: Center(
            child: Opacity(
              opacity: opacity,
              child: Transform.rotate(
                angle: isRight ? -0.2 : 0.2,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: color, width: 4),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, color: color, size: 32),
                      const SizedBox(width: 8),
                      Text(
                        label,
                        style: TextStyle(
                          color: color,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
