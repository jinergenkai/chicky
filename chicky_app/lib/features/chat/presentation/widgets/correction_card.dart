import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';

class CorrectionCard extends StatefulWidget {
  const CorrectionCard({super.key, required this.corrections});

  final List<Map<String, dynamic>> corrections;

  @override
  State<CorrectionCard> createState() => _CorrectionCardState();
}

class _CorrectionCardState extends State<CorrectionCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.corrections.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 8, bottom: 8),
      child: GestureDetector(
        onTap: () => setState(() => _expanded = !_expanded),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: ChickyColors.warning.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: ChickyColors.warning.withOpacity(0.4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    const Icon(
                      Icons.auto_fix_high,
                      size: 16,
                      color: ChickyColors.warning,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${widget.corrections.length} suggestion${widget.corrections.length > 1 ? 's' : ''}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: ChickyColors.warning,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      _expanded ? Icons.expand_less : Icons.expand_more,
                      size: 18,
                      color: ChickyColors.warning,
                    ),
                  ],
                ),
              ),
              // Corrections list
              if (_expanded)
                ...widget.corrections.map(
                  (c) => _CorrectionItem(correction: c),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CorrectionItem extends StatelessWidget {
  const _CorrectionItem({required this.correction});

  final Map<String, dynamic> correction;

  @override
  Widget build(BuildContext context) {
    final original = correction['original'] as String? ?? '';
    final corrected = correction['corrected'] as String? ?? '';
    final explanation = correction['explanation'] as String? ?? '';
    final type = correction['type'] as String? ?? 'grammar';

    return Container(
      margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Type badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: _typeColor(type).withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              type.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: _typeColor(type),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Original -> Corrected
          if (original.isNotEmpty) ...[
            Text(
              original,
              style: const TextStyle(
                fontSize: 14,
                color: ChickyColors.error,
                decoration: TextDecoration.lineThrough,
              ),
            ),
            const SizedBox(height: 4),
          ],
          if (corrected.isNotEmpty)
            Text(
              corrected,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: ChickyColors.success,
              ),
            ),
          if (explanation.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              explanation,
              style: const TextStyle(
                fontSize: 13,
                color: ChickyColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _typeColor(String type) {
    return switch (type.toLowerCase()) {
      'grammar' => ChickyColors.error,
      'vocabulary' => ChickyColors.info,
      'pronunciation' => ChickyColors.warning,
      'spelling' => ChickyColors.secondary,
      _ => ChickyColors.textSecondary,
    };
  }
}
