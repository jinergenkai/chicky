import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors.dart';
import '../providers/review_provider.dart';
import '../providers/vocmap_provider.dart';
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

    return newAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (cards) {
        if (cards.isEmpty) {
          return const Center(child: Text('No new words yet. Try scanning some text!'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: cards.length,
          itemBuilder: (context, i) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: VocabCard(vocab: cards[i], isPreview: true),
          ),
        );
      },
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
