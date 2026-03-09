import 'user_vocab_model.dart';
import 'word_model.dart';

/// Unified card type for the Learn session.
/// Wraps either a vault word (status='new') or an undiscovered word.
class LearnCard {
  const LearnCard({
    required this.wordId,
    required this.word,
    this.ipa,
    this.definitions = const [],
    this.exampleSentences = const [],
    this.cefrLevel,
    this.isInVault = false,
  });

  final String wordId;
  final String word;
  final String? ipa;
  final List<Map<String, dynamic>> definitions;
  final List<String> exampleSentences;
  final String? cefrLevel;

  /// true = already in user_vocabulary (status='new')
  /// false = brand new word, not in vault yet
  final bool isInVault;

  factory LearnCard.fromUserVocab(UserVocabModel uv) {
    final w = uv.word!;
    return LearnCard(
      wordId: uv.wordId,
      word: w.word,
      ipa: w.ipa,
      definitions: w.definitions,
      exampleSentences: w.exampleSentences,
      cefrLevel: w.cefrLevel,
      isInVault: true,
    );
  }

  factory LearnCard.fromWordModel(WordModel w) {
    return LearnCard(
      wordId: w.id,
      word: w.word,
      ipa: w.ipa,
      definitions: w.definitions,
      exampleSentences: w.exampleSentences,
      cefrLevel: w.cefrLevel,
      isInVault: false,
    );
  }

  /// Primary English definition string.
  String? get primaryDefinition {
    if (definitions.isEmpty) return null;
    return definitions.first['en'] as String?;
  }

  String? get primaryPos {
    if (definitions.isEmpty) return null;
    return definitions.first['pos'] as String?;
  }
}
