import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/learn_card.dart';
import 'vocmap_provider.dart';

enum LearnPhase { loading, learning, summary, empty }

class LearnSessionState {
  const LearnSessionState({
    this.phase = LearnPhase.loading,
    this.cards = const [],
    this.knownCount = 0,
    this.learningCount = 0,
    this.error,
  });

  final LearnPhase phase;
  final List<LearnCard> cards;
  final int knownCount;
  final int learningCount;
  final String? error;

  int get total => knownCount + learningCount;

  LearnSessionState copyWith({
    LearnPhase? phase,
    List<LearnCard>? cards,
    int? knownCount,
    int? learningCount,
    String? error,
  }) {
    return LearnSessionState(
      phase: phase ?? this.phase,
      cards: cards ?? this.cards,
      knownCount: knownCount ?? this.knownCount,
      learningCount: learningCount ?? this.learningCount,
      error: error ?? this.error,
    );
  }
}

class LearnSessionNotifier extends StateNotifier<LearnSessionState> {
  LearnSessionNotifier(this._ref) : super(const LearnSessionState());

  final Ref _ref;

  Future<void> loadCards({int limit = 20}) async {
    state = const LearnSessionState(phase: LearnPhase.loading);
    try {
      final repo = _ref.read(vocabRepositoryProvider);
      final cards = await repo.getLearnCards(limit: limit);
      if (cards.isEmpty) {
        state = const LearnSessionState(phase: LearnPhase.empty);
      } else {
        state = LearnSessionState(phase: LearnPhase.learning, cards: cards);
      }
    } catch (e) {
      state = LearnSessionState(
        phase: LearnPhase.empty,
        error: e.toString(),
      );
    }
  }

  /// Called when user swipes a card.
  /// [direction] is 'right' (know it) or 'left' (learn it).
  Future<void> onSwipe(LearnCard card, String direction) async {
    final decision = direction == 'right' ? 'known' : 'learning';
    try {
      final repo = _ref.read(vocabRepositoryProvider);
      await repo.markWordDecision(card.wordId, decision);
    } catch (_) {
      // Swallowed — user already swiped, don't interrupt UX
    }
    if (decision == 'known') {
      state = state.copyWith(knownCount: state.knownCount + 1);
    } else {
      state = state.copyWith(learningCount: state.learningCount + 1);
    }
  }

  void onSessionComplete() {
    state = state.copyWith(phase: LearnPhase.summary);
  }

  void reset() {
    state = const LearnSessionState();
  }
}

final learnSessionProvider =
    StateNotifierProvider<LearnSessionNotifier, LearnSessionState>(
  (ref) => LearnSessionNotifier(ref),
);
