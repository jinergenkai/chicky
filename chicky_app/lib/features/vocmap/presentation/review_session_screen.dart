import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/colors.dart';
import '../../../shared/widgets/chicky_widgets.dart';
import '../providers/review_provider.dart';
import 'widgets/vocab_card.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ReviewSessionScreen extends ConsumerWidget {
  const ReviewSessionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reviewSessionProvider);
    final notifier = ref.read(reviewSessionProvider.notifier);

    return Scaffold(
      backgroundColor: ChickyColors.backgroundLight,
      appBar: chickyAppBar(
        context,
        title: state.phase == ReviewPhase.reviewing
            ? 'Review ${state.currentIndex + 1}/${state.queue.length}'
            : 'Review',
        onBack: () {
          notifier.reset();
          Navigator.of(context).pop();
        },
      ),
      body: switch (state.phase) {
        ReviewPhase.loading => const Center(child: CircularProgressIndicator()),
        ReviewPhase.empty => _EmptyView(onBack: () {
            notifier.reset();
            Navigator.of(context).pop();
          }),
        ReviewPhase.summary => _SummaryView(
            reviewed: state.reviewedCount,
            correct: state.correctCount,
            onFinish: () {
              notifier.reset();
              Navigator.of(context).pop();
            },
          ),
        ReviewPhase.reviewing => _ReviewView(
            state: state,
            onFlip: notifier.flipCard,
            onGrade: notifier.grade,
          ),
      },
    );
  }
}

// ── Review view ───────────────────────────────────────────────────────────

class _ReviewView extends StatelessWidget {
  const _ReviewView({
    required this.state,
    required this.onFlip,
    required this.onGrade,
  });

  final ReviewSessionState state;
  final VoidCallback onFlip;
  final Future<void> Function(String grade) onGrade;

  @override
  Widget build(BuildContext context) {
    final card = state.currentCard!;

    return Column(
      children: [
        // Progress bar
        LinearProgressIndicator(
          value: state.currentIndex / state.queue.length,
          backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
          valueColor:
              AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: GestureDetector(
              onTap: onFlip,
              child: VocabCard(vocab: card, isFlipped: state.isFlipped),
            ),
          ),
        ),
        if (!state.isFlipped)
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            child: SizedBox(
              width: double.infinity,
              child: ChickyGradientButton(
                label: 'Show Answer',
                icon: LucideIcons.eye,
                onTap: onFlip,
              ),
            ),
          )
        else
          _GradeButtons(onGrade: onGrade),
      ],
    );
  }
}

class _GradeButtons extends StatelessWidget {
  const _GradeButtons({required this.onGrade});
  final Future<void> Function(String) onGrade;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Row(
        children: [
          _GradeButton(
            label: 'Again',
            color: ChickyColors.gradeAgain,
            onTap: () => onGrade('again'),
          ),
          const SizedBox(width: 12),
          _GradeButton(
            label: 'Hard',
            color: ChickyColors.gradeHard,
            onTap: () => onGrade('hard'),
          ),
          const SizedBox(width: 12),
          _GradeButton(
            label: 'Good',
            color: ChickyColors.gradeGood,
            onTap: () => onGrade('good'),
          ),
          const SizedBox(width: 12),
          _GradeButton(
            label: 'Easy',
            color: ChickyColors.gradeEasy,
            onTap: () => onGrade('easy'),
          ),
        ],
      ),
    );
  }
}

class _GradeButton extends StatelessWidget {
  const _GradeButton({
    required this.label,
    required this.color,
    required this.onTap,
  });
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.4)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Summary view ──────────────────────────────────────────────────────────

class _SummaryView extends StatelessWidget {
  const _SummaryView({
    required this.reviewed,
    required this.correct,
    required this.onFinish,
  });
  final int reviewed;
  final int correct;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    final pct = reviewed == 0 ? 0 : (correct / reviewed * 100).round();
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🎊', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 24),
            Text(
              'Session Complete!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            _SummaryRow(label: 'Cards reviewed', value: '$reviewed'),
            _SummaryRow(label: 'Correct', value: '$correct ($pct%)'),
            const SizedBox(height: 48),
            ChickyGradientButton(
              label: 'Done',
              icon: LucideIcons.check,
              onTap: onFinish,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.onBack});
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('📚', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text(
            'Nothing to review',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'All cards are up to date!',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: ChickyColors.textSecondary),
          ),
          const SizedBox(height: 48),
          ChickyGradientButton(
            label: 'Go Back',
            icon: LucideIcons.arrowLeft,
            onTap: onBack,
          ),
        ],
      ),
    );
  }
}
