# Feature Spec: Camera Scan (Level 2)
## Chicky App — Scan Text from Camera

> **For:** Claude Code / Developer reference  
> **Status:** Ready for implementation  
> **Dependencies:** VocMap feature (user_vocabulary table), Paste Text Scan (Level 1) already implemented  
> **Priority:** High — core acquisition feature

---

## 1. Overview

Camera Scan allows users to take a photo of any English text (menu, book page, sign, screen, document) and instantly see which words they already know, which they're learning, and which are new. Users can tap unknown words to see definitions and add them to their vocabulary vault with one tap.

**Think:** Google Lens for vocabulary — but personalized to what YOU know.

**NOT real-time AR.** User takes a static photo → app processes → shows overlay on captured image. This is simpler, works on all devices, and avoids battery/performance issues.

---

## 2. Tech Stack for This Feature

```yaml
dependencies:
  camera: ^0.11.x              # Camera preview + capture
  google_mlkit_text_recognition: ^0.13.x  # On-device OCR (FREE, unlimited)
  image_picker: ^1.x            # Alternative: pick from gallery
```

**Why ML Kit (not Google Cloud Vision API):**
- Runs entirely on-device — no API calls, no cost, no internet needed
- Free and unlimited — no quota limits
- Fast: ~100-200ms per image on modern phones
- Supports Latin script (English, Vietnamese, French, Spanish, etc.)
- Same underlying technology as Google Lens
- Flutter package `google_mlkit_text_recognition` wraps it cleanly

**ML Kit does NOT support:** Handwriting recognition (printed text only), very small text (<8px), heavily stylized fonts. These are acceptable limitations for MVP.

---

## 3. User Flow

### 3.1 Entry Point

From the Scan tab (bottom navigation), user sees two options:

```
┌─────────────────────────────┐
│  How do you want to scan?   │
│                             │
│  📋 Paste Text              │
│  (Already implemented)      │
│                             │
│  📷 Scan from Camera        │
│  Take a photo or pick from  │
│  gallery                    │
└─────────────────────────────┘
```

### 3.2 Camera Capture Screen

```dart
/// Screen: CameraCaptureScreen
/// 
/// Simple full-screen camera preview with capture button.
/// No complex UI — just camera + capture + flash + gallery.

// Layout:
// ┌─────────────────────────┐
// │                         │
// │     Camera Preview      │
// │     (full screen)       │
// │                         │
// │                         │
// ├─────────────────────────┤
// │  ⚡  [ 📸 Capture ]  🖼 │
// │ flash              gallery│
// └─────────────────────────┘

// Actions:
// - Capture button: take photo → navigate to ScanResultScreen
// - Flash toggle: on/off/auto
// - Gallery button: open image_picker → select existing photo → navigate to ScanResultScreen
// - Back button: return to Scan tab
```

**Implementation notes:**
- Use `camera` package for preview and capture
- Save captured image to temporary directory (not permanent storage)
- Pass image file path to next screen
- Request camera permission on first use (show rationale: "Chicky needs camera to scan text")
- If permission denied → show "Enable camera in Settings" with button to open settings

### 3.3 Scan Result Screen (CORE SCREEN)

This is the most important screen. It shows the captured image with colored overlays on each detected word.

```dart
/// Screen: ScanResultScreen
/// 
/// Input: String imagePath (captured or picked image)
///
/// Processing pipeline:
/// 1. Display image immediately (don't wait for OCR)
/// 2. Run ML Kit text recognition on image
/// 3. For each detected word:
///    a. Extract text and bounding box
///    b. Lemmatize (simpleLemmatize function from Level 1)
///    c. Look up in local Hive cache (VocabCache)
///    d. Classify: known / learning / unknown / ignore
/// 4. Render colored overlays on image at bounding box positions
/// 5. Wait for user interaction (tap words)
```

#### Layout:

