import 'dart:developer' as developer;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/chat_message_model.dart';
import '../data/models/chat_session_model.dart';
import '../data/repositories/chat_repository.dart';

// ── Repository ────────────────────────────────────────────────────────────

final chatRepositoryProvider = Provider<ChatRepository>(
  (_) => ChatRepository(),
);

// ── Chat mode ─────────────────────────────────────────────────────────────

enum ChatMode { buddy, roleplay, vocabulary }

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

  static String modeToString(ChatMode mode) {
    return switch (mode) {
      ChatMode.buddy => 'buddy',
      ChatMode.roleplay => 'roleplay',
      ChatMode.vocabulary => 'vocabulary',
    };
  }

  Future<void> initSession({ChatMode? mode}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final modeStr = modeToString(mode ?? _ref.read(chatModeProvider));
      developer.log('🚀 Initializing new chat session (Mode: $modeStr)...', name: 'ChatFlow');
      print('\x1B[36m🚀 [ChatFlow] Create new session: $modeStr\x1B[0m');

      final session = await _repo.createSession(mode: modeStr);
      _ref.read(activeSessionProvider.notifier).state = session;

      state = state.copyWith(
        isLoading: false,
        messages: [],
        streamingContent: '',
      );
      developer.log('✅ Session created successfully: ${session.id}', name: 'ChatFlow');
    } catch (e) {
      developer.log('❌ Failed to create session: $e', name: 'ChatFlow', error: e);
      print('\x1B[31m❌ [ChatFlow] Error init session: $e\x1B[0m');
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

    developer.log('💬 Sending text message: "$content"', name: 'ChatFlow');
    print('\x1B[34m💬 [ChatFlow] User sent message: "$content"\x1B[0m');

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

    final currentMode = _ref.read(chatModeProvider);
    final mode = modeToString(currentMode);

    // Fetch learning words for vocabulary mode
    final learningWords = currentMode == ChatMode.vocabulary
        ? await _repo.getLearningWords()
        : <String>[];

    final buffer = StringBuffer();

    try {
      developer.log('🔄 Opening text stream from server...', name: 'ChatFlow');
      print('\x1B[33m🔄 [ChatFlow] Receiving streaming response...\x1B[0m');

      await for (final chunk in _repo.sendTextMessage(
        sessionId: session.id,
        message: content,
        mode: mode,
        history: history,
        learningWords: learningWords,
      )) {
        buffer.write(chunk);
        state = state.copyWith(streamingContent: buffer.toString());
      }

      developer.log('✅ Text stream complete. Length: ${buffer.length}', name: 'ChatFlow');
      print('\x1B[32m✅ [ChatFlow] Completed AI response: "${buffer.toString()}"\x1B[0m');

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
      developer.log('❌ Error during sendTextMessage: $e', name: 'ChatFlow', error: e);
      print('\x1B[31m❌ [ChatFlow] Streaming error: $e\x1B[0m');
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
    developer.log('📝 Appending voice exchange to chat history view...', name: 'ChatFlow');
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
    } catch (e) {
      developer.log('⚠️ Failed to append voice exchange: $e', name: 'ChatFlow', error: e);
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

