import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/theme/colors.dart';
import '../../../shared/widgets/chicky_widgets.dart';
import '../data/models/chat_message_model.dart';
import '../providers/chat_provider.dart';
import '../providers/voice_provider.dart';
import 'widgets/correction_card.dart';
import 'widgets/message_bubble.dart';
import 'widgets/mode_selector.dart';
import 'widgets/voice_button.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  bool _showTextInput = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatProvider.notifier).initSession();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
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
    final session = ref.watch(activeSessionProvider);

    // Auto scroll when messages update
    ref.listen(chatProvider, (_, __) => _scrollToBottom());

    return Scaffold(
      backgroundColor: ChickyColors.backgroundLight,
      appBar: chickyAppBar(
        context,
        title: 'Chicky Chat',
        onBack: () {}, // Handled by GoRouter naturally if pushed
        actions: [
          IconButton(
            icon: Icon(
              _showTextInput ? LucideIcons.mic : LucideIcons.keyboard,
              color: Colors.grey.shade700,
            ),
            onPressed: () => setState(() => _showTextInput = !_showTextInput),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Mode selector right below app bar with nice padding
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: ModeSelector(
              currentMode: ref.watch(chatModeProvider),
              onModeChanged: (mode) {
                ref.read(chatModeProvider.notifier).state = mode;
                ref.read(chatProvider.notifier).initSession(mode: mode);
              },
            ),
          ),
          
          // Messages list with subtle pattern background
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
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
                        top: 24, 
                        bottom: 120, // space for floating dock
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
          
          // Floating Input Dock directly in Column instead of FAB
          // so we can dynamically avoid the MainShell's bottom nav bar
          Builder(
            builder: (context) {
              final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
              final bottomPadding = isKeyboardOpen ? 16.0 : 100.0;
              
              return Padding(
                padding: EdgeInsets.only(
                  left: 16, 
                  right: 16, 
                  top: 12, 
                  bottom: bottomPadding,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _showTextInput
                        ? _TextInputRow(
                            controller: _textController,
                            onSend: _sendText,
                            isLoading: chatState.isStreaming,
                          )
                        : VoiceButton(
                            voiceState: voiceState,
                            sessionId: session?.id ?? '',
                          ),
                  ),
                ),
              );
            }
          ),
        ],
      ),
    );
  }
}

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
              fillColor: Colors.transparent, // Let dock handle background
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
                ChickyColors.primary,
                ChickyColors.primaryDark,
              ],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: ChickyColors.primary.withOpacity(0.3),
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
                  icon: const Icon(LucideIcons.send, color: Colors.white, size: 20),
                  onPressed: onSend,
                ),
        ),
      ],
    );
  }
}
