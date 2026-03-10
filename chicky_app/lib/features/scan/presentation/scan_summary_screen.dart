import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors.dart';
import '../data/models/word_overlay.dart';

/// Shows scan statistics after the user taps "Done" on the result screen.
class ScanSummaryScreen extends StatelessWidget {
  const ScanSummaryScreen({super.key, required this.result});

  final CameraScanResult result;

  @override
  Widget build(BuildContext context) {
    final unknownWords = result.overlays
        .where((o) =>
            o.status == WordStatus.unknown ||
            o.status == WordStatus.unknownNotInBase)
        .toList();

    return Scaffold(
      backgroundColor: ChickyColors.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              const Spacer(),
              // Title
              const Text(
                'Scan Complete',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 32),

              // Stats card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Total words scanned: ${result.totalWords}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _StatRow(
                      color: ChickyColors.vocabKnown,
                      label: 'Known',
                      count: result.knownCount,
                      total: result.totalWords,
                    ),
                    const SizedBox(height: 12),
                    _StatRow(
                      color: ChickyColors.vocabLearning,
                      label: 'Learning',
                      count: result.learningCount,
                      total: result.totalWords,
                    ),
                    const SizedBox(height: 12),
                    _StatRow(
                      color: ChickyColors.vocabUnknown,
                      label: 'New',
                      count: result.unknownCount,
                      total: result.totalWords,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Unknown words chips
              if (unknownWords.isNotEmpty) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'New words found:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: unknownWords
                      .take(12)
                      .map((w) => Chip(
                            label: Text(
                              w.lemma,
                              style: const TextStyle(fontSize: 13),
                            ),
                            backgroundColor:
                                ChickyColors.vocabUnknown.withValues(alpha: 0.12),
                            side: BorderSide(
                              color:
                                  ChickyColors.vocabUnknown.withValues(alpha: 0.3),
                            ),
                          ))
                      .toList(),
                ),
                if (unknownWords.length > 12)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '+${unknownWords.length - 12} more',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
              ],

              const Spacer(),

              // Actions
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    // Navigate to VocMap review
                    context.go('/vocmap');
                  },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Review new words',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.go('/vocmap'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Back to Scan',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.color,
    required this.label,
    required this.count,
    required this.total,
  });

  final Color color;
  final String label;
  final int count;
  final int total;

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? count / total : 0.0;

    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 72,
          child: Text(
            label,
            style: const TextStyle(fontSize: 14),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              backgroundColor: Colors.grey.shade200,
              color: color,
              minHeight: 8,
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 32,
          child: Text(
            '$count',
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
