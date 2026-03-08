import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../data/models/user_vocab_model.dart';

class VocabCard extends StatelessWidget {
  const VocabCard({
    super.key,
    required this.vocab,
    this.isFlipped = false,
    this.isPreview = false,
  });

  final UserVocabModel vocab;
  final bool isFlipped;
  final bool isPreview;

  @override
  Widget build(BuildContext context) {
    final word = vocab.word;
    if (word == null) {
      return const Card(
        child: Center(child: Text('Word data unavailable')),
      );
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFF8E7), Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: isFlipped ? _BackSide(word: word) : _FrontSide(word: word),
        ),
      ),
    );
  }
}

class _FrontSide extends StatelessWidget {
  const _FrontSide({required this.word});
  final WordSummary word;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (word.cefrLevel != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: ChickyColors.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              word.cefrLevel!.toUpperCase(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: ChickyColors.primaryDark,
              ),
            ),
          ),
        const SizedBox(height: 16),
        Text(
          word.word,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: ChickyColors.textPrimary,
              ),
          textAlign: TextAlign.center,
        ),
        if (word.ipa != null && word.ipa!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            '/${word.ipa}/',
            style: TextStyle(
              fontSize: 18,
              color: ChickyColors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
        const SizedBox(height: 32),
        Text(
          'Tap to reveal',
          style: TextStyle(
            fontSize: 14,
            color: ChickyColors.textHint,
          ),
        ),
      ],
    );
  }
}

class _BackSide extends StatelessWidget {
  const _BackSide({required this.word});
  final WordSummary word;

  @override
  Widget build(BuildContext context) {
    final definitions = word.definitions;
    final examples = word.exampleSentences;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              word.word,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          if (word.ipa != null && word.ipa!.isNotEmpty)
            Center(
              child: Text(
                '/${word.ipa}/',
                style: TextStyle(
                  color: ChickyColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          const Divider(height: 24),
          // Definitions
          if (definitions.isNotEmpty) ...[
            Text(
              'Definitions',
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: ChickyColors.primary),
            ),
            const SizedBox(height: 8),
            ...definitions.take(2).map((def) {
              final pos = def['pos'] as String?;
              final defs = def['definitions'] as List?;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (pos != null)
                      Text(
                        pos,
                        style: const TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: ChickyColors.textSecondary,
                        ),
                      ),
                    if (defs != null && defs.isNotEmpty)
                      Text(
                        '• ${defs.first}',
                        style: const TextStyle(fontSize: 15),
                      ),
                  ],
                ),
              );
            }),
          ],
          // Example sentences
          if (examples.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Example',
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: ChickyColors.primary),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ChickyColors.backgroundLight,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: ChickyColors.primaryLight),
              ),
              child: Text(
                '"${examples.first}"',
                style: const TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: ChickyColors.textSecondary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
