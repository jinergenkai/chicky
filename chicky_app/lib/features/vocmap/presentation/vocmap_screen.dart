import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors.dart';
import '../providers/review_provider.dart';
import '../providers/vocmap_provider.dart';
import 'learn_session_screen.dart';
import 'review_session_screen.dart';
import 'widgets/domain_list.dart';
import 'widgets/vocab_card.dart';

class VocMapScreen extends ConsumerStatefulWidget {
  const VocMapScreen({super.key});

  @override
  ConsumerState<VocMapScreen> createState() => _VocMapScreenState();
}

class _VocMapScreenState extends ConsumerState<VocMapScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VocMap'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            tooltip: 'Scan text',
            onPressed: () => context.push('/scan'),
          ),
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            tooltip: 'Chat with Chicky',
            onPressed: () => context.push('/chat'),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Review'),
            Tab(text: 'New Words'),
            Tab(text: 'Domains'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _ReviewTab(),
          _NewWordsTab(),
          _DomainsTab(),
        ],
      ),
    );
  }
}

// ── Review Tab ────────────────────────────────────────────────────────────

class _ReviewTab extends ConsumerWidget {
  const _ReviewTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewAsync = ref.watch(reviewCardsProvider);
    final statsAsync = ref.watch(vocabStatsProvider);

    return reviewAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (cards) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Stats row
              statsAsync.whenOrNull(
                data: (stats) => _StatsRow(stats: stats),
              ) ?? const SizedBox.shrink(),
              const SizedBox(height: 16),
              if (cards.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('🎉', style: TextStyle(fontSize: 64)),
                        const SizedBox(height: 16),
                        Text(
                          'All caught up!',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No cards due for review right now.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: ChickyColors.textSecondary,
                              ),
                        ),
                      ],
                    ),
                  ),
                )
              else ...[
                Expanded(
                  child: VocabCard(vocab: cards.first, isPreview: true),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.play_arrow),
                  label: Text('Start Review (${cards.length} cards)'),
                  onPressed: () {
                    ref.read(reviewSessionProvider.notifier).startSession();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ReviewSessionScreen(),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.stats});
  final Map<String, int> stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatChip(
          label: 'Known',
          count: stats['known'] ?? 0,
          color: ChickyColors.vocabKnown,
        ),
        const SizedBox(width: 8),
        _StatChip(
          label: 'Learning',
          count: stats['learning'] ?? 0,
          color: ChickyColors.vocabLearning,
        ),
        const SizedBox(width: 8),
        _StatChip(
          label: 'New',
          count: stats['new'] ?? 0,
          color: ChickyColors.vocabNew,
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.label,
    required this.count,
    required this.color,
  });
  final String label;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              '$count',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: color),
            ),
          ],
        ),
      ),
    );
  }
}

// ── New Words Tab ─────────────────────────────────────────────────────────

class _NewWordsTab extends ConsumerWidget {
  const _NewWordsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newAsync = ref.watch(newCardsProvider);
    final statsAsync = ref.watch(vocabStatsProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '📖',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 64),
          ),
          const SizedBox(height: 16),
          Text(
            'Learn New Words',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Swipe right if you know it, left to add it to your learning queue.',
            textAlign: TextAlign.center,
            style: TextStyle(color: ChickyColors.textSecondary),
          ),
          const SizedBox(height: 32),
          // Pending new-words count badge
          newAsync.whenOrNull(
            data: (cards) => cards.isNotEmpty
                ? Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: ChickyColors.vocabLearning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: ChickyColors.vocabLearning.withOpacity(0.4),
                        ),
                      ),
                      child: Text(
                        '${cards.length} words waiting in your vault',
                        style: const TextStyle(
                          color: ChickyColors.vocabLearning,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ) ??
              const SizedBox.shrink(),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.style_rounded),
            label: const Text('Start Flashcard Session'),
            style: ElevatedButton.styleFrom(
              backgroundColor: ChickyColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const LearnSessionScreen(),
              ),
            ),
          ),
          const SizedBox(height: 48),
          // Stats summary
          statsAsync.whenOrNull(
            data: (stats) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _MiniStat(
                    label: 'Known',
                    value: stats['known'] ?? 0,
                    color: ChickyColors.vocabKnown),
                const SizedBox(width: 24),
                _MiniStat(
                    label: 'Learning',
                    value: stats['learning'] ?? 0,
                    color: ChickyColors.vocabLearning),
                const SizedBox(width: 24),
                _MiniStat(
                    label: 'New',
                    value: stats['new'] ?? 0,
                    color: ChickyColors.vocabNew),
              ],
            ),
          ) ??
              const SizedBox.shrink(),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$value',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: ChickyColors.textSecondary),
        ),
      ],
    );
  }
}

// ── Domains Tab ───────────────────────────────────────────────────────────

class _DomainsTab extends ConsumerWidget {
  const _DomainsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final domainsAsync = ref.watch(domainsProvider);

    return domainsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (domains) => DomainList(domains: domains),
    );
  }
}
