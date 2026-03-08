import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/colors.dart';
import '../../vocmap/presentation/widgets/word_detail_sheet.dart';
import '../data/repositories/scan_repository.dart';
import '../providers/scan_provider.dart';
import 'widgets/highlighted_text.dart';
import 'widgets/text_input_area.dart';

class ScanScreen extends ConsumerWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(scanProvider);
    final notifier = ref.read(scanProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Text'),
        actions: [
          if (state.result != null)
            TextButton(
              onPressed: notifier.clear,
              child: const Text(
                'Clear',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Input area (shown when no result)
          if (state.result == null)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextInputArea(
                      onChanged: notifier.updateText,
                      initialText: state.text,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: state.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.search),
                        label: const Text('Scan'),
                        onPressed:
                            state.isLoading ? null : notifier.scan,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            // Legend
            _Legend(),
            // Highlighted text
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: HighlightedText(
                  text: state.result!.originalText,
                  tokens: state.result!.tokens,
                  statuses: state.result!.wordStatuses,
                  onWordTap: (lemma) async {
                    await notifier.selectWord(lemma);
                    final word = ref.read(scanProvider).selectedWord;
                    if (word != null && context.mounted) {
                      await WordDetailSheet.show(context, word);
                    }
                  },
                ),
              ),
            ),
            // Unknown words summary
            if (state.result!.unknownWords.isNotEmpty)
              _UnknownWordsSummary(
                count: state.result!.unknownWords.length,
                onAddAll: () async {
                  final repo = ref.read(scanRepositoryProvider);
                  for (final w in state.result!.unknownWords) {
                    await repo.addToVault(w.id);
                  }
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            '${state.result!.unknownWords.length} words added to vault'),
                        backgroundColor: ChickyColors.success,
                      ),
                    );
                  }
                },
              ),
          ],
          if (state.error != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                state.error!,
                style: const TextStyle(color: ChickyColors.error),
              ),
            ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _LegendItem(color: ChickyColors.vocabKnown, label: 'Known'),
          const SizedBox(width: 12),
          _LegendItem(color: ChickyColors.vocabLearning, label: 'Learning'),
          const SizedBox(width: 12),
          _LegendItem(color: ChickyColors.vocabUnknown, label: 'Unknown'),
          const SizedBox(width: 12),
          _LegendItem(color: ChickyColors.vocabNew, label: 'Unseen'),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class _UnknownWordsSummary extends StatelessWidget {
  const _UnknownWordsSummary({
    required this.count,
    required this.onAddAll,
  });
  final int count;
  final VoidCallback onAddAll;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ChickyColors.primaryLight.withOpacity(0.2),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$count unknown word${count > 1 ? 's' : ''} found',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          TextButton(
            onPressed: onAddAll,
            child: const Text('Add all to vault'),
          ),
        ],
      ),
    );
  }
}
