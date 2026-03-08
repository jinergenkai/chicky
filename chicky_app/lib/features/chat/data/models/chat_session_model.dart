import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_session_model.freezed.dart';
part 'chat_session_model.g.dart';

@freezed
class ChatSessionModel with _$ChatSessionModel {
  const factory ChatSessionModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @Default('buddy') String mode,       // buddy | roleplay
    String? scenarioId,
    String? title,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    // Joined
    @Default(0) @JsonKey(name: 'message_count') int messageCount,
  }) = _ChatSessionModel;

  factory ChatSessionModel.fromJson(Map<String, dynamic> json) =>
      _$ChatSessionModelFromJson(json);
}

extension ChatSessionModelX on ChatSessionModel {
  bool get isBuddyMode => mode == 'buddy';
  bool get isRoleplayMode => mode == 'roleplay';

  String get displayTitle {
    if (title != null && title!.isNotEmpty) return title!;
    if (createdAt != null) {
      return 'Chat ${createdAt!.day}/${createdAt!.month}/${createdAt!.year}';
    }
    return 'New Chat';
  }
}
