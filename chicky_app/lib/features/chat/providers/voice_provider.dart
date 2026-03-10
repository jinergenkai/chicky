import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../../core/services/audio_service.dart';
import 'chat_provider.dart';

enum VoiceState { idle, recording, processing, playing }

/// Words that Porcupine may leave in the STT transcript — stripped before sending to LLM.
const _wakewordPatterns = [
  'picovoice',
  'pico voice',
  'pickle voice',
  'pick a voice',
  'picklevoice',
  'Picovoice',
  'Pico voice',
  'Pickle voice',
  'Pick a voice',
  'Picklevoice',
];

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

      // Haptic feedback instead of audio (safe, no mic conflict, no ExoPlayer crash)
      HapticFeedback.mediumImpact();
    } catch (e) {
      developer.log('❌ Failed to start recording: $e',
          name: 'VoiceFlow', error: e);
      print('\x1B[31m❌ [VoiceFlow] Failed to start recording: $e\x1B[0m');
      state = VoiceState.idle;
    }
  }

  /// Stop recording, transcribe via WebSocket, then play TTS response.
  /// If [stoppedByWakeword] is true, the trailing wakeword text will be
  /// stripped from the STT transcript instead of doing risky byte-level trimming.
  Future<void> stopRecordingAndSend(String sessionId,
      {bool stoppedByWakeword = false}) async {
    if (state != VoiceState.recording) return;
    state = VoiceState.processing;

    developer.log('📤 Stopping recording and preparing to send...',
        name: 'VoiceFlow');
    print(
        '\x1B[35m📤 [VoiceFlow] Stopped recording. Processing audio buffer...\x1B[0m');

    // Stop recording FIRST, then give haptic feedback (no audio conflict)
    final bytes = await _audio.stopRecordingAsBytes();

    // Haptic feedback after mic is closed
    HapticFeedback.lightImpact();

    if (bytes == null || bytes.length <= 44) {
      developer.log('⚠️ No audio data recorded (${bytes?.length ?? 0} bytes).',
          name: 'VoiceFlow');
      print(
          '\x1B[33m⚠️ [VoiceFlow] Audio buffer is empty or too small.\x1B[0m');
      state = VoiceState.idle;
      return;
    }

    developer.log(
        '📊 Audio size: ${bytes.length} bytes (~${((bytes.length - 44) / 32000).toStringAsFixed(1)}s)',
        name: 'VoiceFlow');

    try {
      developer.log('🌐 Opening WebSocket for session: $sessionId',
          name: 'VoiceFlow');
      print('\x1B[36m🌐 [VoiceFlow] Connecting to Voice WebSocket...\x1B[0m');
      final repo = _ref.read(chatRepositoryProvider);

      // Start audio queue so playback starts as soon as first chunk arrives
      await _audio.startAudioQueue();
      state = VoiceState.processing;

      final channel = repo.connectVoiceSocket(sessionId);

      // Send audio bytes (full WAV, no trimming — we strip wakeword from text instead)
      developer.log('⬆️ Sending ${bytes.length} bytes of audio data...',
          name: 'VoiceFlow');
      print(
          '\x1B[34m⬆️ [VoiceFlow] Uploading user audio chunk to server STT...\x1B[0m');

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
          developer.log('⏰ Voice WebSocket timed out after 30s',
              name: 'VoiceFlow');
          print(
              '\x1B[31m⏰ [VoiceFlow] Timeout waiting for server response.\x1B[0m');
          sink.close();
        },
      )) {
        if (message is String) {
          try {
            final json = jsonDecode(message) as Map<String, dynamic>;
            final type = json['type'] as String?;
            if (type == 'transcript') {
              transcript = json['content'] as String? ?? '';

              // Strip trailing wakeword from transcript if stopped by wakeword
              if (stoppedByWakeword) {
                transcript = _stripWakeword(transcript);
              }

              developer.log('🗣️ STT Transcript received: $transcript',
                  name: 'VoiceFlow');
              print(
                  '\x1B[32m🗣️ [VoiceFlow] STT Recognized: "$transcript"\x1B[0m');

              // If stripping the wakeword left us with nothing, abort
              if (transcript.trim().isEmpty) {
                developer.log(
                    '⚠️ Transcript is empty after stripping wakeword. Aborting.',
                    name: 'VoiceFlow');
                print(
                    '\x1B[33m⚠️ [VoiceFlow] Empty transcript, skipping.\x1B[0m');
                serverError = true;
                break;
              }
            } else if (type == 'done') {
              responseText = json['content'] as String? ?? '';
              developer.log(
                  '🧠 AI Response complete. Content length: ${responseText.length}',
                  name: 'VoiceFlow');
              print(
                  '\x1B[32m🧠 [VoiceFlow] AI Generation Done: "$responseText"\x1B[0m');
              corrections = (json['corrections'] as List?)
                      ?.cast<Map<String, dynamic>>() ??
                  [];
              break;
            } else if (type == 'error') {
              final errorContent =
                  json['content'] ?? json['message'] ?? 'Unknown error';
              developer.log('❌ Server sent error: $errorContent',
                  name: 'VoiceFlow');
              print('\x1B[31m❌ [VoiceFlow] Server Error: $errorContent\x1B[0m');
              serverError = true;
              break;
            }
          } catch (_) {
            // Unexpected non-JSON text — skip
            developer.log('⚠️ Unknown text message from socket: $message',
                name: 'VoiceFlow');
          }
        } else if (message is List<int>) {
          // Changed to playing state as soon as we start receiving audio
          if (state != VoiceState.playing) {
            developer.log(
                '🎵 First audio chunk received! Starting playback (Edge TTS)',
                name: 'VoiceFlow');
            print(
                '\x1B[33m🎵 [VoiceFlow] Receiving TTS audio stream! Playing...\x1B[0m');
            state = VoiceState.playing;
          }
          await _audio.enqueueAudioChunk(Uint8List.fromList(message));
        }
      }

      if (serverError ||
          (responseText.isEmpty && state == VoiceState.processing)) {
        await _audio.clearAudioQueue();
        state = VoiceState.idle;
        await channel.sink.close();
        return;
      }

      await channel.sink.close();

      if (responseText.isNotEmpty) {
        developer.log('💾 Saving voice exchange to database...',
            name: 'VoiceFlow');
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
      print(
          '\x1B[31m❌ [VoiceFlow] Critical Error during processing: $e\x1B[0m');
      state = VoiceState.idle;
      await _audio.clearAudioQueue();
    }
  }

  /// Strips trailing wakeword patterns from the STT transcript.
  String _stripWakeword(String text) {
    var cleaned = text.trim();
    final lower = cleaned.toLowerCase();
    for (final pattern in _wakewordPatterns) {
      if (lower.endsWith(pattern)) {
        cleaned = cleaned.replaceAll(RegExp(r'[,.?!\s]+$'), '');
        cleaned = cleaned.substring(0, cleaned.length - pattern.length).trim();
        // Also remove trailing punctuation left behind (e.g. "Hello, picovoice" → "Hello")
        cleaned = cleaned.replaceAll(RegExp(r'[,.?!\s]+$'), '');
        developer.log(
            '🧹 Stripped wakeword "$pattern" from transcript → "$cleaned"',
            name: 'VoiceFlow');
        break;
      }
    }
    return cleaned;
  }

  /// Interrupts ongoing AI playback immediately without sending anything to server.
  Future<void> interruptPlayback() async {
    if (state == VoiceState.playing) {
      developer.log('🛑 Client-side interrupt triggered! Halting playback.',
          name: 'VoiceFlow');
      print('\x1B[33m🛑 [VoiceFlow] AI playback interrupted locally.\x1B[0m');
      await _audio.clearAudioQueue();
      await _audio.stopPlayback();
      state = VoiceState.idle;
      HapticFeedback.heavyImpact();
    }
  }

  Future<void> playSpeech(Uint8List audioBytes) async {
    if (state == VoiceState.recording) return;
    developer.log('🔊 Playing speech bytes directly...', name: 'VoiceFlow');
    print(
        '\x1B[33m🔊 [VoiceFlow] Playing offline/provided audio bytes.\x1B[0m');
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
