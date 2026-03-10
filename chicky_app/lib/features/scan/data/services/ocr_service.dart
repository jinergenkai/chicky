import 'dart:typed_data';
import 'dart:ui';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

/// Wraps Google ML Kit text recognition for on-device OCR.
class OcrService {
  OcrService._();
  static final OcrService instance = OcrService._();

  /// Recognizes text in an image.
  ///
  /// Uses [imagePath] on mobile (ML Kit file-based).
  /// Falls back to error on web (ML Kit is mobile-only).
  Future<OcrResult> recognizeText({
    String? imagePath,
    required Uint8List imageBytes,
  }) async {
    if (imagePath == null || imagePath.isEmpty) {
      throw UnsupportedError(
        'Camera OCR is only supported on mobile devices.\n'
        'Use the "Paste Text" tab on web.',
      );
    }

    final inputImage = InputImage.fromFilePath(imagePath);
    final recognizer = TextRecognizer();

    try {
      final recognized = await recognizer.processImage(inputImage);

      final words = <OcrWord>[];
      for (final block in recognized.blocks) {
        for (final line in block.lines) {
          for (final element in line.elements) {
            final text = element.text.trim();
            if (text.isEmpty) continue;

            final box = element.boundingBox;
            words.add(OcrWord(
              text: text,
              boundingBox: Rect.fromLTWH(
                box.left.toDouble(),
                box.top.toDouble(),
                box.width.toDouble(),
                box.height.toDouble(),
              ),
            ));
          }
        }
      }

      return OcrResult(
        words: words,
        fullText: recognized.text,
      );
    } finally {
      await recognizer.close();
    }
  }
}

class OcrWord {
  const OcrWord({
    required this.text,
    required this.boundingBox,
  });

  final String text;
  final Rect boundingBox;
}

class OcrResult {
  const OcrResult({
    required this.words,
    required this.fullText,
  });

  final List<OcrWord> words;
  final String fullText;
}
