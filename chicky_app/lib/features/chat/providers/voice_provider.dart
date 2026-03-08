import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/audio_service.dart';
import '../data/repositories/chat_repository.dart';
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

      // Collect response
      final responseBuffer = StringBuffer();
      await for (final message in channel.stream) {
        if (message is String) {
          final data = message;
          if (data == '[DONE]') break;
          responseBuffer.write(data);
        }
      }

      await channel.sink.close();

      final responseText = responseBuffer.toString();
      if (responseText.isNotEmpty) {
        // TTS playback
        state = VoiceState.playing;
        final audio = await repo.synthesizeSpeech(responseText);
        if (audio != null) {
          await _audio.playFromBytes(audio);
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
