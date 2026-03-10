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
        // Hint text
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Text(
            _hintText,
            key: ValueKey(voiceState),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Colors.white.withValues(alpha: 0.4),
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Main button with animated ring
        GestureDetector(
          onTap: () {
            switch (voiceState) {
              case VoiceState.idle:
                notifier.startRecording();
              case VoiceState.recording:
                notifier.stopRecordingAndSend(sessionId);
              case VoiceState.playing:
                notifier.stopPlayback();
              case VoiceState.processing:
                break;
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
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            width: _buttonSize,
            height: _buttonSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _buttonColor,
              border: Border.all(
                color: _ringColor,
                width: voiceState == VoiceState.recording ? 4 : 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: _buttonColor.withValues(alpha: 0.4),
                  blurRadius: voiceState == VoiceState.recording ? 32 : 12,
                  spreadRadius: voiceState == VoiceState.recording ? 8 : 0,
                ),
                if (voiceState == VoiceState.recording)
                  BoxShadow(
                    color: ChickyColors.error.withValues(alpha: 0.15),
                    blurRadius: 60,
                    spreadRadius: 20,
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
      ],
    );
  }

  double get _buttonSize {
    return switch (voiceState) {
      VoiceState.idle => 72,
      VoiceState.recording => 88,
      VoiceState.processing => 72,
      VoiceState.playing => 72,
    };
  }

  String get _hintText {
    return switch (voiceState) {
      VoiceState.idle => 'TAP TO SPEAK',
      VoiceState.recording => 'TAP TO SEND',
      VoiceState.processing => 'THINKING...',
      VoiceState.playing => 'TAP TO STOP',
    };
  }

  Color get _buttonColor {
    return switch (voiceState) {
      VoiceState.idle => const Color(0xFF1A1D28),
      VoiceState.recording => const Color(0xFF2A1215),
      VoiceState.processing => const Color(0xFF1A1D28),
      VoiceState.playing => const Color(0xFF122A18),
    };
  }

  Color get _ringColor {
    return switch (voiceState) {
      VoiceState.idle => Colors.white.withValues(alpha: 0.15),
      VoiceState.recording => ChickyColors.error.withValues(alpha: 0.8),
      VoiceState.processing => ChickyColors.warning.withValues(alpha: 0.4),
      VoiceState.playing => ChickyColors.success.withValues(alpha: 0.6),
    };
  }

  IconData get _buttonIcon {
    return switch (voiceState) {
      VoiceState.idle => Icons.mic_rounded,
      VoiceState.recording => Icons.stop_rounded,
      VoiceState.processing => Icons.hourglass_top_rounded,
      VoiceState.playing => Icons.volume_up_rounded,
    };
  }
}
