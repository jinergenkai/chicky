import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message_model.freezed.dart';
part 'chat_message_model.g.dart';

@freezed
class ChatMessageModel with _$ChatMessageModel {
  const factory ChatMessageModel({
    required String id,
    @JsonKey(name: 'session_id') required String sessionId,
    required String role,         // user | assistant
    required String content,
    /// Corrections JSONB — list of correction objects from LLM
    @Default([]) List<Map<String, dynamic>> corrections,
    @JsonKey(name: 'audio_url') String? audioUrl,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    // Local-only fields (not persisted)
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(false) bool isStreaming,
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(false) bool isLocalOnly,
  }) = _ChatMessageModel;

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageModelFromJson(json);
}

extension ChatMessageModelX on ChatMessageModel {
  bool get isUser => role == 'user';
  bool get isAssistant => role == 'assistant';
  bool get hasCorrections => corrections.isNotEmpty;

  /// Creates a temporary user message (before persistence).
  static ChatMessageModel userMessage(String content, String sessionId) {
    return ChatMessageModel(
      id: 'local_${DateTime.now().millisecondsSinceEpoch}',
      sessionId: sessionId,
      role: 'user',
      content: content,
      createdAt: DateTime.now(),
      isLocalOnly: true,
    );
  }

  /// Creates a streaming assistant message placeholder.
  static ChatMessageModel streamingPlaceholder(String sessionId) {
    return ChatMessageModel(
      id: 'streaming_${DateTime.now().millisecondsSinceEpoch}',
      sessionId: sessionId,
      role: 'assistant',
      content: '',
      isStreaming: true,
      isLocalOnly: true,
    );
  }
}
