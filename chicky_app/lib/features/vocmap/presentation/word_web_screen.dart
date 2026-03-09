import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/word_model.dart';
import '../providers/vocmap_provider.dart';

// ── Color palette (standalone dark theme) ────────────────────────────────────
const _bgColor = Color(0xFF0D0F15);
const _accentColor = Color(0xFFF97B2C);
const _accentSoftColor = Color(0xFFFFAA6B);
const _textColor = Color(0xFFF0EDE8);
const _textDimColor = Color(0xFF8B8D97);
const _textMutedColor = Color(0xFF4E5060);

// ── Globe node (holds word data + fixed sphere coords + per-frame state) ──────
class _GlobeNode {
  _GlobeNode({
    required this.data,
    required this.nx,
    required this.ny,
    required this.nz,
  });

  final WordModel data;
  final double nx, ny, nz; // unit-sphere Cartesian (fixed per session)

  // Computed every frame by _computePositions()
  double screenX = 0;
  double screenY = 0;
  double depth = 0; // -1 (back) → +1 (front)
  double morph = 0; // 0 (chip) → 1 (detail card)
}

// ── Particle (for background ambiance) ────────────────────────────────────────
class _Particle {
  const _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.phase,
    required this.speed,
  });

  final double x, y, size, phase, speed;
}

// ── Main screen ───────────────────────────────────────────────────────────────
class WordWebScreen extends ConsumerStatefulWidget {
  const WordWebScreen({super.key, required this.word});

  final WordModel word;

  @override
  ConsumerState<WordWebScreen> createState() => _WordWebScreenState();
}

