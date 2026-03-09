# Word Web Globe — Flutter Implementation Spec

## 1. Core Concept

Một sphere ảo chứa **tất cả** word nodes (bao gồm cả từ đang focus).
Không có "center card" cố định — mọi node đều bình đẳng trên sphere.
Node nào gần **tâm màn hình** nhất thì tự **morph expand** thành card detail.
Node nào xa thì tự **morph shrink** thành chip nhỏ.
Transition **liên tục, smooth** — không có rebuild/reload khi chuyển focus.

---

## 2. Layout — Sphere Distribution

### Sphere params
```
sphereRadius = min(screenWidth, screenHeight) * 0.28
centerX = screenWidth / 2
centerY = screenHeight / 2
```

### Node placement
- Dùng **Fibonacci Sphere** để phân bố N+1 điểm đều trên sphere
  (N = số related words, +1 = current word)
- Current word đặt tại **front pole** (theta=0, phi=π/2) → xuất hiện ngay trước mặt
- Related words phân bố đều trên phần còn lại

### Projection (Spherical → Screen 2D)
```dart
// Spherical → Cartesian
x = sin(phi) * cos(theta)
y = cos(phi)
z = sin(phi) * sin(theta)

// Rotate by user gesture (rotX = vertical, rotY = horizontal)
// Rotate around Y axis
x1 = x * cos(rotY) - z * sin(rotY)
z1 = x * sin(rotY) + z * cos(rotY)

// Rotate around X axis
y2 = y * cos(rotX) - z1 * sin(rotX)
z2 = y * sin(rotX) + z1 * cos(rotX)

// Perspective projection
perspective = 600
scale3d = perspective / (perspective + z2 * sphereRadius)
screenX = centerX + x1 * sphereRadius * scale3d
screenY = centerY - y2 * sphereRadius * scale3d
depth = z2  // -1.0 (back) → +1.0 (front)
```

---

## 3. Node Morphing — Chip ↔ Detail Card

Mỗi frame, mỗi node tính **morph factor** (0.0 → 1.0):

```dart
distFromCenter = sqrt((screenX - centerX)² + (screenY - centerY)²)
proximityFactor = 1.0 - clamp(distFromCenter / 140, 0, 1)  // gần center → 1
depthFactor = smoothstep(-0.2, 0.8, depth)                   // phải ở front hemisphere
morph = proximityFactor * depthFactor                         // 0 = chip, 1 = detail card
```

### Properties interpolated by morph:

