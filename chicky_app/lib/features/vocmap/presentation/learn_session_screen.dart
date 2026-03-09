import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/colors.dart';
import '../data/models/learn_card.dart';
import '../providers/learn_session_provider.dart';

class LearnSessionScreen extends ConsumerStatefulWidget {
  const LearnSessionScreen({super.key});

  @override
  ConsumerState<LearnSessionScreen> createState() => _LearnSessionScreenState();
}

class _LearnSessionScreenState extends ConsumerState<LearnSessionScreen> {
  late final CardSwiperController _controller;
  int _currentIndex = 0;
  final Set<int> _flipped = {};

  @override
  void initState() {
    super.initState();
    _controller = CardSwiperController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(learnSessionProvider.notifier).loadCards();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _close() {
    ref.read(learnSessionProvider.notifier).reset();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(learnSessionProvider);

    return Scaffold(
      backgroundColor: ChickyColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _close,
        ),
        title: state.phase == LearnPhase.learning
            ? Text(
                '${_currentIndex + 1} / ${state.cards.length}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              )
            : const Text('Learn Words'),
        centerTitle: true,
      ),
      body: switch (state.phase) {
        LearnPhase.loading => const Center(child: CircularProgressIndicator()),
        LearnPhase.empty => _EmptyView(error: state.error, onClose: _close),
        LearnPhase.summary => _SummaryView(
            known: state.knownCount,
            learning: state.learningCount,
            onFinish: _close,
          ),
        LearnPhase.learning => _LearningView(
            cards: state.cards,
            controller: _controller,
            flipped: _flipped,
            currentIndex: _currentIndex,
            onSwipe: (card, dir) =>
                ref.read(learnSessionProvider.notifier).onSwipe(card, dir),
            onIndexChange: (i) => setState(() => _currentIndex = i),
            onEmpty: () =>
                ref.read(learnSessionProvider.notifier).onSessionComplete(),
            onFlip: (i) => setState(() {
              if (_flipped.contains(i)) {
                _flipped.remove(i);
              } else {
                _flipped.add(i);
              }
            }),
          ),
      },
    );
  }
}

// ── Learning View ─────────────────────────────────────────────────────────────

class _LearningView extends StatelessWidget {
  const _LearningView({
    required this.cards,
    required this.controller,
    required this.flipped,
    required this.currentIndex,
    required this.onSwipe,
    required this.onIndexChange,
    required this.onEmpty,
    required this.onFlip,
  });

  final List<LearnCard> cards;
  final CardSwiperController controller;
  final Set<int> flipped;
  final int currentIndex;
  final void Function(LearnCard, String) onSwipe;
  final void Function(int) onIndexChange;
  final VoidCallback onEmpty;
  final void Function(int) onFlip;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Direction hint row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _DirectionHint(
                icon: Icons.arrow_back_rounded,
                label: 'Learn it',
                color: ChickyColors.vocabLearning,
              ),
              Text(
                'Tap card to flip',
                style: TextStyle(
                  fontSize: 12,
                  color: ChickyColors.textHint,
                ),
              ),
              _DirectionHint(
                icon: Icons.arrow_forward_rounded,
                label: 'Know it',
                color: ChickyColors.vocabKnown,
                iconOnRight: true,
              ),
            ],
          ),
        ),

        // Card swiper
        Expanded(
          child: CardSwiper(
            controller: controller,
            cardsCount: cards.length,
            numberOfCardsDisplayed: min(3, cards.length),
            backCardOffset: const Offset(0, 40),
            scale: 0.95,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            onSwipe: (previousIndex, currentIdx, direction) {
              final dirStr = direction == CardSwiperDirection.right
                  ? 'right'
                  : 'left';
              onSwipe(cards[previousIndex], dirStr);
              if (currentIdx != null) {
                onIndexChange(currentIdx);
              } else {
                onEmpty();
              }
              return true;
            },
            cardBuilder: (
              context,
              index,
              horizontalOffsetPercent,
              verticalOffsetPercent,
            ) {
              return GestureDetector(
                onTap: () => onFlip(index),
                child: _LearnCardFace(
                  card: cards[index],
                  isFlipped: flipped.contains(index),
                  swipePercent: horizontalOffsetPercent,
                ),
              );
            },
          ),
        ),

        // Action buttons
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text('Learn it'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ChickyColors.vocabLearning,
                    side: const BorderSide(color: ChickyColors.vocabLearning),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () =>
                      controller.swipe(CardSwiperDirection.left),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: const Text('Know it'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ChickyColors.vocabKnown,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () =>
                      controller.swipe(CardSwiperDirection.right),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Flashcard face ────────────────────────────────────────────────────────────

class _LearnCardFace extends StatelessWidget {
  const _LearnCardFace({
    required this.card,
    required this.isFlipped,
    this.swipePercent = 0,
  });

  final LearnCard card;
  final bool isFlipped;
  final int swipePercent;

  @override
  Widget build(BuildContext context) {
    // Overlay color: green when swiping right, orange when swiping left
    Color? overlayColor;
    String? overlayLabel;
    if (swipePercent > 10) {
      overlayColor = ChickyColors.vocabKnown.withOpacity(0.7);
      overlayLabel = 'Know it ✓';
    } else if (swipePercent < -10) {
      overlayColor = ChickyColors.vocabLearning.withOpacity(0.7);
      overlayLabel = 'Learn it';
    }

    return Stack(
      children: [
        // Card
        Card(
          elevation: 8,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFF8E7), Colors.white],
              ),
            ),
            padding: const EdgeInsets.all(32),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: isFlipped
                  ? _CardBack(key: const ValueKey('back'), card: card)
                  : _CardFront(key: const ValueKey('front'), card: card),
            ),
          ),
        ),

        // Swipe direction overlay
        if (overlayLabel != null)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: overlayColor,
                borderRadius: BorderRadius.circular(24),
              ),
              alignment: swipePercent > 0
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Text(
                overlayLabel,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _CardFront extends StatelessWidget {
  const _CardFront({super.key, required this.card});
  final LearnCard card;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (card.cefrLevel != null)
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: ChickyColors.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              card.cefrLevel!.toUpperCase(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: ChickyColors.primaryDark,
              ),
            ),
          ),
        const SizedBox(height: 16),
        Text(
          card.word,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: ChickyColors.textPrimary,
              ),
          textAlign: TextAlign.center,
        ),
        if (card.ipa != null && card.ipa!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            '/${card.ipa}/',
            style: TextStyle(
              fontSize: 18,
              color: ChickyColors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
        const SizedBox(height: 32),
        Text(
          'Tap to see definition',
          style: TextStyle(
            fontSize: 13,
            color: ChickyColors.textHint,
          ),
        ),
      ],
    );
  }
}

