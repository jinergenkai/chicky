import 'dart:collection';

import 'models/word_model.dart';
import 'repositories/vocab_repository.dart';

/// A node in the BFS exploration graph.
class WordGraphNode {
  WordGraphNode({required this.data});

  final WordModel data;

  /// Hop count from the current focus word. Recomputed on focus change.
  int distanceFromFocus = 0;

  /// Whether we have already fetched this node's neighbors.
  bool isFetched = false;

  String get id => data.id;
}

/// BFS-expanding graph that grows ahead of the user's exploration.
///
/// Two responsibilities:
/// 1. Maintain an adjacency-list graph of words + relationships.
/// 2. Asynchronously expand the frontier via [expandNext].
///
/// The graph is invisible — it is pure data. The visual layer reads from it.
class WordGraph {
  WordGraph({this.onChanged, this.prefetchDepth = 3, this.maxDistance = 6});

  /// Called after each structural change (new nodes, prune, focus change).
  final void Function()? onChanged;

  /// How many hops ahead of focus to pre-fetch.
  final int prefetchDepth;

  /// Nodes farther than this from focus get pruned.
  final int maxDistance;

  // ── Storage ────────────────────────────────────────────────────────────────
  final Map<String, WordGraphNode> _nodes = {};
  final Map<String, Set<String>> _edges = {};

  String? _focusId;

  // BFS expansion queue: sorted by distance (closest first)
  final Queue<String> _fetchQueue = Queue();
  final Set<String> _fetching = {};
  bool _fetchInFlight = false;

  // ── Public API ─────────────────────────────────────────────────────────────

  String? get focusId => _focusId;
  WordGraphNode? get focusNode => _focusId != null ? _nodes[_focusId] : null;

  /// All nodes currently in the graph.
  Iterable<WordGraphNode> get allNodes => _nodes.values;

  /// Returns nodes within [maxDist] hops of focus.
  List<WordGraphNode> nodesWithin(int maxDist) {
    return _nodes.values
        .where((n) => n.distanceFromFocus <= maxDist)
        .toList();
  }

  /// Get a node by ID.
  WordGraphNode? operator [](String id) => _nodes[id];

  /// Get neighbors of a node.
  Set<String> neighborsOf(String id) => _edges[id] ?? {};

  /// Whether the graph contains this word.
  bool contains(String id) => _nodes.containsKey(id);

  // ── Mutation ───────────────────────────────────────────────────────────────

  /// Add a single word to the graph (if not already present).
  WordGraphNode addNode(WordModel word) {
    return _nodes.putIfAbsent(word.id, () {
      _edges.putIfAbsent(word.id, () => {});
      return WordGraphNode(data: word);
    });
  }

  /// Add a directed edge between two word IDs (bidirectional).
  void addEdge(String a, String b) {
    _edges.putIfAbsent(a, () => {});
    _edges.putIfAbsent(b, () => {});
    _edges[a]!.add(b);
    _edges[b]!.add(a);
  }

  /// Set the focus word. Recomputes all distances via local BFS.
  /// Enqueues unfetched nodes for expansion. Prunes far-away nodes.
  void setFocus(String wordId) {
    if (!_nodes.containsKey(wordId)) return;
    _focusId = wordId;
    _recomputeDistances();
    _rebuildFetchQueue();
    prune();
    onChanged?.call();
  }

  /// Fetches one word's neighbors from the repository.
  /// Call this from the ticker — it's a no-op if nothing to do or already in flight.
  Future<void> expandNext(VocabRepository repo) async {
    if (_fetchInFlight) return;
    if (_fetchQueue.isEmpty) return;

    // Dequeue the next unfetched word
    String? nextId;
    while (_fetchQueue.isNotEmpty) {
      final candidate = _fetchQueue.removeFirst();
      final node = _nodes[candidate];
      if (node != null && !node.isFetched && !_fetching.contains(candidate)) {
        nextId = candidate;
        break;
      }
    }
    if (nextId == null) return;

    _fetchInFlight = true;
    _fetching.add(nextId);

    try {
      final related = await repo.getRelatedWords(nextId);

      // Insert new nodes and edges
      for (final word in related) {
        addNode(word);
        addEdge(nextId, word.id);
      }

      _nodes[nextId]?.isFetched = true;
      _recomputeDistances();
      _rebuildFetchQueue();
      onChanged?.call();
    } catch (_) {
      // Mark as fetched even on error to avoid retrying forever
      _nodes[nextId]?.isFetched = true;
    } finally {
      _fetching.remove(nextId);
      _fetchInFlight = false;
    }
  }

  /// Remove nodes farther than [maxDistance] from focus.
  void prune() {
    final toRemove = <String>[];
    for (final node in _nodes.values) {
      if (node.distanceFromFocus > maxDistance && node.id != _focusId) {
        toRemove.add(node.id);
      }
    }
    for (final id in toRemove) {
      _nodes.remove(id);
      final neighbors = _edges.remove(id);
      if (neighbors != null) {
        for (final nId in neighbors) {
          _edges[nId]?.remove(id);
        }
      }
    }
  }

  // ── Internal ───────────────────────────────────────────────────────────────

  /// BFS from focus to recompute distanceFromFocus on all reachable nodes.
  void _recomputeDistances() {
    // Reset all distances to max
    for (final node in _nodes.values) {
      node.distanceFromFocus = maxDistance + 1;
    }

    if (_focusId == null || !_nodes.containsKey(_focusId)) return;

    final queue = Queue<String>();
    queue.add(_focusId!);
    _nodes[_focusId]!.distanceFromFocus = 0;
    final visited = <String>{_focusId!};

    while (queue.isNotEmpty) {
      final current = queue.removeFirst();
      final dist = _nodes[current]!.distanceFromFocus;

      for (final neighborId in (_edges[current] ?? <String>{})) {
        if (visited.contains(neighborId)) continue;
        if (!_nodes.containsKey(neighborId)) continue;
        visited.add(neighborId);
        _nodes[neighborId]!.distanceFromFocus = dist + 1;
        queue.add(neighborId);
      }
    }
  }

  /// Rebuild the fetch queue: unfetched nodes within prefetch range, closest first.
  void _rebuildFetchQueue() {
    _fetchQueue.clear();
    final candidates = _nodes.values
        .where((n) =>
            !n.isFetched &&
            n.distanceFromFocus <= prefetchDepth &&
            !_fetching.contains(n.id))
        .toList()
      ..sort((a, b) => a.distanceFromFocus.compareTo(b.distanceFromFocus));
    for (final c in candidates) {
      _fetchQueue.add(c.id);
    }
  }
}
