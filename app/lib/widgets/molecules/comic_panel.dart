import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../theme/fonts.dart';
import '../atoms/effects.dart';

/// `molecules/ComicPanel` — coloured card with halftone, darkening gradient
/// and optional pixel label in the corner.
class ComicPanel extends StatelessWidget {
  final Color color;
  final Color halftoneColor;
  final double height;
  final Widget? child;
  final String? label;

  const ComicPanel({
    super.key,
    this.color = COL.magenta,
    this.halftoneColor = Colors.black,
    this.height = 120,
    this.child,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Colors.black, width: 2),
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Halftone(color: halftoneColor, size: 5, opacity: 0.55),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0x00000000), Color(0x8A000000)],
                  stops: [0.6, 1.0],
                ),
              ),
            ),
            if (child != null) child!,
            if (label != null)
              Positioned(
                left: 8,
                bottom: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  color: Colors.black,
                  child: Text(label!,
                      style: FONT.pixel(size: 9, color: Colors.white, letterSpacing: 1)),
                ),
              ),
            const Grain(opacity: 0.12),
          ],
        ),
      ),
    );
  }
}