```
┌──────────────────────────────────┐
│ ← Back          Scan Result      │ (AppBar)
├──────────────────────────────────┤
│                                  │
│  ┌────────────────────────────┐  │
│  │                            │  │ (InteractiveViewer 
│  │  [Image with overlays]     │  │  — pinch to zoom,
│  │                            │  │  pan to scroll)
│  │  The  chef  prepared       │  │
│  │       ^^^^                 │  │ (red = unknown)
│  │  a  delicious  meal        │  │
│  │     ^^^^^^^^^              │  │ (yellow = learning)
│  │  with  sautéed             │  │
│  │        ^^^^^^^             │  │ (red = unknown)
│  │  vegetables  and           │  │
│  │  fresh  herbs              │  │
│  │                            │  │
│  └────────────────────────────┘  │
│                                  │
│  ┌────────────────────────────┐  │
│  │ 🔴 5 new  🟡 2 learning   │  │ (Stats bar)
│  │ 🟢 28 known               │  │
│  └────────────────────────────┘  │
│                                  │
│  ┌──────┐  ┌──────┐  ┌──────┐  │
│  │Filter│  │Rescan│  │ Done │  │ (Action buttons)
│  └──────┘  └──────┘  └──────┘  │
└──────────────────────────────────┘
```

#### Overlay rendering:

```dart
/// Each detected word gets a colored overlay positioned at its bounding box.
/// 
/// Color scheme:
///   - known/mastered: NO overlay (clean — don't clutter with green)
///   - learning:       yellow border + 20% yellow fill
///   - unknown (in base): red border + 20% red fill  
///   - unknown (not in base): red border + dotted (indicates needs API lookup)
///   - ignore:         no overlay (stop words: the, a, is, and, etc.)
///
/// IMPORTANT: Only overlay unknown + learning words by default.
/// Known words get NO visual treatment — this keeps the image clean.
/// User can toggle "Show all" to see green overlays on known words.

class WordOverlay {
  final String rawText;        // Original text from OCR ("sautéed")
  final String lemma;          // Lemmatized ("sauté" or "sautee")
  final Rect boundingBox;      // Position on image
  final WordStatus status;     // known, learning, unknown, ignore
  final String? wordId;        // UUID if exists in words table
  
  bool get shouldShowOverlay => 
    status == WordStatus.unknown || status == WordStatus.learning;
}
```

#### Stop words filter:

```dart
/// Words to ignore (no overlay, not counted in stats)
const stopWords = {
  // Articles
  'a', 'an', 'the',
  // Prepositions
  'in', 'on', 'at', 'to', 'for', 'of', 'with', 'by', 'from',
  'up', 'out', 'off', 'into', 'onto', 'upon',
  // Conjunctions
  'and', 'or', 'but', 'nor', 'yet', 'so',
  // Pronouns
  'i', 'me', 'my', 'you', 'your', 'he', 'him', 'his',
  'she', 'her', 'it', 'its', 'we', 'us', 'our', 'they', 'them', 'their',
  // Common verbs (too basic to learn)
  'is', 'am', 'are', 'was', 'were', 'be', 'been', 'being',
  'have', 'has', 'had', 'do', 'does', 'did',
  'will', 'would', 'shall', 'should', 'may', 'might',
  'can', 'could', 'must',
  // Others
  'not', 'no', 'yes', 'this', 'that', 'these', 'those',
  'what', 'which', 'who', 'whom', 'how', 'when', 'where', 'why',
  'all', 'each', 'every', 'both', 'few', 'more', 'most',
  'other', 'some', 'any', 'such', 'only', 'very',
  'just', 'also', 'than', 'too', 'here', 'there',
};
```

### 3.4 Word Detail Bottom Sheet

When user taps a highlighted word on the image:

