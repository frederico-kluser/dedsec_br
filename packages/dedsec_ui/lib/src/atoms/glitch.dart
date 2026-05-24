import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/fonts.dart';

/// RGB-split text: magenta shadow right, acid green shadow left.
class Glitch extends StatelessWidget {
  final String text;
  final double size;
  final Color? color;
  final TextStyle? style;
  const Glitch({super.key, required this.text, this.size = 24, this.color, this.style});

  @override
  Widget build(BuildContext context) {
    final base = style ?? DedsecFonts.pixel(size: size, color: color ?? DedsecColors.ink, letterSpacing: 1);
    return Text(
      text,
      style: base.copyWith(
        shadows: const [
          Shadow(color: DedsecColors.magenta, offset: Offset(2, 0)),
          Shadow(color: DedsecColors.acid, offset: Offset(-2, 0)),
        ],
      ),
    );
  }
}
