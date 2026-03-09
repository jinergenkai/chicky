import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/audio_service.dart';
import 'chat_provider.dart';

enum VoiceState { idle, recording, processing, playing }

class VoiceNotifier extends StateNotifier<VoiceState> {
  VoiceNotifier(this._ref) : super(VoiceState.idle);

  final Ref _ref;
  final AudioService _audio = AudioService.instance;

  /// Start recording when user holds the mic button.
  Future<void> startRecording() async {
    if (state != VoiceState.idle) return;
    try {
      await _audio.startRecording();
      state = VoiceState.recording;
    } catch (e) {
      state = VoiceState.idle;
    }
  }

  /// Stop recording, transcribe via WebSocket, then play TTS response.
  Future<void> stopRecordingAndSend(String sessionId) async {
    if (state != VoiceState.recording) return;
    state = VoiceState.processing;

    final bytes = await _audio.stopRecordingAsBytes();
    if (bytes == null) {
      state = VoiceState.idle;
      return;
    }

    try {
      final repo = _ref.read(chatRepositoryProvider);
      final channel = repo.connectVoiceSocket(sessionId);

      // Send audio bytes
      channel.sink.add(bytes);

      // Parse structured JSON messages from server
      // Server sends: {"type":"transcript","content":"..."} → binary audio chunks
      //               → {"type":"done","content":"...","corrections":[...]}
      String transcript = '';
      String responseText = '';
      List<Map<String, dynamic>> corrections = [];

      await for (final message in channel.stream) {
        if (message is String) {
          try {
            final json = jsonDecode(message) as Map<String, dynamic>;
            final type = json['type'] as String?;
            if (type == 'transcript') {
              transcript = json['content'] as String? ?? '';
            } else if (type == 'done') {
              responseText = json['content'] as String? ?? '';
              corrections = (json['corrections'] as List?)
                      ?.cast<Map<String, dynamic>>() ??
                  [];
              break;
            }
            // type == 'error': ignore, loop ends naturally
          } catch (_) {
            // Unexpected non-JSON text — skip
          }
        }
        // Binary audio chunks from server are ignored here;
        // we fetch TTS audio via HTTP below for simplicity.
      }

      await channel.sink.close();

      if (responseText.isNotEmpty) {
        // TTS playback via HTTP (simpler than streaming binary from WS)
        state = VoiceState.playing;
        final audio = await repo.synthesizeSpeech(responseText);
        if (audio != null) {
          await _audio.playFromBytes(audio);
        }

        // Persist exchange to DB + update chat UI
        if (transcript.isNotEmpty) {
          await _ref.read(chatProvider.notifier).appendVoiceExchange(
                sessionId: sessionId,
                userTranscript: transcript,
                assistantResponse: responseText,
                corrections: corrections,
              );
        }
      }

      state = VoiceState.idle;
    } catch (_) {
      state = VoiceState.idle;
    }
  }

  Future<void> playSpeech(Uint8List audioBytes) async {
    if (state == VoiceState.recording) return;
    state = VoiceState.playing;
    await _audio.playFromBytes(audioBytes);
    state = VoiceState.idle;
  }

  Future<void> stopPlayback() async {
    await _audio.stopPlayback();
    state = VoiceState.idle;
  }

  void cancel() {
    if (state == VoiceState.recording) {
      _audio.stopRecording();
    }
    state = VoiceState.idle;
  }
}

final voiceProvider = StateNotifierProvider<VoiceNotifier, VoiceState>(
  (ref) => VoiceNotifier(ref),
);