```dart
/// Bottom sheet that slides up, showing word details.
/// 
/// Height: 40-50% of screen (user still sees image context above)
/// 
/// Content:
/// ┌──────────────────────────────────┐
/// │  ─────  (drag handle)            │
/// │                                  │
/// │  sautéed                         │ (word, large font)
/// │  /sɔːˈteɪd/  🔊                 │ (IPA + audio button)
/// │  verb                            │ (part of speech)
/// │                                  │
/// │  to fry quickly in a little      │ (English definition)
/// │  hot oil or fat                  │
/// │                                  │
/// │  "She sautéed the vegetables     │ (example sentence, italic)
/// │   in olive oil"                  │
/// │                                  │
/// │  ── Related ──                   │
/// │  fry · stir-fry · pan-fry · grill│ (related words, tappable)
/// │  Domain: Cooking 🍳              │
/// │                                  │
/// │  ┌────────────────┐ ┌────────┐  │
/// │  │ Add to Vault 📥│ │ Skip   │  │ (action buttons)
/// │  └────────────────┘ └────────┘  │
/// └──────────────────────────────────┘
///
/// If word is already in vault (status = learning):
///   Show "Already in Vault ✓" instead of "Add to Vault"
///   Show FSRS info: "Next review: tomorrow"
///
/// If word is NOT in base words table:
///   Show loading spinner while calling Free Dictionary API
///   Then show definition from API response
///   "Add to Vault" also auto-inserts into words table (verified=false)
```

#### API lookup for unknown words (not in base):

```dart
/// When a word is not found in local words table:
/// 
/// 1. Show bottom sheet immediately with word text + "Looking up..." spinner
/// 2. Call FastAPI: POST /scan/lookup { "word": "sautéed" }
/// 3. FastAPI calls Free Dictionary API + Wordfreq for frequency
/// 4. Response: { id, word, ipa, definitions, frequency_rank, verified: false }
/// 5. Update bottom sheet with definition
/// 6. If user taps "Add to Vault":
///    a. Word is already in words table (auto-inserted by API)
///    b. Insert user_vocabulary record (source: 'scan')
///
/// Fallback if API fails or word not found:
///   Show: "Couldn't find definition for 'sautéed'"
///   Show: "Add anyway?" (user can add and define later)
///   Or: "Try a different spelling?" with text field
```

### 3.5 Scan Summary Screen

After user taps "Done":

```dart
/// Screen: ScanSummaryScreen
///
/// Shows scan statistics and next actions.
///
/// ┌──────────────────────────────────┐
/// │         Scan Complete! 🎉        │
/// │                                  │
/// │  ┌────────────────────────────┐  │
/// │  │  Total words scanned: 42   │  │
/// │  │  ─────────────────────     │  │
/// │  │  🟢 Known:     35  (83%)  │  │
/// │  │  🟡 Learning:   3         │  │
/// │  │  🔴 New added:  4         │  │
/// │  │  ⬜ Skipped:    0         │  │
/// │  └────────────────────────────┘  │
/// │                                  │
/// │  New words added:                │
/// │  ┌────┐ ┌────────┐ ┌──────┐    │
/// │  │chef│ │sautéed │ │herbs │    │ (mini cards)
/// │  └────┘ └────────┘ └──────┘    │
/// │  ┌───────────┐                   │
/// │  │vegetables │                   │
/// │  └───────────┘                   │
/// │                                  │
/// │  ┌──────────────────────────┐   │
/// │  │  Review new words now 📖 │   │ (primary action)
/// │  └──────────────────────────┘   │
/// │  ┌──────────────────────────┐   │
/// │  │  Back to home            │   │ (secondary)
/// │  └──────────────────────────┘   │
/// └──────────────────────────────────┘
///
/// "Review new words now" → navigates to VocMap review session
/// with ONLY the newly added words (filtered review).
```

### 3.6 Save scan session (background)

