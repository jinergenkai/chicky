import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/utils/text_tokenizer.dart';
import '../../data/repositories/scan_repository.dart';

class HighlightedText extends StatelessWidget {
  const HighlightedText({
    super.key,
    required this.text,
    required this.tokens,
    required this.statuses,
    this.onWordTap,
  });

  final String text;
  final List<WordSpan> tokens;
  final Map<String, WordKnowledgeStatus> statuses;
  final Future<void> Function(String lemma)? onWordTap;

  @override
  Widget build(BuildContext context) {
    final spans = _buildSpans(context);
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.8),
        children: spans,
      ),
    );
  }

  List<TextSpan> _buildSpans(BuildContext context) {
    if (tokens.isEmpty) {
      return [TextSpan(text: text)];
    }

    final spans = <TextSpan>[];
    int cursor = 0;

    for (final token in tokens) {
      // Text before this token
      if (token.start > cursor) {
        spans.add(TextSpan(text: text.substring(cursor, token.start)));
      }

      final status = statuses[token.lemma] ?? WordKnowledgeStatus.unseen;
      final color = _statusColor(status);
      final word = text.substring(token.start, token.end);

      spans.add(
        TextSpan(
          text: word,
          style: TextStyle(
            color: color,
            fontWeight: status == WordKnowledgeStatus.unseen
                ? FontWeight.normal
                : FontWeight.w600,
            decoration: TextDecoration.underline,
            decorationColor: color.withOpacity(0.5),
            decorationThickness: 1.5,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () => onWordTap?.call(token.lemma),
        ),
      );

      cursor = token.end;
    }

    // Remaining text
    if (cursor < text.length) {
      spans.add(TextSpan(text: text.substring(cursor)));
    }

    return spans;
  }

  Color _statusColor(WordKnowledgeStatus status) {
    return switch (status) {
      WordKnowledgeStatus.known => ChickyColors.vocabKnown,
      WordKnowledgeStatus.learning => ChickyColors.vocabLearning,
      WordKnowledgeStatus.unknown => ChickyColors.vocabUnknown,
      WordKnowledgeStatus.unseen => ChickyColors.vocabNew,
    };
  }
}
