import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/colors.dart';
import '../../data/models/word_model.dart';
import '../../data/repositories/vocab_repository.dart';
import '../../providers/vocmap_provider.dart';

class WordDetailSheet extends ConsumerWidget {
  const WordDetailSheet({super.key, required this.word});

  final WordModel word;

  static Future<void> show(BuildContext context, WordModel word) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => WordDetailSheet(word: word),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      expand: false,
      builder: (_, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Word + IPA
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    word.word,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (word.hasIpa) ...[
                    const SizedBox(width: 12),
                    Text(
                      '/${word.ipa}/',
                      style: const TextStyle(
                        fontSize: 16,
                        color: ChickyColors.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
              if (word.cefrLevel != null) ...[
                const SizedBox(height: 8),
                Chip(
                  label: Text(word.cefrBadge),
                  backgroundColor: ChickyColors.primary.withOpacity(0.15),
                  labelStyle:
                      const TextStyle(color: ChickyColors.primaryDark),
                ),
              ],
              const Divider(height: 32),
              // Definitions
              if (word.definitions.isNotEmpty) ...[
                Text(
                  'Definitions',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: ChickyColors.primary),
                ),
                const SizedBox(height: 12),
                ...word.definitions.map((def) {
                  final pos = def['pos'] as String?;
                  final defText = def['en'] as String? ?? '';
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (pos != null)
                          Text(
                            pos,
                            style: const TextStyle(
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              color: ChickyColors.secondary,
                            ),
                          ),
                        if (defText.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              defText,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                      ],
                    ),
                  );
                }),
              ],
              // Examples
              if (word.exampleSentences.isNotEmpty) ...[
                Text(
                  'Examples',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: ChickyColors.primary),
                ),
                const SizedBox(height: 8),
                ...word.exampleSentences.take(3).map(
                      (ex) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: ChickyColors.backgroundLight,
                            borderRadius: BorderRadius.circular(8),
                            border:
                                Border.all(color: ChickyColors.primaryLight),
                          ),
                          child: Text(
                            '"$ex"',
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              color: ChickyColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
              ],
              const SizedBox(height: 24),
              // Add to vocab button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Add to My Vocabulary'),
                  onPressed: () async {
                    final repo = ref.read(vocabRepositoryProvider);
                    await repo.addWordToVocab(word.id, source: 'manual');
                    if (context.mounted) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('"${word.word}" added to vocabulary'),
                          backgroundColor: ChickyColors.success,
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
