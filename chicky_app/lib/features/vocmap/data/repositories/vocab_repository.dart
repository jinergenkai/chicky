import '../../../../core/services/supabase_service.dart';
import '../models/domain_model.dart';
import '../models/learn_card.dart';
import '../models/user_vocab_model.dart';
import '../models/word_model.dart';

class VocabRepository {
  VocabRepository({SupabaseService? service})
      : _db = service ?? SupabaseService.instance;

  final SupabaseService _db;

  String get _uid => _db.currentUserId!;

  // ── Review cards ──────────────────────────────────────────────────────────

  /// Returns vocabulary cards that are due for review (FSRS due_at <= now).
  Future<List<UserVocabModel>> getReviewCards({int limit = 20}) async {
    final now = DateTime.now().toIso8601String();
    final data = await _db.client
        .from('user_vocabulary')
        .select('*, word:words(*)')
        .eq('user_id', _uid)
        .neq('status', 'new')
        .neq('status', 'suspended')
        .lte('due_at', now)
        .order('due_at')
        .limit(limit);

    return (data as List)
        .map((e) => UserVocabModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Returns newly added vocabulary not yet reviewed.
  Future<List<UserVocabModel>> getNewCards({int limit = 10}) async {
    final data = await _db.client
        .from('user_vocabulary')
        .select('*, word:words(*)')
        .eq('user_id', _uid)
        .eq('status', 'new')
        .order('first_seen_at')
        .limit(limit);

    return (data as List)
        .map((e) => UserVocabModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ── Learn session ─────────────────────────────────────────────────────────

  /// Returns up to [limit] cards for a learn session:
  /// vault words (status='new') first, then undiscovered words to fill the rest.
  Future<List<LearnCard>> getLearnCards({int limit = 20}) async {
    final vaultNew = await getNewCards(limit: limit);
    final cards = vaultNew
        .where((uv) => uv.word != null)
        .map(LearnCard.fromUserVocab)
        .toList();

    final remaining = limit - cards.length;
    if (remaining > 0) {
      final undiscovered = await _getUndiscoveredWords(limit: remaining);
      cards.addAll(undiscovered.map(LearnCard.fromWordModel));
    }

    return cards;
  }

  Future<List<WordModel>> _getUndiscoveredWords({int limit = 10}) async {
    // Get IDs of all words already in the user's vault
    final vocabData = await _db.client
        .from('user_vocabulary')
        .select('word_id')
        .eq('user_id', _uid);

    final knownIds =
        (vocabData as List).map((e) => e['word_id'] as String).toList();

    // Build filter chain first (before order/limit so .not() is available)
    final data = await (knownIds.isNotEmpty
        ? _db.client
            .from('words')
            .select()
            .eq('verified', true)
            .not('id', 'in', knownIds)
            .order('frequency_rank')
            .limit(limit)
        : _db.client
            .from('words')
            .select()
            .eq('verified', true)
            .order('frequency_rank')
            .limit(limit));
    return (data as List)
        .map((e) => WordModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Records the user's decision for a word during a learn session.
  /// [decision] is either 'known' or 'learning'.
  Future<void> markWordDecision(String wordId, String decision) async {
    final now = DateTime.now().toIso8601String();

    if (decision == 'known') {
      await _db.client.from('user_vocabulary').upsert({
        'user_id': _uid,
        'word_id': wordId,
        'status': 'known',
        'source': 'manual',
        'reps': 1,
        'first_seen_at': now,
        'last_reviewed_at': now,
      });
    } else {
      // 'learning' — schedule first review for tomorrow
      final dueAt =
          DateTime.now().add(const Duration(days: 1)).toIso8601String();
      await _db.client.from('user_vocabulary').upsert({
        'user_id': _uid,
        'word_id': wordId,
        'status': 'learning',
        'source': 'manual',
        'first_seen_at': now,
        'due_at': dueAt,
      });
    }
  }

  // ── Domains ───────────────────────────────────────────────────────────────

  Future<List<DomainModel>> getDomains() async {
    final data = await _db.client
        .from('domains')
        .select('id, name, parent_id, icon')
        .order('name');

    return (data as List)
        .map((e) => DomainModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<WordModel>> getDomainWords(String domainId, {int limit = 50}) async {
    final data = await _db.client
        .from('domain_words')
        .select('word:words(*)')
        .eq('domain_id', domainId)
        .limit(limit);

    return (data as List)
        .map((e) => WordModel.fromJson(e['word'] as Map<String, dynamic>))
        .toList();
  }

  // ── Word lookup ───────────────────────────────────────────────────────────

  Future<WordModel?> lookupWord(String lemma) async {
    final data = await _db.client
        .from('words')
        .select()
        .eq('word', lemma)
        .maybeSingle();

    if (data == null) return null;
    return WordModel.fromJson(data);
  }

  Future<List<WordModel>> getRelatedWords(String wordId) async {
    final data = await _db.client
        .from('word_relationships')
        .select('related_word:words!word_relationships_word_id_b_fkey(*)')
        .eq('word_id_a', wordId)
        .limit(10);

    return (data as List)
        .map(
          (e) =>
              WordModel.fromJson(e['related_word'] as Map<String, dynamic>),
        )
        .toList();
  }

  // ── FSRS update ───────────────────────────────────────────────────────────

  /// Updates FSRS scheduling parameters after a review.
  Future<void> updateFSRS({
    required String wordId,
    required String grade,          // again | hard | good | easy
    required double newStability,
    required double newDifficulty,
    required DateTime newDueAt,
    required String newStatus,
    required int reps,
    required int lapses,
  }) async {
    await _db.client.from('user_vocabulary').update({
      'last_grade': grade,
      'stability': newStability,
      'difficulty': newDifficulty,
      'due_at': newDueAt.toIso8601String(),
      'status': newStatus,
      'reps': reps,
      'lapses': lapses,
      'last_reviewed_at': DateTime.now().toIso8601String(),
    }).eq('user_id', _uid).eq('word_id', wordId);
  }

  // ── Vocab management ──────────────────────────────────────────────────────

  Future<void> addWordToVocab(
    String wordId, {
    String source = 'manual',
  }) async {
    await _db.client.from('user_vocabulary').upsert({
      'user_id': _uid,
      'word_id': wordId,
      'status': 'new',
      'source': source,
      'first_seen_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> suspendWord(String wordId) async {
    await _db.client
        .from('user_vocabulary')
        .update({'status': 'suspended'})
        .eq('user_id', _uid)
        .eq('word_id', wordId);
  }

  Future<UserVocabModel?> getUserVocabEntry(String wordId) async {
    final data = await _db.client
        .from('user_vocabulary')
        .select('*, word:words(*)')
        .eq('user_id', _uid)
        .eq('word_id', wordId)
        .maybeSingle();

    if (data == null) return null;
    return UserVocabModel.fromJson(data);
  }

  /// Returns vocab stats for the current user.
  Future<Map<String, int>> getVocabStats() async {
    final data = await _db.client
        .from('user_vocabulary')
        .select('status')
        .eq('user_id', _uid);

    final stats = <String, int>{
      'new': 0,
      'learning': 0,
      'known': 0,
      'suspended': 0,
    };

    for (final row in data as List) {
      final status = row['status'] as String;
      stats[status] = (stats[status] ?? 0) + 1;
    }

    return stats;
  }
}
