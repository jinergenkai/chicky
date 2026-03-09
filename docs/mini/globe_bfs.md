 The core idea: a living, continuous graph — not a "rebuild per word"

  Data layer — a BFS graph that grows ahead of the user:
  - Starts at the initial word, fetches its neighbors (related words)
  - Each neighbor fetches ITS neighbors (depth 2, 3, ...) — BFS expansion
  - The graph grows ahead of where the user is looking — always has data ready 2-3 hops out
  - When a node is very far from the user's current position (distance > threshold, say 10 hops), prune it from the graph to save memory
  - This graph is invisible — it's pure data, no UI

  Visual layer — a viewport into the graph:
  - The screen is a window onto a small slice of the data graph
  - Only nodes within ~2-3 hops of the current "focus word" are rendered
  - Each rendered node's opacity = f(graph_distance + screen_distance) — farther = more transparent
  - As user rotates/drags the globe:
    - Nodes drifting away from center → opacity decreases → at threshold → removed from visual layer
    - Nodes on the side the user is moving TOWARD → pulled from the data graph → added to visual layer with opacity 0 → fade in
  - No rebuild, no re-render of the whole tree. Nodes individually fade in/out as the user explores

  Two graphs:
  1. Data graph (cache/BFS): Map<String, GraphNode> where each node knows its neighbors. Grows via BFS. Pruned when too far. This is the "reservoir" — always bigger than what's visible.
  2. Visual graph (rendered): A subset of the data graph, currently on the sphere. Each visual node has sphere position + opacity. Nodes enter/exit this layer smoothly based on distance
  from focus.

  The movement flow:
  User at word "run"
    Data graph: run → [walk, sprint, jog, fast, move, ...]
                walk → [step, hike, stroll, ...]
                sprint → [dash, race, speed, ...]
                (BFS depth 2-3 already loaded)

    Visual: run(center, opacity=1), walk(near, 0.9), sprint(near, 0.85),
            jog(medium, 0.6), step(far, 0.3), ...

  User rotates toward "walk":
    - "run" drifts from center → opacity drops 1.0 → 0.7
    - "sprint" drifts further → opacity 0.85 → 0.4 → 0.0 → removed from visual
    - "walk" approaches center → opacity 0.9 → 1.0
    - "step", "hike", "stroll" (walk's neighbors) → added to visual at opacity 0 → fade in
    - BFS fires: fetch walk's depth-2 neighbors into data graph

  User arrives at "walk":
    - walk is at center, its neighbors surround it
    - run is still visible but faded (0.5ish)
    - sprint is gone (too far)
    - NO REBUILD happened — just continuous add/remove/opacity

  The hard parts I see:
  1. Sphere positioning: when a new node enters the visual layer, WHERE on the sphere does it go? It needs a stable position that doesn't shift when other nodes enter/leave
  2. Graph distance vs sphere distance: graph hop count determines when to show/hide, but sphere positioning determines visual layout
  3. Performance: BFS expansion must be async and non-blocking; visual layer must update at 60fps

  Your two-graph split is smart because it separates "what data do we have" (grows freely, async, big) from "what do we show" (small, 60fps, smooth opacity transitions).

  ---
  Is this understanding correct? Before I code, I want to confirm:

  1. The sphere positions should be stable per word — once "walk" gets a position, it stays there even as other nodes come and go?
  2. The BFS depth you want pre-loaded — is 2-3 hops ahead enough, or deeper?
  3. When the user moves, the "focus word" is always the one closest to screen center (morph-based, like now)?