```dart
/// After scan completes, save session data to Supabase (background, don't block UI):
///
/// INSERT INTO scan_sessions (
///   user_id, source_text, title, 
///   total_words, unknown_count, new_added_count
/// )
/// 
/// source_text = all detected text concatenated
/// title = auto-generated: "Camera scan - Mar 10, 2026" 
///         or first few words of detected text
/// 
/// This data is for future scan history feature (backlog).
```

---

## 4. Processing Pipeline (Detailed)

```
Step 1: Capture/Pick Image
├── camera package: capture photo → save to temp file
├── image_picker: pick from gallery → get file path
└── Output: String imagePath

Step 2: ML Kit Text Recognition  
├── Convert image to InputImage:
│   final inputImage = InputImage.fromFilePath(imagePath);
├── Run recognition:
│   final textRecognizer = TextRecognizer();
│   final recognizedText = await textRecognizer.processImage(inputImage);
├── Output: RecognizedText object containing:
│   ├── blocks[] → paragraphs/regions
│   │   ├── lines[] → individual lines
│   │   │   ├── elements[] → individual words
│   │   │   │   ├── text: String ("sautéed")
│   │   │   │   ├── boundingBox: Rect (position on image)
│   │   │   │   └── recognizedLanguages: List<String>
└── IMPORTANT: Close recognizer after use to free memory:
    await textRecognizer.close();

Step 3: Filter & Classify Words
├── For each element in recognizedText:
│   ├── Clean: remove punctuation, trim whitespace
│   ├── Skip if: empty, single char, number, stop word
│   ├── Lemmatize: simpleLemmatize(word) → headword
│   ├── Lookup headword in VocabCache (Hive local):
│   │   ├── Found + status 'mastered'/'known' → WordStatus.known
│   │   ├── Found + status 'learning'/'review' → WordStatus.learning
│   │   └── Not found → check words table in Hive:
│   │       ├── Found in words → WordStatus.unknown (in base)
│   │       └── Not found → WordStatus.unknownNotInBase
│   └── Create WordOverlay object
└── Output: List<WordOverlay>

Step 4: Coordinate Mapping
├── ML Kit returns bounding boxes relative to ORIGINAL image size
├── Image displayed in InteractiveViewer may be scaled/transformed
├── Need to map: image coordinates → screen coordinates
├── Use: imageSize (original) vs displayedSize (on screen)
│   scale = displayedWidth / originalImageWidth
│   screenX = overlay.boundingBox.left * scale
│   screenY = overlay.boundingBox.top * scale
│   screenWidth = overlay.boundingBox.width * scale
│   screenHeight = overlay.boundingBox.height * scale
└── CRITICAL: Recalculate on zoom/pan (InteractiveViewer transform)

Step 5: Render & Interact
├── Display image with CustomPaint overlay
├── Draw colored rectangles at mapped coordinates
├── GestureDetector on each overlay → show bottom sheet
└── Update overlay color when user adds word to vault
```

---

## 5. Data Flow

```
┌─────────────┐     ┌──────────────┐     ┌───────────────┐
│  Camera/     │────▶│  ML Kit      │────▶│  VocabCache   │
│  Gallery     │     │  (on-device) │     │  (Hive local) │
└─────────────┘     └──────────────┘     └───────┬───────┘
                                                   │
                           ┌───────────────────────┤
                           │                       │
                           ▼                       ▼
                    ┌──────────────┐     ┌──────────────────┐
                    │  Word found  │     │  Word NOT found  │
                    │  in cache    │     │  in cache        │
                    │              │     │                  │
                    │  → Show      │     │  → Call FastAPI  │
                    │    overlay   │     │    /scan/lookup  │
                    │    + detail  │     │  → Get definition│
                    └──────────────┘     │  → Auto-insert   │
                                        │    words table    │
                                        │  → Show to user  │
                                        └──────────────────┘
                                                   │
                                                   ▼
                                        ┌──────────────────┐
                                        │  User taps       │
                                        │  "Add to Vault"  │
                                        │                  │
                                        │  → INSERT into   │
                                        │    user_vocabulary│
                                        │    (source:scan) │
                                        │  → Update local  │
                                        │    Hive cache    │
                                        │  → Change overlay│
                                        │    color red→yel │
                                        └──────────────────┘
```

