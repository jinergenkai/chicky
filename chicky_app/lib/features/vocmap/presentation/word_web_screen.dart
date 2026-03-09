import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/word_model.dart';
import '../data/word_graph.dart';
import '../providers/vocmap_provider.dart';
import 'globe/globe_node_widget.dart';
import 'globe/visual_graph.dart';

class WordWebScreen extends ConsumerStatefulWidget {
  const WordWebScreen({super.key, required this.word});
  final WordModel word;

  @override
  ConsumerState<WordWebScreen> createState() => _WordWebScreenState();
}

class _WordWebScreenState extends ConsumerState<WordWebScreen>
    with TickerProviderStateMixin {

  // ── Graph layers ────────────────────────────────────────────────────────────
  late final WordGraph _graph;
  late final VisualGraph _visual;

  // ── Focus state ────────────────────────────────────────────────────────────
  String _focusId = '';
  final List<String> _history = [];

  // ── Rotation ────────────────────────────────────────────────────────────────
  double _rotX = 0.0, _rotY = 0.0;
  double _velX = 0.0, _velY = 0.0;
  bool _isDragging = false;
  final List<Offset> _recentVels = [];

  // ── Snap animation ──────────────────────────────────────────────────────────
  bool _isAnimatingRot = false;
  double _animFromRotX = 0, _animFromRotY = 0;
  double _animToRotX = 0, _animToRotY = 0;
  Duration? _animStart;
  String? _pendingFocusId; // word to focus after snap completes
  static const int _animMs = 300;

  // Auto-snap
  bool _wasMoving = false;
  bool _justSnapped = false; // prevent cascade: skip auto-snap right after snap completes

  // ── Screen ──────────────────────────────────────────────────────────────────
  double _screenW = 0, _screenH = 0;
  double get _sphereRadius => math.min(_screenW, _screenH) * 0.50;

  // ── Ticker / background ────────────────────────────────────────────────────
  late final Ticker _ticker;
  Duration _lastElapsed = Duration.zero;
  final List<GlobeParticle> _particles = [];
  double _glowPhase = 0.0;

  // ── Init ────────────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();

    _graph = WordGraph(onChanged: _onGraphChanged);
    _visual = VisualGraph(graph: _graph);

    // Seed graph with initial word and set focus
    _graph.addNode(widget.word);

    // ── Mock data for testing ──────────────────────────────────────────────
    final mockWords = [
      const WordModel(id: 'happy', word: 'happy', ipa: 'ˈhæpi', definitions: [{'pos': 'adjective', 'en': 'Feeling or showing pleasure or contentment'}]),
      const WordModel(id: 'sad', word: 'sad', ipa: 'sæd', definitions: [{'pos': 'adjective', 'en': 'Feeling sorrow; unhappy'}]),
      const WordModel(id: 'joyful', word: 'joyful', ipa: 'ˈdʒɔɪfəl', definitions: [{'pos': 'adjective', 'en': 'Full of happiness and joy'}]),
      const WordModel(id: 'angry', word: 'angry', ipa: 'ˈæŋɡri', definitions: [{'pos': 'adjective', 'en': 'Feeling strong displeasure or hostility'}]),
      const WordModel(id: 'love', word: 'love', ipa: 'lʌv', definitions: [{'pos': 'noun', 'en': 'An intense feeling of deep affection'}]),
      const WordModel(id: 'hate', word: 'hate', ipa: 'heɪt', definitions: [{'pos': 'verb', 'en': 'Feel intense dislike or aversion for'}]),
      const WordModel(id: 'peace', word: 'peace', ipa: 'piːs', definitions: [{'pos': 'noun', 'en': 'Freedom from disturbance; tranquility'}]),
      const WordModel(id: 'fear', word: 'fear', ipa: 'fɪr', definitions: [{'pos': 'noun', 'en': 'An unpleasant emotion caused by threat of danger'}]),
      const WordModel(id: 'brave', word: 'brave', ipa: 'breɪv', definitions: [{'pos': 'adjective', 'en': 'Ready to face and endure danger or pain'}]),
      const WordModel(id: 'calm', word: 'calm', ipa: 'kɑːm', definitions: [{'pos': 'adjective', 'en': 'Not showing or feeling nervousness or anger'}]),
      const WordModel(id: 'bright', word: 'bright', ipa: 'braɪt', definitions: [{'pos': 'adjective', 'en': 'Giving out or reflecting much light; shining'}]),
      const WordModel(id: 'dark', word: 'dark', ipa: 'dɑːrk', definitions: [{'pos': 'adjective', 'en': 'With little or no light'}]),
    ];
    for (final w in mockWords) {
      _graph.addNode(w);
      _graph.addEdge(widget.word.id, w.id);
    }
    // Add some cross-edges for realism
    _graph.addEdge('happy', 'joyful');
    _graph.addEdge('sad', 'angry');
    _graph.addEdge('love', 'peace');
    _graph.addEdge('hate', 'angry');
    _graph.addEdge('brave', 'fear');
    _graph.addEdge('calm', 'peace');
    _graph.addEdge('bright', 'dark');
    // ── End mock data ──────────────────────────────────────────────────────

    _graph.setFocus(widget.word.id);
    _focusId = widget.word.id;
    _history.add(widget.word.word);

    // Set initial rotation so the focus word's hash position faces front
    final (nx, _, nz) = VisualGraph.stablePosition(widget.word.id);
    _rotY = math.atan2(nx, nz);
    final z1 = nx * math.sin(_rotY) + nz * math.cos(_rotY);
    final (_, ny, _) = VisualGraph.stablePosition(widget.word.id);
    _rotX = math.atan2(ny, z1);

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
      _particles.add(GlobeParticle(
        x: rng.nextDouble(), y: rng.nextDouble(),
        size: rng.nextDouble() * 2.5 + 1.0,
        phase: rng.nextDouble() * math.pi * 2,
        speed: rng.nextDouble() * 0.4 + 0.2,
      ));
    }
  }

  void _onGraphChanged() {
    // Graph structure changed (new nodes arrived from BFS).
    // No explicit action needed — the ticker picks up changes each frame.
  }

  // ── Tick ────────────────────────────────────────────────────────────────────
  void _onTick(Duration elapsed) {
    if (!mounted) return;

    final dt = (elapsed - _lastElapsed).inMicroseconds / 1e6; // seconds
    _lastElapsed = elapsed;
    _glowPhase += dt * 0.8;

    // 1. Drive snap animation or momentum
    if (_isAnimatingRot) {
      _animStart ??= elapsed;
      final t = ((elapsed - _animStart!).inMilliseconds / _animMs)
          .clamp(0.0, 1.0);
      final c = Curves.easeInOutCubic.transform(t);
      _rotX = _animFromRotX + (_animToRotX - _animFromRotX) * c;
      _rotY = _animFromRotY + (_animToRotY - _animFromRotY) * c;
      if (t >= 1.0) {
        _isAnimatingRot = false;
        _animStart = null;
        _justSnapped = true; // prevent auto-snap cascade
        if (_pendingFocusId != null) {
          _changeFocus(_pendingFocusId!);
          _pendingFocusId = null;
        }
      }
    } else if (!_isDragging) {
      _velX *= 0.82;
      _velY *= 0.82;
      if (_velX.abs() < 0.001) _velX = 0;
      if (_velY.abs() < 0.001) _velY = 0;
      _rotX += _velX;
      _rotY += _velY;
    }

    // 2. Auto-snap when globe comes to rest (skip if we just finished a snap)
    final isMoving =
        _isDragging || _isAnimatingRot || _velX != 0 || _velY != 0;
    if (_wasMoving && !isMoving && _visual.nodes.isNotEmpty) {
      if (_justSnapped) {
        // Snap just completed — don't re-trigger, just update focus
        _justSnapped = false;
        final best = _visual.nodes.reduce(
          (a, b) => a.morph > b.morph ? a : b,
        );
        if (best.wordId != _focusId) _changeFocus(best.wordId);
      } else {
        _autoSnap();
      }
    }
    _wasMoving = isMoving;

    // 3. BFS expansion: one fetch per tick (non-blocking)
    if (_screenW > 0) {
      _graph.expandNext(ref.read(vocabRepositoryProvider));
    }

    // 4. Visual node lifecycle (add/remove/fade)
    _visual.tick(dt);

    // 5. Project to screen
    _visual.computePositions(
        _rotX, _rotY, _screenW, _screenH, _sphereRadius);

    setState(() {});
  }

  // ── Focus change ──────────────────────────────────────────────────────────
  void _changeFocus(String wordId) {
    if (wordId == _focusId) return;

    _graph.setFocus(wordId);
    _focusId = wordId;

    final node = _graph[wordId];
    if (node != null &&
        (_history.isEmpty || _history.last != node.data.word)) {
      _history.add(node.data.word);
    }
  }

  // ── Snap to node ──────────────────────────────────────────────────────────
  void _snapToWordId(String wordId, {bool changeFocus = false}) {
    final (nx, ny, nz) = VisualGraph.stablePosition(wordId);
    final targetRotY = _shortestPath(_rotY, math.atan2(nx, nz));
    final z1 = nx * math.sin(targetRotY) + nz * math.cos(targetRotY);
    final targetRotX = _shortestPath(_rotX, math.atan2(ny, z1));

    _animFromRotX = _rotX;
    _animFromRotY = _rotY;
    _animToRotX = targetRotX;
    _animToRotY = targetRotY;
    _animStart = null;
    _isAnimatingRot = true;
    _velX = 0;
    _velY = 0;
    _pendingFocusId = changeFocus ? wordId : null;
  }

  void _autoSnap() {
    // Find the front-hemisphere node closest to screen center (pure distance)
    final cx = _screenW / 2, cy = _screenH / 2;
    VisualNode? best;
    double bestDist = double.infinity;
    for (final vn in _visual.nodes) {
      if (vn.depth < -0.1) continue; // skip back hemisphere
      final d = math.sqrt(
        math.pow(vn.screenX - cx, 2) + math.pow(vn.screenY - cy, 2),
      );
      if (d < bestDist) {
        bestDist = d;
        best = vn;
      }
    }
    if (best == null) return;

    if (bestDist < 8.0) {
      // Already at center — just change focus if needed
      if (best.wordId != _focusId) _changeFocus(best.wordId);
      return;
    }

    _snapToWordId(
      best.wordId,
      changeFocus: best.wordId != _focusId,
    );
  }

  void _onNodeTap(VisualNode vn) {
    if (vn.morph > 0.7) {
      if (vn.wordId != _focusId) _changeFocus(vn.wordId);
      return;
    }
    _snapToWordId(
      vn.wordId,
      changeFocus: vn.wordId != _focusId,
    );
  }

  // ── Gestures ──────────────────────────────────────────────────────────────
  void _onPanStart(DragStartDetails d) {
    _isDragging = true;
    _velX = 0; _velY = 0;
    _recentVels.clear();
    _isAnimatingRot = false;
    _animStart = null;
    _justSnapped = false;
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
    final avg =
        _recentVels.reduce((a, b) => a + b) / _recentVels.length.toDouble();
    const s = 0.007 * 0.8;
    var vy = (-avg.dx * s).clamp(-0.06, 0.06);
    var vx = (avg.dy * s).clamp(-0.06, 0.06);
    // Suppress minor axis to prevent diagonal drift
    if (vx.abs() > vy.abs() * 2) {
      vy *= 0.3;
    } else if (vy.abs() > vx.abs() * 2) {
      vx *= 0.3;
    }
    _velY = vy;
    _velX = vx;
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  double _shortestPath(double current, double target) {
    var diff = (target - current) % (2 * math.pi);
    if (diff > math.pi) diff -= 2 * math.pi;
    if (diff < -math.pi) diff += 2 * math.pi;
    return current + diff;
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final botPad = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: globeBg,
      body: LayoutBuilder(builder: (ctx, constraints) {
        _screenW = constraints.maxWidth;
        _screenH = constraints.maxHeight;

        // Sort nodes back-to-front for correct z-order
        final sorted = _visual.nodes.toList()
          ..sort((a, b) => a.depth.compareTo(b.depth));

        final focusWord = _graph[_focusId]?.data.word ?? widget.word.word;

        return GestureDetector(
          onPanStart: _onPanStart,
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          behavior: HitTestBehavior.opaque,
          child: Stack(children: [
            // Background
            RepaintBoundary(
              child: CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: GlobeBackgroundPainter(
                  glowPhase: _glowPhase,
                  particles: _particles,
                  elapsed: _lastElapsed,
                ),
              ),
            ),

            // Nodes
            ...sorted.map((vn) {
              final opacity = _visual.displayOpacity(vn);
              if (opacity < 0.01) return const SizedBox.shrink();

              final scale = _visual.displayScale(vn);
              final estW = 80.0 + 140.0 * vn.morph;
              final estH = vn.morph > 0.15 ? 160.0 : 30.0;

              return Positioned(
                left: vn.screenX - estW / 2,
                top: vn.screenY - estH / 2,
                child: Opacity(
                  opacity: opacity,
                  child: Transform.scale(
                    scale: scale,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _onNodeTap(vn),
                      child: GlobeNodeWidget(node: vn),
                    ),
                  ),
                ),
              );
            }),

            // Top bar
            Positioned(
              top: topPad + 8, left: 16, right: 16,
              child: GlobeTopBar(
                word: focusWord,
                onBack: () => Navigator.of(context).pop(),
              ),
            ),

            // Breadcrumb
            if (_history.length > 1)
              Positioned(
                bottom: botPad + 16, left: 16, right: 16,
                child: GlobeBreadcrumb(history: _history),
              ),
          ]),
        );
      }),
    );
  }
}
