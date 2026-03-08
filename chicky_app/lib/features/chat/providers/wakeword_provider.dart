import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:porcupine_flutter/porcupine.dart';
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

    onWakeWordDetected = onDetected;

    try {
      _porcupineManager = await PorcupineManager.fromBuiltInKeywords(
        Env.picovoiceAccessKey,
        [BuiltInKeyword.HEY_GOOGLE], // placeholder — replace with custom "Hey Chicky" model
        _onWakeWord,
        errorCallback: _onError,
      );
      await _porcupineManager!.start();
      state = WakeWordState.listening;
    } on PorcupineException catch (_) {
      state = WakeWordState.error;
    }
  }

  void _onWakeWord(int keywordIndex) {
    state = WakeWordState.detected;
    onWakeWordDetected?.call();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) state = WakeWordState.listening;
    });
  }

  void _onError(PorcupineException error) {
    state = WakeWordState.error;
  }

  Future<void> stop() async {
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
