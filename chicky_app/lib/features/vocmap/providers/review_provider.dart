import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/user_vocab_model.dart';
import '../data/repositories/vocab_repository.dart';
import 'fsrs_provider.dart';
import 'vocmap_provider.dart';

enum ReviewPhase { loading, reviewing, summary, empty }

class ReviewSessionState {
  const ReviewSessionState({
    this.phase = ReviewPhase.loading,
    this.queue = const [],
    this.currentIndex = 0,
    this.isFlipped = false,
    this.reviewedCount = 0,
    this.correctCount = 0,
  });

  final ReviewPhase phase;
  final List<UserVocabModel> queue;
  final int currentIndex;
  final bool isFlipped;
  final int reviewedCount;
  final int correctCount;

  UserVocabModel? get currentCard =>
      queue.isNotEmpty && currentIndex < queue.length
          ? queue[currentIndex]
          : null;

  int get remaining => queue.length - currentIndex;

  ReviewSessionState copyWith({
    ReviewPhase? phase,
    List<UserVocabModel>? queue,
    int? currentIndex,
    bool? isFlipped,
    int? reviewedCount,
    int? correctCount,
  }) {
    return ReviewSessionState(
      phase: phase ?? this.phase,
      queue: queue ?? this.queue,
      currentIndex: currentIndex ?? this.currentIndex,
      isFlipped: isFlipped ?? this.isFlipped,
      reviewedCount: reviewedCount ?? this.reviewedCount,
      correctCount: correctCount ?? this.correctCount,
    );
  }
}

class ReviewSessionNotifier extends StateNotifier<ReviewSessionState> {
  ReviewSessionNotifier(this._ref) : super(const ReviewSessionState());

  final Ref _ref;

  Future<void> startSession() async {
    state = state.copyWith(phase: ReviewPhase.loading);
    try {
      final repo = _ref.read(vocabRepositoryProvider);
      final cards = await repo.getReviewCards(limit: 20);
      if (cards.isEmpty) {
        state = state.copyWith(phase: ReviewPhase.empty);
        return;
      }
      state = ReviewSessionState(
        phase: ReviewPhase.reviewing,
        queue: cards,
        currentIndex: 0,
        isFlipped: false,
      );
    } catch (_) {
      state = state.copyWith(phase: ReviewPhase.empty);
    }
  }

  void flipCard() {
    state = state.copyWith(isFlipped: !state.isFlipped);
  }

  Future<void> grade(String gradeStr) async {
    final card = state.currentCard;
    if (card == null) return;

    final result = FsrsAlgorithm.fsrsUpdate(
      currentStability: card.stability,
      currentDifficulty: card.difficulty,
      reps: card.reps,
      lapses: card.lapses,
      lastReviewedAt: card.lastReviewedAt,
      gradeStr: gradeStr,
    );

    // Persist to Supabase
    final repo = _ref.read(vocabRepositoryProvider);
    await repo.updateFSRS(
      wordId: card.wordId,
      grade: gradeStr,
      newStability: result.stability,
      newDifficulty: result.difficulty,
      newDueAt: result.dueAt,
      newStatus: result.status,
      reps: result.reps,
      lapses: result.lapses,
    );

    final isCorrect = gradeStr != 'again';
    final newIndex = state.currentIndex + 1;

    if (newIndex >= state.queue.length) {
      state = state.copyWith(
        phase: ReviewPhase.summary,
        reviewedCount: state.reviewedCount + 1,
        correctCount: state.correctCount + (isCorrect ? 1 : 0),
      );
    } else {
      state = state.copyWith(
        currentIndex: newIndex,
        isFlipped: false,
        reviewedCount: state.reviewedCount + 1,
        correctCount: state.correctCount + (isCorrect ? 1 : 0),
      );
    }
  }

  void reset() {
    state = const ReviewSessionState();
  }
}

final reviewSessionProvider =
    StateNotifierProvider<ReviewSessionNotifier, ReviewSessionState>(
  (ref) => ReviewSessionNotifier(ref),
);
