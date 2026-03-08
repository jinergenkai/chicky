// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_vocab_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserVocabModelImpl _$$UserVocabModelImplFromJson(Map<String, dynamic> json) =>
    _$UserVocabModelImpl(
      userId: json['user_id'] as String,
      wordId: json['word_id'] as String,
      status: json['status'] as String? ?? 'new',
      stability: (json['stability'] as num?)?.toDouble() ?? 1.0,
      difficulty: (json['difficulty'] as num?)?.toDouble() ?? 5.0,
      dueAt: json['due_at'] == null
          ? null
          : DateTime.parse(json['due_at'] as String),
      lastGrade: json['last_grade'] as String?,
      reps: (json['reps'] as num?)?.toInt() ?? 0,
      lapses: (json['lapses'] as num?)?.toInt() ?? 0,
      source: json['source'] as String? ?? 'manual',
      firstSeenAt: json['first_seen_at'] == null
          ? null
          : DateTime.parse(json['first_seen_at'] as String),
      lastReviewedAt: json['last_reviewed_at'] == null
          ? null
          : DateTime.parse(json['last_reviewed_at'] as String),
      word: json['word'] == null
          ? null
          : WordSummary.fromJson(json['word'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$UserVocabModelImplToJson(
        _$UserVocabModelImpl instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'word_id': instance.wordId,
      'status': instance.status,
      'stability': instance.stability,
      'difficulty': instance.difficulty,
      'due_at': instance.dueAt?.toIso8601String(),
      'last_grade': instance.lastGrade,
      'reps': instance.reps,
      'lapses': instance.lapses,
      'source': instance.source,
      'first_seen_at': instance.firstSeenAt?.toIso8601String(),
      'last_reviewed_at': instance.lastReviewedAt?.toIso8601String(),
      'word': instance.word,
    };

_$WordSummaryImpl _$$WordSummaryImplFromJson(Map<String, dynamic> json) =>
    _$WordSummaryImpl(
      id: json['id'] as String,
      word: json['word'] as String,
      ipa: json['ipa'] as String?,
      definitions: (json['definitions'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      cefrLevel: json['cefr_level'] as String?,
      frequencyRank: (json['frequency_rank'] as num?)?.toInt(),
      exampleSentences: (json['example_sentences'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$WordSummaryImplToJson(_$WordSummaryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'word': instance.word,
      'ipa': instance.ipa,
      'definitions': instance.definitions,
      'cefr_level': instance.cefrLevel,
      'frequency_rank': instance.frequencyRank,
      'example_sentences': instance.exampleSentences,
    };
