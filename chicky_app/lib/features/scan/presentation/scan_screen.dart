import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/colors.dart';
import '../../vocmap/presentation/widgets/word_detail_sheet.dart';
import '../providers/scan_provider.dart';
import 'camera_capture_screen.dart';
import 'scan_result_screen.dart';
import 'widgets/highlighted_text.dart';
import 'widgets/text_input_area.dart';

/// Entry point for the Scan tab — toggle between paste-text and camera scan.
class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  int _tabIndex = 0; // 0 = paste, 1 = camera

  Future<void> _openCamera() async {
    final picked = await Navigator.of(context, rootNavigator: true).push<PickedImageData>(
      MaterialPageRoute(builder: (_) => const CameraCaptureScreen()),
    );

    if (picked != null && mounted) {
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (_) => ScanResultScreen(
            imageBytes: picked.bytes,
            imagePath: picked.path,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tab toggle
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                _TabButton(
                  label: 'Paste Text',
                  icon: Icons.text_fields,
                  selected: _tabIndex == 0,
                  onTap: () => setState(() => _tabIndex = 0),
                ),
                _TabButton(
                  label: 'Camera Scan',
                  icon: Icons.camera_alt_outlined,
                  selected: _tabIndex == 1,
                  onTap: () => setState(() => _tabIndex = 1),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Tab content
        Expanded(
          child: _tabIndex == 0
              ? const _PasteTextTab()
              : _CameraScanTab(onOpenCamera: _openCamera),
        ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: selected ? ChickyColors.textPrimary : Colors.grey,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: selected ? ChickyColors.textPrimary : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Paste Text Tab (original scan) ──────────────────────────────────────

class _PasteTextTab extends ConsumerWidget {
  const _PasteTextTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(scanProvider);
    final notifier = ref.read(scanProvider.notifier);

    return Column(
      children: [
        if (state.result == null)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextInputArea(
                    onChanged: notifier.updateText,
                    initialText: state.text,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: state.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.search),
                      label: const Text('Scan'),
                      onPressed: state.isLoading ? null : notifier.scan,
                    ),
                  ),
                ],
              ),
            ),
          )
        else ...[
          // Legend
          _Legend(),
          // Highlighted text
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: HighlightedText(
                text: state.result!.originalText,
                tokens: state.result!.tokens,
                statuses: state.result!.wordStatuses,
                onWordTap: (lemma) async {
                  await notifier.selectWord(lemma);
                  final word = ref.read(scanProvider).selectedWord;
                  if (word != null && context.mounted) {
                    await WordDetailSheet.show(context, word);
                  }
                },
              ),
            ),
          ),
          // Unknown words summary
          if (state.result!.unknownWords.isNotEmpty)
            _UnknownWordsSummary(
              count: state.result!.unknownWords.length,
              onAddAll: () async {
                final repo = ref.read(scanRepositoryProvider);
                for (final w in state.result!.unknownWords) {
                  await repo.addToVault(w.id);
                }
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          '${state.result!.unknownWords.length} words added to vault'),
                      backgroundColor: ChickyColors.success,
                    ),
                  );
                }
              },
            ),
          // Clear button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: notifier.clear,
                child: const Text('Clear'),
              ),
            ),
          ),
        ],
        if (state.error != null)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              state.error!,
              style: const TextStyle(color: ChickyColors.error),
            ),
          ),
      ],
    );
  }
}

// ── Camera Scan Tab ─────────────────────────────────────────────────────

class _CameraScanTab extends StatelessWidget {
  const _CameraScanTab({required this.onOpenCamera});

  final VoidCallback onOpenCamera;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.camera_alt_outlined,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Scan text from an image',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Take a photo or pick from gallery to identify\nknown and unknown words.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: const Icon(Icons.camera_alt, size: 20),
                label: const Text(
                  'Open Camera',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                onPressed: onOpenCamera,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared Widgets ──────────────────────────────────────────────────────

class _Legend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _LegendItem(color: ChickyColors.vocabKnown, label: 'Known'),
          const SizedBox(width: 12),
          _LegendItem(color: ChickyColors.vocabLearning, label: 'Learning'),
          const SizedBox(width: 12),
          _LegendItem(color: ChickyColors.vocabUnknown, label: 'Unknown'),
          const SizedBox(width: 12),
          _LegendItem(color: ChickyColors.vocabNew, label: 'Unseen'),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class _UnknownWordsSummary extends StatelessWidget {
  const _UnknownWordsSummary({
    required this.count,
    required this.onAddAll,
  });
  final int count;
  final VoidCallback onAddAll;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$count unknown word${count > 1 ? 's' : ''} found',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          TextButton(
            onPressed: onAddAll,
            child: const Text('Add all to vault'),
          ),
        ],
      ),
    );
  }
}