| Property       | morph=0 (chip)            | morph=1 (detail card)           |
|----------------|---------------------------|---------------------------------|
| width          | auto (~100-120px)         | 210px                           |
| padding        | 10px 16px                 | 26px 20px                       |
| borderRadius   | 40px (pill)               | 22px (rounded rect)             |
| fontSize(word) | 14px                      | 26px (DM Serif Display)         |
| background     | rgba(255,255,255,0.05)    | gradient(#1C2030, #252A3A)      |
| border         | rgba(255,255,255,0.07)    | rgba(accent, 0.25)              |
| boxShadow      | none                      | 0 0 60px accent glow            |
| detail section | opacity=0, maxHeight=0    | opacity=1, maxHeight=140px      |
|   phonetic     | hidden                    | 13px, accent-soft color         |
|   POS badge    | hidden                    | 10px uppercase, accent bg       |
|   definition   | hidden                    | 12.5px, text-dim color          |

### Depth-based properties (independent of morph):
```dart
nodeScale = lerp(0.5, 1.05, (depth + 1) / 2)
nodeOpacity = lerp(0.08, 1.0, (depth + 1) / 2)
zIndex = (depth + 1) * 50 + morph * 100
```

**Quan trọng:** Morph diễn ra LIÊN TỤC mỗi frame, không có animation riêng.
Khi user xoay globe, node tự nhiên expand/shrink theo vị trí.

---

## 4. Gesture — Globe Rotation

### Pan (Hold & Drag)
```dart
GestureDetector(
  onPanStart: (details) {
    _isDragging = true;
    _velocityX = 0; _velocityY = 0;
    _recentVelocities.clear();
  },
  onPanUpdate: (details) {
    double dx = details.delta.dx;
    double dy = details.delta.dy;
    
    // Horizontal drag → rotate Y, Vertical drag → rotate X
    rotY += dx * sensitivity;  // sensitivity ≈ 0.007
    rotX += -dy * sensitivity;
    
    _recentVelocities.add(Offset(dx, dy));
    if (_recentVelocities.length > 5) _recentVelocities.removeAt(0);
  },
  onPanEnd: (details) {
    _isDragging = false;
    // Fling momentum from recent velocities average
    final avg = _averageRecentVelocities();
    _velocityY = avg.dx * sensitivity * 1.3;
    _velocityX = -avg.dy * sensitivity * 1.3;
    // Cap velocity
    _velocityX = _velocityX.clamp(-0.08, 0.08);
    _velocityY = _velocityY.clamp(-0.08, 0.08);
  },
)
```

### Momentum & Friction (mỗi frame trong Ticker)
```dart
void _onTick(Duration elapsed) {
  if (!_isDragging) {
    _velocityX *= 0.94;  // friction
    _velocityY *= 0.94;
    if (_velocityX.abs() < 0.0002) _velocityX = 0;
    if (_velocityY.abs() < 0.0002) _velocityY = 0;
  }
  rotX += _velocityX;
  rotY += _velocityY;
  
  setState(() {}); // rebuild positions
}
```

---

## 5. Tap to Navigate

Khi user **tap** vào một chip (không drag):
- **KHÔNG rebuild ngay** — thay vào đó, animate globe rotation
  sao cho node được tap **xoay smooth về center**
- Tính delta angle cần xoay:
  ```dart
  // Node's current projected angle relative to front
  targetRotY = rotY - node.theta  // (simplified)
  targetRotX = rotX - (node.phi - π/2)
  ```
- Dùng `Tween` + `CurvedAnimation(Curves.easeInOutCubic, 500ms)`
  để animate `rotX`, `rotY` về target
- Khi node đến center → morph tự nhiên expand nó lên
- **SAU KHI** node đã expand xong (≈600ms) → gọi `rebuildGlobe(newWord)`
  để fetch related words mới, phân bố lại sphere

### Rebuild khi focus thay đổi
```dart
void rebuildGlobe(String newWord) {
  // 1. Fade out all nodes EXCEPT the new center word
  // 2. Fetch related words cho newWord
  // 3. Phân bố lại Fibonacci sphere (newWord ở front pole)
  // 4. Fade in new nodes staggered
  // 5. Update history, breadcrumb
}
```

**Khi xoay thủ công** (không tap):
- Khi globe dừng hẳn (velocity=0) + pointer up
- Đợi ~600ms
- Nếu node gần center nhất khác currentWord → `rebuildGlobe()`
- Tương tự flow tap nhưng không có animate rotation (đã ở center rồi)

---

## 6. Visual Design

### Color scheme
```dart
bg:          #0D0F15
surface:     #161923
accent:      #F97B2C
accentSoft:  #FFAA6B
accentGlow:  rgba(249,123,44, 0.18)
text:        #F0EDE8
textDim:     #8B8D97
textMuted:   #4E5060
```

### Typography
- Word title (expanded): DM Serif Display, 26px
- Word title (chip): Plus Jakarta Sans, 14px, 600 weight
- Phonetic: Plus Jakarta Sans, 13px, 500 weight, accentSoft
- POS badge: 10px, 700 weight, uppercase, letter-spacing 1.5px
- Definition: 12.5px, line-height 1.55, textDim
- Chip POS: 9px, uppercase, textMuted

### Background elements
- Ambient glow: RadialGradient centered, accent color, pulsing opacity
- Grid rings: 3 concentric circles (400px, 260px, 120px), very subtle borders
- Particles: tiny dots (2-4px), random spawn, fade in/out animation

### Node styling
- Chip state: pill shape, glassmorphism (blur backdrop), subtle border
- Card state: rounded rect, solid gradient bg, accent border glow, deep shadow
- "Near center" highlight: border turns accent, subtle glow appears

---

## 7. Widget Tree (Flutter)

```
Scaffold
├── Stack
│   ├── AmbientBackground (CustomPainter, animated)
│   ├── GridRings (3x Container with circular border)
│   ├── GestureDetector (covers full screen)
│   │   └── CustomPaint / Stack
│   │       └── for each node: Positioned(
│   │             left: screenX, top: screenY,
│   │             child: GlobeNodeWidget(morph, depth, wordData)
│   │           )
│   ├── TopBar (back button, title, menu)
│   └── Breadcrumb (bottom, horizontal chips)
```

### GlobeNodeWidget
```dart
class GlobeNodeWidget extends StatelessWidget {
  final double morph;     // 0→1
  final double depth;     // -1→1
  final double scale;
  final double opacity;
  final WordData data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: opacity,
        child: Transform.scale(
          scale: scale,
          child: AnimatedContainer(
            duration: Duration.zero,  // instant, driven by morph
            width: morph > 0.1 ? lerp(120, 210, morph) : null,
            padding: EdgeInsets.symmetric(
              horizontal: lerp(16, 20, morph),
              vertical: lerp(10, 26, morph),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(lerp(40, 22, morph)),
              gradient: morph > 0.3 ? cardGradient(morph) : null,
              color: morph <= 0.3 ? chipBgColor : null,
              border: Border.all(color: borderColor(morph)),
              boxShadow: morph > 0.2 ? [cardShadow(morph)] : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Word title — always visible
                Text(data.word, style: wordStyle(morph)),
                
                // Detail section — conditional
                if (morph > 0.3) ...[
                  Opacity(
                    opacity: smoothstep(0.4, 0.9, morph),
                    child: Column(children: [
                      Text(data.phonetic, style: phoneticStyle),
                      POSBadge(data.pos),
                      Text(data.definition, style: defStyle),
                    ]),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

---

## 8. State Management (Riverpod)

```dart
// Provider cho related words
final relatedWordsProvider = FutureProvider.family<List<WordModel>, String>(
  (ref, word) async {
    return ref.read(vocmapRepositoryProvider).getRelatedWords(word);
  },
);

// State cho globe
class GlobeState {
  final String currentWord;
  final List<GlobeNode> nodes;  // all nodes on sphere
  final double rotX, rotY;
  final double velX, velY;
  final List<String> history;
}

class GlobeNode {
  final String word;
  final WordData data;
  final double theta, phi;  // sphere position
  double screenX, screenY;  // computed each frame
  double depth, morph;       // computed each frame
}
```

---

## 9. Performance Notes

- **Ticker-driven**, không dùng `setState` mỗi frame cho toàn bộ widget tree
- Dùng `CustomPainter` hoặc `RepaintBoundary` cho nodes
- Hoặc: mỗi node là `ValueListenableBuilder` listen vào computed position
- Sphere math = pure arithmetic, rất nhẹ cho 10-12 nodes
- Backdrop blur chỉ áp dụng cho chip state (morph < 0.3), tắt khi expand
- Particles: dùng `CustomPainter` vẽ hết trong 1 layer, không spawn widget riêng

---

## 10. Entry Points

```dart
// Từ WordDetailSheet, ScanResults, DomainList, etc.
OutlinedButton(
  onPressed: () => Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (_, __, ___) => WordWebScreen(initialWord: word),
      transitionsBuilder: (_, anim, __, child) =>
        FadeTransition(opacity: anim, child: child),
      transitionDuration: Duration(milliseconds: 400),
    ),
  ),
  child: Text('Explore Word Web'),
)
```

---

## 11. Key Differences from HTML Prototype (Bug Fixes)

| HTML Bug                                    | Flutter Correct Behavior                          |
|---------------------------------------------|---------------------------------------------------|
| Center card cố định, không xoay theo globe  | Mọi node trên sphere, xoay cùng nhau             |
| Rebuild/flash khi switch word               | Smooth rotate → morph → rebuild sau khi settle    |
| Nodes quá thưa, quá nhỏ                    | sphereRadius lớn hơn, chip size 120px min          |
| Tap navigate = instant jump                 | Tap → animate rotate tới center → morph → rebuild |
| Detail card "nhảy" khi switch               | Morph liên tục theo distance, không có jump        |