class _WordWebScreenState extends ConsumerState<WordWebScreen>
    with TickerProviderStateMixin {
  // ── Globe nodes & word state ────────────────────────────────────────────────
  List<_GlobeNode> _nodes = [];
  WordModel? _currentWord;
  List<String> _history = [];
  bool _isLoading = false;
  double _nodesOpacity = 1.0;

  // ── Rotation ────────────────────────────────────────────────────────────────
  double _rotX = 0.0;
  double _rotY = 0.0;
  double _velX = 0.0;
  double _velY = 0.0;
  bool _isDragging = false;
  final List<Offset> _recentVels = [];

  // ── Tap-to-center animation ─────────────────────────────────────────────────
  bool _isAnimatingRot = false;
  double _animFromRotX = 0;
  double _animFromRotY = 0;
  double _animToRotX = 0;
  double _animToRotY = 0;
  Duration? _animStart;
  WordModel? _pendingRebuild;
  static const int _animMs = 500;

  // ── Screen layout ───────────────────────────────────────────────────────────
  double _screenW = 0;
  double _screenH = 0;
  double get _sphereRadius => math.min(_screenW, _screenH) * 0.28;

  // ── Ticker ─────────────────────────────────────────────────────────────────
  late final Ticker _ticker;
  Duration _lastElapsed = Duration.zero;

  // ── Background ─────────────────────────────────────────────────────────────
  final List<_Particle> _particles = [];
  double _glowPhase = 0.0;

  // ── Init ────────────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _currentWord = widget.word;
    _history = [widget.word.word];
    _initParticles();
    _ticker = createTicker(_onTick)..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _initParticles() {
    final rng = math.Random(42);
    for (int i = 0; i < 35; i++) {
      _particles.add(_Particle(
        x: rng.nextDouble(),
        y: rng.nextDouble(),
        size: rng.nextDouble() * 2.5 + 1.0,
        phase: rng.nextDouble() * math.pi * 2,
        speed: rng.nextDouble() * 0.4 + 0.2,
      ));
    }
  }

  // ── Data loading ────────────────────────────────────────────────────────────
  Future<void> _loadRelatedWords(WordModel word) async {
    if (_screenW == 0) return; // wait for first layout
    setState(() {
      _isLoading = true;
      _nodesOpacity = 1.0;
    });
    try {
      final repo = ref.read(vocabRepositoryProvider);
      final related = await repo.getRelatedWords(word.id);

      final all = [word, ...related];
      final coords = _fibonacciSphere(all.length);
      final nodes = List.generate(
        all.length,
        (i) => _GlobeNode(
          data: all[i],
          nx: coords[i].$1,
          ny: coords[i].$2,
          nz: coords[i].$3,
        ),
      );

      if (!mounted) return;
      setState(() {
        _nodes = nodes;
        _isLoading = false;
        // Orient so word (at z=1) faces front on first load
        _rotX = 0;
        _rotY = 0;
        _velX = 0;
        _velY = 0;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _nodes = [_GlobeNode(data: word, nx: 0, ny: 0, nz: 1)];
        _isLoading = false;
      });
    }
  }

  // Fibonacci sphere: index 0 placed at (0,0,1) = camera-facing front.
  // Remaining distributed evenly using golden angle.
  List<(double, double, double)> _fibonacciSphere(int n) {
    if (n == 1) return [(0.0, 0.0, 1.0)];

    final goldenAngle = math.pi * (3 - math.sqrt(5));
    final result = <(double, double, double)>[];

    // Current word at front pole (z = +1)
    result.add((0.0, 0.0, 1.0));

    for (int i = 1; i < n; i++) {
      // Distribute across y ∈ [0.9, -0.9] to avoid the poles
      final y = 0.9 - (i / (n - 1)) * 1.8;
      final r = math.sqrt((1 - y * y).clamp(0.0, 1.0));
      final theta = goldenAngle * i;
      final x = r * math.cos(theta);
      final z = r * math.sin(theta);
      final len = math.sqrt(x * x + y * y + z * z);
      result.add((x / len, y / len, z / len));
    }
    return result;
  }

  // ── Animation tick ──────────────────────────────────────────────────────────
  void _onTick(Duration elapsed) {
    if (!mounted) return;

    // Trigger initial load once layout is ready
    if (_nodes.isEmpty && !_isLoading && _screenW > 0) {
      _loadRelatedWords(_currentWord!);
      return;
    }

    final dtMs = (elapsed - _lastElapsed).inMicroseconds / 1000.0;
    _lastElapsed = elapsed;

    // Glow pulse
    _glowPhase += dtMs * 0.001 * 0.8;

    // Tap animation
    if (_isAnimatingRot) {
      _animStart ??= elapsed;
      final t = ((elapsed - _animStart!).inMilliseconds / _animMs).clamp(0.0, 1.0);
      final curved = Curves.easeInOutCubic.transform(t);
      _rotX = _animFromRotX + (_animToRotX - _animFromRotX) * curved;
      _rotY = _animFromRotY + (_animToRotY - _animFromRotY) * curved;
      if (t >= 1.0) {
        _isAnimatingRot = false;
        _animStart = null;
        if (_pendingRebuild != null) {
          final word = _pendingRebuild!;
          _pendingRebuild = null;
          _rebuildGlobe(word);
        }
      }
    } else if (!_isDragging) {
      // Momentum decay
      _velX *= 0.94;
      _velY *= 0.94;
      if (_velX.abs() < 0.0003) _velX = 0;
      if (_velY.abs() < 0.0003) _velY = 0;
      _rotX += _velX;
      _rotY += _velY;
    }

    _computePositions();
    setState(() {});
  }

  void _computePositions() {
    if (_screenW == 0 || _nodes.isEmpty) return;

    final cx = _screenW / 2;
    final cy = _screenH / 2;
    final r = _sphereRadius;
    const perspective = 600.0;

    for (final node in _nodes) {
      final nx = node.nx, ny = node.ny, nz = node.nz;

      // Rotate Y (horizontal swipe)
      final x1 = nx * math.cos(_rotY) - nz * math.sin(_rotY);
      final z1 = nx * math.sin(_rotY) + nz * math.cos(_rotY);

      // Rotate X (vertical swipe)
      final y2 = ny * math.cos(_rotX) - z1 * math.sin(_rotX);
      final z2 = ny * math.sin(_rotX) + z1 * math.cos(_rotX);

      // Perspective projection
      final scale3d = perspective / (perspective + z2 * r);
      node.screenX = cx + x1 * r * scale3d;
      node.screenY = cy - y2 * r * scale3d;
      node.depth = z2;

      // Morph: proximity to screen center × front-hemisphere factor
      final dist = math.sqrt(
        math.pow(node.screenX - cx, 2) + math.pow(node.screenY - cy, 2),
      );
      final proximity = (1.0 - (dist / 140.0).clamp(0.0, 1.0));
      final depthFactor = _smoothstep(-0.2, 0.8, z2);
      node.morph = (proximity * depthFactor).clamp(0.0, 1.0);
    }
  }

  // ── Gesture handlers ────────────────────────────────────────────────────────
  void _onPanStart(DragStartDetails d) {
    _isDragging = true;
    _velX = 0;
    _velY = 0;
    _recentVels.clear();
    _isAnimatingRot = false;
    _animStart = null;
  }

  void _onPanUpdate(DragUpdateDetails d) {
    const sensitivity = 0.007;
    _rotY -= d.delta.dx * sensitivity;
    _rotX += d.delta.dy * sensitivity;
    _recentVels.add(d.delta);
    if (_recentVels.length > 5) _recentVels.removeAt(0);
  }

  void _onPanEnd(DragEndDetails d) {
    _isDragging = false;
    if (_recentVels.isEmpty) return;
    final avg = _recentVels.reduce((a, b) => a + b) /
        _recentVels.length.toDouble();
    const sensitivity = 0.007 * 1.3;
    _velY = (-avg.dx * sensitivity).clamp(-0.08, 0.08);
    _velX = (avg.dy * sensitivity).clamp(-0.08, 0.08);
  }

  // ── Tap to navigate ─────────────────────────────────────────────────────────
  void _onNodeTap(_GlobeNode node) {
    // If the tapped node is already at the front (high morph), rebuild around it
    if (node.morph > 0.7) {
      if (node.data.id != _currentWord?.id) {
        _rebuildGlobe(node.data);
      }
      return;
    }

    // Animate globe rotation to bring this node to center
    final nx = node.nx, ny = node.ny, nz = node.nz;

    // Target rotY: bring x-component to 0
    final targetRotY = _shortestPath(_rotY, math.atan2(nx, nz));

    // Compute z1 at that rotY, then target rotX to bring y2 to 0
    final z1 = nx * math.sin(targetRotY) + nz * math.cos(targetRotY);
    final targetRotX = _shortestPath(_rotX, -math.atan2(ny, z1));

    _animFromRotX = _rotX;
    _animFromRotY = _rotY;
    _animToRotX = targetRotX;
    _animToRotY = targetRotY;
    _animStart = null;
    _isAnimatingRot = true;
    _velX = 0;
    _velY = 0;

    // After animation, rebuild globe around this word
    _pendingRebuild = node.data;
  }

  Future<void> _rebuildGlobe(WordModel newWord) async {
    if (!mounted) return;
    if (newWord.id == _currentWord?.id) return;

    // Fade out satellite nodes
    setState(() {
      _nodesOpacity = 0.0;
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 280));
    if (!mounted) return;

    setState(() {
      _currentWord = newWord;
      if (_history.isEmpty || _history.last != newWord.word) {
        _history.add(newWord.word);
      }
    });

    try {
      final repo = ref.read(vocabRepositoryProvider);
      final related = await repo.getRelatedWords(newWord.id);

      final all = [newWord, ...related];
      final coords = _fibonacciSphere(all.length);
      final nodes = List.generate(
        all.length,
        (i) => _GlobeNode(
          data: all[i],
          nx: coords[i].$1,
          ny: coords[i].$2,
          nz: coords[i].$3,
        ),
      );

      _rotX = 0;
      _rotY = 0;
      _velX = 0;
      _velY = 0;

      if (!mounted) return;
      setState(() {
        _nodes = nodes;
        _isLoading = false;
      });

      // Staggered fade-in
      await Future.delayed(const Duration(milliseconds: 40));
      if (mounted) setState(() => _nodesOpacity = 1.0);
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────
  double _shortestPath(double current, double target) {
    var diff = (target - current) % (2 * math.pi);
    if (diff > math.pi) diff -= 2 * math.pi;
    if (diff < -math.pi) diff += 2 * math.pi;
    return current + diff;
  }

  static double _smoothstep(double e0, double e1, double x) {
    final t = ((x - e0) / (e1 - e0)).clamp(0.0, 1.0);
    return t * t * (3 - 2 * t);
  }

  // ── Build ────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final botPad = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: _bgColor,
      body: LayoutBuilder(builder: (ctx, constraints) {
        _screenW = constraints.maxWidth;
        _screenH = constraints.maxHeight;

        // Sort nodes back-to-front for correct z-order
        final sorted = [..._nodes]..sort((a, b) => a.depth.compareTo(b.depth));

        return GestureDetector(
          onPanStart: _onPanStart,
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          behavior: HitTestBehavior.opaque,
          child: Stack(
            children: [
              // ── Background ─────────────────────────────────────────────────
              RepaintBoundary(
                child: CustomPaint(
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                  painter: _BackgroundPainter(
                    glowPhase: _glowPhase,
                    particles: _particles,
                    elapsed: _lastElapsed,
                  ),
                ),
              ),

              // ── Globe nodes ─────────────────────────────────────────────────
              AnimatedOpacity(
                duration: const Duration(milliseconds: 280),
                opacity: _nodesOpacity,
                child: Stack(
                  children: sorted.map((node) {
                    final depthT = (node.depth + 1) / 2;
                    final nodeOpacity = _lerpD(0.08, 1.0, depthT);
                    final nodeScale = _lerpD(0.5, 1.05, depthT);
                    // Estimate node width for centering
                    final estimatedW = node.morph > 0.05
                        ? _lerpD(110, 210, node.morph)
                        : 110.0;
                    final estimatedH = node.morph > 0.3 ? 90.0 : 40.0;

                    return Positioned(
                      left: node.screenX - estimatedW / 2,
                      top: node.screenY - estimatedH / 2,
                      child: Opacity(
                        opacity: nodeOpacity.clamp(0.0, 1.0),
                        child: Transform.scale(
                          scale: nodeScale,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => _onNodeTap(node),
                            child: _GlobeNodeWidget(node: node),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              // ── Loading spinner ─────────────────────────────────────────────
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(
                    color: _accentColor,
                    strokeWidth: 2,
                  ),
                ),

              // ── Top bar ─────────────────────────────────────────────────────
              Positioned(
                top: topPad + 8,
                left: 16,
                right: 16,
                child: _TopBar(
                  word: _currentWord?.word ?? widget.word.word,
                  onBack: () => Navigator.of(context).pop(),
                ),
              ),

              // ── Breadcrumb ──────────────────────────────────────────────────
              if (_history.length > 1)
                Positioned(
                  bottom: botPad + 16,
                  left: 16,
                  right: 16,
                  child: _Breadcrumb(history: _history),
                ),
            ],
          ),
        );
      }),
    );
  }

  static double _lerpD(double a, double b, double t) =>
      a + (b - a) * t.clamp(0.0, 1.0);
}

// ── Background CustomPainter ──────────────────────────────────────────────────
class _BackgroundPainter extends CustomPainter {
  const _BackgroundPainter({
    required this.glowPhase,
    required this.particles,
    required this.elapsed,
  });

  final double glowPhase;
  final List<_Particle> particles;
  final Duration elapsed;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final secs = elapsed.inMilliseconds / 1000.0;

    // Base fill
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = _bgColor,
    );

    // Ambient radial glow (pulsing)
    final glowAlpha = 0.12 + 0.04 * math.sin(glowPhase);
    final glowShader = RadialGradient(
      colors: [
        _accentColor.withValues(alpha: glowAlpha),
        Colors.transparent,
      ],
    ).createShader(Rect.fromCircle(
      center: Offset(cx, cy),
      radius: size.width * 0.55,
    ));
    canvas.drawRect(Offset.zero & size, Paint()..shader = glowShader);

    // Grid rings (3 concentric circles)
    final ringPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.035)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    for (final fraction in [0.22, 0.37, 0.52]) {
      canvas.drawCircle(Offset(cx, cy), size.width * fraction, ringPaint);
    }

    // Particles (tiny fading dots)
    final dotPaint = Paint()..style = PaintingStyle.fill;
    for (final p in particles) {
      final t = (secs * p.speed + p.phase) % (math.pi * 2);
      final alpha = (0.05 + 0.13 * math.sin(t)).clamp(0.0, 1.0);
      dotPaint.color = Colors.white.withValues(alpha: alpha);
      canvas.drawCircle(
        Offset(p.x * size.width, p.y * size.height),
        p.size,
        dotPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_BackgroundPainter old) => true; // driven by ticker
}

// ── Globe node widget ─────────────────────────────────────────────────────────
class _GlobeNodeWidget extends StatelessWidget {
  const _GlobeNodeWidget({required this.node});

  final _GlobeNode node;

  static double _l(double a, double b, double t) =>
      a + (b - a) * t.clamp(0.0, 1.0);

  static double _ss(double e0, double e1, double x) {
    final t = ((x - e0) / (e1 - e0)).clamp(0.0, 1.0);
    return t * t * (3 - 2 * t);
  }

  @override
  Widget build(BuildContext context) {
    final m = node.morph;

    final width = _l(110, 210, m);
    final hPad = _l(16, 20, m);
    final vPad = _l(10, 26, m);
    final borderRadius = _l(40, 22, m);
    final wordSize = _l(14, 26, m);
    final detailOpacity = _ss(0.35, 0.9, m);

    // Background
    final Color bg;
    final Gradient? gradient;
    if (m > 0.3) {
      bg = Colors.transparent;
      gradient = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF1C2030), Color(0xFF252A3A)],
      );
    } else {
      bg = const Color(0x0DFFFFFF); // rgba(255,255,255,0.05)
      gradient = null;
    }

    final borderAlpha = _l(0.07, 0.35, m);
    final borderCol = m > 0.2
        ? Color.lerp(
            Colors.white.withValues(alpha: 0.07),
            _accentColor.withValues(alpha: 0.35),
            m,
          )!
        : Colors.white.withValues(alpha: borderAlpha);

    final List<BoxShadow>? shadows = m > 0.15
        ? [
            BoxShadow(
              color: _accentColor.withValues(alpha: m * 0.28),
              blurRadius: 50 * m,
              spreadRadius: -4,
            ),
          ]
        : null;

    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: gradient,
        color: gradient == null ? bg : null,
        border: Border.all(color: borderCol, width: 1.0),
        boxShadow: shadows,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Word title — always visible, morphs from chip label to headline
          Text(
            node.data.word,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: _textColor,
              fontSize: wordSize,
              fontWeight: m > 0.4 ? FontWeight.w700 : FontWeight.w600,
              fontFamily: m > 0.5 ? 'serif' : null,
              letterSpacing: m > 0.4 ? 0.5 : 0,
            ),
          ),

          // POS micro-label (chip state only)
          if (m < 0.25 && node.data.primaryPos != null)
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Text(
                node.data.primaryPos!.toUpperCase(),
                style: const TextStyle(
                  fontSize: 9,
                  color: _textMutedColor,
                  letterSpacing: 1.0,
                ),
              ),
            ),

          // Detail section — fades in as morph grows
          if (m > 0.3)
            Opacity(
              opacity: detailOpacity,
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Phonetic
                    if (node.data.hasIpa) ...[
                      Text(
                        '/${node.data.ipa}/',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: _accentSoftColor,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 6),
                    ],

                    // POS badge
                    if (node.data.primaryPos != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: _accentColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          node.data.primaryPos!.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: _accentSoftColor,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                    ],

                    // Primary definition
                    if (node.data.primaryDefinition != null)
                      Text(
                        node.data.primaryDefinition!,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.5,
                          height: 1.55,
                          color: _textDimColor,
                        ),
                      ),
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
class _TopBar extends StatelessWidget {
  const _TopBar({required this.word, required this.onBack});

  final String word;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onBack,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.10),
              ),
            ),
            child: const Icon(Icons.arrow_back, color: _textColor, size: 20),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Word Web',
                style: TextStyle(
                  color: _textMutedColor,
                  fontSize: 11,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                word,
                style: const TextStyle(
                  color: _textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        // Hint icon
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: const Center(
            child: Text('🌐', style: TextStyle(fontSize: 18)),
          ),
        ),
      ],
    );
  }
}

// ── Breadcrumb nav trail ──────────────────────────────────────────────────────
class _Breadcrumb extends StatelessWidget {
  const _Breadcrumb({required this.history});

  final List<String> history;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (int i = 0; i < history.length; i++) ...[
            if (i > 0)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Icon(Icons.chevron_right, color: _textMutedColor, size: 14),
              ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: i == history.length - 1
                    ? _accentColor.withValues(alpha: 0.16)
                    : Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: i == history.length - 1
                      ? _accentColor.withValues(alpha: 0.38)
                      : Colors.white.withValues(alpha: 0.07),
                ),
              ),
              child: Text(
                history[i],
                style: TextStyle(
                  fontSize: 12,
                  color: i == history.length - 1
                      ? _accentSoftColor
                      : _textMutedColor,
                  fontWeight: i == history.length - 1
                      ? FontWeight.w600
                      : FontWeight.w400,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