---

## 6. Local Cache Strategy (VocabCache)

```dart
/// VocabCache uses Hive for instant word lookups during scan.
/// 
/// Pre-loaded data (synced from Supabase on app launch):
/// 
/// Box 'user_vocab': { 
///   "determine": "mastered",
///   "mortgage": "learning",
///   "collateral": "new",
///   ... 
/// }
/// 
/// Box 'base_words': {
///   "determine": {"id": "uuid", "ipa": "/dɪˈtɜːrmɪn/", "cefr": "B1"},
///   "happy": {"id": "uuid", "ipa": "/ˈhæpi/", "cefr": "A1"},
///   ...
/// }
///
/// Sync strategy:
/// - Full sync on first app launch (download all 5000 base words)
/// - Incremental sync on subsequent launches (only changes since last sync)
/// - user_vocab syncs after any vault changes
/// - Offline-capable: scan works without internet using cached data
///   (only API lookup for unknown-not-in-base words needs internet)

class VocabCache {
  late Box _userVocab;
  late Box _baseWords;
  
  Future<void> initialize() async {
    _userVocab = await Hive.openBox('user_vocab');
    _baseWords = await Hive.openBox('base_words');
  }
  
  /// Sync from Supabase (call on app launch)
  Future<void> syncFromSupabase(String userId) async {
    // 1. Sync user vocabulary
    final vocab = await supabase
      .from('user_vocabulary')
      .select('word_id, status, words(word)')
      .eq('user_id', userId);
    
    await _userVocab.clear();
    for (final v in vocab) {
      await _userVocab.put(v['words']['word'], v['status']);
    }
    
    // 2. Sync base words (only if first time or stale)
    if (_baseWords.isEmpty) {
      final words = await supabase
        .from('words')
        .select('id, word, ipa, cefr_level')
        .eq('verified', true);
      
      for (final w in words) {
        await _baseWords.put(w['word'], {
          'id': w['id'],
          'ipa': w['ipa'],
          'cefr': w['cefr_level'],
        });
      }
    }
  }
  
  /// Classify a word during scan
  WordStatus classify(String lemma) {
    // Check user vocabulary first
    final userStatus = _userVocab.get(lemma);
    if (userStatus != null) {
      if (userStatus == 'mastered' || userStatus == 'review') {
        return WordStatus.known;
      }
      return WordStatus.learning;
    }
    
    // Check base words
    final baseWord = _baseWords.get(lemma);
    if (baseWord != null) {
      return WordStatus.unknown; // In base, but user hasn't learned
    }
    
    return WordStatus.unknownNotInBase; // Needs API lookup
  }
  
  /// After user adds word to vault
  void markAsLearning(String lemma) {
    _userVocab.put(lemma, 'learning');
  }
}
```

---

## 7. OCR Accuracy & Error Handling

### 7.1 Fuzzy Matching for OCR Errors

