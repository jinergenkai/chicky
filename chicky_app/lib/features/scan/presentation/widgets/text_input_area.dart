import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextInputArea extends StatefulWidget {
  const TextInputArea({
    super.key,
    required this.onChanged,
    this.initialText = '',
    this.maxLines = 10,
  });

  final ValueChanged<String> onChanged;
  final String initialText;
  final int maxLines;

  @override
  State<TextInputArea> createState() => _TextInputAreaState();
}

class _TextInputAreaState extends State<TextInputArea> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
    _controller.addListener(() => widget.onChanged(_controller.text));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _paste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text != null) {
      _controller.text = data!.text!;
      _controller.selection = TextSelection.collapsed(
        offset: _controller.text.length,
      );
    }
  }

  void _clear() {
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                hintText:
                    'Paste or type English text here...\n\nChicky will analyze each word and show your vocabulary level.',
                hintStyle: const TextStyle(color: Color(0xFFAAAAAA)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                alignLabelWithHint: true,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.content_paste, size: 18),
                label: const Text('Paste'),
                onPressed: _paste,
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                icon: const Icon(Icons.clear, size: 18),
                label: const Text('Clear'),
                onPressed: _clear,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
