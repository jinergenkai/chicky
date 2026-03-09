import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/colors.dart';
import '../../providers/voice_provider.dart';

class VoiceButton extends ConsumerWidget {
  const VoiceButton({
    super.key,
    required this.voiceState,
    required this.sessionId,
  });

  final VoiceState voiceState;
  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(voiceProvider.notifier);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _statusText,
          style: TextStyle(
            color: ChickyColors.textSecondary,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            switch (voiceState) {
              case VoiceState.idle:
                // Tap to start recording
                notifier.startRecording();
              case VoiceState.recording:
                // Tap again to stop and send
                notifier.stopRecordingAndSend(sessionId);
              case VoiceState.playing:
                notifier.stopPlayback();
              case VoiceState.processing:
                break; // ignore taps while processing
            }
          },
          onLongPressStart: (_) {
            if (voiceState == VoiceState.idle) {
              notifier.startRecording();
            }
          },
          onLongPressEnd: (_) {
            if (voiceState == VoiceState.recording) {
              notifier.stopRecordingAndSend(sessionId);
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: voiceState == VoiceState.recording ? 80 : 64,
            height: voiceState == VoiceState.recording ? 80 : 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _buttonColor,
              boxShadow: [
                BoxShadow(
                  color: _buttonColor.withValues(alpha: 0.4),
                  blurRadius: voiceState == VoiceState.recording ? 20 : 8,
                  spreadRadius: voiceState == VoiceState.recording ? 4 : 0,
                ),
              ],
            ),
            child: Icon(
              _buttonIcon,
              color: Colors.white,
              size: voiceState == VoiceState.recording ? 36 : 28,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _hintText,
          style: const TextStyle(
            fontSize: 12,
            color: ChickyColors.textHint,
          ),
        ),
      ],
    );
  }

  String get _statusText {
    return switch (voiceState) {
      VoiceState.idle => 'Voice Mode',
      VoiceState.recording => 'Recording...',
      VoiceState.processing => 'Processing...',
      VoiceState.playing => 'Playing response',
    };
  }

  String get _hintText {
    return switch (voiceState) {
      VoiceState.idle => 'Tap or hold to speak',
      VoiceState.recording => 'Tap to send',
      VoiceState.processing => 'Please wait...',
      VoiceState.playing => 'Tap to stop',
    };
  }

  Color get _buttonColor {
    return switch (voiceState) {
      VoiceState.idle => ChickyColors.primary,
      VoiceState.recording => ChickyColors.error,
      VoiceState.processing => ChickyColors.warning,
      VoiceState.playing => ChickyColors.success,
    };
  }

  IconData get _buttonIcon {
    return switch (voiceState) {
      VoiceState.idle => Icons.mic,
      VoiceState.recording => Icons.stop,
      VoiceState.processing => Icons.hourglass_top,
      VoiceState.playing => Icons.volume_up,
    };
  }
}
