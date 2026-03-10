import 'dart:developer' as developer;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porcupine_flutter/porcupine_error.dart';
import 'package:porcupine_flutter/porcupine_manager.dart';

import '../../../core/config/env.dart';

enum WakeWordState { inactive, listening, detected, error }

class WakeWordNotifier extends StateNotifier<WakeWordState> {
  WakeWordNotifier() : super(WakeWordState.inactive);

  PorcupineManager? _porcupineManager;
  void Function()? onWakeWordDetected;

  Future<void> start({void Function()? onDetected}) async {
    if (state == WakeWordState.listening) return;

    developer.log('🎧 Starting Wakeword listener...', name: 'WakeWord');
    print('\x1B[36m🎧 [WakeWord] Starting listener...\x1B[0m');

    onWakeWordDetected = onDetected;

    try {
      final keywordPath = "assets/model/wakeword/hey-chicky_en_android_v4_0_0.ppn";

      _porcupineManager = await PorcupineManager.fromKeywordPaths(
        Env.picovoiceAccessKey,
        [keywordPath],
        _onWakeWord,
        errorCallback: _onError,
      );
      await _porcupineManager!.start();
      state = WakeWordState.listening;
      developer.log('✅ Wakeword listener started successfully', name: 'WakeWord');
      print('\x1B[32m✅ [WakeWord] Listener started successfully!\x1B[0m');
    } on PorcupineException catch (e) {
      state = WakeWordState.error;
      developer.log('❌ Failed to start Wakeword: $e', name: 'WakeWord', error: e);
      print('\x1B[31m❌ [WakeWord] Failed to start: $e\x1B[0m');
    }
  }

  void _onWakeWord(int keywordIndex) {
    developer.log('🐥🐥🐥 WAKEWORD DETECTED! [hey chicky] 🐥🐥🐥', name: 'WakeWord');
    print('\x1B[33m🌟🌟🌟 [WakeWord] WAKEWORD DETECTED! 🌟🌟🌟\x1B[0m');
    
    state = WakeWordState.detected;
    onWakeWordDetected?.call();
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
    super.dispose();
  }
}

final wakeWordProvider =
    StateNotifierProvider<WakeWordNotifier, WakeWordState>(
  (_) => WakeWordNotifier(),
);
