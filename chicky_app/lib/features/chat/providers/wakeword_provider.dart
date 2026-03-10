import 'dart:developer' as developer;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:porcupine_flutter/porcupine.dart';
import 'package:porcupine_flutter/porcupine_error.dart';
import 'package:porcupine_flutter/porcupine_manager.dart';

import '../../../core/config/env.dart';

enum WakeWordState { inactive, listening, detected, error }

class WakeWordNotifier extends StateNotifier<WakeWordState> {
  WakeWordNotifier() : super(WakeWordState.inactive) {
    _initTingSound();
  }

  PorcupineManager? _porcupineManager;
  void Function(int)? onWakeWordDetected;
  final AudioPlayer _tingPlayer = AudioPlayer();

  Future<void> _initTingSound() async {
    try {
      final bytes = await rootBundle.load('assets/audio/ting.mp3');
      final uri = Uri.dataFromBytes(
        bytes.buffer.asUint8List(),
        mimeType: 'audio/mpeg',
      );
      await _tingPlayer.setAudioSource(AudioSource.uri(uri));
    } catch (e) {
      print('⚠️ Could not load ting sound: $e');
    }
  }

  Future<void> start({void Function(int)? onDetected}) async {
    if (state == WakeWordState.listening) return;

    developer.log('🎧 Starting Wakeword listener (Porcupine / Picovoice)...',
        name: 'WakeWord');
    print('\x1B[36m🎧 [WakeWord] Starting listener...\x1B[0m');

    onWakeWordDetected = onDetected;

    try {
      _porcupineManager = await PorcupineManager.fromBuiltInKeywords(
        Env.picovoiceAccessKey,
        [BuiltInKeyword.HEY_SIRI, BuiltInKeyword.PICOVOICE],
        _onWakeWord,
        errorCallback: _onError,
      );
      await _porcupineManager!.start();
      state = WakeWordState.listening;
      developer.log('✅ Wakeword listener started successfully',
          name: 'WakeWord');
      print('\x1B[32m✅ [WakeWord] Listener started successfully!\x1B[0m');
    } on PorcupineException catch (e) {
      state = WakeWordState.error;
      developer.log('❌ Failed to start Wakeword: $e',
          name: 'WakeWord', error: e);
      print('\x1B[31m❌ [WakeWord] Failed to start: $e\x1B[0m');
    }
  }

  void _onWakeWord(int keywordIndex) {
    final word = keywordIndex == 0 ? 'Hey Siri' : 'Picovoice';
    developer.log('🐥🐥🐥 WAKEWORD DETECTED! [$word] 🐥🐥🐥', name: 'WakeWord');
    print('\x1B[33m🌟🌟🌟 [WakeWord] WAKEWORD DETECTED! [$word] 🌟🌟🌟\x1B[0m');

    // Play ting sound as instant audio feedback
    _tingPlayer.seek(Duration.zero);
    _tingPlayer.play();

    state = WakeWordState.detected;
    onWakeWordDetected?.call(keywordIndex);
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        developer.log('🎧 Resuming listening...', name: 'WakeWord');
        print('\x1B[36m🎧 [WakeWord] Resuming listening...\x1B[0m');
        state = WakeWordState.listening;
      }
    });
  }

  void _onError(PorcupineException error) {
    state = WakeWordState.error;
    developer.log('⚠️ Wakeword Error: $error', name: 'WakeWord', error: error);
    print('\x1B[31m⚠️ [WakeWord] Error: $error\x1B[0m');
  }

  Future<void> stop() async {
    developer.log('🛑 Stopping Wakeword listener...', name: 'WakeWord');
    print('\x1B[35m🛑 [WakeWord] Stopping listener...\x1B[0m');
    await _porcupineManager?.stop();
    state = WakeWordState.inactive;
  }

  @override
  void dispose() {
    _porcupineManager?.delete();
    _tingPlayer.dispose();
    super.dispose();
  }
}

final wakeWordProvider = StateNotifierProvider<WakeWordNotifier, WakeWordState>(
  (_) => WakeWordNotifier(),
);
