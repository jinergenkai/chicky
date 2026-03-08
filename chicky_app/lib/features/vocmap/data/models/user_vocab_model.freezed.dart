// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_vocab_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserVocabModel _$UserVocabModelFromJson(Map<String, dynamic> json) {
  return _UserVocabModel.fromJson(json);
}

/// @nodoc
mixin _$UserVocabModel {
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'word_id')
  String get wordId => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // new | learning | known | suspended
  double get stability => throw _privateConstructorUsedError; // FSRS S
  double get difficulty => throw _privateConstructorUsedError; // FSRS D
  @JsonKey(name: 'due_at')
  DateTime? get dueAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_grade')
  String? get lastGrade =>
      throw _privateConstructorUsedError; // again | hard | good | easy
  int get reps => throw _privateConstructorUsedError;
  int get lapses => throw _privateConstructorUsedError;
  String get source =>
      throw _privateConstructorUsedError; // manual | scan | chat
  @JsonKey(name: 'first_seen_at')
  DateTime? get firstSeenAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_reviewed_at')
  DateTime? get lastReviewedAt =>
      throw _privateConstructorUsedError; // Joined from words table (optional)
  WordSummary? get word => throw _privateConstructorUsedError;

  /// Serializes this UserVocabModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserVocabModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserVocabModelCopyWith<UserVocabModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserVocabModelCopyWith<$Res> {
  factory $UserVocabModelCopyWith(
          UserVocabModel value, $Res Function(UserVocabModel) then) =
      _$UserVocabModelCopyWithImpl<$Res, UserVocabModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'word_id') String wordId,
      String status,
      double stability,
      double difficulty,
      @JsonKey(name: 'due_at') DateTime? dueAt,
      @JsonKey(name: 'last_grade') String? lastGrade,
      int reps,
      int lapses,
      String source,
      @JsonKey(name: 'first_seen_at') DateTime? firstSeenAt,
      @JsonKey(name: 'last_reviewed_at') DateTime? lastReviewedAt,
      WordSummary? word});

  $WordSummaryCopyWith<$Res>? get word;
}

