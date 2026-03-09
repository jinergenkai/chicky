import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/chat_message_model.dart';
import '../data/models/chat_session_model.dart';
import '../data/repositories/chat_repository.dart';

// ── Repository ────────────────────────────────────────────────────────────

final chatRepositoryProvider = Provider<ChatRepository>(
  (_) => ChatRepository(),
);

// ── Chat mode ─────────────────────────────────────────────────────────────

enum ChatMode { buddy, roleplay }

final chatModeProvider = StateProvider<ChatMode>((ref) => ChatMode.buddy);

// ── Active session ────────────────────────────────────────────────────────

final activeSessionProvider = StateProvider<ChatSessionModel?>((ref) => null);

// ── Chat state ────────────────────────────────────────────────────────────

class ChatState {
  const ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.isStreaming = false,
    this.error,
    this.streamingContent = '',
  });

  final List<ChatMessageModel> messages;
  final bool isLoading;
  final bool isStreaming;
  final String? error;
  final String streamingContent;

  ChatState copyWith({
    List<ChatMessageModel>? messages,
    bool? isLoading,
    bool? isStreaming,
    String? error,
    String? streamingContent,
    bool clearError = false,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isStreaming: isStreaming ?? this.isStreaming,
      error: clearError ? null : (error ?? this.error),
      streamingContent: streamingContent ?? this.streamingContent,
    );
  }
}

class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier(this._ref) : super(const ChatState());

  final Ref _ref;
  ChatRepository get _repo => _ref.read(chatRepositoryProvider);

  Future<void> initSession({ChatMode? mode}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final modeStr = (mode ?? _ref.read(chatModeProvider)) == ChatMode.buddy
          ? 'buddy'
          : 'roleplay';

      final session = await _repo.createSession(mode: modeStr);
      _ref.read(activeSessionProvider.notifier).state = session;

      state = state.copyWith(
        isLoading: false,
        messages: [],
        streamingContent: '',
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadSession(String sessionId) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final session = await _repo.getSession(sessionId);
      final messages = await _repo.getMessages(sessionId);
      _ref.read(activeSessionProvider.notifier).state = session;
      state = state.copyWith(isLoading: false, messages: messages);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> sendMessage(String content) async {
    final session = _ref.read(activeSessionProvider);
    if (session == null || content.trim().isEmpty) return;

    // Append user message optimistically
    final userMsg = ChatMessageModelX.userMessage(content, session.id);
    state = state.copyWith(
      messages: [...state.messages, userMsg],
      isStreaming: true,
      streamingContent: '',
      clearError: true,
    );

    // Build history for context (last 10 exchanges)
    final allMsgs = state.messages.where((m) => !m.isLocalOnly).toList();
    final history = allMsgs
        .skip((allMsgs.length - 10).clamp(0, allMsgs.length))
        .map((m) => {'role': m.role, 'content': m.content})
        .toList();

    final mode = _ref.read(chatModeProvider) == ChatMode.buddy ? 'buddy' : 'roleplay';
    final buffer = StringBuffer();

    try {
      await for (final chunk in _repo.sendTextMessage(
        sessionId: session.id,
        message: content,
        mode: mode,
        history: history,
      )) {
        buffer.write(chunk);
        state = state.copyWith(streamingContent: buffer.toString());
      }

      // Persist both messages
      final savedUser = await _repo.saveMessage(
        sessionId: session.id,
        role: 'user',
        content: content,
      );
      final savedAssistant = await _repo.saveMessage(
        sessionId: session.id,
        role: 'assistant',
        content: buffer.toString(),
      );

      // Replace local-only messages with persisted ones
      final msgs = state.messages
          .where((m) => !m.isLocalOnly)
          .toList()
        ..addAll([savedUser, savedAssistant]);

      state = state.copyWith(
        messages: msgs,
        isStreaming: false,
        streamingContent: '',
      );
    } catch (e) {
      state = state.copyWith(
        isStreaming: false,
        streamingContent: '',
        error: e.toString(),
      );
    }
  }

  /// Called by VoiceNotifier after a completed voice exchange.
  /// Persists both messages to DB and updates in-memory state.
  Future<void> appendVoiceExchange({
    required String sessionId,
    required String userTranscript,
    required String assistantResponse,
    List<Map<String, dynamic>> corrections = const [],
  }) async {
    try {
      final savedUser = await _repo.saveMessage(
        sessionId: sessionId,
        role: 'user',
        content: userTranscript,
      );
      final savedAssistant = await _repo.saveMessage(
        sessionId: sessionId,
        role: 'assistant',
        content: assistantResponse,
        corrections: corrections,
      );
      state = state.copyWith(
        messages: [...state.messages, savedUser, savedAssistant],
      );
    } catch (_) {
      // Non-critical — voice already played; swallow persistence error silently.
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>(
  (ref) => ChatNotifier(ref),
);

