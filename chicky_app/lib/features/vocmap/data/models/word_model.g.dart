// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WordModelImpl _$$WordModelImplFromJson(Map<String, dynamic> json) =>
    _$WordModelImpl(
      id: json['id'] as String,
      word: json['word'] as String,
      ipa: json['ipa'] as String?,
      definitions: (json['definitions'] as List<dynamic>?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          const [],
      cefrLevel: json['cefrLevel'] as String?,
      frequencyRank: (json['frequencyRank'] as num?)?.toInt(),
      exampleSentences: (json['exampleSentences'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      verified: json['verified'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      viTranslation: json['vi_translation'] as String?,
    );

Map<String, dynamic> _$$WordModelImplToJson(_$WordModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'word': instance.word,
      'ipa': instance.ipa,
      'definitions': instance.definitions,
      'cefrLevel': instance.cefrLevel,
      'frequencyRank': instance.frequencyRank,
      'exampleSentences': instance.exampleSentences,
      'verified': instance.verified,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'vi_translation': instance.viTranslation,
    };
