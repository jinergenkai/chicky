import 'dart:math' as math;

import '../../data/word_graph.dart';

/// A word node currently rendered on the 3D sphere.
class VisualNode {
  VisualNode({
    required this.graphNode,
    required this.nx,
    required this.ny,
    required this.nz,
  });

  final WordGraphNode graphNode;

  /// Fixed unit-sphere position (hash-based, stable per word).
  final double nx, ny, nz;

  /// Fade lifecycle: 0 = invisible → 1 = fully opaque.
  double fadeOpacity = 0.0;

  /// Whether this node is fading out and should be removed when fadeOpacity hits 0.
  bool markedForRemoval = false;

  // ── Per-frame computed values ────────────────────────────────────────────
  double screenX = 0;
  double screenY = 0;
  double depth = 0;   // −1 (back) → +1 (front)
  double morph = 0;   // 0 (chip) → 1 (detail card)

  String get wordId => graphNode.id;
}

/// Manages which data-graph nodes are visible on the sphere and their fade lifecycle.
class VisualGraph {
  VisualGraph({required this.graph});

  final WordGraph graph;

  final Map<String, VisualNode> _visual = {};

  /// How many graph-hops from focus to include in visual.
  static const int showDistance = 3;

  /// Nodes at this distance start fading out.
  static const int fadeOutDistance = 4;

  /// Fade speeds (opacity per second).
  static const double fadeInSpeed = 3.0;   // ~330ms to full
  static const double fadeOutSpeed = 4.0;  // ~250ms to zero

  /// Distance-based opacity multiplier.
  static const List<double> _distOpacity = [1.0, 1.0, 0.75, 0.45, 0.2];

  /// All visual nodes (for rendering).
  Iterable<VisualNode> get nodes => _visual.values;

  /// Get a specific visual node by word ID.
  VisualNode? operator [](String id) => _visual[id];

  // ── Tick ─────────────────────────────────────────────────────────────────

  /// Called each frame. Adds/removes/fades visual nodes based on graph state.
  void tick(double dtSeconds) {
    final focusId = graph.focusId;
    if (focusId == null) return;

    // 1. Add nodes that should be visible but aren't yet
    for (final gn in graph.nodesWithin(showDistance)) {
      if (!_visual.containsKey(gn.id)) {
        _visual[gn.id] = VisualNode(
          graphNode: gn,
          nx: _stableNx(gn.id),
          ny: _stableNy(gn.id),
          nz: _stableNz(gn.id),
        );
      }
    }

    // 2. Mark far-away nodes for removal
    for (final vn in _visual.values) {
      final dist = vn.graphNode.distanceFromFocus;
      if (dist > fadeOutDistance || !graph.contains(vn.wordId)) {
        vn.markedForRemoval = true;
      } else {
        vn.markedForRemoval = false; // un-mark if user came back
      }
    }

    // 3. Update fade opacities
    final toRemove = <String>[];
    for (final vn in _visual.values) {
      if (vn.markedForRemoval) {
        vn.fadeOpacity = (vn.fadeOpacity - dtSeconds * fadeOutSpeed).clamp(0.0, 1.0);
        if (vn.fadeOpacity <= 0.0) toRemove.add(vn.wordId);
      } else {
        vn.fadeOpacity = (vn.fadeOpacity + dtSeconds * fadeInSpeed).clamp(0.0, 1.0);
      }
    }
    for (final id in toRemove) {
      _visual.remove(id);
    }
  }

  /// Project all visual nodes to screen coordinates.
  void computePositions(
    double rotX,
    double rotY,
    double screenW,
    double screenH,
    double sphereRadius,
  ) {
    if (screenW == 0) return;
    final cx = screenW / 2, cy = screenH / 2;
    const perspective = 800.0;

    for (final vn in _visual.values) {
      // Rotate Y
      final x1 = vn.nx * math.cos(rotY) - vn.nz * math.sin(rotY);
      final z1 = vn.nx * math.sin(rotY) + vn.nz * math.cos(rotY);
      // Rotate X
      final y2 = vn.ny * math.cos(rotX) - z1 * math.sin(rotX);
      final z2 = vn.ny * math.sin(rotX) + z1 * math.cos(rotX);
      // Perspective
      final scale3d = perspective / (perspective + z2 * sphereRadius);
      vn.screenX = cx + x1 * sphereRadius * scale3d;
      vn.screenY = cy - y2 * sphereRadius * scale3d;
      vn.depth = z2;
      // Morph – tight zone so only the dead-center word expands
      final dist = math.sqrt(
        math.pow(vn.screenX - cx, 2) + math.pow(vn.screenY - cy, 2),
      );
      final prox = (1.0 - (dist / 80.0).clamp(0.0, 1.0));
      final sharpProx = prox * prox; // quadratic falloff
      final depthF = _smoothstep(0.1, 0.8, z2); // must be clearly in front
      vn.morph = (sharpProx * depthF).clamp(0.0, 1.0);
    }
  }

  /// Final display opacity for a node: fade × depth × distance factor.
  double displayOpacity(VisualNode vn) {
    final depthT = (vn.depth + 1) / 2;
    final depthOp = _lerp(0.08, 1.0, depthT);
    final distIdx = vn.graphNode.distanceFromFocus
        .clamp(0, _distOpacity.length - 1);
    final distOp = _distOpacity[distIdx];
    return (vn.fadeOpacity * depthOp * distOp).clamp(0.0, 1.0);
  }

  /// Scale based on depth.
  double displayScale(VisualNode vn) {
    final depthT = (vn.depth + 1) / 2;
    return _lerp(0.5, 1.05, depthT);
  }

  // ── Stable hash-based sphere positions ─────────────────────────────────

  /// FNV-1a hash for deterministic, cross-platform stability.
  static int _fnv1a(String s) {
    var hash = 0x811c9dc5;
    for (var i = 0; i < s.length; i++) {
      hash ^= s.codeUnitAt(i);
      hash = (hash * 0x01000193) & 0xFFFFFFFF;
    }
    return hash;
  }

  static double _stableNx(String id) {
    final h = _fnv1a(id);
    final h1 = (h & 0xFFFF) / 65536.0;
    final h2 = ((h >> 16) & 0xFFFF) / 65536.0;
    final theta = h1 * 2 * math.pi;
    final phi = math.acos(1 - 2 * h2);
    return math.sin(phi) * math.cos(theta);
  }

  static double _stableNy(String id) {
    final h = _fnv1a(id);
    final h2 = ((h >> 16) & 0xFFFF) / 65536.0;
    final phi = math.acos(1 - 2 * h2);
    return math.cos(phi);
  }

  static double _stableNz(String id) {
    final h = _fnv1a(id);
    final h1 = (h & 0xFFFF) / 65536.0;
    final h2 = ((h >> 16) & 0xFFFF) / 65536.0;
    final theta = h1 * 2 * math.pi;
    final phi = math.acos(1 - 2 * h2);
    return math.sin(phi) * math.sin(theta);
  }

  /// Get the stable sphere position for a word ID.
  static (double, double, double) stablePosition(String id) {
    return (_stableNx(id), _stableNy(id), _stableNz(id));
  }

  // ── Helpers ────────────────────────────────────────────────────────────

  static double _smoothstep(double e0, double e1, double x) {
    final t = ((x - e0) / (e1 - e0)).clamp(0.0, 1.0);
    return t * t * (3 - 2 * t);
  }

  static double _lerp(double a, double b, double t) =>
      a + (b - a) * t.clamp(0.0, 1.0);
}
