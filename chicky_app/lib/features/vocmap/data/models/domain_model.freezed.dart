// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'domain_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DomainModel _$DomainModelFromJson(Map<String, dynamic> json) {
  return _DomainModel.fromJson(json);
}

/// @nodoc
mixin _$DomainModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'parent_id')
  String? get parentId => throw _privateConstructorUsedError;
  String? get icon =>
      throw _privateConstructorUsedError; // Children loaded separately when building the hierarchy
  List<DomainModel> get children =>
      throw _privateConstructorUsedError; // Word count for display
  @JsonKey(name: 'word_count')
  int get wordCount => throw _privateConstructorUsedError;

  /// Serializes this DomainModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DomainModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DomainModelCopyWith<DomainModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DomainModelCopyWith<$Res> {
  factory $DomainModelCopyWith(
          DomainModel value, $Res Function(DomainModel) then) =
      _$DomainModelCopyWithImpl<$Res, DomainModel>;
  @useResult
  $Res call(
      {String id,
      String name,
      @JsonKey(name: 'parent_id') String? parentId,
      String? icon,
      List<DomainModel> children,
      @JsonKey(name: 'word_count') int wordCount});
}

/// @nodoc
class _$DomainModelCopyWithImpl<$Res, $Val extends DomainModel>
    implements $DomainModelCopyWith<$Res> {
  _$DomainModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DomainModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? parentId = freezed,
    Object? icon = freezed,
    Object? children = null,
    Object? wordCount = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      children: null == children
          ? _value.children
          : children // ignore: cast_nullable_to_non_nullable
              as List<DomainModel>,
      wordCount: null == wordCount
          ? _value.wordCount
          : wordCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DomainModelImplCopyWith<$Res>
    implements $DomainModelCopyWith<$Res> {
  factory _$$DomainModelImplCopyWith(
          _$DomainModelImpl value, $Res Function(_$DomainModelImpl) then) =
      __$$DomainModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      @JsonKey(name: 'parent_id') String? parentId,
      String? icon,
      List<DomainModel> children,
      @JsonKey(name: 'word_count') int wordCount});
}

/// @nodoc
class __$$DomainModelImplCopyWithImpl<$Res>
    extends _$DomainModelCopyWithImpl<$Res, _$DomainModelImpl>
    implements _$$DomainModelImplCopyWith<$Res> {
  __$$DomainModelImplCopyWithImpl(
      _$DomainModelImpl _value, $Res Function(_$DomainModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of DomainModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? parentId = freezed,
    Object? icon = freezed,
    Object? children = null,
    Object? wordCount = null,
  }) {
    return _then(_$DomainModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      icon: freezed == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String?,
      children: null == children
          ? _value._children
          : children // ignore: cast_nullable_to_non_nullable
              as List<DomainModel>,
      wordCount: null == wordCount
          ? _value.wordCount
          : wordCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DomainModelImpl implements _DomainModel {
  const _$DomainModelImpl(
      {required this.id,
      required this.name,
      @JsonKey(name: 'parent_id') this.parentId,
      this.icon,
      final List<DomainModel> children = const [],
      @JsonKey(name: 'word_count') this.wordCount = 0})
      : _children = children;

  factory _$DomainModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DomainModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey(name: 'parent_id')
  final String? parentId;
  @override
  final String? icon;
// Children loaded separately when building the hierarchy
  final List<DomainModel> _children;
// Children loaded separately when building the hierarchy
  @override
  @JsonKey()
  List<DomainModel> get children {
    if (_children is EqualUnmodifiableListView) return _children;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_children);
  }

// Word count for display
  @override
  @JsonKey(name: 'word_count')
  final int wordCount;

  @override
  String toString() {
    return 'DomainModel(id: $id, name: $name, parentId: $parentId, icon: $icon, children: $children, wordCount: $wordCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DomainModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            const DeepCollectionEquality().equals(other._children, _children) &&
            (identical(other.wordCount, wordCount) ||
                other.wordCount == wordCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, parentId, icon,
      const DeepCollectionEquality().hash(_children), wordCount);

  /// Create a copy of DomainModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DomainModelImplCopyWith<_$DomainModelImpl> get copyWith =>
      __$$DomainModelImplCopyWithImpl<_$DomainModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DomainModelImplToJson(
      this,
    );
  }
}

abstract class _DomainModel implements DomainModel {
  const factory _DomainModel(
      {required final String id,
      required final String name,
      @JsonKey(name: 'parent_id') final String? parentId,
      final String? icon,
      final List<DomainModel> children,
      @JsonKey(name: 'word_count') final int wordCount}) = _$DomainModelImpl;

  factory _DomainModel.fromJson(Map<String, dynamic> json) =
      _$DomainModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  @JsonKey(name: 'parent_id')
  String? get parentId;
  @override
  String? get icon; // Children loaded separately when building the hierarchy
  @override
  List<DomainModel> get children; // Word count for display
  @override
  @JsonKey(name: 'word_count')
  int get wordCount;

  /// Create a copy of DomainModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DomainModelImplCopyWith<_$DomainModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