class _CardBack extends StatelessWidget {
  const _CardBack({super.key, required this.card});
  final LearnCard card;

  @override
  Widget build(BuildContext context) {
    final definitions = card.definitions;
    final examples = card.exampleSentences;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              card.word,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: ChickyColors.textPrimary,
                  ),
            ),
          ),
          if (card.ipa != null && card.ipa!.isNotEmpty)
            Center(
              child: Text(
                '/${card.ipa}/',
                style: TextStyle(
                  color: ChickyColors.textSecondary,
                  fontStyle: FontStyle.italic,
                  fontSize: 15,
                ),
              ),
            ),
          const Divider(height: 28),
          // Definitions
          if (definitions.isNotEmpty) ...[
            Text(
              'Definitions',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: ChickyColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            ...definitions.take(3).map((def) {
              final pos = def['pos'] as String?;
              final defText = def['en'] as String?;
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (pos != null)
                      Text(
                        pos,
                        style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: ChickyColors.textSecondary,
                        ),
                      ),
                    if (defText != null && defText.isNotEmpty)
                      Text(
                        '• $defText',
                        style: const TextStyle(fontSize: 15),
                      ),
                  ],
                ),
              );
            }),
          ],
          // Example sentence
          if (examples.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              'Example',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: ChickyColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ChickyColors.backgroundLight,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: ChickyColors.primaryLight.withOpacity(0.5),
                ),
              ),
              child: Text(
                '"${examples.first}"',
                style: TextStyle(
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

// ── Direction hint label ──────────────────────────────────────────────────────

class _DirectionHint extends StatelessWidget {
  const _DirectionHint({
    required this.icon,
    required this.label,
    required this.color,
    this.iconOnRight = false,
  });

  final IconData icon;
  final String label;
  final Color color;
  final bool iconOnRight;

  @override
  Widget build(BuildContext context) {
    final children = [
      Icon(icon, size: 16, color: color),
      const SizedBox(width: 4),
      Text(
        label,
        style: TextStyle(
          fontSize: 13,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    ];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: iconOnRight ? children.reversed.toList() : children,
    );
  }
}

// ── Summary View ──────────────────────────────────────────────────────────────

class _SummaryView extends StatelessWidget {
  const _SummaryView({
    required this.known,
    required this.learning,
    required this.onFinish,
  });

  final int known;
  final int learning;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    final total = known + learning;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text(
              'Session complete!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'You went through $total words',
              style: TextStyle(color: ChickyColors.textSecondary),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: _SummaryTile(
                    emoji: '✅',
                    count: known,
                    label: 'Already knew',
                    color: ChickyColors.vocabKnown,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _SummaryTile(
                    emoji: '📚',
                    count: learning,
                    label: 'Added to queue',
                    color: ChickyColors.vocabLearning,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ChickyColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: onFinish,
                child: const Text(
                  'Done',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.emoji,
    required this.count,
    required this.label,
    required this.color,
  });

  final String emoji;
  final int count;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 8),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 13, color: color),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── Empty View ────────────────────────────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  const _EmptyView({this.error, required this.onClose});
  final String? error;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('📭', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text(
              'No words to learn',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              error ??
                  'Scan some text first to discover new words!',
              style: TextStyle(color: ChickyColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: onClose,
              child: const Text('Go back'),
            ),
          ],
        ),
      ),
    );
  }
}
