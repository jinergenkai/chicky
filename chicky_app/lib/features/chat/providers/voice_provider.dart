import 'dart:convert';
import 'dart:developer' as developer;
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
      developer.log('🎙️ Starting audio recording...', name: 'VoiceFlow');
      print('\x1B[36m🎙️ [VoiceFlow] SDK: Start recording audio...\x1B[0m');
      
      await _audio.startRecording();
      state = VoiceState.recording;
    } catch (e) {
      developer.log('❌ Failed to start recording: $e', name: 'VoiceFlow', error: e);
      print('\x1B[31m❌ [VoiceFlow] Failed to start recording: $e\x1B[0m');
      state = VoiceState.idle;
    }
  }

  /// Stop recording, transcribe via WebSocket, then play TTS response.
  Future<void> stopRecordingAndSend(String sessionId) async {
    if (state != VoiceState.recording) return;
    state = VoiceState.processing;

    developer.log('📤 Stopping recording and preparing to send...', name: 'VoiceFlow');
    print('\x1B[35m📤 [VoiceFlow] Stopped recording. Processing audio buffer...\x1B[0m');

    final bytes = await _audio.stopRecordingAsBytes();
    if (bytes == null) {
      developer.log('⚠️ No audio data recorded.', name: 'VoiceFlow');
      print('\x1B[33m⚠️ [VoiceFlow] Audio buffer is empty.\x1B[0m');
      state = VoiceState.idle;
      return;
    }

    try {
      developer.log('🌐 Opening WebSocket for session: $sessionId', name: 'VoiceFlow');
      print('\x1B[36m🌐 [VoiceFlow] Connecting to Voice WebSocket...\x1B[0m');
      final repo = _ref.read(chatRepositoryProvider);
      
      // Start audio queue so playback starts as soon as first chunk arrives
      await _audio.startAudioQueue();
      state = VoiceState.processing;
      
      final channel = repo.connectVoiceSocket(sessionId);

      // Send audio bytes
      developer.log('⬆️ Sending ${bytes.length} bytes of audio data...', name: 'VoiceFlow');
      print('\x1B[34m⬆️ [VoiceFlow] Uploading user audio chunk to server STT...\x1B[0m');

      channel.sink.add(bytes);

      // Parse structured JSON messages from server
      // Server sends: {"type":"transcript","content":"..."} → binary audio chunks
      //               → {"type":"done","content":"...","corrections":[...]}
      String transcript = '';
      String responseText = '';
      List<Map<String, dynamic>> corrections = [];

      bool serverError = false;
      await for (final message in channel.stream.timeout(
        const Duration(seconds: 30),
        onTimeout: (sink) {
          developer.log('⏰ Voice WebSocket timed out after 30s', name: 'VoiceFlow');
          print('\x1B[31m⏰ [VoiceFlow] Timeout waiting for server response.\x1B[0m');
          sink.close();
        },
      )) {
        if (message is String) {
          try {
            final json = jsonDecode(message) as Map<String, dynamic>;
            final type = json['type'] as String?;
            if (type == 'transcript') {
              transcript = json['content'] as String? ?? '';
              developer.log('🗣️ STT Transcript received: $transcript', name: 'VoiceFlow');
              print('\x1B[32m🗣️ [VoiceFlow] STT Recognized: "$transcript"\x1B[0m');
            } else if (type == 'done') {
              responseText = json['content'] as String? ?? '';
              developer.log('🧠 AI Response complete. Content length: ${responseText.length}', name: 'VoiceFlow');
              print('\x1B[32m🧠 [VoiceFlow] AI Generation Done: "$responseText"\x1B[0m');
              corrections = (json['corrections'] as List?)
                      ?.cast<Map<String, dynamic>>() ??
                  [];
              break;
            } else if (type == 'error') {
              final errorContent = json['content'] ?? json['message'] ?? 'Unknown error';
              developer.log('❌ Server sent error: $errorContent', name: 'VoiceFlow');
              print('\x1B[31m❌ [VoiceFlow] Server Error: $errorContent\x1B[0m');
              serverError = true;
              break;
            }
          } catch (_) {
            // Unexpected non-JSON text — skip
            developer.log('⚠️ Unknown text message from socket: $message', name: 'VoiceFlow');
          }
        } else if (message is List<int>) {
          // Changed to playing state as soon as we start receiving audio
          if (state != VoiceState.playing) {
            developer.log('🎵 First audio chunk received! Starting playback (Edge TTS)', name: 'VoiceFlow');
            print('\x1B[33m🎵 [VoiceFlow] Receiving TTS audio stream! Playing...\x1B[0m');
            state = VoiceState.playing;
          }
          await _audio.enqueueAudioChunk(Uint8List.fromList(message));
        }
      }

      if (serverError || (responseText.isEmpty && state == VoiceState.processing)) {
        await _audio.clearAudioQueue();
        state = VoiceState.idle;
        await channel.sink.close();
        return;
      }

      await channel.sink.close();

      if (responseText.isNotEmpty) {
        developer.log('💾 Saving voice exchange to database...', name: 'VoiceFlow');
        print('\x1B[36m💾 [VoiceFlow] Persisting messages to local DB.\x1B[0m');
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
    } catch (e) {
      developer.log('❌ Voice Flow Exception: $e', name: 'VoiceFlow', error: e);
      print('\x1B[31m❌ [VoiceFlow] Critical Error during processing: $e\x1B[0m');
      state = VoiceState.idle;
      await _audio.clearAudioQueue();
    }
  }

  Future<void> playSpeech(Uint8List audioBytes) async {
    if (state == VoiceState.recording) return;
    developer.log('🔊 Playing speech bytes directly...', name: 'VoiceFlow');
    print('\x1B[33m🔊 [VoiceFlow] Playing offline/provided audio bytes.\x1B[0m');
    state = VoiceState.playing;
    await _audio.playFromBytes(audioBytes);
    developer.log('✅ Finished playing speech bytes.', name: 'VoiceFlow');
    state = VoiceState.idle;
  }

  Future<void> stopPlayback() async {
    developer.log('⏹️ Stopping audio playback.', name: 'VoiceFlow');
    print('\x1B[35m⏹️ [VoiceFlow] User stopped playback manually.\x1B[0m');
    await _audio.stopPlayback();
    state = VoiceState.idle;
  }

  void cancel() {
    developer.log('🚫 Cancelling current Voice operation!', name: 'VoiceFlow');
    print('\x1B[31m🚫 [VoiceFlow] Operation CANCELLED.\x1B[0m');
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
