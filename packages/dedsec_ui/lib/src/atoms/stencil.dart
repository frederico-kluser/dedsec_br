import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/fonts.dart';

class Stencil extends StatelessWidget {
  final String text;
  final double size;
  final Color? color;
  final TextAlign textAlign;
  final List<Shadow>? shadows;
  const Stencil(
    this.text, {
    super.key,
    this.size = 40,
    this.color,
    this.textAlign = TextAlign.left,
    this.shadows,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      textAlign: textAlign,
      style: DedsecFonts.stencil(
        size: size,
        color: color ?? DedsecColors.ink,
        letterSpacing: 1,
        height: 0.92,
      ).copyWith(shadows: shadows),
    );
  }
}

class StencilRich extends StatelessWidget {
  final List<TextSpan> spans;
  final double size;
  final TextAlign textAlign;
  const StencilRich({super.key, required this.spans, this.size = 40, this.textAlign = TextAlign.left});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: DedsecFonts.stencil(size: size, letterSpacing: 1, height: 0.95),
        children: spans,
      ),
      textAlign: textAlign,
    );
  }
}
