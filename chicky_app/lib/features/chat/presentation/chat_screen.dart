import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/colors.dart';
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
      appBar: AppBar(
        title: const Text('Chat with Chicky'),
        actions: [
          IconButton(
            icon: Icon(_showTextInput ? Icons.mic : Icons.keyboard),
            onPressed: () => setState(() => _showTextInput = !_showTextInput),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: ModeSelector(
            currentMode: ref.watch(chatModeProvider),
            onModeChanged: (mode) {
              ref.read(chatModeProvider.notifier).state = mode;
              ref.read(chatProvider.notifier).initSession(mode: mode);
            },
          ),
        ),
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: chatState.isLoading && chatState.messages.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: chatState.messages.length +
                        (chatState.isStreaming ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == chatState.messages.length &&
                          chatState.isStreaming) {
                        return MessageBubble(
                          content: chatState.streamingContent,
                          isUser: false,
                          isStreaming: true,
                        );
                      }
                      final msg = chatState.messages[index];
                      return Column(
                        crossAxisAlignment: msg.isUser
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          MessageBubble(
                            content: msg.content,
                            isUser: msg.isUser,
                          ),
                          if (msg.hasCorrections)
                            CorrectionCard(corrections: msg.corrections),
                        ],
                      );
                    },
                  ),
          ),
          // Error display
          if (chatState.error != null)
            Container(
              color: ChickyColors.error.withOpacity(0.1),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: ChickyColors.error),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      chatState.error!,
                      style: const TextStyle(color: ChickyColors.error),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: ref.read(chatProvider.notifier).clearError,
                  ),
                ],
              ),
            ),
          // Input area
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(12),
            child: SafeArea(
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
            decoration: InputDecoration(
              hintText: 'Type a message...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        CircleAvatar(
          backgroundColor: ChickyColors.primary,
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: onSend,
                ),
        ),
      ],
    );
  }
}
