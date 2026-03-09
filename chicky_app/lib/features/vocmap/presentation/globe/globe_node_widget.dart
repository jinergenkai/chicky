import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../data/models/word_model.dart';
import 'visual_graph.dart';

// ── Color palette (standalone dark theme) ────────────────────────────────────
const globeBg = Color(0xFF0D0F15);
const globeAccent = Color(0xFFF97B2C);
const globeAccentSoft = Color(0xFFFFAA6B);
const globeText = Color(0xFFF0EDE8);
const globeTextDim = Color(0xFF8B8D97);
const globeTextMuted = Color(0xFF4E5060);

// ── Particle data ─────────────────────────────────────────────────────────────
class GlobeParticle {
  const GlobeParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.phase,
    required this.speed,
  });
  final double x, y, size, phase, speed;
}

// ── Background painter ────────────────────────────────────────────────────────
class GlobeBackgroundPainter extends CustomPainter {
  const GlobeBackgroundPainter({
    required this.glowPhase,
    required this.particles,
    required this.elapsed,
  });

  final double glowPhase;
  final List<GlobeParticle> particles;
  final Duration elapsed;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2, cy = size.height / 2;
    final secs = elapsed.inMilliseconds / 1000.0;

    canvas.drawRect(Offset.zero & size, Paint()..color = globeBg);

    // Ambient glow
    final glowA = 0.12 + 0.04 * math.sin(glowPhase);
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = RadialGradient(colors: [
          globeAccent.withValues(alpha: glowA),
          Colors.transparent,
        ]).createShader(
            Rect.fromCircle(center: Offset(cx, cy), radius: size.width * 0.55)),
    );

    // Grid rings
    final ringP = Paint()
      ..color = Colors.white.withValues(alpha: 0.035)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    for (final f in [0.22, 0.37, 0.52]) {
      canvas.drawCircle(Offset(cx, cy), size.width * f, ringP);
    }

    // Particles
    final dotP = Paint()..style = PaintingStyle.fill;
    for (final p in particles) {
      final t = (secs * p.speed + p.phase) % (math.pi * 2);
      dotP.color = Colors.white
          .withValues(alpha: (0.05 + 0.13 * math.sin(t)).clamp(0.0, 1.0));
      canvas.drawCircle(
          Offset(p.x * size.width, p.y * size.height), p.size, dotP);
    }
  }

  @override
  bool shouldRepaint(GlobeBackgroundPainter _) => true;
}

// ── Node widget (morph chip ↔ detail card) ────────────────────────────────────
class GlobeNodeWidget extends StatelessWidget {
  const GlobeNodeWidget({super.key, required this.node});

  final VisualNode node;

  static double _l(double a, double b, double t) =>
      a + (b - a) * t.clamp(0.0, 1.0);
  static double _ss(double e0, double e1, double x) {
    final t = ((x - e0) / (e1 - e0)).clamp(0.0, 1.0);
    return t * t * (3 - 2 * t);
  }

  @override
  Widget build(BuildContext context) {
    final m = node.morph;
    final data = node.graphNode.data;

    final width = _l(80, 220, m);
    final hPad = _l(10, 20, m);
    final vPad = _l(5, 18, m);
    final borderR = _l(30, 18, m);
    final wordSz = _l(11, 22, m);
    final detailA = _ss(0.2, 0.55, m);

    final Gradient? gradient = m > 0.15
        ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1C2030), Color(0xFF252A3A)])
        : null;
    final bg =
        gradient != null ? Colors.transparent : const Color(0x0DFFFFFF);
    final borderCol = Color.lerp(
      Colors.white.withValues(alpha: 0.07),
      globeAccent.withValues(alpha: 0.35),
      m,
    )!;
    final shadows = m > 0.15
        ? [
            BoxShadow(
                color: globeAccent.withValues(alpha: m * 0.28),
                blurRadius: 50 * m,
                spreadRadius: -4)
          ]
        : null;

    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderR),
        gradient: gradient,
        color: gradient == null ? bg : null,
        border: Border.all(color: borderCol, width: 1.0),
        boxShadow: shadows,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.word,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: globeText,
              fontSize: wordSz,
              fontWeight: m > 0.25 ? FontWeight.w700 : FontWeight.w600,
              fontFamily: m > 0.3 ? 'serif' : null,
              letterSpacing: m > 0.25 ? 0.5 : 0,
            ),
          ),
          if (m < 0.15 && data.primaryPos != null)
            Text(data.primaryPos!.toUpperCase(),
                style: const TextStyle(
                    fontSize: 9, color: globeTextMuted, letterSpacing: 1.0)),
          if (m > 0.15)
            Opacity(
              opacity: detailA,
              child: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (data.hasIpa) ...[
                      Text('/${data.ipa}/',
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: globeAccentSoft,
                              fontStyle: FontStyle.italic)),
                      const SizedBox(height: 4),
                    ],
                    if (data.primaryPos != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: globeAccent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(data.primaryPos!.toUpperCase(),
                            style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: globeAccentSoft,
                                letterSpacing: 1.2)),
                      ),
                      const SizedBox(height: 4),
                    ],
                    if (data.primaryDefinition != null)
                      Text(data.primaryDefinition!,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 12,
                              height: 1.5,
                              color: globeTextDim)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Top bar ───────────────────────────────────────────────────────────────────
class GlobeTopBar extends StatelessWidget {
  const GlobeTopBar({super.key, required this.word, required this.onBack});

  final String word;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      GestureDetector(
        onTap: onBack,
        child: Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
          ),
          child: const Icon(Icons.arrow_back, color: globeText, size: 20),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Word Web',
                style: TextStyle(
                    color: globeTextMuted,
                    fontSize: 11,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w600)),
            Text(word,
                style: const TextStyle(
                    color: globeText,
                    fontSize: 18,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
      Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: const Center(
            child: Text('🌐', style: TextStyle(fontSize: 18))),
      ),
    ]);
  }
}

// ── Breadcrumb ────────────────────────────────────────────────────────────────
class GlobeBreadcrumb extends StatelessWidget {
  const GlobeBreadcrumb({super.key, required this.history});

  final List<String> history;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: [
        for (int i = 0; i < history.length; i++) ...[
          if (i > 0)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Icon(Icons.chevron_right, color: globeTextMuted, size: 14),
            ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: i == history.length - 1
                  ? globeAccent.withValues(alpha: 0.16)
                  : Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: i == history.length - 1
                    ? globeAccent.withValues(alpha: 0.38)
                    : Colors.white.withValues(alpha: 0.07),
              ),
            ),
            child: Text(history[i],
                style: TextStyle(
                  fontSize: 12,
                  color: i == history.length - 1
                      ? globeAccentSoft
                      : globeTextMuted,
                  fontWeight: i == history.length - 1
                      ? FontWeight.w600
                      : FontWeight.w400,
                )),
          ),
        ],
      ]),
    );
  }
}
