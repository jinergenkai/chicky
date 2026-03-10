import 'dart:typed_data';
import 'dart:ui';

/// Status of a word detected by OCR, extending the base enum.
enum WordStatus {
  known,
  learning,
  unknown,         // exists in words table but user hasn't learned
  unknownNotInBase, // not in words table at all — needs API lookup
  ignore,          // stop word or too short
}

/// A single word detected by OCR with its bounding box and classification.
class WordOverlay {
  const WordOverlay({
    required this.rawText,
    required this.lemma,
    required this.boundingBox,
    required this.status,
    this.wordId,
  });

  final String rawText;
  final String lemma;
  final Rect boundingBox;
  final WordStatus status;
  final String? wordId;

  bool get shouldShowOverlay =>
      status == WordStatus.unknown ||
      status == WordStatus.unknownNotInBase ||
      status == WordStatus.learning;

  WordOverlay copyWith({WordStatus? status, String? wordId}) {
    return WordOverlay(
      rawText: rawText,
      lemma: lemma,
      boundingBox: boundingBox,
      status: status ?? this.status,
      wordId: wordId ?? this.wordId,
    );
  }
}

/// Result of scanning an image with OCR.
class CameraScanResult {
  const CameraScanResult({
    required this.imageBytes,
    required this.imageWidth,
    required this.imageHeight,
    required this.overlays,
    required this.fullText,
  });

  final Uint8List imageBytes;
  final double imageWidth;
  final double imageHeight;
  final List<WordOverlay> overlays;
  final String fullText;

  int get knownCount =>
      overlays.where((o) => o.status == WordStatus.known).length;
  int get learningCount =>
      overlays.where((o) => o.status == WordStatus.learning).length;
  int get unknownCount => overlays
      .where((o) =>
          o.status == WordStatus.unknown ||
          o.status == WordStatus.unknownNotInBase)
      .length;
  int get totalWords =>
      overlays.where((o) => o.status != WordStatus.ignore).length;
}
