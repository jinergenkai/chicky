// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'domain_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DomainModelImpl _$$DomainModelImplFromJson(Map<String, dynamic> json) =>
    _$DomainModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      parentId: json['parent_id'] as String?,
      icon: json['icon'] as String?,
      children: (json['children'] as List<dynamic>?)
              ?.map((e) => DomainModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      wordCount: (json['word_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$DomainModelImplToJson(_$DomainModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'parent_id': instance.parentId,
      'icon': instance.icon,
      'children': instance.children,
      'word_count': instance.wordCount,
    };
