import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../providers/chat_provider.dart';

class ModeSelector extends StatelessWidget {
  const ModeSelector({
    super.key,
    required this.currentMode,
    required this.onModeChanged,
  });

  final ChatMode currentMode;
  final ValueChanged<ChatMode> onModeChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ModeChip(
            label: 'Buddy',
            isSelected: currentMode == ChatMode.buddy,
            onTap: () => onModeChanged(ChatMode.buddy),
          ),
          _ModeChip(
            label: 'Vocab',
            isSelected: currentMode == ChatMode.vocabulary,
            onTap: () => onModeChanged(ChatMode.vocabulary),
          ),
          _ModeChip(
            label: 'Roleplay',
            isSelected: currentMode == ChatMode.roleplay,
            onTap: () => onModeChanged(ChatMode.roleplay),
          ),
        ],
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected
                ? ChickyColors.textPrimary
                : ChickyColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