/// @nodoc
class _$UserVocabModelCopyWithImpl<$Res, $Val extends UserVocabModel>
    implements $UserVocabModelCopyWith<$Res> {
  _$UserVocabModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserVocabModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? wordId = null,
    Object? status = null,
    Object? stability = null,
    Object? difficulty = null,
    Object? dueAt = freezed,
    Object? lastGrade = freezed,
    Object? reps = null,
    Object? lapses = null,
    Object? source = null,
    Object? firstSeenAt = freezed,
    Object? lastReviewedAt = freezed,
    Object? word = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      wordId: null == wordId
          ? _value.wordId
          : wordId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      stability: null == stability
          ? _value.stability
          : stability // ignore: cast_nullable_to_non_nullable
              as double,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as double,
      dueAt: freezed == dueAt
          ? _value.dueAt
          : dueAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastGrade: freezed == lastGrade
          ? _value.lastGrade
          : lastGrade // ignore: cast_nullable_to_non_nullable
              as String?,
      reps: null == reps
          ? _value.reps
          : reps // ignore: cast_nullable_to_non_nullable
              as int,
      lapses: null == lapses
          ? _value.lapses
          : lapses // ignore: cast_nullable_to_non_nullable
              as int,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      firstSeenAt: freezed == firstSeenAt
          ? _value.firstSeenAt
          : firstSeenAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastReviewedAt: freezed == lastReviewedAt
          ? _value.lastReviewedAt
          : lastReviewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      word: freezed == word
          ? _value.word
          : word // ignore: cast_nullable_to_non_nullable
              as WordSummary?,
    ) as $Val);
  }

  /// Create a copy of UserVocabModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WordSummaryCopyWith<$Res>? get word {
    if (_value.word == null) {
      return null;
    }

    return $WordSummaryCopyWith<$Res>(_value.word!, (value) {
      return _then(_value.copyWith(word: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserVocabModelImplCopyWith<$Res>
    implements $UserVocabModelCopyWith<$Res> {
  factory _$$UserVocabModelImplCopyWith(_$UserVocabModelImpl value,
          $Res Function(_$UserVocabModelImpl) then) =
      __$$UserVocabModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'word_id') String wordId,
      String status,
      double stability,
      double difficulty,
      @JsonKey(name: 'due_at') DateTime? dueAt,
      @JsonKey(name: 'last_grade') String? lastGrade,
      int reps,
      int lapses,
      String source,
      @JsonKey(name: 'first_seen_at') DateTime? firstSeenAt,
      @JsonKey(name: 'last_reviewed_at') DateTime? lastReviewedAt,
      WordSummary? word});

  @override
  $WordSummaryCopyWith<$Res>? get word;
}

/// @nodoc
class __$$UserVocabModelImplCopyWithImpl<$Res>
    extends _$UserVocabModelCopyWithImpl<$Res, _$UserVocabModelImpl>
    implements _$$UserVocabModelImplCopyWith<$Res> {
  __$$UserVocabModelImplCopyWithImpl(
      _$UserVocabModelImpl _value, $Res Function(_$UserVocabModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserVocabModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? wordId = null,
    Object? status = null,
    Object? stability = null,
    Object? difficulty = null,
    Object? dueAt = freezed,
    Object? lastGrade = freezed,
    Object? reps = null,
    Object? lapses = null,
    Object? source = null,
    Object? firstSeenAt = freezed,
    Object? lastReviewedAt = freezed,
    Object? word = freezed,
  }) {
    return _then(_$UserVocabModelImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      wordId: null == wordId
          ? _value.wordId
          : wordId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      stability: null == stability
          ? _value.stability
          : stability // ignore: cast_nullable_to_non_nullable
              as double,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as double,
      dueAt: freezed == dueAt
          ? _value.dueAt
          : dueAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastGrade: freezed == lastGrade
          ? _value.lastGrade
          : lastGrade // ignore: cast_nullable_to_non_nullable
              as String?,
      reps: null == reps
          ? _value.reps
          : reps // ignore: cast_nullable_to_non_nullable
              as int,
      lapses: null == lapses
          ? _value.lapses
          : lapses // ignore: cast_nullable_to_non_nullable
              as int,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      firstSeenAt: freezed == firstSeenAt
          ? _value.firstSeenAt
          : firstSeenAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastReviewedAt: freezed == lastReviewedAt
          ? _value.lastReviewedAt
          : lastReviewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      word: freezed == word
          ? _value.word
          : word // ignore: cast_nullable_to_non_nullable
              as WordSummary?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserVocabModelImpl implements _UserVocabModel {
  const _$UserVocabModelImpl(
      {@JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'word_id') required this.wordId,
      this.status = 'new',
      this.stability = 1.0,
      this.difficulty = 5.0,
      @JsonKey(name: 'due_at') this.dueAt,
      @JsonKey(name: 'last_grade') this.lastGrade,
      this.reps = 0,
      this.lapses = 0,
      this.source = 'manual',
      @JsonKey(name: 'first_seen_at') this.firstSeenAt,
      @JsonKey(name: 'last_reviewed_at') this.lastReviewedAt,
      this.word});

  factory _$UserVocabModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserVocabModelImplFromJson(json);

  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'word_id')
  final String wordId;
  @override
  @JsonKey()
  final String status;
// new | learning | known | suspended
  @override
  @JsonKey()
  final double stability;
// FSRS S
  @override
  @JsonKey()
  final double difficulty;
// FSRS D
  @override
  @JsonKey(name: 'due_at')
  final DateTime? dueAt;
  @override
  @JsonKey(name: 'last_grade')
  final String? lastGrade;
// again | hard | good | easy
  @override
  @JsonKey()
  final int reps;
  @override
  @JsonKey()
  final int lapses;
  @override
  @JsonKey()
  final String source;
// manual | scan | chat
  @override
  @JsonKey(name: 'first_seen_at')
  final DateTime? firstSeenAt;
  @override
  @JsonKey(name: 'last_reviewed_at')
  final DateTime? lastReviewedAt;
// Joined from words table (optional)
  @override
  final WordSummary? word;

  @override
  String toString() {
    return 'UserVocabModel(userId: $userId, wordId: $wordId, status: $status, stability: $stability, difficulty: $difficulty, dueAt: $dueAt, lastGrade: $lastGrade, reps: $reps, lapses: $lapses, source: $source, firstSeenAt: $firstSeenAt, lastReviewedAt: $lastReviewedAt, word: $word)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserVocabModelImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.wordId, wordId) || other.wordId == wordId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.stability, stability) ||
                other.stability == stability) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(other.dueAt, dueAt) || other.dueAt == dueAt) &&
            (identical(other.lastGrade, lastGrade) ||
                other.lastGrade == lastGrade) &&
            (identical(other.reps, reps) || other.reps == reps) &&
            (identical(other.lapses, lapses) || other.lapses == lapses) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.firstSeenAt, firstSeenAt) ||
                other.firstSeenAt == firstSeenAt) &&
            (identical(other.lastReviewedAt, lastReviewedAt) ||
                other.lastReviewedAt == lastReviewedAt) &&
            (identical(other.word, word) || other.word == word));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      wordId,
      status,
      stability,
      difficulty,
      dueAt,
      lastGrade,
      reps,
      lapses,
      source,
      firstSeenAt,
      lastReviewedAt,
      word);

  /// Create a copy of UserVocabModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserVocabModelImplCopyWith<_$UserVocabModelImpl> get copyWith =>
      __$$UserVocabModelImplCopyWithImpl<_$UserVocabModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserVocabModelImplToJson(
      this,
    );
  }
}

