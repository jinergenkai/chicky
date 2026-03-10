import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../vocmap/data/models/word_model.dart';
import '../data/models/word_overlay.dart';
import '../data/repositories/scan_repository.dart';
import '../data/services/ocr_service.dart';
import '../data/services/word_classifier.dart';
import 'scan_provider.dart';

class CameraScanState {
  const CameraScanState({
    this.result,
    this.isLoading = false,
    this.error,
  });

  final CameraScanResult? result;
  final bool isLoading;
  final String? error;

  CameraScanState copyWith({
    CameraScanResult? result,
    bool? isLoading,
    String? error,
    bool clearResult = false,
    bool clearError = false,
  }) {
    return CameraScanState(
      result: clearResult ? null : (result ?? this.result),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class CameraScanNotifier extends StateNotifier<CameraScanState> {
  CameraScanNotifier(this._ref) : super(const CameraScanState());

  final Ref _ref;
  final _ocr = OcrService.instance;
  final _classifier = WordClassifier();

  ScanRepository get _repo => _ref.read(scanRepositoryProvider);

  /// Runs OCR on an image, classifies all words, and produces overlays.
  ///
  /// [imageBytes] — raw image bytes (works on all platforms).
  /// [imagePath] — optional file path for native ML Kit (mobile only).
  Future<void> scanImage({
    required Uint8List imageBytes,
    String? imagePath,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true, clearResult: true);

    try {
      // 1. Get image dimensions from bytes (cross-platform)
      final codec = await ui.instantiateImageCodec(imageBytes);
      final frame = await codec.getNextFrame();
      final imgWidth = frame.image.width.toDouble();
      final imgHeight = frame.image.height.toDouble();
      frame.image.dispose();

      // 2. Run OCR
      final ocrResult = await _ocr.recognizeText(
        imageBytes: imageBytes,
        imagePath: imagePath,
      );

      if (ocrResult.words.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          error: 'No text found in image.\n\nTry capturing text that is:\n'
              '  • Well-lit\n  • Not blurry\n  • Printed (not handwritten)',
        );
        return;
      }

      // 3. Classify words
      final overlays = await _classifier.classify(ocrResult.words);

      final result = CameraScanResult(
        imageBytes: imageBytes,
        imageWidth: imgWidth,
        imageHeight: imgHeight,
        overlays: overlays,
        fullText: ocrResult.fullText,
      );

      // 4. Save scan session (background, non-blocking)
      _repo.saveScanSession(
        text: ocrResult.fullText,
        wordCount: result.totalWords,
        unknownCount: result.unknownCount,
      );

      state = state.copyWith(isLoading: false, result: result);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Scan failed: $e');
    }
  }

  /// Looks up a word for the detail bottom sheet.
  Future<WordModel?> lookupWord(String lemma) async {
    return _repo.lookupWord(lemma);
  }

  /// Adds a word to the user's vault and updates the overlay status.
  Future<void> addToVault(String wordId, String lemma) async {
    await _repo.addToVault(wordId);

    // Update overlay status to learning
    final result = state.result;
    if (result == null) return;

    final updated = result.overlays.map((o) {
      if (o.lemma == lemma) {
        return o.copyWith(status: WordStatus.learning);
      }
      return o;
    }).toList();

    state = state.copyWith(
      result: CameraScanResult(
        imageBytes: result.imageBytes,
        imageWidth: result.imageWidth,
        imageHeight: result.imageHeight,
        overlays: updated,
        fullText: result.fullText,
      ),
    );
  }

  void reset() {
    state = const CameraScanState();
  }
}

final cameraScanProvider =
    StateNotifierProvider<CameraScanNotifier, CameraScanState>(
  (ref) => CameraScanNotifier(ref),
);
