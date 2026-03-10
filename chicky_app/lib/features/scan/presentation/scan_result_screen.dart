import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/colors.dart';
import '../../vocmap/presentation/widgets/word_detail_sheet.dart';
import '../data/models/word_overlay.dart';
import '../providers/camera_scan_provider.dart';
import 'scan_summary_screen.dart';
import 'widgets/image_overlay_painter.dart';

/// Displays the captured image with colored word overlays.
/// User can tap overlays to see word details and add to vault.
class ScanResultScreen extends ConsumerStatefulWidget {
  const ScanResultScreen({
    super.key,
    required this.imageBytes,
    this.imagePath,
  });

  final Uint8List imageBytes;
  final String? imagePath; // available on mobile, null on web

  @override
  ConsumerState<ScanResultScreen> createState() => _ScanResultScreenState();
}

class _ScanResultScreenState extends ConsumerState<ScanResultScreen> {
  final _imageKey = GlobalKey();
  Size _displaySize = Size.zero;
  bool _showKnown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cameraScanProvider.notifier).scanImage(
            imageBytes: widget.imageBytes,
            imagePath: widget.imagePath,
          );
    });
  }

  void _onImageLayout() {
    final renderBox =
        _imageKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null && renderBox.hasSize) {
      final size = renderBox.size;
      if (size != _displaySize) {
        setState(() => _displaySize = size);
      }
    }
  }

  void _onTapUp(TapUpDetails details, CameraScanResult result) {
    final tap = details.localPosition;
    final scaleX = _displaySize.width / result.imageWidth;
    final scaleY = _displaySize.height / result.imageHeight;

    for (final overlay in result.overlays) {
      if (overlay.status == WordStatus.ignore) continue;
      if (overlay.status == WordStatus.known && !_showKnown) continue;

      final rect = Rect.fromLTWH(
        overlay.boundingBox.left * scaleX,
        overlay.boundingBox.top * scaleY,
        overlay.boundingBox.width * scaleX,
        overlay.boundingBox.height * scaleY,
      );

      if (rect.contains(tap)) {
        _showWordDetail(overlay);
        break;
      }
    }
  }

  Future<void> _showWordDetail(WordOverlay overlay) async {
    final notifier = ref.read(cameraScanProvider.notifier);
    final word = await notifier.lookupWord(overlay.lemma);
    if (word != null && mounted) {
      await WordDetailSheet.show(context, word);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cameraScanProvider);

    return Scaffold(
      backgroundColor: ChickyColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Scan Result'),
        backgroundColor: Colors.white,
        foregroundColor: ChickyColors.textPrimary,
        elevation: 0,
      ),
      body: state.isLoading
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Scanning text...'),
                ],
              ),
            )
          : state.error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 48, color: ChickyColors.error),
                        const SizedBox(height: 16),
                        Text(
                          state.error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 24),
                        OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Try again'),
                        ),
                      ],
                    ),
                  ),
                )
              : state.result != null
                  ? _buildResult(state.result!)
                  : const SizedBox.shrink(),
    );
  }

  Widget _buildResult(CameraScanResult result) {
    return Column(
      children: [
        // Stats bar
        _StatsBar(
          known: result.knownCount,
          learning: result.learningCount,
          unknown: result.unknownCount,
          total: result.totalWords,
        ),

        // Image with overlays
        Expanded(
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            child: LayoutBuilder(
              builder: (context, constraints) {
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => _onImageLayout());

                return GestureDetector(
                  onTapUp: (details) => _onTapUp(details, result),
                  child: Stack(
                    children: [
                      Image.memory(
                        result.imageBytes,
                        key: _imageKey,
                        fit: BoxFit.contain,
                        width: constraints.maxWidth,
                      ),
                      if (_displaySize != Size.zero)
                        Positioned.fill(
                          child: CustomPaint(
                            painter: ImageOverlayPainter(
                              overlays: result.overlays,
                              imageSize: Size(
                                result.imageWidth,
                                result.imageHeight,
                              ),
                              displaySize: _displaySize,
                              showKnown: _showKnown,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),

        // Action bar
        SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Toggle known visibility
                FilterChip(
                  label: Text(_showKnown ? 'Hide known' : 'Show all'),
                  selected: _showKnown,
                  onSelected: (v) => setState(() => _showKnown = v),
                  avatar: Icon(
                    _showKnown ? Icons.visibility : Icons.visibility_off,
                    size: 18,
                  ),
                ),
                const Spacer(),
                FilledButton.icon(
                  icon: const Icon(Icons.check_circle_outline, size: 20),
                  label: const Text('Done'),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ScanSummaryScreen(result: result),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StatsBar extends StatelessWidget {
  const _StatsBar({
    required this.known,
    required this.learning,
    required this.unknown,
    required this.total,
  });

  final int known;
  final int learning;
  final int unknown;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.white,
      child: Row(
        children: [
          _StatChip(ChickyColors.vocabUnknown, '$unknown new'),
          const SizedBox(width: 12),
          _StatChip(ChickyColors.vocabLearning, '$learning learning'),
          const SizedBox(width: 12),
          _StatChip(ChickyColors.vocabKnown, '$known known'),
          const Spacer(),
          Text(
            '$total words',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip(this.color, this.label);
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
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
