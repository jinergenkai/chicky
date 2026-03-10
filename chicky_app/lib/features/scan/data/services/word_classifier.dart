import '../../../../core/services/supabase_service.dart';
import '../../../../core/utils/lemmatizer.dart';
import '../models/word_overlay.dart';
import 'ocr_service.dart';

/// Classifies OCR words against the user's vocabulary and the base words table.
class WordClassifier {
  WordClassifier({SupabaseService? supabase})
      : _db = supabase ?? SupabaseService.instance;

  final SupabaseService _db;

  String get _uid => _db.currentUserId!;

  /// Stop words that should be ignored during classification.
  static const _stopWords = <String>{
    'a', 'an', 'the', 'and', 'or', 'but', 'nor', 'yet', 'so',
    'in', 'on', 'at', 'to', 'for', 'of', 'with', 'by', 'from',
    'up', 'out', 'off', 'into', 'onto', 'upon',
    'i', 'me', 'my', 'you', 'your', 'he', 'him', 'his',
    'she', 'her', 'it', 'its', 'we', 'us', 'our', 'they', 'them', 'their',
    'is', 'am', 'are', 'was', 'were', 'be', 'been', 'being',
    'have', 'has', 'had', 'do', 'does', 'did',
    'will', 'would', 'shall', 'should', 'may', 'might',
    'can', 'could', 'must',
    'not', 'no', 'yes', 'this', 'that', 'these', 'those',
    'what', 'which', 'who', 'whom', 'how', 'when', 'where', 'why',
    'all', 'each', 'every', 'both', 'few', 'more', 'most',
    'other', 'some', 'any', 'such', 'only', 'very',
    'just', 'also', 'than', 'too', 'here', 'there',
    'if', 'then', 'about', 'own', 'same',
  };

  static final _englishPattern =
      RegExp(r'^[a-zA-Zàáâãäåèéêëìíîïòóôõöùúûüýÿñ\-]+$');

  /// Classifies a list of OCR words into [WordOverlay] objects.
  Future<List<WordOverlay>> classify(List<OcrWord> ocrWords) async {
    // 1. Filter and lemmatize
    final candidates = <_Candidate>[];
    for (final w in ocrWords) {
      final cleaned =
          w.text.replaceAll(RegExp(r'[^a-zA-Z\-]'), '').toLowerCase();
      if (cleaned.length < 2) continue;
      if (!_englishPattern.hasMatch(cleaned)) continue;

      final lemma = simpleLemmatize(cleaned);
      if (_stopWords.contains(lemma)) {
        candidates.add(_Candidate(w, lemma, WordStatus.ignore));
      } else {
        candidates.add(_Candidate(w, lemma, null));
      }
    }

    // 2. Collect unique lemmas that need lookup
    final lemmasToLookup = candidates
        .where((c) => c.status == null)
        .map((c) => c.lemma)
        .toSet()
        .toList();

    if (lemmasToLookup.isEmpty) {
      return candidates
          .map((c) => WordOverlay(
                rawText: c.ocrWord.text,
                lemma: c.lemma,
                boundingBox: c.ocrWord.boundingBox,
                status: c.status ?? WordStatus.ignore,
              ))
          .toList();
    }

    // 3. Batch lookup: user_vocabulary
    final userVocabStatuses = <String, String>{};
    // Supabase inFilter has a practical limit; chunk if needed
    for (var i = 0; i < lemmasToLookup.length; i += 100) {
      final chunk = lemmasToLookup.sublist(
        i,
        (i + 100).clamp(0, lemmasToLookup.length),
      );
      final vocabData = await _db.client
          .from('user_vocabulary')
          .select('status, words!inner(word)')
          .eq('user_id', _uid)
          .inFilter('words.word', chunk);

      for (final row in vocabData as List) {
        final word = (row['words'] as Map)['word'] as String;
        userVocabStatuses[word] = row['status'] as String;
      }
    }

    // 4. Batch lookup: base words table (for words not in user vocab)
    final missingLemmas =
        lemmasToLookup.where((l) => !userVocabStatuses.containsKey(l)).toList();
    final baseWordIds = <String, String>{}; // lemma → word id
    if (missingLemmas.isNotEmpty) {
      for (var i = 0; i < missingLemmas.length; i += 100) {
        final chunk = missingLemmas.sublist(
          i,
          (i + 100).clamp(0, missingLemmas.length),
        );
        final wordData = await _db.client
            .from('words')
            .select('id, word')
            .inFilter('word', chunk);

        for (final row in wordData as List) {
          baseWordIds[row['word'] as String] = row['id'] as String;
        }
      }
    }

    // 5. Build final overlays
    return candidates.map((c) {
      if (c.status != null) {
        // Already classified (stop word)
        return WordOverlay(
          rawText: c.ocrWord.text,
          lemma: c.lemma,
          boundingBox: c.ocrWord.boundingBox,
          status: c.status!,
        );
      }

      final userStatus = userVocabStatuses[c.lemma];
      if (userStatus != null) {
        final status = switch (userStatus) {
          'known' => WordStatus.known,
          'learning' || 'new' => WordStatus.learning,
          _ => WordStatus.unknown,
        };
        return WordOverlay(
          rawText: c.ocrWord.text,
          lemma: c.lemma,
          boundingBox: c.ocrWord.boundingBox,
          status: status,
          wordId: baseWordIds[c.lemma],
        );
      }

      final wordId = baseWordIds[c.lemma];
      return WordOverlay(
        rawText: c.ocrWord.text,
        lemma: c.lemma,
        boundingBox: c.ocrWord.boundingBox,
        status: wordId != null
            ? WordStatus.unknown
            : WordStatus.unknownNotInBase,
        wordId: wordId,
      );
    }).toList();
  }
}

class _Candidate {
  _Candidate(this.ocrWord, this.lemma, this.status);
  final OcrWord ocrWord;
  final String lemma;
  final WordStatus? status;
}
