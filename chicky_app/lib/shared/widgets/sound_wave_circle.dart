import 'package:flutter/material.dart';

/// Animated pulsing circle that responds to audio RMS dB values.
///
/// Used as visual feedback during voice recording — the circle
/// expands and contracts with the user's voice volume.
///
/// ```dart
/// SoundWaveCircle(
///   rmsDB: voiceProvider.currentRms,
///   color: ChickyColors.primary,
/// )
/// ```
class SoundWaveCircle extends StatelessWidget {
  final double rmsDB;
  final double minRadius;
  final double maxRadius;
  final Color? color;

  const SoundWaveCircle({
    super.key,
    required this.rmsDB,
    this.minRadius = 32,
    this.maxRadius = 64,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    // SpeechToText returns rmsDB from -2.0 to 10.0
    // Normalize to 0–1 range
    final normalized = ((rmsDB - (-2.0)) / (10.0 - (-2.0))).clamp(0.0, 1.0);
    final radius = minRadius + (maxRadius - minRadius) * normalized;
    final effectiveColor = color ?? Theme.of(context).colorScheme.primary;

    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          color: effectiveColor.withOpacity(0.15),
          shape: BoxShape.circle,
          border: Border.all(
            color: effectiveColor,
            width: 3,
          ),
        ),
        child: Center(
          child: Icon(
            Icons.mic,
            color: effectiveColor,
            size: minRadius,
          ),
        ),
      ),
    );
  }
}
