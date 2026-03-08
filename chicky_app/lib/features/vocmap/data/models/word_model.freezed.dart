// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'word_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WordModel _$WordModelFromJson(Map<String, dynamic> json) {
  return _WordModel.fromJson(json);
}

/// @nodoc
mixin _$WordModel {
  String get id => throw _privateConstructorUsedError;
  String get word => throw _privateConstructorUsedError;
  String? get ipa => throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get definitions =>
      throw _privateConstructorUsedError;
  String? get cefrLevel => throw _privateConstructorUsedError;
  int? get frequencyRank => throw _privateConstructorUsedError;
  List<String> get exampleSentences => throw _privateConstructorUsedError;
  bool get verified => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt =>
      throw _privateConstructorUsedError; // Optional: Vietnamese translation from fill_vietnamese pipeline
  @JsonKey(name: 'vi_translation')
  String? get viTranslation => throw _privateConstructorUsedError;

  /// Serializes this WordModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WordModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WordModelCopyWith<WordModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WordModelCopyWith<$Res> {
  factory $WordModelCopyWith(WordModel value, $Res Function(WordModel) then) =
      _$WordModelCopyWithImpl<$Res, WordModel>;
  @useResult
  $Res call(
      {String id,
      String word,
      String? ipa,
      List<Map<String, dynamic>> definitions,
      String? cefrLevel,
      int? frequencyRank,
      List<String> exampleSentences,
      bool verified,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'vi_translation') String? viTranslation});
}

/// @nodoc
class _$WordModelCopyWithImpl<$Res, $Val extends WordModel>
    implements $WordModelCopyWith<$Res> {
  _$WordModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WordModel
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
    Object? verified = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? viTranslation = freezed,
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
      verified: null == verified
          ? _value.verified
          : verified // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      viTranslation: freezed == viTranslation
          ? _value.viTranslation
          : viTranslation // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WordModelImplCopyWith<$Res>
    implements $WordModelCopyWith<$Res> {
  factory _$$WordModelImplCopyWith(
          _$WordModelImpl value, $Res Function(_$WordModelImpl) then) =
      __$$WordModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String word,
      String? ipa,
      List<Map<String, dynamic>> definitions,
      String? cefrLevel,
      int? frequencyRank,
      List<String> exampleSentences,
      bool verified,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'vi_translation') String? viTranslation});
}

/// @nodoc
class __$$WordModelImplCopyWithImpl<$Res>
    extends _$WordModelCopyWithImpl<$Res, _$WordModelImpl>
    implements _$$WordModelImplCopyWith<$Res> {
  __$$WordModelImplCopyWithImpl(
      _$WordModelImpl _value, $Res Function(_$WordModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of WordModel
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
    Object? verified = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? viTranslation = freezed,
  }) {
    return _then(_$WordModelImpl(
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
      verified: null == verified
          ? _value.verified
          : verified // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      viTranslation: freezed == viTranslation
          ? _value.viTranslation
          : viTranslation // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WordModelImpl implements _WordModel {
  const _$WordModelImpl(
      {required this.id,
      required this.word,
      this.ipa,
      final List<Map<String, dynamic>> definitions = const [],
      this.cefrLevel,
      this.frequencyRank,
      final List<String> exampleSentences = const [],
      this.verified = false,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'vi_translation') this.viTranslation})
      : _definitions = definitions,
        _exampleSentences = exampleSentences;

  factory _$WordModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$WordModelImplFromJson(json);

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
  final String? cefrLevel;
  @override
  final int? frequencyRank;
  final List<String> _exampleSentences;
  @override
  @JsonKey()
  List<String> get exampleSentences {
    if (_exampleSentences is EqualUnmodifiableListView)
      return _exampleSentences;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_exampleSentences);
  }

  @override
  @JsonKey()
  final bool verified;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
// Optional: Vietnamese translation from fill_vietnamese pipeline
  @override
  @JsonKey(name: 'vi_translation')
  final String? viTranslation;

  @override
  String toString() {
    return 'WordModel(id: $id, word: $word, ipa: $ipa, definitions: $definitions, cefrLevel: $cefrLevel, frequencyRank: $frequencyRank, exampleSentences: $exampleSentences, verified: $verified, createdAt: $createdAt, updatedAt: $updatedAt, viTranslation: $viTranslation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WordModelImpl &&
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
                .equals(other._exampleSentences, _exampleSentences) &&
            (identical(other.verified, verified) ||
                other.verified == verified) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.viTranslation, viTranslation) ||
                other.viTranslation == viTranslation));
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
      const DeepCollectionEquality().hash(_exampleSentences),
      verified,
      createdAt,
      updatedAt,
      viTranslation);

  /// Create a copy of WordModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WordModelImplCopyWith<_$WordModelImpl> get copyWith =>
      __$$WordModelImplCopyWithImpl<_$WordModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WordModelImplToJson(
      this,
    );
  }
}

abstract class _WordModel implements WordModel {
  const factory _WordModel(
          {required final String id,
          required final String word,
          final String? ipa,
          final List<Map<String, dynamic>> definitions,
          final String? cefrLevel,
          final int? frequencyRank,
          final List<String> exampleSentences,
          final bool verified,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt,
          @JsonKey(name: 'vi_translation') final String? viTranslation}) =
      _$WordModelImpl;

  factory _WordModel.fromJson(Map<String, dynamic> json) =
      _$WordModelImpl.fromJson;

  @override
  String get id;
  @override
  String get word;
  @override
  String? get ipa;
  @override
  List<Map<String, dynamic>> get definitions;
  @override
  String? get cefrLevel;
  @override
  int? get frequencyRank;
  @override
  List<String> get exampleSentences;
  @override
  bool get verified;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime?
      get updatedAt; // Optional: Vietnamese translation from fill_vietnamese pipeline
  @override
  @JsonKey(name: 'vi_translation')
  String? get viTranslation;

  /// Create a copy of WordModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WordModelImplCopyWith<_$WordModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