```dart
/// When ML Kit misreads a word (e.g., "hecbs" instead of "herbs"):
/// 
/// 1. Exact lookup fails (not in base_words or user_vocab)
/// 2. Try fuzzy match against base_words keys
/// 3. If match found with Levenshtein distance <= 2 → use that word
/// 4. If no match → treat as unknownNotInBase → API lookup

int levenshteinDistance(String s, String t) {
  if (s.isEmpty) return t.length;
  if (t.isEmpty) return s.length;
  
  List<List<int>> d = List.generate(
    s.length + 1, (_) => List.filled(t.length + 1, 0));
  
  for (int i = 0; i <= s.length; i++) d[i][0] = i;
  for (int j = 0; j <= t.length; j++) d[0][j] = j;
  
  for (int i = 1; i <= s.length; i++) {
    for (int j = 1; j <= t.length; j++) {
      int cost = s[i - 1] == t[j - 1] ? 0 : 1;
      d[i][j] = [
        d[i - 1][j] + 1,      // deletion
        d[i][j - 1] + 1,      // insertion
        d[i - 1][j - 1] + cost // substitution
      ].reduce((a, b) => a < b ? a : b);
    }
  }
  
  return d[s.length][t.length];
}

String? fuzzyLookup(String ocrWord, Iterable<String> dictionary) {
  String? bestMatch;
  int bestDistance = 3; // max distance threshold
  
  for (final word in dictionary) {
    if ((word.length - ocrWord.length).abs() > 2) continue; // skip if length too different
    final dist = levenshteinDistance(ocrWord.toLowerCase(), word);
    if (dist < bestDistance) {
      bestDistance = dist;
      bestMatch = word;
    }
  }
  
  return bestMatch; // null if no close match found
}
```

### 7.2 Language Filtering

```dart
/// ML Kit may detect non-English text (Vietnamese on bilingual menus).
/// Filter strategy:
/// 
/// Option A (Simple): Only process words that are ASCII + common accented chars
/// Option B (Better): Check recognizedLanguages per text block

bool isLikelyEnglish(String word) {
  // Allow ASCII letters + common accented (café, naïve, résumé)
  return RegExp(r'^[a-zA-Zàáâãäåèéêëìíîïòóôõöùúûüýÿñ\-]+$')
      .hasMatch(word);
}

/// In processing pipeline:
for (final element in line.elements) {
  final word = element.text.trim();
  if (!isLikelyEnglish(word)) continue; // skip non-English
  // ... proceed with classification
}
```

### 7.3 Error States

```dart
/// Handle all error cases gracefully:
///
/// 1. Camera permission denied:
///    → Show explanation + "Open Settings" button
///
/// 2. ML Kit returns empty (no text detected):
///    → Show: "No text found in image. Try capturing text that is:
///            • Well-lit  • Not blurry  • Printed (not handwritten)"
///    → Button: "Try again" (back to camera)
///
/// 3. Free Dictionary API fails (for unknown words):
///    → Show word without definition
///    → "Definition unavailable — add to vault and look up later?"
///    → Retry button
///
/// 4. Supabase sync fails:
///    → Use stale local cache (still functional)
///    → Show subtle banner: "Offline mode — some data may be outdated"
///
/// 5. Image too large (>10MB):
///    → Compress before processing
///    → If still fails: "Image too large, try cropping"
```

---

## 8. File Structure

```
lib/features/scan/
├── data/
│   ├── models/
│   │   ├── word_overlay.dart           # WordOverlay data class
│   │   ├── scan_result.dart            # ScanResult with stats
│   │   └── word_status.dart            # Enum: known, learning, unknown, etc.
│   ├── repositories/
│   │   └── scan_repository.dart        # Supabase scan_sessions + API lookup
│   └── services/
│       ├── ocr_service.dart            # ML Kit wrapper
│       ├── vocab_cache.dart            # Hive local cache
│       └── word_classifier.dart        # Lemmatize + classify pipeline
│
├── presentation/
│   ├── scan_tab_screen.dart            # Entry: Paste Text / Camera toggle
│   ├── camera_capture_screen.dart      # Camera preview + capture
│   ├── scan_result_screen.dart         # Image with overlays (CORE)
│   ├── scan_summary_screen.dart        # Stats after scan complete
│   └── widgets/
│       ├── image_overlay_painter.dart  # CustomPainter for word overlays
│       ├── word_detail_sheet.dart      # Bottom sheet with definition
│       ├── scan_stats_bar.dart         # Stats bar (X new, Y learning, Z known)
│       └── mini_word_card.dart         # Small card in summary screen
│
└── providers/
    ├── scan_provider.dart              # Riverpod: scan state management
    ├── camera_provider.dart            # Riverpod: camera state
    └── vocab_cache_provider.dart       # Riverpod: cache initialization
```

