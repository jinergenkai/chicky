import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/theme/colors.dart';
import '../data/models/chat_message_model.dart';
import '../data/models/chat_session_model.dart';
import '../providers/chat_provider.dart';
import '../providers/voice_provider.dart';
import '../providers/wakeword_provider.dart';
import 'widgets/correction_card.dart';
import 'widgets/message_bubble.dart';
import 'widgets/mode_selector.dart';
import 'widgets/voice_button.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen>
    with SingleTickerProviderStateMixin {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isVoiceMode = true;

  late final AnimationController _modeAnimController;
  late final Animation<double> _modeAnim;

  @override
  void initState() {
    super.initState();
    _modeAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _modeAnim = CurvedAnimation(
      parent: _modeAnimController,
      curve: Curves.easeInOutCubic,
    );
    // Start in voice mode
    _modeAnimController.value = 1.0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatProvider.notifier).initSession();
      _startWakeWord();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _modeAnimController.dispose();
    ref.read(wakeWordProvider.notifier).stop();
    super.dispose();
  }

  void _startWakeWord() {
    ref.read(wakeWordProvider.notifier).start(
      onDetected: (keywordIndex) {
        final voice = ref.read(voiceProvider);
        final voiceNotifier = ref.read(voiceProvider.notifier);
        final session = ref.read(activeSessionProvider);

        if (keywordIndex == 0) {
          // "Porcupine" -> Start recording
          if (voice == VoiceState.idle) {
            voiceNotifier.startRecording();
          }
        } else if (keywordIndex == 1) {
          // "Picovoice" -> Interrupt or Stop early
          if (voice == VoiceState.playing) {
            voiceNotifier.interruptPlayback();
          } else if (voice == VoiceState.recording && session != null) {
            voiceNotifier.stopRecordingAndSend(session.id, stoppedByWakeword: true);
          }
        }
      },
    );
  }

  void _toggleInputMode() {
    setState(() => _isVoiceMode = !_isVoiceMode);
    if (_isVoiceMode) {
      _modeAnimController.forward();
      _startWakeWord();
    } else {
      _modeAnimController.reverse();
      ref.read(wakeWordProvider.notifier).stop();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendText() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    _textController.clear();
    await ref.read(chatProvider.notifier).sendMessage(text);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    final voiceState = ref.watch(voiceProvider);
    ref.watch(wakeWordProvider);
    final session = ref.watch(activeSessionProvider);

    ref.listen(chatProvider, (_, __) => _scrollToBottom());

    return Scaffold(
      backgroundColor: _isVoiceMode
          ? const Color(0xFF0D0F15)
          : ChickyColors.backgroundLight,
      body: AnimatedBuilder(
        animation: _modeAnim,
        builder: (context, _) {
          return _isVoiceMode
              ? _buildVoiceLayout(chatState, voiceState, session)
              : _buildTextLayout(chatState, voiceState, session);
        },
      ),
    );
  }

  // ── Text mode layout (original chat style) ─────────────────────────────

  Widget _buildTextLayout(
    ChatState chatState,
    VoiceState voiceState,
    ChatSessionModel? session,
  ) {
    return Column(
      children: [
        // Compact top bar: mode selector + voice toggle
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Row(
              children: [
                Expanded(
                  child: ModeSelector(
                    currentMode: ref.watch(chatModeProvider),
                    onModeChanged: (mode) {
                      ref.read(chatModeProvider.notifier).state = mode;
                      ref.read(chatProvider.notifier).initSession(mode: mode);
                    },
                  ),
                ),
                _InputModeToggle(
                  isVoice: false,
                  onTap: _toggleInputMode,
                ),
              ],
            ),
          ),
        ),

        // Messages
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(28)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: chatState.isLoading && chatState.messages.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 20,
                      bottom: 120,
                    ),
                    itemCount: chatState.messages.length +
                        (chatState.isStreaming ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == chatState.messages.length &&
                          chatState.isStreaming) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: MessageBubble(
                            content: chatState.streamingContent,
                            isUser: false,
                            isStreaming: true,
                          ),
                        );
                      }
                      final msg = chatState.messages[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: msg.isUser
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            MessageBubble(
                              content: msg.content,
                              isUser: msg.isUser,
                            ),
                            if (msg.hasCorrections) ...[
                              const SizedBox(height: 8),
                              CorrectionCard(corrections: msg.corrections),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ),

        // Text input dock
        Builder(builder: (context) {
          final isKeyboardOpen =
              MediaQuery.of(context).viewInsets.bottom > 0;
          final bottomPadding = isKeyboardOpen ? 16.0 : 100.0;

          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 8,
              bottom: bottomPadding,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: _TextInputRow(
                  controller: _textController,
                  onSend: _sendText,
                  isLoading: chatState.isStreaming,
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  // ── Voice mode layout (immersive karaoke style) ────────────────────────

  Widget _buildVoiceLayout(
    ChatState chatState,
    VoiceState voiceState,
    ChatSessionModel? session,
  ) {
    // Get all messages for the "lyric lines"
    final messages = chatState.messages;
    final streamingText = chatState.streamingContent;
    final isStreaming = chatState.isStreaming;

    return SafeArea(
      child: Column(
        children: [
          // ── Minimal top bar ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
            child: Row(
              children: [
                // Small mode pills
                _VoiceModePill(
                  currentMode: ref.watch(chatModeProvider),
                  onModeChanged: (mode) {
                    ref.read(chatModeProvider.notifier).state = mode;
                    ref.read(chatProvider.notifier).initSession(mode: mode);
                  },
                ),
                const Spacer(),
                _InputModeToggle(
                  isVoice: true,
                  onTap: _toggleInputMode,
                ),
              ],
            ),
          ),

          // ── Lyric area (big text, center-aligned, scrollable) ───
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _VoiceLyricsView(
                messages: messages,
                streamingText: streamingText,
                isStreaming: isStreaming,
                voiceState: voiceState,
              ),
            ),
          ),

          // ── Voice control area ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(bottom: 40, top: 20),
            child: VoiceButton(
              voiceState: voiceState,
              sessionId: session?.id ?? '',
            ),
          ),
        ],
      ),
    );
  }
}