abstract class _UserVocabModel implements UserVocabModel {
  const factory _UserVocabModel(
      {@JsonKey(name: 'user_id') required final String userId,
      @JsonKey(name: 'word_id') required final String wordId,
      final String status,
      final double stability,
      final double difficulty,
      @JsonKey(name: 'due_at') final DateTime? dueAt,
      @JsonKey(name: 'last_grade') final String? lastGrade,
      final int reps,
      final int lapses,
      final String source,
      @JsonKey(name: 'first_seen_at') final DateTime? firstSeenAt,
      @JsonKey(name: 'last_reviewed_at') final DateTime? lastReviewedAt,
      final WordSummary? word}) = _$UserVocabModelImpl;

  factory _UserVocabModel.fromJson(Map<String, dynamic> json) =
      _$UserVocabModelImpl.fromJson;

  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'word_id')
  String get wordId;
  @override
  String get status; // new | learning | known | suspended
  @override
  double get stability; // FSRS S
  @override
  double get difficulty; // FSRS D
  @override
  @JsonKey(name: 'due_at')
  DateTime? get dueAt;
  @override
  @JsonKey(name: 'last_grade')
  String? get lastGrade; // again | hard | good | easy
  @override
  int get reps;
  @override
  int get lapses;
  @override
  String get source; // manual | scan | chat
  @override
  @JsonKey(name: 'first_seen_at')
  DateTime? get firstSeenAt;
  @override
  @JsonKey(name: 'last_reviewed_at')
  DateTime? get lastReviewedAt; // Joined from words table (optional)
  @override
  WordSummary? get word;

  /// Create a copy of UserVocabModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserVocabModelImplCopyWith<_$UserVocabModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WordSummary _$WordSummaryFromJson(Map<String, dynamic> json) {
  return _WordSummary.fromJson(json);
}

/// @nodoc
mixin _$WordSummary {
  String get id => throw _privateConstructorUsedError;
  String get word => throw _privateConstructorUsedError;
  String? get ipa => throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get definitions =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'cefr_level')
  String? get cefrLevel => throw _privateConstructorUsedError;
  @JsonKey(name: 'frequency_rank')
  int? get frequencyRank => throw _privateConstructorUsedError;
  @JsonKey(name: 'example_sentences')
  List<String> get exampleSentences => throw _privateConstructorUsedError;

  /// Serializes this WordSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WordSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WordSummaryCopyWith<WordSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WordSummaryCopyWith<$Res> {
  factory $WordSummaryCopyWith(
          WordSummary value, $Res Function(WordSummary) then) =
      _$WordSummaryCopyWithImpl<$Res, WordSummary>;
  @useResult
  $Res call(
      {String id,
      String word,
      String? ipa,
      List<Map<String, dynamic>> definitions,
      @JsonKey(name: 'cefr_level') String? cefrLevel,
      @JsonKey(name: 'frequency_rank') int? frequencyRank,
      @JsonKey(name: 'example_sentences') List<String> exampleSentences});
}

/// @nodoc
class _$WordSummaryCopyWithImpl<$Res, $Val extends WordSummary>
    implements $WordSummaryCopyWith<$Res> {
  _$WordSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WordSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? word = null,
    Object? ipa = freezed,
    Object? definitions = null,
    Object? cefrLevel = freezed,
    Object? frequencyRank = freezed,
    Object? exampleSentences = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      word: null == word
          ? _value.word
          : word // ignore: cast_nullable_to_non_nullable
              as String,
      ipa: freezed == ipa
          ? _value.ipa
          : ipa // ignore: cast_nullable_to_non_nullable
              as String?,
      definitions: null == definitions
          ? _value.definitions
          : definitions // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      cefrLevel: freezed == cefrLevel
          ? _value.cefrLevel
          : cefrLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      frequencyRank: freezed == frequencyRank
          ? _value.frequencyRank
          : frequencyRank // ignore: cast_nullable_to_non_nullable
              as int?,
      exampleSentences: null == exampleSentences
          ? _value.exampleSentences
          : exampleSentences // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WordSummaryImplCopyWith<$Res>
    implements $WordSummaryCopyWith<$Res> {
  factory _$$WordSummaryImplCopyWith(
          _$WordSummaryImpl value, $Res Function(_$WordSummaryImpl) then) =
      __$$WordSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String word,
      String? ipa,
      List<Map<String, dynamic>> definitions,
      @JsonKey(name: 'cefr_level') String? cefrLevel,
      @JsonKey(name: 'frequency_rank') int? frequencyRank,
      @JsonKey(name: 'example_sentences') List<String> exampleSentences});
}

