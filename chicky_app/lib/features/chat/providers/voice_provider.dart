import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../../core/services/audio_service.dart';
import 'chat_provider.dart';

enum VoiceState { idle, recording, processing, playing }

class VoiceNotifier extends StateNotifier<VoiceState> {
  VoiceNotifier(this._ref) : super(VoiceState.idle) {
    _listenToPlayerState();
  }

  final Ref _ref;
  final AudioService _audio = AudioService.instance;

  void _listenToPlayerState() {
    _audio.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        if (state == VoiceState.playing) {
          state = VoiceState.idle;
          _audio.clearAudioQueue();
        }
      }
    });
  }

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
      
      // Start audio queue so playback starts as soon as first chunk arrives
      await _audio.startAudioQueue();
      state = VoiceState.processing;
      
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
        } else if (message is List<int>) {
          // Changed to playing state as soon as we start receiving audio
          if (state != VoiceState.playing) {
            state = VoiceState.playing;
          }
          await _audio.enqueueAudioChunk(Uint8List.fromList(message));
        }
      }

      await channel.sink.close();

      if (responseText.isNotEmpty) {
        // Audio playback is already handled via stream enqueue.
        // Once the queue empties naturally, the state returns to idle.
        
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

      // We don't set state to idle here because audio might still be playing
      // The playing state will eventually be handled by listening to playback completion,
      // but for simplicity we keep it playing until UI action or next mic invocation.
    } catch (_) {
      state = VoiceState.idle;
      await _audio.clearAudioQueue();
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
    _audio.clearAudioQueue();
    state = VoiceState.idle;
  }
}

final voiceProvider = StateNotifierProvider<VoiceNotifier, VoiceState>(
  (ref) => VoiceNotifier(ref),
);
