import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// FSRS-4.5 algorithm implementation.
///
/// Based on the Free Spaced Repetition Scheduler paper.
/// Grades: again=1, hard=2, good=3, easy=4
class FsrsAlgorithm {
  // FSRS-4.5 default weights
  static const List<double> w = [
    0.4072, 1.1829, 3.1262, 15.4722, 7.2102, 0.5316, 1.0651, 0.0589,
    1.5330, 0.1544, 1.0071, 1.9395, 0.1100, 0.2900, 2.2700, 0.1700,
    2.9898, 0.5100, 0.1400,
  ];

  static const double _decayFactor = -0.5;
  static const double _stabilityModifier = 0.9;

  // ── Stability after successful recall ─────────────────────────────────────

  static double _stabilityAfterRecall({
    required double s,        // current stability
    required double d,        // difficulty
    required double r,        // retrievability
    required int grade,       // 2=hard, 3=good, 4=easy
  }) {
    final hardPenalty = grade == 2 ? w[15] : 1.0;
    final easyBonus = grade == 4 ? w[16] : 1.0;
    return s *
        (math.exp(w[8]) *
            (11 - d) *
            math.pow(s, -w[9]) *
            (math.exp((1 - r) * w[10]) - 1) *
            hardPenalty *
            easyBonus +
            1);
  }

  // ── Stability after forgetting (lapse) ───────────────────────────────────

  static double _stabilityAfterForgetting({
    required double s,
    required double d,
    required double r,
  }) {
    return w[11] *
        math.pow(d, -w[12]) *
        (math.pow(s + 1, w[13]) - 1) *
        math.exp((1 - r) * w[14]);
  }

  // ── Difficulty update ─────────────────────────────────────────────────────

  static double _updateDifficulty(double d, int grade) {
    const double deltaD = -0.5; // shift per grade
    final newD = d + deltaD * (3 - grade) * ((10 - d) / 9);
    return newD.clamp(1.0, 10.0);
  }

  // ── Retrievability ────────────────────────────────────────────────────────

  static double _retrievability(double elapsedDays, double stability) {
    return math.pow(1 + elapsedDays / (9 * stability), _decayFactor).toDouble();
  }

  // ── Initial stability for new cards ──────────────────────────────────────

  static double _initialStability(int grade) {
    // grade index offset: again=0, hard=1, good=2, easy=3
    final idx = (grade - 1).clamp(0, 3);
    return w[idx];
  }

  static double _initialDifficulty(int grade) {
    return (w[4] - math.exp(w[5] * (grade - 1)) + 1).clamp(1.0, 10.0);
  }

  // ── Public API ────────────────────────────────────────────────────────────

  /// Computes updated FSRS fields after a review.
  ///
  /// [currentStability] — S from DB (default 1.0 for new cards)
  /// [currentDifficulty] — D from DB (default 5.0 for new cards)
  /// [reps] — number of reviews so far
  /// [lapses] — number of forgotten reviews
  /// [lastReviewedAt] — timestamp of last review (null if new card)
  /// [gradeStr] — 'again' | 'hard' | 'good' | 'easy'
  ///
  /// Returns [FsrsResult] with updated fields.
  static FsrsResult fsrsUpdate({
    required double currentStability,
    required double currentDifficulty,
    required int reps,
    required int lapses,
    required DateTime? lastReviewedAt,
    required String gradeStr,
  }) {
    final int grade = _gradeValue(gradeStr);

    double newStability;
    double newDifficulty;
    int newReps = reps;
    int newLapses = lapses;

    if (reps == 0) {
      // First review — initialize
      newStability = _initialStability(grade);
      newDifficulty = _initialDifficulty(grade);
    } else {
      final double elapsedDays = lastReviewedAt == null
          ? 1.0
          : DateTime.now().difference(lastReviewedAt).inHours / 24.0;

      final double r = _retrievability(elapsedDays, currentStability);
      newDifficulty = _updateDifficulty(currentDifficulty, grade);

      if (grade == 1) {
        // Forgotten
        newStability = _stabilityAfterForgetting(
          s: currentStability,
          d: newDifficulty,
          r: r,
        );
        newLapses = lapses + 1;
      } else {
        // Recalled
        newStability = _stabilityAfterRecall(
          s: currentStability,
          d: newDifficulty,
          r: r,
          grade: grade,
        );
      }
    }

    // Clamp stability to reasonable range
    newStability = newStability.clamp(0.1, 36500.0);
    newDifficulty = newDifficulty.clamp(1.0, 10.0);

    // Compute next interval in days
    final double interval = _nextInterval(newStability, grade);
    final DateTime newDueAt = DateTime.now().add(
      Duration(seconds: (interval * 86400).round()),
    );

    newReps = newReps + 1;

    // Determine card status
    final String newStatus = _deriveStatus(grade, newReps);

    return FsrsResult(
      stability: newStability,
      difficulty: newDifficulty,
      dueAt: newDueAt,
      reps: newReps,
      lapses: newLapses,
      status: newStatus,
      intervalDays: interval,
    );
  }

  static double _nextInterval(double stability, int grade) {
    if (grade == 1) {
      // Relearn interval — 10 minutes expressed as fraction of a day
      return 10.0 / 1440.0;
    }
    // Target retrievability 0.9
    const double targetR = 0.9;
    return (9 * stability * (1 / targetR - 1) * _stabilityModifier)
        .clamp(1.0, 36500.0);
  }

  static String _deriveStatus(int grade, int reps) {
    if (grade == 1) return 'learning';
    if (reps <= 1) return 'learning';
    return 'known';
  }

  static int _gradeValue(String grade) {
    switch (grade) {
      case 'again':
        return 1;
      case 'hard':
        return 2;
      case 'good':
        return 3;
      case 'easy':
        return 4;
      default:
        return 3;
    }
  }
}

class FsrsResult {
  const FsrsResult({
    required this.stability,
    required this.difficulty,
    required this.dueAt,
    required this.reps,
    required this.lapses,
    required this.status,
    required this.intervalDays,
  });

  final double stability;
  final double difficulty;
  final DateTime dueAt;
  final int reps;
  final int lapses;
  final String status;
  final double intervalDays;

  String get intervalDisplay {
    if (intervalDays < 1) {
      final minutes = (intervalDays * 1440).round();
      return '${minutes}m';
    } else if (intervalDays < 30) {
      return '${intervalDays.round()}d';
    } else if (intervalDays < 365) {
      return '${(intervalDays / 30).round()}mo';
    } else {
      return '${(intervalDays / 365).toStringAsFixed(1)}yr';
    }
  }
}

// ── Riverpod provider ─────────────────────────────────────────────────────

final fsrsAlgorithmProvider = Provider<FsrsAlgorithm>((_) => FsrsAlgorithm());
