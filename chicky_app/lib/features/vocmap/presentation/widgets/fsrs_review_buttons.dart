import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';

/// FSRS review buttons — 4 grades: Again, Hard, Good, Easy.
///
/// Shows animated buttons with emoji, hover effects, and a
/// next-review-interval preview. Adapts the old SM-2 buttons
/// to match FSRS algorithm grades from the readme spec.
class FsrsReviewButtons extends StatefulWidget {
  final void Function(String grade) onGradeSelected;
  final bool isVisible;

  const FsrsReviewButtons({
    super.key,
    required this.onGradeSelected,
    this.isVisible = true,
  });

  @override
  State<FsrsReviewButtons> createState() => _FsrsReviewButtonsState();
}

class _FsrsReviewButtonsState extends State<FsrsReviewButtons>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  int? _hoveredIndex;

  static const _grades = [
    _GradeConfig('again', '😫', 'Again', '10 min'),
    _GradeConfig('hard', '😰', 'Hard', '1 day'),
    _GradeConfig('good', '😊', 'Good', '3 days'),
    _GradeConfig('easy', '😄', 'Easy', '7 days'),
  ];

  static const _gradeColors = [
    ChickyColors.gradeAgain,
    ChickyColors.gradeHard,
    ChickyColors.gradeGood,
    ChickyColors.gradeEasy,
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    if (widget.isVisible) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(FsrsReviewButtons oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _controller.forward();
    } else if (!widget.isVisible && oldWidget.isVisible) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) {
      return const SizedBox.shrink();
    }

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: ChickyColors.primaryLight.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star_rounded,
                    color: ChickyColors.primaryDark, size: 20),
                const SizedBox(width: 8),
                Text(
                  'How well did you know this?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ChickyColors.primaryDark,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Grade buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_grades.length, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: _buildGradeButton(index),
              );
            }),
          ),

          // Preview next review
          if (_hoveredIndex != null) ...[
            const SizedBox(height: 12),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: 1.0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calendar_today_rounded,
                        size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 6),
                    Text(
                      'Next review: ${_grades[_hoveredIndex!].interval}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGradeButton(int index) {
    final grade = _grades[index];
    final color = _gradeColors[index];
    final isHovered = _hoveredIndex == index;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = null),
      child: GestureDetector(
        onTap: () => widget.onGradeSelected(grade.id),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: isHovered ? 72 : 64,
          height: isHovered ? 72 : 64,
          decoration: BoxDecoration(
            color: isHovered ? color : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color,
              width: isHovered ? 3 : 2,
            ),
            boxShadow: isHovered
                ? [
                    BoxShadow(
                      color: color.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                grade.emoji,
                style: TextStyle(fontSize: isHovered ? 24 : 20),
              ),
              const SizedBox(height: 2),
              Text(
                grade.label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isHovered ? Colors.white : color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GradeConfig {
  final String id;
  final String emoji;
  final String label;
  final String interval;

  const _GradeConfig(this.id, this.emoji, this.label, this.interval);
}
