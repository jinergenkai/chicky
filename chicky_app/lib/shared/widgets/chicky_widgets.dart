import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';

// ═══════════════════════════════════════════════════════════════════════
//  Chicky Design System — Reusable Widgets
// ═══════════════════════════════════════════════════════════════════════

/// Primary gradient button with shadow — used for main CTA actions.
///
/// ```dart
/// ChickyGradientButton(
///   label: 'START LEARNING',
///   icon: Icons.play_arrow_rounded,
///   onTap: () => ...,
/// )
/// ```
class ChickyGradientButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final List<Color>? colors;
  final double height;
  final double borderRadius;

  const ChickyGradientButton({
    super.key,
    required this.label,
    this.icon,
    this.onTap,
    this.colors,
    this.height = 56,
    this.borderRadius = 14,
  });

  @override
  Widget build(BuildContext context) {
    final gradientColors = colors ??
        [
          ChickyColors.primary,
          ChickyColors.primaryDark,
        ];

    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, color: Colors.white, size: 24),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Rounded back button with subtle background — used in AppBars.
class ChickyBackButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const ChickyBackButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 18,
          color: Colors.grey.shade800,
        ),
        onPressed: onPressed ?? () => Navigator.maybePop(context),
      ),
    );
  }
}

/// Gradient-shadow progress bar with label.
///
/// ```dart
/// ChickyProgressBar(
///   label: 'Mastered',
///   value: 0.6,
///   color: ChickyColors.success,
/// )
/// ```
class ChickyProgressBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final double height;

  const ChickyProgressBar({
    super.key,
    required this.label,
    required this.value,
    this.color = ChickyColors.success,
    this.height = 12,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (value * 100).round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.2,
              ),
            ),
            Text(
              '$percentage%',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: value,
              minHeight: height,
              backgroundColor: Colors.grey.shade100,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
      ],
    );
  }
}

/// Stats card with gradient background, icon, large value, and subtitle.
///
/// ```dart
/// ChickyStatsCard(
///   icon: LucideIcons.flame,
///   iconColor: Colors.orange,
///   value: '15',
///   subtitle: 'days in a row',
///   label: 'Streak',
/// )
/// ```
class ChickyStatsCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String subtitle;
  final String label;

  const ChickyStatsCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.subtitle,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.grey.shade50],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      iconColor.withOpacity(0.15),
                      iconColor.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: iconColor,
              letterSpacing: -0.5,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Animated page indicator dots (for PageView carousels).
class ChickyPageDots extends StatelessWidget {
  final int count;
  final int currentIndex;
  final Color activeColor;
  final Color inactiveColor;

  const ChickyPageDots({
    super.key,
    required this.count,
    required this.currentIndex,
    this.activeColor = ChickyColors.primary,
    Color? inactiveColor,
  }) : inactiveColor = inactiveColor ?? const Color(0xFFE0E0E0);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: currentIndex == index ? 24 : 8,
          decoration: BoxDecoration(
            color: currentIndex == index ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

/// Modern AppBar with subtle gradient and shadow.
///
/// Use as `appBar: chickyAppBar(context, title: 'Screen Title')`.
PreferredSizeWidget chickyAppBar(
  BuildContext context, {
  required String title,
  VoidCallback? onBack,
  List<Widget>? actions,
  double toolbarHeight = 68,
}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(toolbarHeight),
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.grey.shade50],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: AppBar(
        foregroundColor: Colors.black87,
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            letterSpacing: -0.5,
          ),
        ),
        leading: ChickyBackButton(onPressed: onBack),
        actions: actions,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: toolbarHeight,
      ),
    ),
  );
}

/// Gradient action button for AppBar actions.
///
/// ```dart
/// chickyAppBarAction(
///   icon: Icons.add_rounded,
///   label: 'Add',
///   onTap: () => ...,
/// )
/// ```
Widget chickyAppBarAction({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
  List<Color>? colors,
}) {
  final gradientColors = colors ??
      [
        ChickyColors.primary,
        ChickyColors.primaryDark,
      ];

  return Container(
    margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: gradientColors,
      ),
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: gradientColors.first.withOpacity(0.25),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
