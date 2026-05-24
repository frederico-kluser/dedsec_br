import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/fonts.dart';
import 'dashed_box.dart';

/// Dashed-outline secondary button.
class GhostBtn extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool full;
  final Color? color;
  final EdgeInsets padding;
  const GhostBtn({
    super.key,
    required this.label,
    this.onPressed,
    this.full = false,
    this.color,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? DedsecColors.ink;
    final child = GestureDetector(
      onTap: onPressed,
      child: DashedBox(
        color: c,
        strokeWidth: 1.5,
        child: Padding(
          padding: padding,
          child: Center(
            child: Text(
              label.toUpperCase(),
              textAlign: TextAlign.center,
              style: DedsecFonts.pixel(size: 10, color: c, letterSpacing: 1.5),
            ),
          ),
        ),
      ),
    );
    if (full) return SizedBox(width: double.infinity, child: child);
    return child;
  }
}