/// @nodoc
class __$$WordSummaryImplCopyWithImpl<$Res>
    extends _$WordSummaryCopyWithImpl<$Res, _$WordSummaryImpl>
    implements _$$WordSummaryImplCopyWith<$Res> {
  __$$WordSummaryImplCopyWithImpl(
      _$WordSummaryImpl _value, $Res Function(_$WordSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of WordSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? word = null,
    Object? ipa = freezed,
    Object? definitions = null,
    Object? cefrLevel = freezed,
    Object? frequencyRank = freezed,
    Object? exampleSentences = null,
  }) {
    return _then(_$WordSummaryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      word: null == word
          ? _value.word
          : word // ignore: cast_nullable_to_non_nullable
              as String,
      ipa: freezed == ipa
          ? _value.ipa
          : ipa // ignore: cast_nullable_to_non_nullable
              as String?,
      definitions: null == definitions
          ? _value._definitions
          : definitions // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      cefrLevel: freezed == cefrLevel
          ? _value.cefrLevel
          : cefrLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      frequencyRank: freezed == frequencyRank
          ? _value.frequencyRank
          : frequencyRank // ignore: cast_nullable_to_non_nullable
              as int?,
      exampleSentences: null == exampleSentences
          ? _value._exampleSentences
          : exampleSentences // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WordSummaryImpl implements _WordSummary {
  const _$WordSummaryImpl(
      {required this.id,
      required this.word,
      this.ipa,
      final List<Map<String, dynamic>> definitions = const [],
      @JsonKey(name: 'cefr_level') this.cefrLevel,
      @JsonKey(name: 'frequency_rank') this.frequencyRank,
      @JsonKey(name: 'example_sentences')
      final List<String> exampleSentences = const []})
      : _definitions = definitions,
        _exampleSentences = exampleSentences;

  factory _$WordSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$WordSummaryImplFromJson(json);

  @override
  final String id;
  @override
  final String word;
  @override
  final String? ipa;
  final List<Map<String, dynamic>> _definitions;
  @override
  @JsonKey()
  List<Map<String, dynamic>> get definitions {
    if (_definitions is EqualUnmodifiableListView) return _definitions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_definitions);
  }

  @override
  @JsonKey(name: 'cefr_level')
  final String? cefrLevel;
  @override
  @JsonKey(name: 'frequency_rank')
  final int? frequencyRank;
  final List<String> _exampleSentences;
  @override
  @JsonKey(name: 'example_sentences')
  List<String> get exampleSentences {
    if (_exampleSentences is EqualUnmodifiableListView)
      return _exampleSentences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_exampleSentences);
  }

  @override
  String toString() {
    return 'WordSummary(id: $id, word: $word, ipa: $ipa, definitions: $definitions, cefrLevel: $cefrLevel, frequencyRank: $frequencyRank, exampleSentences: $exampleSentences)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WordSummaryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.word, word) || other.word == word) &&
            (identical(other.ipa, ipa) || other.ipa == ipa) &&
            const DeepCollectionEquality()
                .equals(other._definitions, _definitions) &&
            (identical(other.cefrLevel, cefrLevel) ||
                other.cefrLevel == cefrLevel) &&
            (identical(other.frequencyRank, frequencyRank) ||
                other.frequencyRank == frequencyRank) &&
            const DeepCollectionEquality()
                .equals(other._exampleSentences, _exampleSentences));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      word,
      ipa,
      const DeepCollectionEquality().hash(_definitions),
      cefrLevel,
      frequencyRank,
      const DeepCollectionEquality().hash(_exampleSentences));

  /// Create a copy of WordSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WordSummaryImplCopyWith<_$WordSummaryImpl> get copyWith =>
      __$$WordSummaryImplCopyWithImpl<_$WordSummaryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WordSummaryImplToJson(
      this,
    );
  }
}

abstract class _WordSummary implements WordSummary {
  const factory _WordSummary(
      {required final String id,
      required final String word,
      final String? ipa,
      final List<Map<String, dynamic>> definitions,
      @JsonKey(name: 'cefr_level') final String? cefrLevel,
      @JsonKey(name: 'frequency_rank') final int? frequencyRank,
      @JsonKey(name: 'example_sentences')
      final List<String> exampleSentences}) = _$WordSummaryImpl;

  factory _WordSummary.fromJson(Map<String, dynamic> json) =
      _$WordSummaryImpl.fromJson;

  @override
  String get id;
  @override
  String get word;
  @override
  String? get ipa;
  @override
  List<Map<String, dynamic>> get definitions;
  @override
  @JsonKey(name: 'cefr_level')
  String? get cefrLevel;
  @override
  @JsonKey(name: 'frequency_rank')
  int? get frequencyRank;
  @override
  @JsonKey(name: 'example_sentences')
  List<String> get exampleSentences;

  /// Create a copy of WordSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WordSummaryImplCopyWith<_$WordSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