// ── Voice lyrics view ─────────────────────────────────────────────────────

class _VoiceLyricsView extends StatefulWidget {
  const _VoiceLyricsView({
    required this.messages,
    required this.streamingText,
    required this.isStreaming,
    required this.voiceState,
  });

  final List<ChatMessageModel> messages;
  final String streamingText;
  final bool isStreaming;
  final VoiceState voiceState;

  @override
  State<_VoiceLyricsView> createState() => _VoiceLyricsViewState();
}

class _VoiceLyricsViewState extends State<_VoiceLyricsView> {
  final _scrollController = ScrollController();

  @override
  void didUpdateWidget(covariant _VoiceLyricsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Auto-scroll to bottom when messages or streaming text updates
    if (widget.messages.length != oldWidget.messages.length ||
        widget.streamingText != oldWidget.streamingText) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayLines = <_LyricLine>[];

    // Show all messages to allow scrolling history
    for (final msg in widget.messages) {
      displayLines.add(_LyricLine(
        text: msg.content,
        isUser: msg.isUser,
        isCurrent: false,
      ));
    }

    // Add streaming content as the current "active" line
    if (widget.isStreaming && widget.streamingText.isNotEmpty) {
      displayLines.add(_LyricLine(
        text: widget.streamingText,
        isUser: false,
        isCurrent: true,
      ));
    }

    if (displayLines.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.voiceState == VoiceState.recording
                  ? Icons.graphic_eq_rounded
                  : Icons.mic_none_rounded,
              size: 48,
              color: Colors.white.withValues(alpha: 0.2),
            ),
            const SizedBox(height: 16),
            Text(
              widget.voiceState == VoiceState.recording
                  ? 'Listening...'
                  : widget.voiceState == VoiceState.processing
                      ? 'Thinking...'
                      : 'Say something',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.4),
                fontSize: 18,
                fontWeight: FontWeight.w300,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 40),
      itemCount: displayLines.length,
      itemBuilder: (context, index) {
        final line = displayLines[index];
        final isLast = index == displayLines.length - 1;
        
        // Boost visibility of the active line and recent messages
        // Since it's a list, the newest items are at the bottom.
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: _buildLyricLine(context, line, isLast),
        );
      },
    );
  }

  Widget _buildLyricLine(BuildContext context, _LyricLine line, bool isLast) {
    // The very last item gets full opacity. Older items are slightly faded.
    final alpha = isLast ? 1.0 : (line.isUser ? 0.7 : 0.85);
    final fontSize = isLast ? 22.0 : 18.0;

    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 300),
      style: TextStyle(
        color: line.isUser
            ? Theme.of(context).colorScheme.primary.withValues(alpha: alpha)
            : Colors.white.withValues(alpha: alpha),
        fontSize: fontSize,
        fontWeight: isLast ? FontWeight.w600 : FontWeight.w400,
        height: 1.5,
        letterSpacing: isLast ? 0.3 : 0,
      ),
      textAlign: TextAlign.center,
      child: Text(
        line.text,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _LyricLine {
  const _LyricLine({
    required this.text,
    required this.isUser,
    required this.isCurrent,
  });
  final String text;
  final bool isUser;
  final bool isCurrent;
}

// ── Input mode toggle button ──────────────────────────────────────────────

class _InputModeToggle extends StatelessWidget {
  const _InputModeToggle({
    required this.isVoice,
    required this.onTap,
  });

  final bool isVoice;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isVoice
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.grey.shade100,
          shape: BoxShape.circle,
        ),
        child: Icon(
          isVoice ? LucideIcons.keyboard : LucideIcons.mic,
          size: 20,
          color: isVoice ? Colors.white70 : Colors.grey.shade600,
        ),
      ),
    );
  }
}

// ── Voice mode pill (minimal mode selector for dark bg) ───────────────────

class _VoiceModePill extends StatelessWidget {
  const _VoiceModePill({
    required this.currentMode,
    required this.onModeChanged,
  });

  final ChatMode currentMode;
  final ValueChanged<ChatMode> onModeChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _pill('Buddy', ChatMode.buddy),
          _pill('Vocab', ChatMode.vocabulary),
          _pill('Role', ChatMode.roleplay),
        ],
      ),
    );
  }

  Widget _pill(String label, ChatMode mode) {
    final selected = currentMode == mode;
    return GestureDetector(
      onTap: () => onModeChanged(mode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? Colors.white.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected
                ? Colors.white
                : Colors.white.withValues(alpha: 0.4),
          ),
        ),
      ),
    );
  }
}

// ── Text input row ────────────────────────────────────────────────────────

class _TextInputRow extends StatelessWidget {
  const _TextInputRow({
    required this.controller,
    required this.onSend,
    required this.isLoading,
  });

  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            maxLines: 4,
            minLines: 1,
            textInputAction: TextInputAction.newline,
            style: const TextStyle(fontSize: 15),
            decoration: InputDecoration(
              hintText: 'Message Chicky...',
              hintStyle: TextStyle(color: Colors.grey.shade400),
              filled: true,
              fillColor: Colors.transparent,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.primary,
              ],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: isLoading
              ? const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                )
              : IconButton(
                  icon: const Icon(LucideIcons.send,
                      color: Colors.white, size: 20),
                  onPressed: onSend,
                ),
        ),
      ],
    );
  }
}
