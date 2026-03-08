import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/api_service.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/utils/text_tokenizer.dart';
import '../../../vocmap/data/models/word_model.dart';

enum WordKnowledgeStatus { known, learning, unknown, unseen }

class ScanResult {
  const ScanResult({
    required this.originalText,
    required this.tokens,
    required this.wordStatuses,
    required this.unknownWords,
  });

  final String originalText;
  final List<WordSpan> tokens;

  /// Maps lemma -> knowledge status
  final Map<String, WordKnowledgeStatus> wordStatuses;

  /// Words identified as unknown (not in user vocab)
  final List<WordModel> unknownWords;
}

class ScanRepository {
  ScanRepository({
    SupabaseService? supabase,
    ApiService? api,
  })  : _db = supabase ?? SupabaseService.instance,
        _api = api ?? ApiService.instance;

  final SupabaseService _db;
  final ApiService _api;

  String get _uid => _db.currentUserId!;

  /// Tokenizes text and classifies each word against user vocabulary.
  Future<ScanResult> scanText(String text) async {
    final tokens = TextTokenizer.tokenizeWithOffsets(text);
    final lemmas = tokens.map((t) => t.lemma).toSet().toList();

    if (lemmas.isEmpty) {
      return ScanResult(
        originalText: text,
        tokens: tokens,
        wordStatuses: {},
        unknownWords: [],
      );
    }

    // Batch lookup user vocabulary for these lemmas
    final vocabData = await _db.client
        .from('user_vocabulary')
        .select('word_id, status, words!inner(word)')
        .eq('user_id', _uid)
        .inFilter('words.word', lemmas);

    final Map<String, WordKnowledgeStatus> statuses = {};
    for (final row in vocabData as List) {
      final word = (row['words'] as Map)['word'] as String;
      final status = row['status'] as String;
      statuses[word] = _toStatus(status);
    }

    // Mark all tokens that have no vocab entry as 'unseen'
    final wordData = await _db.client
        .from('words')
        .select('id, word, ipa, definitions, cefr_level, frequency_rank, example_sentences')
        .inFilter('word', lemmas);

    final Map<String, WordModel> knownWords = {};
    for (final row in wordData as List) {
      final wm = WordModel.fromJson(row as Map<String, dynamic>);
      knownWords[wm.word] = wm;
    }

    final List<WordModel> unknownWords = [];
    for (final lemma in lemmas) {
      if (!statuses.containsKey(lemma)) {
        statuses[lemma] = WordKnowledgeStatus.unseen;
        if (knownWords.containsKey(lemma)) {
          unknownWords.add(knownWords[lemma]!);
        }
      }
    }

    return ScanResult(
      originalText: text,
      tokens: tokens,
      wordStatuses: statuses,
      unknownWords: unknownWords,
    );
  }

  /// Looks up a single word via API (dictionary service).
  Future<WordModel?> lookupWord(String word) async {
    try {
      // First try local DB
      final data = await _db.client
          .from('words')
          .select()
          .eq('word', word.toLowerCase())
          .maybeSingle();

      if (data != null) {
        return WordModel.fromJson(data as Map<String, dynamic>);
      }

      // Fallback: ask FastAPI dictionary service
      final response = await _api.post<Map<String, dynamic>>(
        '/scan/lookup',
        data: {'word': word},
      );

      if (response.data != null) {
        return WordModel.fromJson(response.data!);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Saves a word to the user's vocabulary (from Scan feature).
  Future<void> addToVault(String wordId) async {
    await _db.client.from('user_vocabulary').upsert({
      'user_id': _uid,
      'word_id': wordId,
      'status': 'new',
      'source': 'scan',
      'first_seen_at': DateTime.now().toIso8601String(),
    });
  }

  /// Saves a scan session to the database.
  Future<void> saveScanSession({
    required String text,
    required int wordCount,
    required int unknownCount,
  }) async {
    await _db.client.from('scan_sessions').insert({
      'user_id': _uid,
      'raw_text': text,
      'word_count': wordCount,
      'unknown_count': unknownCount,
      'scanned_at': DateTime.now().toIso8601String(),
    });
  }

  WordKnowledgeStatus _toStatus(String s) => switch (s) {
        'known' => WordKnowledgeStatus.known,
        'learning' => WordKnowledgeStatus.learning,
        _ => WordKnowledgeStatus.unknown,
      };
}
