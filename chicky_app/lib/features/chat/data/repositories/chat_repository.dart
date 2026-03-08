import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../core/services/api_service.dart';
import '../../../../core/services/supabase_service.dart';
import '../models/chat_message_model.dart';
import '../models/chat_session_model.dart';

class ChatRepository {
  ChatRepository({
    SupabaseService? supabase,
    ApiService? api,
  })  : _db = supabase ?? SupabaseService.instance,
        _api = api ?? ApiService.instance;

  final SupabaseService _db;
  final ApiService _api;

  String get _uid => _db.currentUserId!;

  // ── Sessions ──────────────────────────────────────────────────────────────

  Future<ChatSessionModel> createSession({
    String mode = 'buddy',
    String? scenarioId,
    String? title,
  }) async {
    final data = await _db.client
        .from('chat_sessions')
        .insert({
          'user_id': _uid,
          'mode': mode,
          'scenario_id': scenarioId,
          'title': title,
        })
        .select()
        .single();
    return ChatSessionModel.fromJson(data as Map<String, dynamic>);
  }

  Future<List<ChatSessionModel>> getSessions({int limit = 20}) async {
    final data = await _db.client
        .from('chat_sessions')
        .select()
        .eq('user_id', _uid)
        .order('created_at', ascending: false)
        .limit(limit);
    return (data as List)
        .map((e) => ChatSessionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ChatSessionModel?> getSession(String sessionId) async {
    final data = await _db.client
        .from('chat_sessions')
        .select()
        .eq('id', sessionId)
        .maybeSingle();
    if (data == null) return null;
    return ChatSessionModel.fromJson(data as Map<String, dynamic>);
  }

  Future<void> updateSessionTitle(String sessionId, String title) async {
    await _db.client
        .from('chat_sessions')
        .update({'title': title, 'updated_at': DateTime.now().toIso8601String()})
        .eq('id', sessionId);
  }

  // ── Messages ──────────────────────────────────────────────────────────────

  Future<List<ChatMessageModel>> getMessages(String sessionId) async {
    final data = await _db.client
        .from('chat_messages')
        .select()
        .eq('session_id', sessionId)
        .order('created_at');
    return (data as List)
        .map((e) => ChatMessageModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ChatMessageModel> saveMessage({
    required String sessionId,
    required String role,
    required String content,
    List<Map<String, dynamic>> corrections = const [],
    String? audioUrl,
  }) async {
    final data = await _db.client
        .from('chat_messages')
        .insert({
          'session_id': sessionId,
          'role': role,
          'content': content,
          'corrections': corrections,
          'audio_url': audioUrl,
        })
        .select()
        .single();
    return ChatMessageModel.fromJson(data as Map<String, dynamic>);
  }

  // ── API: Text chat ────────────────────────────────────────────────────────

  /// Sends a text message and returns the assistant's response stream.
  Stream<String> sendTextMessage({
    required String sessionId,
    required String message,
    required String mode,
    String? scenarioId,
    List<Map<String, dynamic>> history = const [],
  }) async* {
    final response = await _api.dio.post<ResponseBody>(
      '/chat/text',
      data: {
        'session_id': sessionId,
        'message': message,
        'mode': mode,
        'scenario_id': scenarioId,
        'history': history,
      },
      options: Options(responseType: ResponseType.stream),
    );

    await for (final chunk in response.data!.stream) {
      final text = utf8.decode(chunk);
      // SSE format: "data: ...\n\n"
      for (final line in text.split('\n')) {
        if (line.startsWith('data: ')) {
          final data = line.substring(6).trim();
          if (data == '[DONE]') return;
          try {
            final json = jsonDecode(data) as Map<String, dynamic>;
            yield json['content'] as String? ?? '';
          } catch (_) {
            yield data;
          }
        }
      }
    }
  }

  // ── API: TTS ──────────────────────────────────────────────────────────────

  Future<Uint8List?> synthesizeSpeech(String text) async {
    try {
      final response = await _api.postBytes(
        '/tts',
        data: {'text': text},
      );
      return Uint8List.fromList(response.data ?? []);
    } catch (_) {
      return null;
    }
  }

  // ── Voice WebSocket ───────────────────────────────────────────────────────

  WebSocketChannel connectVoiceSocket(String sessionId) {
    final token =
        _db.auth.currentSession?.accessToken ?? '';
    final wsUrl = _api.dio.options.baseUrl
        .replaceFirst('http', 'ws')
        .replaceFirst('https', 'wss');
    return WebSocketChannel.connect(
      Uri.parse('$wsUrl/chat/voice?session_id=$sessionId&token=$token'),
    );
  }
}