---

## 9. Key Implementation Notes

### 9.1 Image Coordinate Mapping

```dart
/// ML Kit bounding boxes are in ORIGINAL image coordinates.
/// When displaying in InteractiveViewer, we need to transform.
///
/// Use a GlobalKey on the image widget to get its rendered size,
/// then calculate scale factor.

class ImageOverlayPainter extends CustomPainter {
  final List<WordOverlay> overlays;
  final Size imageSize;      // Original image dimensions
  final Size displaySize;    // Rendered size on screen
  
  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = displaySize.width / imageSize.width;
    final scaleY = displaySize.height / imageSize.height;
    
    for (final overlay in overlays) {
      if (!overlay.shouldShowOverlay) continue;
      
      final rect = Rect.fromLTWH(
        overlay.boundingBox.left * scaleX,
        overlay.boundingBox.top * scaleY,
        overlay.boundingBox.width * scaleX,
        overlay.boundingBox.height * scaleY,
      );
      
      // Draw colored rectangle
      final paint = Paint()
        ..color = _colorForStatus(overlay.status).withOpacity(0.25)
        ..style = PaintingStyle.fill;
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(4)), paint);
      
      // Draw border
      final borderPaint = Paint()
        ..color = _colorForStatus(overlay.status)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(4)), borderPaint);
    }
  }
  
  Color _colorForStatus(WordStatus status) {
    switch (status) {
      case WordStatus.known: return Colors.green;
      case WordStatus.learning: return Colors.amber;
      case WordStatus.unknown: return Colors.red;
      case WordStatus.unknownNotInBase: return Colors.red;
      default: return Colors.transparent;
    }
  }
}
```

### 9.2 Tap Detection on Overlays

```dart
/// Since overlays are painted on canvas, we need manual hit testing.
/// Wrap the image in a GestureDetector and check tap position
/// against overlay bounding boxes.

GestureDetector(
  onTapUp: (details) {
    final tapPosition = details.localPosition;
    
    // Find which overlay was tapped
    for (final overlay in overlays) {
      final scaledRect = _scaleRect(overlay.boundingBox);
      if (scaledRect.contains(tapPosition)) {
        _showWordDetail(context, overlay);
        break;
      }
    }
  },
  child: CustomPaint(
    painter: ImageOverlayPainter(...),
    child: Image.file(File(imagePath)),
  ),
)
```

### 9.3 Performance Considerations

```
- ML Kit processing: ~100-200ms on modern phones. Run in isolate if needed.
- VocabCache lookup: <1ms per word (Hive is very fast).
- For images with 200+ words: batch the classification, show loading indicator.
- InteractiveViewer: use RepaintBoundary to avoid repainting overlays on every zoom/pan.
- Memory: dispose CameraController and TextRecognizer when leaving screen.
```

---

## 10. Testing Checklist

- [ ] Camera permission flow (grant, deny, deny-forever)
- [ ] Capture photo → OCR → overlays appear at correct positions
- [ ] Gallery pick → same flow works
- [ ] Tap word → bottom sheet shows correct info
- [ ] "Add to Vault" → word status changes, overlay color updates
- [ ] Unknown word (not in base) → API lookup works, definition shows
- [ ] API lookup fails → graceful error message
- [ ] Empty image (no text) → helpful error message
- [ ] Blurry image → partial results shown, not crash
- [ ] Bilingual image (Vi+En) → only English words highlighted
- [ ] Very long text (full page) → performance acceptable (<2s total)
- [ ] Pinch to zoom → overlays stay aligned with words
- [ ] Scan summary stats are accurate
- [ ] "Review new words" → navigates to VocMap with correct filter
- [ ] Offline mode → scan works with cached data, API lookup shows offline message
- [ ] Memory: no leaks after multiple scan sessions