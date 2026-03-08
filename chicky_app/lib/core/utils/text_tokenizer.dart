import 'lemmatizer.dart';

/// Tokenizes English text into cleaned, lemmatized word tokens.
class TextTokenizer {
  TextTokenizer._();

  static final RegExp _wordPattern = RegExp(r"[a-zA-Z]+(?:'[a-zA-Z]+)*");

  static const Set<String> _stopWords = {
    'a', 'an', 'the', 'and', 'or', 'but', 'in', 'on', 'at', 'to', 'for',
    'of', 'with', 'by', 'from', 'as', 'is', 'was', 'are', 'were', 'be',
    'been', 'being', 'have', 'has', 'had', 'do', 'does', 'did', 'will',
    'would', 'could', 'should', 'may', 'might', 'shall', 'can', 'need',
    'dare', 'ought', 'used', 'it', 'its', 'this', 'that', 'these', 'those',
    'i', 'me', 'my', 'we', 'our', 'you', 'your', 'he', 'she', 'they',
    'him', 'her', 'them', 'his', 'their', 'not', 'no', 'so', 'if', 'up',
    'out', 'about', 'into', 'than', 'then', 'there', 'when', 'where',
    'who', 'which', 'what', 'how', 'all', 'any', 'each', 'every', 'more',
    'most', 'other', 'some', 'such', 'own', 'same', 'just',
  };

  /// Returns a list of unique lemmatized tokens from [text],
  /// filtered to only include content words of length >= [minLength].
  static List<String> tokenize(
    String text, {
    bool lemmatize = true,
    bool removeStopWords = false,
    int minLength = 2,
  }) {
    final matches = _wordPattern.allMatches(text);
    final seen = <String>{};
    final result = <String>[];

    for (final match in matches) {
      var token = match.group(0)!.toLowerCase();

      if (token.length < minLength) continue;
      if (removeStopWords && _stopWords.contains(token)) continue;

      if (lemmatize) {
        token = simpleLemmatize(token);
      }

      if (seen.add(token)) {
        result.add(token);
      }
    }

    return result;
  }

  /// Returns all word matches with their character offsets (for highlighting).
  static List<WordSpan> tokenizeWithOffsets(String text) {
    final matches = _wordPattern.allMatches(text);
    return matches
        .map(
          (m) => WordSpan(
            word: m.group(0)!,
            lemma: simpleLemmatize(m.group(0)!.toLowerCase()),
            start: m.start,
            end: m.end,
          ),
        )
        .toList();
  }
}

class WordSpan {
  const WordSpan({
    required this.word,
    required this.lemma,
    required this.start,
    required this.end,
  });

  final String word;
  final String lemma;
  final int start;
  final int end;
}
