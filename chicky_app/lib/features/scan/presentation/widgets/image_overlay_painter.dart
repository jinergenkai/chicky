import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../data/models/word_overlay.dart';

/// Paints colored rectangles over detected words on the captured image.
class ImageOverlayPainter extends CustomPainter {
  ImageOverlayPainter({
    required this.overlays,
    required this.imageSize,
    required this.displaySize,
    this.showKnown = false,
  });

  final List<WordOverlay> overlays;
  final Size imageSize;
  final Size displaySize;
  final bool showKnown;

  @override
  void paint(Canvas canvas, Size size) {
    if (imageSize.width == 0 || imageSize.height == 0) return;

    final scaleX = displaySize.width / imageSize.width;
    final scaleY = displaySize.height / imageSize.height;

    for (final overlay in overlays) {
      if (overlay.status == WordStatus.ignore) continue;
      if (overlay.status == WordStatus.known && !showKnown) continue;

      final rect = Rect.fromLTWH(
        overlay.boundingBox.left * scaleX,
        overlay.boundingBox.top * scaleY,
        overlay.boundingBox.width * scaleX,
        overlay.boundingBox.height * scaleY,
      );

      final color = _colorForStatus(overlay.status);

      // Fill
      final fillPaint = Paint()
        ..color = color.withValues(alpha: 0.2)
        ..style = PaintingStyle.fill;
      final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(3));
      canvas.drawRRect(rrect, fillPaint);

      // Border
      final borderPaint = Paint()
        ..color = color.withValues(alpha: 0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawRRect(rrect, borderPaint);
    }
  }

  Color _colorForStatus(WordStatus status) {
    return switch (status) {
      WordStatus.known => ChickyColors.vocabKnown,
      WordStatus.learning => ChickyColors.vocabLearning,
      WordStatus.unknown => ChickyColors.vocabUnknown,
      WordStatus.unknownNotInBase => ChickyColors.vocabUnknown,
      WordStatus.ignore => Colors.transparent,
    };
  }

  @override
  bool shouldRepaint(covariant ImageOverlayPainter oldDelegate) {
    return overlays != oldDelegate.overlays ||
        imageSize != oldDelegate.imageSize ||
        displaySize != oldDelegate.displaySize ||
        showKnown != oldDelegate.showKnown;
  }
}
