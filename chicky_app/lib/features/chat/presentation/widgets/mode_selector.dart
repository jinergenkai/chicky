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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          _ModeChip(
            label: '🐣 Buddy',
            isSelected: currentMode == ChatMode.buddy,
            onTap: () => onModeChanged(ChatMode.buddy),
          ),
          const SizedBox(width: 8),
          _ModeChip(
            label: '🎭 Roleplay',
            isSelected: currentMode == ChatMode.roleplay,
            onTap: () => onModeChanged(ChatMode.roleplay),
          ),
          const Spacer(),
          if (currentMode == ChatMode.buddy)
            const Text(
              'Free conversation',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            )
          else
            const Text(
              'Scenario practice',
              style: TextStyle(color: Colors.white70, fontSize: 12),
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white
              : Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight:
                isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? ChickyColors.primaryDark : Colors.white,
          ),
        ),
      ),
    );
  }
}
