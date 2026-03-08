// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatSessionModelImpl _$$ChatSessionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ChatSessionModelImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      mode: json['mode'] as String? ?? 'buddy',
      scenarioId: json['scenarioId'] as String?,
      title: json['title'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      messageCount: (json['message_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$ChatSessionModelImplToJson(
        _$ChatSessionModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'mode': instance.mode,
      'scenarioId': instance.scenarioId,
      'title': instance.title,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'message_count': instance.messageCount,
    };
