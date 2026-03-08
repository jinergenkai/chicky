import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picovoice_flutter/picovoice_flutter.dart';

import '../../../core/config/env.dart';

enum WakeWordState { inactive, listening, detected, error }

class WakeWordNotifier extends StateNotifier<WakeWordState> {
  WakeWordNotifier() : super(WakeWordState.inactive);

  Picovoice? _picovoice;
  void Function()? onWakeWordDetected;

  Future<void> start({
    required String porcupineKeywordPath,
    required String rhinoContextPath,
    void Function()? onDetected,
  }) async {
    if (state == WakeWordState.listening) return;

    onWakeWordDetected = onDetected;

    try {
      _picovoice = await Picovoice.create(
        accessKey: Env.picovoiceAccessKey,
        keywordPath: porcupineKeywordPath,
        wakeWordCallback: _onWakeWord,
        contextPath: rhinoContextPath,
        inferenceCallback: _onInference,
      );
      await _picovoice!.start();
      state = WakeWordState.listening;
    } catch (e) {
      state = WakeWordState.error;
    }
  }

  void _onWakeWord() {
    state = WakeWordState.detected;
    onWakeWordDetected?.call();
    // Reset back to listening after brief detection window
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) state = WakeWordState.listening;
    });
  }

  void _onInference(Map<String, dynamic> inference) {
    // Handle Rhino intent (optional natural language commands)
    // e.g. "start review", "open chat" etc.
  }

  Future<void> stop() async {
    await _picovoice?.stop();
    state = WakeWordState.inactive;
  }

  @override
  void dispose() {
    _picovoice?.delete();
    super.dispose();
  }
}

final wakeWordProvider =
    StateNotifierProvider<WakeWordNotifier, WakeWordState>(
  (_) => WakeWordNotifier(),
);
