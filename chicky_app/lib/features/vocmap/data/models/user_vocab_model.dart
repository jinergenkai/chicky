import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_vocab_model.freezed.dart';
part 'user_vocab_model.g.dart';

/// Mirrors the user_vocabulary table row including FSRS scheduling fields.
@freezed
class UserVocabModel with _$UserVocabModel {
  const factory UserVocabModel({
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'word_id') required String wordId,
    @Default('new') String status,        // new | learning | known | suspended
    @Default(1.0) double stability,       // FSRS S
    @Default(5.0) double difficulty,      // FSRS D
    @JsonKey(name: 'due_at') DateTime? dueAt,
    @JsonKey(name: 'last_grade') String? lastGrade, // again | hard | good | easy
    @Default(0) int reps,
    @Default(0) int lapses,
    @Default('manual') String source,     // manual | scan | chat
    @JsonKey(name: 'first_seen_at') DateTime? firstSeenAt,
    @JsonKey(name: 'last_reviewed_at') DateTime? lastReviewedAt,
    // Joined from words table (optional)
    WordSummary? word,
  }) = _UserVocabModel;

  factory UserVocabModel.fromJson(Map<String, dynamic> json) =>
      _$UserVocabModelFromJson(json);
}

@freezed
class WordSummary with _$WordSummary {
  const factory WordSummary({
    required String id,
    required String word,
    String? ipa,
    @Default([]) List<Map<String, dynamic>> definitions,
    @JsonKey(name: 'cefr_level') String? cefrLevel,
    @JsonKey(name: 'frequency_rank') int? frequencyRank,
    @JsonKey(name: 'example_sentences') @Default([]) List<String> exampleSentences,
  }) = _WordSummary;

  factory WordSummary.fromJson(Map<String, dynamic> json) =>
      _$WordSummaryFromJson(json);
}

extension UserVocabModelX on UserVocabModel {
  bool get isDue {
    if (dueAt == null) return true;
    return DateTime.now().isAfter(dueAt!);
  }

  bool get isNew => status == 'new';
  bool get isLearning => status == 'learning';
  bool get isKnown => status == 'known';
  bool get isSuspended => status == 'suspended';
}
