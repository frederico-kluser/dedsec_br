import 'package:flutter/material.dart';
import '../atoms/grain.dart';
import '../atoms/halftone.dart';
import '../tokens/colors.dart';
import '../tokens/fonts.dart';

class ComicPanel extends StatelessWidget {
  final Color? color;
  final Color halftoneColor;
  final Widget? child;
  final double? height;
  final String? label;
  const ComicPanel({
    super.key,
    this.color,
    this.halftoneColor = Colors.black,
    this.child,
    this.height = 120,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? DedsecColors.magenta;
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: c,
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: ClipRect(
        child: Stack(children: [
          Positioned.fill(child: Halftone(color: halftoneColor, size: 5, opacity: 0.55)),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.55)],
                  stops: const [0.6, 1.0],
                ),
              ),
            ),
          ),
          if (child != null) Positioned.fill(child: child!),
          if (label != null)
            Positioned(
              left: 8,
              bottom: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                color: Colors.black,
                child: Text(label!,
                    style: DedsecFonts.pixel(size: 9, color: Colors.white, letterSpacing: 1)),
              ),
            ),
          const Positioned.fill(child: Grain(opacity: 0.12)),
        ]),
      ),
    );
  }
}
